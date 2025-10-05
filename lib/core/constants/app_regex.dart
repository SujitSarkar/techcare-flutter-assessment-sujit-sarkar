class AppRegex {
  AppRegex._();

  // Compiled
  static final RegExp allowedAmountChars = RegExp(r"[0-9.,]");
  static final RegExp nonDigitExceptDot = RegExp(r"[^\d.]");
}
