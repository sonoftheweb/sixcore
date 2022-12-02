import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sixcore/Constants/routine.dart';
import 'package:sixcore/Models/db_refs.dart';
import 'package:sixcore/Models/exercise.dart';
import 'package:sixcore/router/router.dart';
import 'package:sixcore/router/routes.dart';

import '../Models/workout_model.dart';

class RoutineProvider with ChangeNotifier {
  final Map<String, dynamic> _routineTemplate = {
    'name': '',
    'createdBy': '',
    'assignedTo': '',
    'routineAreas': {
      BodyAreas.biceps: 0,
      BodyAreas.triceps: 0,
      BodyAreas.chest: 0,
      BodyAreas.abdomen: 0,
      BodyAreas.thighs: 0,
      BodyAreas.calf: 0,
      BodyAreas.trapezium: 0,
      BodyAreas.upperBack: 0,
      BodyAreas.lowerBack: 0,
      BodyAreas.glutes: 0,
      BodyAreas.quads: 0,
      BodyAreas.hamstrings: 0,
    },
    'mode': '',
    'sub_mode': ''
  };
  Map<String, dynamic> createRoutine = {};
  Map<String, dynamic>? viewRoutine;
  List<Map<String, dynamic>>? _viewRoutineExercises;

  void initNewRoutine() {
    createRoutine = _routineTemplate;
    notifyListeners();
  }

  void updateNewRoutineAttributes(
      {required String key, required dynamic value}) {
    createRoutine[key] = value;
    notifyListeners();
  }

  Map<String, dynamic>? getModeDetailsFromSelectedMode() {
    return (createRoutine.containsKey('mode') && createRoutine['mode'] != '')
        ? RoutineModes().getProp(createRoutine['mode'])
        : null;
  }

  Future<List<Map<String, dynamic>>?>? getAllWorkoutExercise() async {
    if (_viewRoutineExercises == null) {
      List<Map<String, dynamic>> woe = [];
      List<QueryDocumentSnapshot<Exercise>> e =
          await DbRefs.exercisesRef.get().then((snapshot) => snapshot.docs);
      for (QueryDocumentSnapshot<Exercise> snapshot in e) {
        var eData = snapshot.data();
        woe.add({
          'name': eData.name,
          'areas': eData.areas,
          'mode': eData.routineModes,
          'sub_mode': eData.routineSubModes,
          'image': eData.image,
        });
      }

      _viewRoutineExercises = woe;
      notifyListeners();
    }
    return _viewRoutineExercises;
  }

  Future<List<Map<String, dynamic>>> getExercisesForThisWorkout({
    required int count,
    required String subMode,
    required List areas,
  }) async {
    List<Map<String, dynamic>>? allWoE = await getAllWorkoutExercise();
    List<Map<String, dynamic>> filtered =
        allWoE!.where((Map<String, dynamic> e) {
      return e['sub_mode'].contains(subMode);
    }).where((Map<String, dynamic> e) {
      return areas.any((value) => e['areas'].contains(value));
    }).toList();
    return (filtered..shuffle()).take(count).toList();
  }

  saveNewRoutine({required BuildContext context}) async {
    await DbRefs.workoutsRef.add(
      Workout(
        name: createRoutine['name'],
        createdBy: createRoutine['createdBy'],
        assignedTo: createRoutine['assignedTo'],
        workoutAreas: jsonEncode(createRoutine['routineAreas']),
        workoutSettings: json.encode({
          'mode': createRoutine['mode'],
          'sub_mode': createRoutine['sub_mode']
        }),
      ),
    );

    PageNavigator(context: context).nextPageOnly(page: Routes.dashboardRoute);
  }
}
