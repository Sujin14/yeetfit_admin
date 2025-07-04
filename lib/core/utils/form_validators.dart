class FormValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Name is required';
    return null;
  }

  static String? validatePlanType(String? value) {
    if (value == null || value.isEmpty) return 'Plan type is required';
    return null;
  }

  static String? validatePlanDetails(String? value) {
    if (value == null || value.isEmpty) return 'Details are required';
    return null;
  }

  static String? validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName is required';
    if (int.tryParse(value) == null) return 'Please enter a valid number';
    return null;
  }
}
