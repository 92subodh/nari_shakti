String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your phone number';
  }
  
  // Remove any spaces or special characters
  final cleanNumber = value.replaceAll(RegExp(r'[^0-9]'), '');
  
  if (cleanNumber.length != 10) {
    return 'Please enter a valid 10-digit phone number';
  }
  
  return null;
}

String? validateOTP(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter the OTP';
  }
  
  if (value.length != 6) {
    return 'OTP must be 6 digits';
  }
  
  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return 'OTP must contain only numbers';
  }
  
  return null;
}
