import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:sixcore/Constants/colors.dart';
import 'package:sixcore/Constants/devices_and_services.dart';
import 'package:sixcore/Provider/app_provider.dart';
import 'package:sixcore/Provider/routine_provider.dart';
import 'package:sixcore/router/router.dart';
import 'package:sixcore/router/routes.dart';

import '../../Models/workout_model.dart';
import '../../Utils/routine.dart';
import '../../Widgets/button.dart';
import '../../Widgets/last_activities.dart';

class ViewRoutine extends StatefulWidget {
  const ViewRoutine({Key? key}) : super(key: key);

  @override
  State<ViewRoutine> createState() => _ViewRoutineState();
}

class _ViewRoutineState extends State<ViewRoutine> {
  late final String routineId;
  late final Workout workout;
  late final Map<String, dynamic> workoutSettings;
  late final Map<String, dynamic> workoutSettingsDecoded;
  late final Map<String, dynamic> workoutAreas;
  late final int areasTrainable;
  late final int exercisesCount;
  final int randomImageIdentifier = 0 + Random().nextInt(2 - 0);
  final List imageNames = [
    'image_one.png',
    'image_two.png',
    'image_three.png',
  ];

  List exercises = [];
  List areasTrainableList = [];

  @override
  void initState() {
    if (context.read<RoutineProvider>().viewRoutine != null) {
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
    Provider.of<RoutineProvider>(context, listen: false).viewRoutine = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        context.read<AppProvider>().device = null;
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          backgroundColor: AppColor.white,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          scrolledUnderElevation: 0.5,
          centerTitle: false,
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(
                  builder: (context) => IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColor.greyShade800,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    workout.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColor.greyShade800),
                  ),
                ),
                const SizedBox(
                  width: 35.0,
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black,
                            Colors.black,
                            AppColor.transparent,
                          ],
                        ).createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.height),
                        );
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image.asset(
                        'assets/images/v/${workoutSettings['mode']}/${imageNames[randomImageIdentifier]}',
                        width: 150,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      width: (MediaQuery.of(context).size.width / 2),
                      decoration: BoxDecoration(
                        color: AppColor.greyShade100,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${workoutSettingsDecoded['train_time']}',
                            style: TextStyle(
                              color: AppColor.greyShade800,
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            ' minutes ${workoutSettings['mode']} routine',
                            style: TextStyle(
                              color: AppColor.greyShade800,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                        ),
                        padding: const EdgeInsets.all(15),
                        width: (MediaQuery.of(context).size.width / 2),
                        decoration: BoxDecoration(
                          color: AppColor.blue,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${workoutSettingsDecoded['k_calorie_burn']}',
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 30,
                              ),
                            ),
                            Text(
                              ' kCal',
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '$areasTrainable area stimulation\'s with $exercisesCount exercises.',
                  style: TextStyle(
                    color: AppColor.greyShade800,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Your last activities',
                  style: TextStyle(
                    color: AppColor.greyShade800,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const LastActivities(
                  completed: true,
                  time: 20,
                  date: '12/12/2022',
                  calorieBurn: 715,
                ),
                const LastActivities(
                  completed: false,
                  time: 13,
                  date: '11/12/2022',
                  calorieBurn: 321,
                ),
                FutureBuilder(
                  future: Provider.of<RoutineProvider>(context)
                      .getExercisesForThisWorkout(
                    count: exercisesCount,
                    subMode: workoutSettings['sub_mode'],
                    areas: areasTrainableList,
                  ),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                        List<Map<String, dynamic>>? wE = snapshot.data;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                'Exercises in this routine',
                                style: TextStyle(
                                  color: AppColor.greyShade800,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColor.blue,
                                  width: 2.0,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: GridView.count(
                                crossAxisCount:
                                    wE!.length > 10 ? 10 : wE.length,
                                padding: const EdgeInsets.all(3),
                                crossAxisSpacing: 2,
                                shrinkWrap: true,
                                children: wE
                                    .map((e) => Image.asset(
                                        'assets/images/e/${e['image']}'))
                                    .toList(),
                              ),
                            ),
                          ],
                        );
                      default:
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColor.blue,
                          ),
                        );
                    }
                  },
                ),
                const SizedBox(
                  height: 35,
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isDismissible: false,
                        enableDrag: false,
                        builder: (BuildContext context) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            height: 500,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Select Bluetooth device',
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Provider.of<AppProvider>(context,
                                                listen: false)
                                            .device = null;
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: AppColor.blue,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: AppColor.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                    'This routine requires bluetooth connection to the SixCore wearable device. Please connect to the device by scanning for and selecting the device below.'),
                                Consumer<AppProvider>(
                                    builder: (context, appProvider, _) {
                                  return StreamBuilder(
                                      stream: appProvider.flutterBlue.state,
                                      initialData: BluetoothState.unknown,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<BluetoothState>
                                              snapshot) {
                                        final state = snapshot.data;
                                        if (state == BluetoothState.on) {
                                          return FindDeviceScreen(
                                              provider: appProvider);
                                        } else {
                                          return bluetoothOff();
                                        }
                                      });
                                }),
                              ],
                            ),
                          );
                        });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: AppColor.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.start,
                          color: AppColor.white,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Begin routine',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColor.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column bluetoothOff() {
    return Column(
      children: const [
        Center(
          child: Text('Bluetooth is switched off.'),
        )
      ],
    );
  }
}

class FindDeviceScreen extends StatelessWidget {
  final AppProvider provider;

  const FindDeviceScreen({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return provider.device == null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: StatefulButton(
                    onTap: () {
                      provider.beginScanning();
                    },
                    label: 'Scan for device',
                    isLoading: provider.isLoading,
                  ),
                ),
              ),
              provider.isLoading != true
                  ? StreamBuilder<List<ScanResult>>(
                      stream: provider.flutterBlue.scanResults,
                      initialData: const [],
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<List<ScanResult>> snapshot,
                      ) {
                        List<ScanResult>? devices = snapshot.data!
                            .where(
                                (ScanResult d) => d.device.name == deviceName)
                            .toList();
                        if (devices.isEmpty && provider.btScanRan) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: const Text(
                              'No device found',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 17),
                            ),
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: devices.map((ScanResult r) {
                            return GestureDetector(
                              onTap: () {
                                provider.device = r.device;
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color: AppColor.blue,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.settings_bluetooth_rounded,
                                      color: AppColor.white,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      r.device.name,
                                      style: TextStyle(
                                        color: AppColor.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      })
                  : Container(),
            ],
          )
        : SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  Text(
                    '${provider.device!.name} device selected',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: () {
                      PageNavigator(context: context)
                          .nextPage(page: Paths.workRoutinePath);
                    },
                    icon: const Icon(Icons.play_circle_outline_rounded),
                    label: const Text('Begin Routine with workouts'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      provider.device = null;
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(AppColor.error),
                    ),
                    icon: const Icon(Icons.lock_reset),
                    label: const Text('reset'),
                  ),
                ],
              ),
            ),
          );
  }
}
