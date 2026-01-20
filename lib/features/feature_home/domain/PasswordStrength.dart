enum PasswordStrength { weak, medium, strong, veryStrong }

PasswordStrength calculatePasswordStrength(String password) {
  if (password.isEmpty) return PasswordStrength.weak;

  int score = 0;

  if (password.length >= 8) score++;
  if (RegExp(r'[A-Z]').hasMatch(password)) score++;
  if (RegExp(r'[0-9]').hasMatch(password)) score++;
  if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

  if (score <= 1) return PasswordStrength.weak;
  if (score == 2) return PasswordStrength.medium;
  if (score == 3) return PasswordStrength.strong;
  return PasswordStrength.veryStrong;
}

