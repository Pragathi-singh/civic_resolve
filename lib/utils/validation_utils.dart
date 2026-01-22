class ValidationUtils {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.trim().length < 3) return 'Name must be at least 3 characters';
    if (value.trim().length > 50) return 'Name must not exceed 50 characters';
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    // Check for at least one number
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  static String? validatePasswordMatch(String? password, String? confirmPassword) {
    if (password != confirmPassword) return 'Passwords do not match';
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone is required';
    final phoneRegex = RegExp(r'^[+]?[0-9]{7,15}$');
    if (!phoneRegex.hasMatch(value.trim())) return 'Enter a valid phone number';
    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) return 'Address is required';
    if (value.trim().length < 5) return 'Address must be at least 5 characters';
    return null;
  }

  static String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty) return 'City is required';
    return null;
  }

  static String? validateSkill(String? value) {
    if (value == null || value.trim().isEmpty) return 'Skill category is required';
    return null;
  }

  static String? validateJurisdiction(String? value) {
    if (value == null || value.trim().isEmpty) return 'Jurisdiction is required';
    return null;
  }

  static String? validateIssueTitle(String? value) {
    if (value == null || value.trim().isEmpty) return 'Issue title is required';
    if (value.trim().length < 5) return 'Title must be at least 5 characters';
    if (value.trim().length > 200) return 'Title must not exceed 200 characters';
    return null;
  }

  static String? validateIssueDescription(String? value) {
    if (value == null || value.trim().isEmpty) return 'Description is required';
    if (value.trim().length < 10) return 'Description must be at least 10 characters';
    if (value.trim().length > 2000) return 'Description must not exceed 2000 characters';
    return null;
  }

  static String? validateIssueCategory(String? value) {
    if (value == null || value.trim().isEmpty) return 'Category is required';
    return null;
  }
}
  }
}
