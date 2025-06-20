String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Full name can\'t be empty';
  } else if (value.length <= 4) {
    return 'Full name must be more than 3 characters';
  } else if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
    return 'Full name can only contain letters';
  }
  return null;
}

String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Phone number can\'t be empty';
  } else if (value.length < 11) {
    return 'Phone number must be more than 9 characters';
  } else if (!RegExp(r"^[0-9]+$").hasMatch(value)) {
    return 'Phone number can only contain numbers';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value!.isEmpty) {
    return 'Email can\'t be empty';
  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    return 'Please enter a valid email';
  } else {
    return null;
  }
}

String? validatePassword(String? value) {
  if (value!.isEmpty) {
    return 'Password can\'t be empty';
  } else if (value.length < 4) {
    return 'Password can\'t be less than 8 characters';
  } else {
    return null;
  }
}
