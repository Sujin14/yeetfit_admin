// core/utils/form_validators.dart
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class FormValidators {
  // ... keep your other validators above (omitted here for brevity) ...

  /// Extracts a clean 11-character YouTube video ID from many URL formats.
  /// Returns null when no 11-char ID is found.
  static String? extractYouTubeId(String? url) {
    if (url == null) return null;
    final trimmed = url.trim();

    if (trimmed.isEmpty) return null;

    // 1) Quick attempt with package helper (works for simple urls)
    try {
      final quick = YoutubePlayerController.convertUrlToId(trimmed);
      if (quick != null && quick.length == 11) {
        return quick;
      }
    } catch (_) {
      // ignore — continue to more robust parsing
    }

    // 2) Robust regex patterns for various URL shapes
    final patterns = <RegExp>[
      // https://www.youtube.com/watch?v=VIDEOID
      RegExp(r'v=([0-9A-Za-z_-]{11})'),
      // https://youtu.be/VIDEOID
      RegExp(r'youtu\.be\/([0-9A-Za-z_-]{11})'),
      // https://www.youtube.com/embed/VIDEOID
      RegExp(r'embed\/([0-9A-Za-z_-]{11})'),
      // https://www.youtube.com/shorts/VIDEOID
      RegExp(r'shorts\/([0-9A-Za-z_-]{11})'),
      // any 11 char id preceded by / or = or ?
      RegExp(r'([0-9A-Za-z_-]{11})'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(trimmed);
      if (match != null && match.groupCount >= 1) {
        final id = match.group(1);
        if (id != null && id.length == 11) return id;
      }
    }

    // 3) final fallback - try to strip query params and pick last path segment
    try {
      final uri = Uri.tryParse(trimmed);
      if (uri != null) {
        // check path segments
        if (uri.pathSegments.isNotEmpty) {
          final last = uri.pathSegments.last;
          // strip query-like trailing parts
          final cleaned = last.split(RegExp(r'[?&]')).first;
          if (cleaned.length == 11) return cleaned;
          // sometimes last contains 'watch' or 'embed' — attempt to find 11-char in it
          final m = RegExp(r'([0-9A-Za-z_-]{11})').firstMatch(cleaned);
          if (m != null) return m.group(1);
        }
        // check query parameter v
        if (uri.queryParameters.containsKey('v')) {
          final v = uri.queryParameters['v'];
          if (v != null && v.length >= 11) return v.substring(0, 11);
        }
      }
    } catch (_) {
      // ignore
    }

    return null;
  }

  static String? validateYouTubeUrl(String? value) {
    if (value == null || value.isEmpty) return null; // optional field
    final id = extractYouTubeId(value);
    if (id == null || id.length != 11) {
      return 'Please enter a valid YouTube URL (e.g., https://youtu.be/xyz).';
    }
    return null;
  }

  // Keep the rest of your validators...
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
    if (value == null || value.isEmpty) {
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
    if (value == null || value.isEmpty) {
      return 'Please provide an instruction step.';
    }
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
    if (value == null || value.isEmpty) {
      return 'Please enter the number of sets (e.g., 3).';
    }
    if (int.tryParse(value) == null || int.parse(value) <= 0) {
      return 'Please enter a valid number of sets (e.g., 3).';
    }
    return null;
  }

  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a quantity (e.g., 100).';
    }
    if (int.tryParse(value) == null || int.parse(value) <= 0) {
      return 'Please enter a valid integer quantity (e.g., 100).';
    }
    return null;
  }

  static String? validateCalories(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a calorie count (e.g., 200).';
    }
    if (int.tryParse(value) == null || int.parse(value) < 0) {
      return 'Please enter a valid calorie count (e.g., 200).';
    }
    return null;
  }

  static String? validateMacronutrient(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value for the macronutrient (e.g., 50).';
    }
    if (double.tryParse(value) == null || double.parse(value) < 0) {
      return 'Please enter a valid non-negative number (e.g., 50).';
    }
    return null;
  }
}
