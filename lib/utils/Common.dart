import 'dart:math';

String generateStrongPassword() {
  const letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const numbers = '0123456789';
  const symbols = '!@#\$%^&*()-_=+[]{};:,.<>?';

  final allChars = letters + numbers + symbols;
  final rand = Random.secure();

  final length = 12 + rand.nextInt(4); // 12–15

  return List.generate(
    length,
        (_) => allChars[rand.nextInt(allChars.length)],
  ).join();
}