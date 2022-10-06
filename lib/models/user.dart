class User {
  String id = '';
  String createdAt = '';
  String updatedAt = '';
  String deletedAt = '';
  String name = '';
  String email = '';
  String schoolId = '';
  int status = -1;
  int role = -1;
  String lastLoginAt = '';
  bool isEmailVerified = false;
  String nis = '';
  String nisn = '';
  String yearEnrolled = '';

  User({
    id = '',
    createdAt = '',
    updatedAt = '',
    deletedAt = '',
    name = '',
    email = '',
    schoolId = '',
    status = -1,
    role = -1,
    lastLoginAt = '',
    isEmailVerified = false,
    nis = '',
    nisn = '',
    yearEnrolled = '',
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    deletedAt = json['deleted_at'] ?? '';
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    schoolId = json['schoolId'] ?? '';
    status = json['status'] ?? -1;
    role = json['role'] ?? -1;
    lastLoginAt = json['last_login_at'] ?? '';
    isEmailVerified = json['isEmailVerified'] ?? false;
    nis = json['nis'] ?? '';
    nisn = json['nisn'] ?? '';
    yearEnrolled = json['yearEnrolled'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['name'] = name;
    data['email'] = email;
    data['schoolId'] = schoolId;
    data['status'] = status;
    data['role'] = role;
    data['last_login_at'] = lastLoginAt;
    data['isEmailVerified'] = isEmailVerified;
    data['nis'] = nis;
    data['nisn'] = nisn;
    data['yearEnrolled'] = yearEnrolled;
    return data;
  }
}
