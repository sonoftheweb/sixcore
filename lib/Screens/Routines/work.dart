import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixcore/Constants/colors.dart';
import 'package:sixcore/Provider/app_provider.dart';
import 'package:sixcore/router/router.dart';
import 'package:sixcore/router/routes.dart';

import '../../Models/workout_model.dart';
import '../../Provider/routine_provider.dart';
import '../../Utils/routine.dart';

class WorkRoutine extends StatefulWidget {
  const WorkRoutine({Key? key}) : super(key: key);

  @override
  State<WorkRoutine> createState() => _WorkRoutineState();
}

class _WorkRoutineState extends State<WorkRoutine> {
  late final String routineId;
  late final Workout workout;
  late final Map<String, dynamic> workoutSettings;
  late final Map<String, dynamic> workoutSettingsDecoded;
  late final Map<String, dynamic> workoutAreas;
  late final int areasTrainable;
  late final int exercisesCount;

  List exercises = [];
  List areasTrainableList = [];

  /*TEST PARAMS*/
  final TextEditingController _start = TextEditingController();
  final TextEditingController _command = TextEditingController();
  final TextEditingController _value = TextEditingController();
  final TextEditingController _crc = TextEditingController();
  final TextEditingController _channel = TextEditingController();

  @override
  void initState() {
    if (context.read<RoutineProvider>().viewRoutine != null) {
      // connect to BLE and source for services and chars
      context.read<AppProvider>().connectToBLE();

      routineId = context.read<RoutineProvider>().viewRoutine!['id'];
      workout = context.read<RoutineProvider>().viewRoutine!['workout'];
      workoutSettings = json.decode(workout.workoutSettings);
      Map<String, dynamic> wA = json.decode(workout.workoutAreas);

      workoutAreas = {};

      for (MapEntry<String, dynamic> i in wA.entries) {
        if (i.value != 0) {
          workoutAreas[i.key] = i.value;
        }
      }

      for (var entry in workoutAreas.entries) {
        areasTrainableList.add(entry.key);
      }

      workoutSettingsDecoded = getDecodedSettings(
        mode: workoutSettings['mode'],
        subMode: workoutSettings['sub_mode'],
      );

      areasTrainable = workoutAreas.length;
      exercisesCount =
          workoutSettingsDecoded['train_time'] ~/ 2; // one min per exercise
    } else {
      Navigator.pop(context);
    }

    super.initState();
  }

  @override
  void dispose() {
    _start.dispose();
    _command.dispose();
    _value.dispose();
    _crc.dispose();
    _channel.dispose();

    context.read<AppProvider>().disconnectFromBle();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Consumer<AppProvider>(builder: (context, p, _) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColor.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 335,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Text(
                          'Send Custom Commands',
                          style: TextStyle(
                            fontSize: 17,
                            color: AppColor.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: TextFormField(
                                style: TextStyle(
                                  color: AppColor.white,
                                ),
                                controller: _start,
                                onChanged: (_) {
                                  calculateCRC();
                                },
                                decoration: InputDecoration(
                                  labelText: 'Start',
                                  labelStyle: TextStyle(color: AppColor.white),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColor.white),
                                    borderRadius: BorderRadius.circular(5.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                style: TextStyle(
                                  color: AppColor.white,
                                ),
                                onChanged: (_) {
                                  calculateCRC();
                                },
                                controller: _command,
                                decoration: InputDecoration(
                                  labelText: 'Command',
                                  labelStyle: TextStyle(color: AppColor.white),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColor.white),
                                    borderRadius: BorderRadius.circular(5.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 13),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: TextFormField(
                                style: TextStyle(
                                  color: AppColor.white,
                                ),
                                onChanged: (_) {
                                  calculateCRC();
                                },
                                controller: _value,
                                decoration: InputDecoration(
                                  labelText: 'Value',
                                  labelStyle: TextStyle(color: AppColor.white),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColor.white),
                                    borderRadius: BorderRadius.circular(5.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                style: TextStyle(
                                  color: AppColor.white,
                                ),
                                onChanged: (_) {
                                  calculateCRC();
                                },
                                controller: _channel,
                                decoration: InputDecoration(
                                  labelText: 'Channel',
                                  labelStyle: TextStyle(color: AppColor.white),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColor.white),
                                    borderRadius: BorderRadius.circular(5.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: TextFormField(
                                style: TextStyle(
                                  color: AppColor.white,
                                ),
                                onChanged: (_) {
                                  calculateCRC();
                                },
                                controller: _crc,
                                decoration: InputDecoration(
                                  labelText: 'CRC',
                                  labelStyle: TextStyle(color: AppColor.white),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColor.white),
                                    borderRadius: BorderRadius.circular(5.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(AppColor.teal),
                          ),
                          onPressed: () {
                            if (_start.text.isNotEmpty &&
                                _command.text.isNotEmpty &&
                                _crc.text.isNotEmpty) {
                              p.sendCustomCommandsToBoard(
                                  start: _start.text,
                                  command: _command.text,
                                  value: _value.text,
                                  channel: _channel.text,
                                  crc: _crc.text);
                            }
                          },
                          child: const Text('Send Command to board'),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            p.sendCommandsToBoard();
                          },
                          child: const Text('Trigger flashing light'),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(AppColor.error),
                          ),
                          onPressed: () {
                            p.disconnectFromBle().then((_) =>
                                PageNavigator(context: context)
                                    .nextPageOnly(page: Paths.viewRoutinePath));
                          },
                          icon: Icon(
                            Icons.close,
                            color: AppColor.white,
                          ),
                          label: Text(
                            'Disconnect ${p.device!.name}',
                            style: TextStyle(color: AppColor.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  void calculateCRC() {
    int intStart = isNumeric(string: _start.text) ? int.parse(_start.text) : 0;
    int intCommand =
        isNumeric(string: _command.text) ? int.parse(_command.text) : 0;
    int intValue = _value.text.isNotEmpty && isNumeric(string: _value.text)
        ? int.parse(_value.text)
        : 0;
    int intChannel =
        _channel.text.isNotEmpty && isNumeric(string: _channel.text)
            ? int.parse(_channel.text)
            : 0;

    int calculatedCrc = intStart + intCommand + intValue + intChannel;
    _crc.text = calculatedCrc.toString();
  }

  bool isNumeric({required String string}) {
    try {
      int.parse(string);
      return true;
    } catch (_) {
      return false;
    }
  }
}
