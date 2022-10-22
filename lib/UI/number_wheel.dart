import 'package:flutter/material.dart';
import 'package:writing_machine/UI/style.dart';

// TODO: Reduce unnecesary state updates

class _NumberWheelState extends ChangeNotifier {
  late final num initialValue, finalValue, increment;

  late final int elementCount;

  late TextEditingController textController;

  late FixedExtentScrollController scrollController;

  var _inTextEditingMode = false;

  bool get inTextEditingMode => _inTextEditingMode;

  set inTextEditingMode(bool newValue) {
    if (_inTextEditingMode != newValue) {
      _inTextEditingMode = newValue;
      notifyListeners();
    }
  }

  num _value = 0;

  num get value => _value;

  set value(num newValue) {
    if (_value != newValue) {
      _value = newValue;

      // TODO: Remove controller rplacement
      if (inTextEditingMode) {
        scrollController =
            FixedExtentScrollController(initialItem: (value - initialValue) ~/ increment);

        scrollController.addListener(() => _scrollControllerValueUpdater());
      } else {
        textController = TextEditingController(text: '$value');

        textController.addListener(() => _textEditingControllerValueUpdater());
      }

      notifyListeners();
    }
  }

  ///
  _NumberWheelState({
    required num defaultValue,
    required this.initialValue,
    required this.finalValue,
    required this.increment,
  }) {
    value = defaultValue;

    textController = TextEditingController(text: defaultValue.toString());
    scrollController = FixedExtentScrollController();

    elementCount = (finalValue - initialValue) ~/ increment;

    scrollController.addListener(() => _scrollControllerValueUpdater());

    textController.addListener(() => _textEditingControllerValueUpdater());

    addListener(() {
      print('value changed to "$value"');
      print('inTextEditingMode: $inTextEditingMode\n\n');
    });
  }

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

class NumberWheel extends StatelessWidget {
  late final _NumberWheelState _state;

  ///
  NumberWheel({
    super.key,
    num? defaultValue,
    required num initialValue,
    required num finalValue,
    required num increment,
  }) {
    _state = _NumberWheelState(
      defaultValue: defaultValue ?? initialValue,
      initialValue: initialValue,
      finalValue: finalValue,
      increment: increment,
    );
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

class _NumberWheelTextMode extends StatelessWidget {
  final _NumberWheelState state;

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

class _NumberWheelScrollMode extends StatelessWidget {
  final _NumberWheelState state;

  const _NumberWheelScrollMode({required this.state});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        state.inTextEditingMode = true;
      },
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
