class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidMobile(String phone) {
    if(phone.isNotEmpty && phone.length == 10){
      return true;
    }else{
      return false;
    }
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }
  static String? requiredText(String? v, {int min = 1}) {
    if (v == null || v.trim().isEmpty) return "Required";
    if (v.trim().length < min) return "Minimum $min characters";
    return null;
  }

  static String?  emailValidator(String? v) {
    if (v == null || v.isEmpty) return "Email required";
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
      return "Invalid email";
    }
    return null;
  }

  static String? phoneValidator(String? v) {
    if (v == null || v.isEmpty) return "Phone required";
    if (!RegExp(r'^[0-9]{10}$').hasMatch(v)) {
      return "Enter valid 10 digit number";
    }
    return null;
  }

  static String?  numberValidator(String? v) {
    if (v == null || v.isEmpty) return "Required";
    if (num.tryParse(v) == null || v.length != 1)  return "Invalid number";
    return null;
  }

  static String?  latitudeValidator(String? v) {
    final d = double.tryParse(v ?? "");
    if (d == null || d < -90 || d > 90) return "Invalid latitude";
    return null;
  }

  static String?  longitudeValidator(String? v) {
    final d = double.tryParse(v ?? "");
    if (d == null || d < -180 || d > 180) return "Invalid longitude";
    return null;
  }

  static String?  gradeValidator(String? v) {
    if (v == null || v.isEmpty) return "Required";
    if (!["A", "B", "C"].contains(v.toUpperCase())) {
      return "Grade must be A / B / C";
    }
    return null;
  }

}
