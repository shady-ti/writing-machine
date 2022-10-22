import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:writing_machine/UI/number_wheel.temp.dart';
import 'package:writing_machine/UI/style.dart';
import 'package:writing_machine/model/ticker.dart';

class TickerInputs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TickerInputsState();
}

class _TickerInputsState extends State<TickerInputs> {
  var hourController = TextEditingController(text: '1');
  var minuteController = TextEditingController(text: '0');
  var secondController = TextEditingController(text: '5');

  late Ticker ticker;

  var inInputMode = true;

  @override
  Widget build(BuildContext context) {
    return inInputMode
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Total writing time',
                        style: FontStyles.heading1,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NumberWheel(
                                textController: hourController,
                                startNumber: 0,
                                endNumber: 25,
                              ),
                              const Text('Hours')
                            ],
                          ),
                          SizedBox(
                            width: getFractionalWidth(0.01, context),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NumberWheel(
                                textController: minuteController,
                                startNumber: 0,
                                endNumber: 61,
                              ),
                              const Text('Minutes')
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: getFractionalWidth(0.05, context),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Sec/Word',
                        style: FontStyles.heading1,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NumberWheel(
                            textController: secondController,
                            startNumber: 1,
                            endNumber: 61,
                          ),
                          const Text('Seconds')
                        ],
                      )
                    ],
                  )
                ],
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    ticker = Ticker(
                      totalDuration: Duration(
                        hours: int.parse(hourController.text),
                        minutes: int.parse(minuteController.text),
                      ),
                      timeBetweenTicks: Duration(seconds: int.parse(secondController.text)),
                    );
                  });

                  await ticker.startPlayback();

                  setState(() {
                    inInputMode = false;
                  });
                },
                child: const Text(
                  'Start',
                  style: FontStyles.heading3,
                ),
              )
            ],
          )
        : Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Words: ${ticker.tick}/${ticker.totalTicks}',
                  style: FontStyles.heading3,
                ),
                Text(
                  ' Time: ${(ticker.timeBetweenTicks * ticker.tick).toString().substring(0, 9)}/${ticker.totalDuration.toString().substring(0, 9)}',
                  style: FontStyles.heading3,
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      ticker.stopPlayback();

                      setState(() {
                        inInputMode = true;
                      });
                    },
                    child: const Text(
                      'Cancel',
                      style: FontStyles.heading3,
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
