// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:writing_machine/UI/style.dart';

// TODO: Reduce unnecesary state updates

/// Data State of the [NumberWheel] Object
class NumberWheelState extends ChangeNotifier {
  /// the first value on the [NumberWheel]
  late final num initialValue;

  /// last value on the number wheel (exclusive — numbers up to, but not
  /// including this one will be displayed)
  late final num finalValue;

  /// Increment between number wheel entries
  late final num increment;

  /// Number of elements on the number wheel
  late final int elementCount;

  /// A [TextEditingController] so that user inputs can directly be plugged
  /// into the state without much mumbo-jumbo
  late TextEditingController textController;

  /// A [FixedExtentScrollController] so that user inputs can directly be
  /// plugged into state
  late FixedExtentScrollController scrollController;

  /// Weather a [TextField] is displayed or a wheel
  var _inTextEditingMode = false;

  bool get inTextEditingMode => _inTextEditingMode;

  set inTextEditingMode(bool newValue) {
    if (_inTextEditingMode != newValue) {
      _inTextEditingMode = newValue;
      notifyListeners();
    }
  }

  /// Value that is currently selected
  num _value = 0;

  num get value => _value;

  set value(num newValue) {
    if (_value != newValue) {
      _value = newValue;

      // TODO: Remove controller rplacement
      if (inTextEditingMode) {
        scrollController.dispose();

        scrollController =
            FixedExtentScrollController(initialItem: (value - initialValue) ~/ increment);

        // the old scrollController is dead, need to update the listeners or
        // the state will no longer get updated
        scrollController.addListener(() => _scrollControllerValueUpdater());
      } else {
        textController.dispose();

        textController = TextEditingController(text: '$value');

        // the old textController is dead, need to update the listeners or
        // the state will no longer get updated
        textController.addListener(() => _textEditingControllerValueUpdater());
      }

      notifyListeners();
    }
  }

  /// Build a [NumberWheelState]
  NumberWheelState({
    required num defaultValue,
    required this.initialValue,
    required this.finalValue,
    required this.increment,
  }) {
    textController = TextEditingController(text: defaultValue.toString());
    scrollController = FixedExtentScrollController();

    value = defaultValue;

    elementCount = (finalValue - initialValue) ~/ increment;

    scrollController.addListener(() => _scrollControllerValueUpdater());

    textController.addListener(() => _textEditingControllerValueUpdater());
  }

  /// Utility for when adding listeners to new [textController]'s
  void _textEditingControllerValueUpdater() {
    var textNumber =
        (int.tryParse(textController.text) ?? double.tryParse(textController.text)) ?? 0;

    if (!((textNumber < initialValue) || (textNumber >= finalValue))) {
      value = textNumber ~/ increment * increment;
    } else if (textNumber <= initialValue) {
      value = initialValue;
    } else {
      value = initialValue + (elementCount - 1) * increment;
    }
  }

  /// Utility for when adding listeners to new [scrollController]'s
  void _scrollControllerValueUpdater() {
    if (scrollController.selectedItem >= 0) {
      value = initialValue + ((scrollController.selectedItem % elementCount) * increment);
    } else {
      // -3 of 5 is the same as 2 of 5
      value = initialValue +
          ((elementCount - (scrollController.selectedItem.abs() % elementCount)) * increment);
    }
  }
}

/// A snapping, scrollable wheel, where you can also type in values
class NumberWheel extends StatelessWidget {
  /// A [NumberWheelState] object that controls this widgets state
  late final NumberWheelState _state;

  /// Create a [NumberWheel]
  NumberWheel({
    super.key,
    num? defaultValue,
    required num initialValue,
    required num finalValue,
    required num increment,
    void Function(NumberWheelState state)? onStateChange,
  }) {
    _state = NumberWheelState(
      defaultValue: defaultValue ?? initialValue,
      initialValue: initialValue,
      finalValue: finalValue,
      increment: increment,
    );

    _state.addListener(() => onStateChange!(_state));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getFractionalWidth(valueSet<double>(0.2, 0.15, 0.1, context), context),
      height: getFractionalHeight(0.2, context),
      // input box borders
      child: Container(
        decoration: getBoxDecoration(borderColor: ColorPalette.lavenderGray),
        // Text or Scroll View
        child: AnimatedBuilder(
          animation: _state,
          builder: (context, child) => Center(
            child: _state.inTextEditingMode
                ? _NumberWheelTextMode(state: _state)
                : _NumberWheelScrollMode(state: _state),
          ),
        ),
      ),
    );
  }
}

/// Display for when the [NumberWheel] works like a text input
class _NumberWheelTextMode extends StatelessWidget {
  final NumberWheelState state;

  const _NumberWheelTextMode({required this.state});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: state,
      builder: (BuildContext context, Widget? child) => TextField(
        controller: state.textController,
        keyboardType: TextInputType.number,
        style: FontStyles.heading3,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        decoration: null,
        onEditingComplete: () {
          state.textController.text = '${state.value}';
          state.inTextEditingMode = false;
        },
        autofocus: true,
      ),
    );
  }
}

/// Display for when the [NumberWheel] works like a scrollable selection wheel
class _NumberWheelScrollMode extends StatelessWidget {
  final NumberWheelState state;

  const _NumberWheelScrollMode({required this.state});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        state.inTextEditingMode = true;
      },
      // wheel
      child: ListWheelScrollView.useDelegate(
        controller: state.scrollController,
        physics: const FixedExtentScrollPhysics(),
        diameterRatio: 1,
        overAndUnderCenterOpacity: 0.75,
        itemExtent: getFractionalHeight(0.05, context),
        childDelegate: ListWheelChildLoopingListDelegate(
          children: List.generate(
            state.elementCount,
            (index) => Center(
              // FittedBox makes sure the text doesn't clip
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  '${state.initialValue + (index * state.increment)}',
                  style: FontStyles.heading3,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
