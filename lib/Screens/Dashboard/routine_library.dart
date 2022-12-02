import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixcore/Provider/routine_provider.dart';
import 'package:sixcore/router/router.dart';
import 'package:sixcore/router/routes.dart';

import '../../Constants/routine.dart';
import '../../Models/workout_model.dart';
import '../../Utils/dialogs.dart';

class RoutineLibraryWidget extends StatefulWidget {
  const RoutineLibraryWidget({Key? key}) : super(key: key);

  @override
  State<RoutineLibraryWidget> createState() => _RoutineLibraryWidgetState();
}

class _RoutineLibraryWidgetState extends State<RoutineLibraryWidget>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _animationController,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 28, right: 28, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Routine Library',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.normal,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  PageNavigator(context: context)
                      .nextPage(page: Routes.createRoutineRoute);
                },
                icon: const Icon(
                  Icons.add_rounded,
                  size: 12,
                ),
                label: const Text(
                  'new routine',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Below is a list of all your recorded routines. Swipe to delete or tap to view details.',
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FirestoreListView(
              shrinkWrap: true,
              query: FirebaseFirestore.instance
                  .collection('workouts')
                  .where('createdBy',
                      isEqualTo: FirebaseAuth.instance.currentUser!
                          .uid) //@todo: add checks for user ID
                  .where('name', isNotEqualTo: '')
                  .withConverter<Workout>(
                    fromFirestore: (snapshot, _) =>
                        Workout.fromJson(snapshot.data()!),
                    toFirestore: (workout, _) => workout.toJson(),
                  ),
              itemBuilder: (context, snapshot) {
                Workout workout = snapshot.data();
                String workoutId = snapshot.id;
                Map<String, dynamic> areas = json.decode(workout.workoutAreas);
                num areasTrainable =
                    areas.entries.where((a) => a.value != 0).toList().length;
                Map<String, dynamic> settings =
                    json.decode(workout.workoutSettings);
                List subMode = RoutineModes()
                    .getProp(settings['mode'])['sub']
                    .where((sub) {
                  return sub['key'] == settings['sub_mode'];
                }).toList();

                return GestureDetector(
                    onTap: () {
                      Provider.of<RoutineProvider>(context, listen: false)
                          .viewRoutine = {'id': workoutId, 'workout': workout};
                      PageNavigator(context: context)
                          .nextPage(page: Paths.viewRoutinePath);
                    },
                    child: Dismissible(
                      key: ObjectKey(workoutId),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        child: const Icon(Icons.delete),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        child: const Icon(Icons.delete),
                      ),
                      confirmDismiss: (DismissDirection direction) async {
                        final shouldDelete =
                            await showDeleteDialog(context: context);
                        if (shouldDelete) {
                          await FirebaseFirestore.instance
                              .collection('workouts')
                              .doc(workoutId)
                              .delete();
                        }
                      },
                      child: ListTile(
                        title: Text(
                          workout.name,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        leading: (workout.createdBy == workout.assignedTo)
                            ? const Icon(Icons.verified_user)
                            : const Icon(Icons.supervised_user_circle),
                        trailing: Text('${subMode.first['train_time']} mins'),
                        subtitle: Text('$areasTrainable stimulated areas'),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
