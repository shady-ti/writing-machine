import 'package:flutter/material.dart';
import 'package:writing_machine/UI/number_wheel.dart';
import 'package:writing_machine/UI/style.dart';
import 'package:writing_machine/model/ticker.dart';

class TickerInputScreenState extends ChangeNotifier {
  bool _inInputMode = true;

  set inInputMode(bool newValue) {
    if (_inInputMode != newValue) {
      _inInputMode = newValue;

      notifyListeners();
    }
  }

  bool get inInputMode => _inInputMode;
}

class TickerInputScreen extends StatelessWidget {
  int _hours = 1, _minutes = 0, _seconds = 5;

  late Ticker ticker;

  late TickerInputScreenState _state;

  ///
  TickerInputScreen({super.key}) {
    _state = TickerInputScreenState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _state,
      builder: (context, child) {
        if (_state.inInputMode) {
          return Center(
            // input mode
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // time inputs
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: InsetSizes.wide,
                      // writing time
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Writing Time', style: FontStyles.heading3),
                          Row(
                            children: [
                              Column(
                                children: [
                                  NumberWheel(
                                    initialValue: 0,
                                    finalValue: 25,
                                    defaultValue: _hours,
                                    onStateChange: (state) {
                                      _hours = state.value.toInt();
                                    },
                                  ),
                                  const Text('Hours')
                                ],
                              ),
                              Column(
                                children: [
                                  NumberWheel(
                                    initialValue: 0,
                                    finalValue: 60,
                                    defaultValue: _minutes,
                                    onStateChange: (state) {
                                      _minutes = state.value.toInt();
                                    },
                                  ),
                                  const Text(
                                    'Minutes',
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: InsetSizes.wide,
                      // Sec/Word
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Sec/Word', style: FontStyles.heading3),
                          NumberWheel(
                            initialValue: 1,
                            finalValue: 61,
                            defaultValue: _seconds,
                            onStateChange: (state) {
                              _seconds = state.value.toInt();
                            },
                          ),
                          const Text(
                            'Seconds',
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  margin: InsetSizes.wide,
                  decoration: getBoxDecoration(borderColor: Colors.blue),
                  child: TextButton(
                    onPressed: () async {
                      ticker = Ticker(
                        totalDuration: Duration(hours: _hours, minutes: _minutes),
                        timeBetweenTicks: Duration(seconds: _seconds),
                      );

                      await ticker.startPlayback();

                      _state.inInputMode = false;
                    },
                    child: const Text('Start', style: FontStyles.normal),
                  ),
                )
              ],
            ),
          );
        } else {
          // progress mode
          return Center(
            child: AnimatedBuilder(
              animation: ticker,
              builder: (context, child) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${ticker.tick} of ${ticker.totalTicks} words',
                    style: FontStyles.heading2,
                  ),
                  const Text(
                    '',
                    style: FontStyles.heading1,
                  ),
                  Text(
                    '${(ticker.timeBetweenTicks * ticker.tick).toString().substring(0, 7).replaceFirst(r':', 'h ').replaceFirst(r':', 'm ')}s',
                    style: FontStyles.heading3,
                  ),
                  const Text(
                    'of',
                    style: FontStyles.heading3,
                  ),
                  Text(
                    '${(ticker.timeBetweenTicks * ticker.totalTicks).toString().substring(0, 7).replaceFirst(r':', 'h ').replaceFirst(r':', 'm ')}s',
                    style: FontStyles.heading3,
                  ),
                  Container(
                    margin: InsetSizes.wide,
                    decoration: getBoxDecoration(borderColor: Colors.blue),
                    child: TextButton(
                      onPressed: () async {
                        await ticker.stopPlayback();
                        ticker.dispose();

                        _state.inInputMode = true;
                      },
                      child: const Text('Stop'),
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
