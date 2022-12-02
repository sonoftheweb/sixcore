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
    context.read<AppProvider>().disconnectFromBle();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Consumer<AppProvider>(builder: (context, p, _) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await p.sendCommandsToBoard();
                  },
                  child: const Text('Trigger flashing light'),
                ),
                const SizedBox(height: 40),
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
                    'Disconnect device ${p.device!.name}',
                    style: TextStyle(color: AppColor.white),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
