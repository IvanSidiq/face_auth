class Attendance {
  String id = '';
  String createdAt = '';
  String updatedAt = '';
  String deletedAt = '';
  int status = -1;
  String checkIn = '';
  double confidence = -1;
  int lateDurationInMinutes = -1;
  String dispensationId = '';
  String dateId = '';
  String userId = '';
  String schoolGroupId = '';
  String schoolId = '';
  String selfieFileName = '';
  String name = '';
  String nis = '';

  Attendance({
    this.id = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.deletedAt = '',
    this.status = -1,
    this.checkIn = '',
    this.confidence = -1,
    this.lateDurationInMinutes = -1,
    this.dispensationId = '',
    this.dateId = '',
    this.userId = '',
    this.schoolGroupId = '',
    this.schoolId = '',
    this.selfieFileName = '',
    this.name = '',
    this.nis = '',
  });

  Attendance.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    deletedAt = json['deletedAt'] ?? '';
    status = json['status'] ?? -1;
    checkIn = json['checkIn'] ?? '';
    confidence = json['confidence'] ?? 0;
    lateDurationInMinutes = json['lateDurationInMinutes'] ?? -1;
    dispensationId = json['dispensationId'] ?? '';
    dateId = json['dateId'] ?? '';
    userId = json['userId'] ?? '';
    schoolGroupId = json['schoolGroupId'] ?? '';
    schoolId = json['schoolId'] ?? '';
    selfieFileName = json['selfieFileName'] ?? '';
    name = json['name'] ?? '';
    nis = json['nis'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    data['status'] = status;
    data['checkIn'] = checkIn;
    data['confidence'] = confidence;
    data['lateDurationInMinutes'] = lateDurationInMinutes;
    data['dispensationId'] = dispensationId;
    data['dateId'] = dateId;
    data['userId'] = userId;
    data['schoolGroupId'] = schoolGroupId;
    data['schoolId'] = schoolId;
    data['selfieFileName'] = selfieFileName;
    data['name'] = name;
    data['nis'] = nis;
    return data;
  }
}
