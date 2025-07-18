import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class FormValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter an email address.';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email (e.g., user@example.com).';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password.';
    if (value.length < 6) return 'Password must be at least 6 characters long.';
    return null;
  }

  static String? validatePlanTitle(String? value) {
    if (value == null || value.isEmpty){
      return 'Please enter a title for the plan.';
    }
    return null;
  }

  static String? validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name (e.g., John Doe).';
    }
    return null;
  }

  static String? validateName(String? value, String fieldType) {
    if (value == null || value.isEmpty) {
      return fieldType == 'meal'
          ? 'Please enter a name for the meal (e.g., Breakfast).'
          : 'Please enter a name for the exercise (e.g., Push-ups).';
    }
    return null;
  }

  static String? validateInstruction(String? value) {
    if (value == null || value.isEmpty)
      return 'Please provide an instruction step.';
    return null;
  }

  static String? validateReps(String? value, String repsType) {
    if (value == null || value.isEmpty) {
      return repsType == 'reps'
          ? 'Please enter the number of reps (e.g., 10).'
          : 'Please enter the duration in minutes (e.g., 5).';
    }
    if (int.tryParse(value) == null || int.parse(value) <= 0) {
      return repsType == 'reps'
          ? 'Please enter a valid number of reps (e.g., 10).'
          : 'Please enter a valid duration in minutes (e.g., 5).';
    }
    return null;
  }

  static String? validateSets(String? value) {
    if (value == null || value.isEmpty)
      return 'Please enter the number of sets (e.g., 3).';
    if (int.tryParse(value) == null || int.parse(value) <= 0) {
      return 'Please enter a valid number of sets (e.g., 3).';
    }
    return null;
  }

  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty)
      return 'Please enter a quantity (e.g., 100).';
    if (int.tryParse(value) == null || int.parse(value) <= 0) {
      return 'Please enter a valid integer quantity (e.g., 100).';
    }
    return null;
  }

  static String? validateCalories(String? value) {
    if (value == null || value.isEmpty)
      return 'Please enter a calorie count (e.g., 200).';
    if (int.tryParse(value) == null || int.parse(value) < 0) {
      return 'Please enter a valid calorie count (e.g., 200).';
    }
    return null;
  }

  static String? validateYouTubeUrl(String? value) {
    if (value == null || value.isEmpty) return null;
    if (YoutubePlayerController.convertUrlToId(value.trim()) == null) {
      return 'Please enter a valid YouTube URL (e.g., https://youtu.be/xyz).';
    }
    return null;
  }
}
