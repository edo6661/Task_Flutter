class EmailValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return "Email tidak boleh kosong";
    }

    if (!value.contains('@') || !value.contains('.')) {
      return "Format email tidak valid";
    }

    return null;
  }
}
