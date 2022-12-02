import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sixcore/Models/exercise.dart';
import 'package:sixcore/Models/user_profile.dart';
import 'package:sixcore/Models/workout_model.dart';

class DbRefs {
  static CollectionReference<UserProfile> userProfileRef = FirebaseFirestore
      .instance
      .collection('userProfile')
      .withConverter<UserProfile>(
        fromFirestore: (snapshot, _) => UserProfile.fromJson(snapshot.data()!),
        toFirestore: (userProfile, _) => userProfile.toJson(),
      );

  static CollectionReference<Workout> workoutsRef =
      FirebaseFirestore.instance.collection('workouts').withConverter<Workout>(
            fromFirestore: (snapshot, _) => Workout.fromJson(snapshot.data()!),
            toFirestore: (workout, _) => workout.toJson(),
          );

  static CollectionReference<Exercise> exercisesRef =
      FirebaseFirestore.instance.collection('exercise').withConverter<Exercise>(
            fromFirestore: (snapshot, _) => Exercise.fromJson(snapshot.data()!),
            toFirestore: (exercise, _) => exercise.toJson(),
          );
}
