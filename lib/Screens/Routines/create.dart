import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixcore/Constants/colors.dart';
import 'package:sixcore/Provider/user_provider.dart';

import '../../Constants/routine.dart';
import '../../Provider/routine_provider.dart';
import '../../Utils/body_map_utils.dart';
import '../../Widgets/Selectors/quantity_selector_widget.dart';
import '../../Widgets/cool_stepper/cool_stepper.dart';
import '../../Widgets/cool_stepper/src/models/cool_step.dart';
import '../../Widgets/cool_stepper/src/models/cool_stepper_config.dart';

class CreateRoutine extends StatefulWidget {
  const CreateRoutine({Key? key}) : super(key: key);

  @override
  State<CreateRoutine> createState() => _CreateRoutineState();
}

class _CreateRoutineState extends State<CreateRoutine> {
  final _formKey = GlobalKey<FormState>();
  String? selectedMode = '';
  String? selectedSubMode = '';
  final TextEditingController _nameCtrl = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) =>
        Provider.of<RoutineProvider>(context, listen: false).initNewRoutine());
    super.initState();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      CoolStep(
        isHeaderEnabled: false,
        title: 'Select your role',
        subtitle: 'Choose a role that better defines you',
        color: AppColor.blue,
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Select Mode',
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'What mode do you want this routine to run?',
                style: TextStyle(
                  color: AppColor.white,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  _buildModeSelector(
                    context: context,
                    name: 'workout',
                  ),
                  const SizedBox(width: 5.0),
                  _buildModeSelector(
                    context: context,
                    name: 'refresh',
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  _buildModeSelector(
                    context: context,
                    name: 'massage',
                  ),
                ],
              ),
              Consumer<RoutineProvider>(builder: (context, routineProvider, _) {
                return routineProvider.createRoutine['mode'] != ''
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                width: 2,
                                color: AppColor.teal,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Rules',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'It is imperative that you follow the rules below to ensure maximum effectiveness and ensure no injury occurs.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ...RoutineModes()
                                    .getProp(routineProvider
                                        .createRoutine['mode'])['rules']
                                    ?.asMap()
                                    .entries
                                    .map(
                                      (rule) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3.0),
                                        child: Text(
                                          '${rule.key + 1}.  ${rule.value}',
                                          style: TextStyle(
                                            color: AppColor.white,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ],
                            ),
                          ),
                        ],
                      )
                    : const SizedBox();
              }),
              Consumer<RoutineProvider>(builder: (context, routineProvider, _) {
                Map<String, dynamic>? routineModeData =
                    routineProvider.getModeDetailsFromSelectedMode();

                if (routineModeData != null &&
                    routineModeData.containsKey('sub')) {
                  return SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'Select Routine Type',
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...routineModeData['sub'].map((s) {
                          return _buildSubModeSelector(
                            name: s['key'],
                            context: context,
                            item: s,
                          );
                        }).toList(),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }),
            ],
          ),
        ),
        validation: () {
          var newRoutine = Provider.of<RoutineProvider>(context, listen: false)
              .createRoutine;
          return newRoutine['mode'] == '' || newRoutine['sub_mode'] == ''
              ? 'You must select a mode and type.'
              : null;
        },
      ),
      CoolStep(
        isHeaderEnabled: false,
        title: 'Body Selection (front)',
        subtitle: 'Select the parts of the body to workout',
        content: Form(
          key: _formKey,
          child: Consumer<RoutineProvider>(
            builder: (context, routineProvider, _) {
              return Column(
                children: [
                  Center(
                    child: SizedBox(
                      width: 250,
                      child: Column(
                        children: [
                          const SizedBox(height: 20.0),
                          Text(
                            'Select body areas stimulation intensities...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColor.blue,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Stack(
                            children: [
                              Center(
                                child: Image.asset(
                                  'assets/images/bodmap.png',
                                  width: 250,
                                ),
                              ),
                              Positioned(
                                top: 75,
                                left: 41,
                                child: ClipOval(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    color: pointsColor(routineProvider
                                            .createRoutine['routineAreas']
                                        [BodyAreas.chest]),
                                  ),
                                ),
                              ), // Chest
                              Positioned(
                                top: 75,
                                left: 69,
                                child: ClipOval(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    color: pointsColor(routineProvider
                                            .createRoutine['routineAreas']
                                        [BodyAreas.chest]),
                                  ),
                                ),
                              ), // Chest
                              Positioned(
                                top: 94,
                                left: 91,
                                child: ClipOval(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    color: pointsColor(routineProvider
                                            .createRoutine['routineAreas']
                                        [BodyAreas.biceps]),
                                  ),
                                ),
                              ), // Left Bicep
                              Positioned(
                                top: 94,
                                left: 21,
                                child: ClipOval(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    color: pointsColor(routineProvider
                                            .createRoutine['routineAreas']
                                        [BodyAreas.biceps]),
                                  ),
                                ),
                              ), // Right Bicep
                              Positioned(
                                top: 119,
                                left: 46,
                                child: ClipOval(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    color: pointsColor(routineProvider
                                            .createRoutine['routineAreas']
                                        [BodyAreas.abdomen]),
                                  ),
                                ),
                              ), // Abdomen
                              Positioned(
                                top: 119,
                                left: 65,
                                child: ClipOval(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    color: pointsColor(routineProvider
                                            .createRoutine['routineAreas']
                                        [BodyAreas.abdomen]),
                                  ),
                                ),
                              ), // Abdomen
                              Positioned(
                                top: 188,
                                left: 69,
                                child: ClipOval(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    color: pointsColor(routineProvider
                                            .createRoutine['routineAreas']
                                        [BodyAreas.thighs]),
                                  ),
                                ),
                              ), // Thigh
                              Positioned(
                                top: 188,
                                left: 38,
                                child: ClipOval(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    color: pointsColor(routineProvider
                                            .createRoutine['routineAreas']
                                        [BodyAreas.thighs]),
                                  ),
                                ),
                              ), // Thigh
                              Positioned(
                                top: 250,
                                right: 39,
                                child: ClipOval(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    color: pointsColor(routineProvider
                                            .createRoutine['routineAreas']
                                        [BodyAreas.calf]),
                                  ),
                                ),
                              ), // Calf
                              Positioned(
                                top: 250,
                                right: 65,
                                child: ClipOval(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    color: pointsColor(routineProvider
                                            .createRoutine['routineAreas']
                                        [BodyAreas.calf]),
                                  ),
                                ),
                              ), // Calf
                              Positioned(
                                top: 190,
                                right: 39,
                                child: ClipOval(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    color: pointsColor(routineProvider
                                            .createRoutine['routineAreas']
                                        [BodyAreas.hamstrings]),
                                  ),
                                ),
                              ), // Hamstrings
                              Positioned(
                                top: 190,
                                right: 65,
                                child: ClipOval(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    color: pointsColor(routineProvider
                                            .createRoutine['routineAreas']
                                        [BodyAreas.hamstrings]),
                                  ),
                                ),
                              ), // Hamstrings
                              Positioned(
                                top: 160,
                                right: 38,
                                child: ClipOval(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    color: pointsColor(routineProvider
                                            .createRoutine['routineAreas']
                                        [BodyAreas.glutes]),
                                  ),
                                ),
                              ), // Glutes
                              Positioned(
                                top: 160,
                                right: 65,
                                child: ClipOval(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    color: pointsColor(routineProvider
                                            .createRoutine['routineAreas']
                                        [BodyAreas.glutes]),
                                  ),
                                ),
                              ), // Glutes
                              Positioned(
                                top: 120,
                                right: 42,
                                child: ClipOval(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    color: pointsColor(routineProvider
                                            .createRoutine['routineAreas']
                                        [BodyAreas.lowerBack]),
                                  ),
                                ),
                              ), // Lower Back
                              Positioned(
                                top: 120,
                                right: 65,
                                child: ClipOval(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    color: pointsColor(routineProvider
                                            .createRoutine['routineAreas']
                                        [BodyAreas.lowerBack]),
                                  ),
                                ),
                              ), // Lower Back
                              Positioned(
                                top: 100,
                                right: 37,
                                child: ClipOval(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    color: pointsColor(routineProvider
                                            .createRoutine['routineAreas']
                                        [BodyAreas.upperBack]),
                                  ),
                                ),
                              ), // Upper Back
                              Positioned(
                                top: 100,
                                right: 70,
                                child: ClipOval(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    color: pointsColor(routineProvider
                                            .createRoutine['routineAreas']
                                        [BodyAreas.upperBack]),
                                  ),
                                ),
                              ), // Upper Back
                              Positioned(
                                top: 100,
                                right: 20,
                                child: ClipOval(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    color: pointsColor(routineProvider
                                            .createRoutine['routineAreas']
                                        [BodyAreas.triceps]),
                                  ),
                                ),
                              ), // Triceps
                              Positioned(
                                top: 100,
                                right: 90,
                                child: ClipOval(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    color: pointsColor(routineProvider
                                            .createRoutine['routineAreas']
                                        [BodyAreas.triceps]),
                                  ),
                                ),
                              ), // Triceps
                              Positioned(
                                top: 80,
                                right: 30,
                                child: ClipOval(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    color: pointsColor(routineProvider
                                            .createRoutine['routineAreas']
                                        [BodyAreas.trapezium]),
                                  ),
                                ),
                              ), // Trapeziums
                              Positioned(
                                top: 80,
                                right: 80,
                                child: ClipOval(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    color: pointsColor(routineProvider
                                            .createRoutine['routineAreas']
                                        [BodyAreas.trapezium]),
                                  ),
                                ),
                              ), // Trapeziums
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20.0)),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 30.0,
                      right: 30.0,
                      bottom: 20.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        QuantitySelectorWidget(
                          label: 'Biceps',
                          callback: (value) {
                            routineProvider.createRoutine['routineAreas']
                                [BodyAreas.biceps] = value;
                          },
                        ),
                        QuantitySelectorWidget(
                          label: 'Triceps',
                          callback: (value) {
                            routineProvider.createRoutine['routineAreas']
                                [BodyAreas.triceps] = value;
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 30.0,
                      right: 30.0,
                      bottom: 20.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        QuantitySelectorWidget(
                          label: 'Chest',
                          callback: (value) {
                            routineProvider.createRoutine['routineAreas']
                                [BodyAreas.chest] = value;
                          },
                        ),
                        QuantitySelectorWidget(
                          label: 'Abdomen',
                          callback: (value) {
                            routineProvider.createRoutine['routineAreas']
                                [BodyAreas.abdomen] = value;
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 30.0,
                      right: 30.0,
                      bottom: 20.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        QuantitySelectorWidget(
                          label: 'Thighs',
                          callback: (value) {
                            routineProvider.createRoutine['routineAreas']
                                [BodyAreas.thighs] = value;
                          },
                        ),
                        QuantitySelectorWidget(
                          label: 'Calf',
                          callback: (value) {
                            routineProvider.createRoutine['routineAreas']
                                [BodyAreas.calf] = value;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        validation: () {
          if (!_formKey.currentState!.validate()) {
            return 'Fill form correctly';
          }
          return null;
        },
      ),
      CoolStep(
        isHeaderEnabled: false,
        title: 'Body Selection (back)',
        subtitle: 'Select the parts of the body to workout',
        content: Consumer<RoutineProvider>(
          builder: (context, routineProvider, _) {
            return Column(
              children: [
                Center(
                  child: SizedBox(
                    width: 250,
                    child: Column(
                      children: [
                        const SizedBox(height: 20.0),
                        Text(
                          'Select body areas stimulation intensities...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.blue,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Stack(
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/images/bodmap.png',
                                width: 250,
                              ),
                            ),
                            Positioned(
                              top: 75,
                              left: 41,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(routineProvider
                                          .createRoutine['routineAreas']
                                      [BodyAreas.chest]),
                                ),
                              ),
                            ), // Chest
                            Positioned(
                              top: 75,
                              left: 69,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(routineProvider
                                          .createRoutine['routineAreas']
                                      [BodyAreas.chest]),
                                ),
                              ),
                            ), // Chest
                            Positioned(
                              top: 94,
                              left: 91,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(routineProvider
                                          .createRoutine['routineAreas']
                                      [BodyAreas.biceps]),
                                ),
                              ),
                            ), // Left Bicep
                            Positioned(
                              top: 94,
                              left: 21,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(routineProvider
                                          .createRoutine['routineAreas']
                                      [BodyAreas.biceps]),
                                ),
                              ),
                            ), // Right Bicep
                            Positioned(
                              top: 119,
                              left: 46,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(routineProvider
                                          .createRoutine['routineAreas']
                                      [BodyAreas.abdomen]),
                                ),
                              ),
                            ), // Abdomen
                            Positioned(
                              top: 119,
                              left: 65,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(routineProvider
                                          .createRoutine['routineAreas']
                                      [BodyAreas.abdomen]),
                                ),
                              ),
                            ), // Abdomen
                            Positioned(
                              top: 188,
                              left: 69,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(routineProvider
                                          .createRoutine['routineAreas']
                                      [BodyAreas.thighs]),
                                ),
                              ),
                            ), // Thigh
                            Positioned(
                              top: 188,
                              left: 38,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(routineProvider
                                          .createRoutine['routineAreas']
                                      [BodyAreas.thighs]),
                                ),
                              ),
                            ), // Thigh
                            Positioned(
                              top: 250,
                              right: 39,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(routineProvider
                                          .createRoutine['routineAreas']
                                      [BodyAreas.calf]),
                                ),
                              ),
                            ), // Calf
                            Positioned(
                              top: 250,
                              right: 65,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(routineProvider
                                          .createRoutine['routineAreas']
                                      [BodyAreas.calf]),
                                ),
                              ),
                            ), // Calf
                            Positioned(
                              top: 190,
                              right: 39,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(routineProvider
                                          .createRoutine['routineAreas']
                                      [BodyAreas.hamstrings]),
                                ),
                              ),
                            ), // Hamstrings
                            Positioned(
                              top: 190,
                              right: 65,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(routineProvider
                                          .createRoutine['routineAreas']
                                      [BodyAreas.hamstrings]),
                                ),
                              ),
                            ), // Hamstrings
                            Positioned(
                              top: 160,
                              right: 38,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(routineProvider
                                          .createRoutine['routineAreas']
                                      [BodyAreas.glutes]),
                                ),
                              ),
                            ), // Glutes
                            Positioned(
                              top: 160,
                              right: 65,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(routineProvider
                                          .createRoutine['routineAreas']
                                      [BodyAreas.glutes]),
                                ),
                              ),
                            ), // Glutes
                            Positioned(
                              top: 120,
                              right: 42,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(routineProvider
                                          .createRoutine['routineAreas']
                                      [BodyAreas.lowerBack]),
                                ),
                              ),
                            ), // Lower Back
                            Positioned(
                              top: 120,
                              right: 65,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(routineProvider
                                          .createRoutine['routineAreas']
                                      [BodyAreas.lowerBack]),
                                ),
                              ),
                            ), // Lower Back
                            Positioned(
                              top: 100,
                              right: 37,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(routineProvider
                                          .createRoutine['routineAreas']
                                      [BodyAreas.upperBack]),
                                ),
                              ),
                            ), // Upper Back
                            Positioned(
                              top: 100,
                              right: 70,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(routineProvider
                                          .createRoutine['routineAreas']
                                      [BodyAreas.upperBack]),
                                ),
                              ),
                            ), // Upper Back
                            Positioned(
                              top: 100,
                              right: 20,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(routineProvider
                                          .createRoutine['routineAreas']
                                      [BodyAreas.triceps]),
                                ),
                              ),
                            ), // Triceps
                            Positioned(
                              top: 100,
                              right: 90,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(routineProvider
                                          .createRoutine['routineAreas']
                                      [BodyAreas.triceps]),
                                ),
                              ),
                            ), // Triceps
                            Positioned(
                              top: 80,
                              right: 30,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(routineProvider
                                          .createRoutine['routineAreas']
                                      [BodyAreas.trapezium]),
                                ),
                              ),
                            ), // Trapeziums
                            Positioned(
                              top: 80,
                              right: 80,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(routineProvider
                                          .createRoutine['routineAreas']
                                      [BodyAreas.trapezium]),
                                ),
                              ),
                            ), // Trapeziums
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 20.0)),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                    bottom: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      QuantitySelectorWidget(
                        label: 'Trapezius',
                        callback: (value) {
                          routineProvider.createRoutine['routineAreas']
                              [BodyAreas.trapezium] = value;
                        },
                      ),
                      QuantitySelectorWidget(
                        label: 'Upper Back',
                        callback: (value) {
                          routineProvider.createRoutine['routineAreas']
                              [BodyAreas.upperBack] = value;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                    bottom: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      QuantitySelectorWidget(
                        label: 'Lower Back',
                        callback: (value) {
                          routineProvider.createRoutine['routineAreas']
                              [BodyAreas.lowerBack] = value;
                        },
                      ),
                      QuantitySelectorWidget(
                        label: 'Glutes',
                        callback: (value) {
                          routineProvider.createRoutine['routineAreas']
                              [BodyAreas.glutes] = value;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                    bottom: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      QuantitySelectorWidget(
                        label: 'Quads',
                        callback: (value) {
                          routineProvider.createRoutine['routineAreas']
                              [BodyAreas.quads] = value;
                        },
                      ),
                      QuantitySelectorWidget(
                        label: 'Hamstrings',
                        callback: (value) {
                          routineProvider.createRoutine['routineAreas']
                              [BodyAreas.hamstrings] = value;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        validation: () {
          return null;
        },
      ),
      CoolStep(
        isHeaderEnabled: false,
        title: '',
        subtitle: '',
        content: Column(
          children: [
            const SizedBox(height: 20.0),
            Text(
              'Give your routine a name',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.blue,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                hintText: 'Enter your routine name',
                hintStyle: TextStyle(
                  color: AppColor.greyShade800,
                ),
              ),
              onChanged: (String value) {
                Provider.of<RoutineProvider>(context, listen: false)
                    .createRoutine['name'] = value;
                Provider.of<RoutineProvider>(context, listen: false)
                        .createRoutine['createdBy'] =
                    Provider.of<UserProvider>(context, listen: false)
                        .currentUser
                        ?.uid;
                Provider.of<RoutineProvider>(context, listen: false)
                        .createRoutine['assignedTo'] =
                    Provider.of<UserProvider>(context, listen: false)
                        .currentUser
                        ?.uid;
              },
            ),
          ],
        ),
        validation: () {
          if (_nameCtrl.text.isEmpty) {
            return 'Please enter a name to save this routine.';
          }
          return null;
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new routine'),
      ),
      body: SafeArea(
        child: CoolStepper(
          showErrorSnackbar: true,
          onCompleted: () {
            Provider.of<RoutineProvider>(context, listen: false)
                .saveNewRoutine(context: context);
          },
          steps: steps,
          config: const CoolStepperConfig(
            backText: 'PREV',
          ),
        ),
      ),
    );
  }

  Widget _buildModeSelector({
    BuildContext? context,
    required String name,
    Color? activeColor = Colors.white,
    Color? color = Colors.white,
  }) {
    final isActive =
        name == Provider.of<RoutineProvider>(context!).createRoutine['mode'];

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).primaryColor : null,
          border: Border.all(
            width: 0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: RadioListTile(
          value: name,
          activeColor: Colors.white,
          groupValue: selectedMode,
          onChanged: (String? v) {
            Provider.of<RoutineProvider>(context, listen: false)
                .updateNewRoutineAttributes(key: 'mode', value: v);
          },
          title: Text(
            name[0].toUpperCase() + name.substring(1),
            style: TextStyle(
              color: isActive ? activeColor : color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubModeSelector({
    BuildContext? context,
    required String name,
    required Map<String, dynamic> item,
    Color? activeColor = Colors.white,
    Color? color = Colors.white,
  }) {
    final isActive = name ==
        Provider.of<RoutineProvider>(context!).createRoutine['sub_mode'];

    return AnimatedContainer(
      margin: const EdgeInsets.only(bottom: 15),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor : null,
        border: Border.all(
          width: 0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: RadioListTile(
        value: name,
        activeColor: Colors.white,
        groupValue: selectedSubMode,
        onChanged: (String? v) {
          Provider.of<RoutineProvider>(context, listen: false)
              .updateNewRoutineAttributes(key: 'sub_mode', value: v);
        },
        title: Text(
          item['name'],
          style: TextStyle(
            color: isActive ? activeColor : color,
          ),
        ),
      ),
    );
  }
}
