class BodyAreas {
  static String biceps = 'biceps';
  static String triceps = 'triceps';
  static String chest = 'chest';
  static String abdomen = 'abdomen';
  static String thighs = 'thighs';
  static String calf = 'calf';
  static String trapezium = 'trapezium';
  static String upperBack = 'upperBack';
  static String lowerBack = 'lowerBack';
  static String glutes = 'glutes';
  static String quads = 'quads';
  static String hamstrings = 'hamstrings';
}

class RoutineModes {
  Map<String, dynamic> getProp(String key) => <String, dynamic>{
        'workout': workout,
        'refresh': refresh,
        'massage': massage,
      }[key];

  static Map<String, dynamic> workout = {
    'name': 'Workout',
    'sub': [
      {
        'key': 'power',
        'name': 'Power',
        'frequency': 85,
        'pulse_width': 350,
        'pulse_time': 20,
        'pause_time': 0,
        'train_time': 20,
        'k_calorie_burn': 715,
      },
      {
        'key': 'endurance',
        'name': 'Endurance',
        'frequency': 40,
        'pulse_width': 350,
        'pulse_time': 4,
        'pause_time': 4,
        'train_time': 20,
        'k_calorie_burn': 715,
      },
      {
        'key': 'fat_burning',
        'name': 'Fat Burning',
        'frequency': 85,
        'pulse_width': 350,
        'pulse_time': 4,
        'pause_time': 4,
        'train_time': 20,
        'k_calorie_burn': 715,
      },
    ],
    'rules': [
      'Routine may only be done twice per week.',
      'A maximum of 20 mins per routine is advised.',
      'It is also advised to have a break of 72 hours.',
    ],
  };

  static Map<String, dynamic> refresh = {
    'name': 'Refresh',
    'sub': [
      {
        'key': 'meta_cell',
        'name': 'Meta & Cell',
        'frequency': 7,
        'pulse_width': 350,
        'pulse_time': 20,
        'pause_time': 0,
        'train_time': 10,
        'k_calorie_burn': 200,
      }
    ],
    'rules': [
      'Routine may only be done twice per day.',
      'A maximum of 10 mins per routine is advised.',
      'It is also advised to have a break of 6 hours.',
    ],
  };

  static Map<String, dynamic> massage = {
    'name': 'Massage',
    'sub': [
      {
        'key': 'body_relax',
        'name': 'Meta & Cell',
        'frequency': 7,
        'pulse_width': 350,
        'pulse_time': 20,
        'pause_time': 0,
        'train_time': 20,
        'k_calorie_burn': 100,
      }
    ],
    'rules': [
      'Routine may only be done once per day.',
      'A maximum of 20 mins per routine is advised.',
      'It is also advised to have a break of 72 hours.',
      'Massage after workout must have a minimum wait time of 12 to 24 hours.',
    ],
  };
}
