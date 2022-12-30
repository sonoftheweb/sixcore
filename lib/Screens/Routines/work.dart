import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixcore/Constants/colors.dart';
import 'package:sixcore/Provider/app_provider.dart';
import 'package:sixcore/router/router.dart';
import 'package:sixcore/router/routes.dart';

import '../../Models/workout_model.dart';
import '../../Provider/routine_provider.dart';
import '../../Utils/number_to_base.dart';
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
  final TextEditingController _command_1 = TextEditingController();
  final TextEditingController _command_2 = TextEditingController();
  final TextEditingController _command_3 = TextEditingController();
  final TextEditingController _command_4 = TextEditingController();

  final TextEditingController _crc = TextEditingController();

  @override
  void initState() {
    if (context.read<RoutineProvider>().viewRoutine != null) {
      // connect to BLE and source for services and chars
      //context.read<AppProvider>().connectToBLE();

      _start.text = '0xa8';
      _crc.text = '0xa8';
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
    _command_1.dispose();
    _command_2.dispose();
    _command_3.dispose();
    _command_4.dispose();
    _crc.dispose();

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
                                controller: _command_1,
                                decoration: InputDecoration(
                                  labelText: 'Command 1',
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
                                controller: _command_2,
                                decoration: InputDecoration(
                                  labelText: 'Command 2',
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
                                controller: _command_3,
                                decoration: InputDecoration(
                                  labelText: 'Command 3',
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
                                controller: _command_4,
                                onChanged: (_) {
                                  calculateCRC();
                                },
                                decoration: InputDecoration(
                                  labelText: 'Command 4',
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
                            p.sendCustomCommandsToBoard(
                              start: _start.text,
                              command_1: _command_1.text,
                              command_2: _command_2.text,
                              command_3: _command_3.text,
                              command_4: _command_4.text,
                              crc: _crc.text,
                            );
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
    int intCommand1 =
        isNumeric(string: _command_1.text) ? int.parse(_command_1.text) : 0;
    int intCommand2 =
        isNumeric(string: _command_2.text) ? int.parse(_command_2.text) : 0;
    int intCommand3 =
        isNumeric(string: _command_3.text) ? int.parse(_command_3.text) : 0;
    int intCommand4 =
        isNumeric(string: _command_4.text) ? int.parse(_command_4.text) : 0;

    int calculatedCrc =
        intStart + intCommand1 + intCommand2 + intCommand3 + intCommand4;

    _crc.text = (intToUnit8[calculatedCrc] ?? "Overload");
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
