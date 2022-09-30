class AttendanceFace {
  String? id = '';
  String? createdAt = '';
  String? updatedAt = '';
  String? deletedAt = '';
  List<double>? vector;

  AttendanceFace(
      {this.id = '',
      this.createdAt = '',
      this.updatedAt = '',
      this.deletedAt = '',
      this.vector});

  AttendanceFace.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    deletedAt = json['deletedAt'] ?? '';
    vector = json['vector'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    data['vector'] = vector;
    return data;
  }
}
