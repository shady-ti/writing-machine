import 'package:flutter/material.dart';
import 'package:writing_machine/UI/style.dart';

/// Numeric Input wheel where you can also type in the values
class NumberWheel extends StatefulWidget {
  /// [TextEditingController] that is used to communicate the chosen values
  /// up and down the widget tree
  final TextEditingController textController;

  final num startNumber, endNumber, increment;

  /// Create a [NumberWheel]
  const NumberWheel({
    super.key,
    required this.textController,
    required this.startNumber,
    required this.endNumber,
    this.increment = 1,
  });

  @override
  State<StatefulWidget> createState() => _NumberWheelState();
}

class _NumberWheelState extends State<NumberWheel> {
  /// `true` is the widget is in [TextField] mode
  bool isTextModeActive = false;

  /// up-tree pass down, used to share about the chosen value
  late TextEditingController textController;

  /// keeps getting replaced when switching back to scroll mode
  var scrollController = FixedExtentScrollController();

  /// parse both int's and double's
  ///
  /// ### NOTE
  /// - Returns `0` if input can't be parsed
  num parseNumber(String text) =>
      (int.tryParse(textController.text) ?? double.tryParse(textController.text)) ?? 0;

  @override
  void initState() {
    super.initState();

    textController = widget.textController;
  }

  @override
  Widget build(BuildContext context) {
    // input box size
    return FractionallySizedBox(
      widthFactor: valueSet<double>(0.2, 0.15, 0.1, context),
      heightFactor: 0.2,
      // input box borders
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: ColorPalette.lavenderGray),
          borderRadius: BorderRadius.circular(4),
        ),
        // Text or Scroll View
        child: Center(
          child: isTextModeActive
              ? CustomTextInput(
                  controller: textController,
                  onEditingCompleteCallback: () => setState(
                    () {
                      isTextModeActive = false;

                      if (parseNumber(textController.text) > widget.endNumber) {
                        textController.text = '${widget.endNumber}';
                      }

                      if (parseNumber(textController.text) < widget.startNumber) {
                        textController.text = '${widget.startNumber}';
                      }

                      scrollController = FixedExtentScrollController(
                        initialItem: (parseNumber(textController.text) - widget.startNumber) ~/
                            widget.increment,
                      );
                    },
                  ),
                )
              : ValueScroll(
                  controller: scrollController,
                  items: [
                    for (int index = 0;
                        index < (widget.endNumber - widget.startNumber) ~/ widget.increment;
                        index++)
                      Center(
                        child: Text(
                          '${widget.startNumber + (index * widget.increment)}',
                          style: FontStyles.heading3,
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                  onTap: () => setState(() {
                    isTextModeActive = true;

                    var elementCount = (widget.endNumber - widget.startNumber) ~/ widget.increment;

                    if (scrollController.selectedItem > 0) {
                      textController.text =
                          '${widget.startNumber + ((scrollController.selectedItem % elementCount) * widget.increment)}';
                    } else {
                      textController.text =
                          '${widget.startNumber + ((elementCount + 1 - (scrollController.selectedItem.abs() % elementCount)) * widget.increment)}';
                    }
                  }),
                ),
        ),
      ),
    );
  }
}

class CustomTextInput extends StatelessWidget {
  late TextEditingController controller;

  late void Function() onEditingCompleteCallback;

  ///
  CustomTextInput({
    super.key,
    required this.onEditingCompleteCallback,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: FontStyles.heading3,
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      decoration: null,
      onEditingComplete: onEditingCompleteCallback,
      autofocus: true,
    );
  }
}

/// A [ListWheelScrollView] of numeric values
class ValueScroll extends StatelessWidget {
  /// Items to display on the wheel
  final List<Widget> items;

  /// up-tree passed down Scroll controller
  final FixedExtentScrollController controller;

  /// Set up-tree state/translate values
  final void Function() onTap;

  /// Create a [ValueScroll]
  const ValueScroll({
    super.key,
    required this.controller,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // switch to TextMode on tap
    return GestureDetector(
      onTap: onTap,
      child: ListWheelScrollView.useDelegate(
        diameterRatio: 1,
        overAndUnderCenterOpacity: 0.5,
        itemExtent: getFractionalHeight(0.05, context),
        childDelegate: ListWheelChildLoopingListDelegate(children: items),
        controller: controller,
      ),
    );
  }
}
