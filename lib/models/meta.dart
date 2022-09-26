class Meta {
  dynamic paginateData;
  int itemsPerPage = -1;
  int totalPage = -1;
  int totalItems = -1;
  int currentPage = -1;
  int deletedCount = -1;

  Meta(
      {this.paginateData,
      this.itemsPerPage = -1,
      this.totalPage = -1,
      this.totalItems = -1,
      this.currentPage = -1,
      this.deletedCount = -1});

  Meta.fromJson(Map<String, dynamic> json) {
    paginateData = json['paginateData'];
    itemsPerPage = json['itemsPerPage'] ?? -1;
    totalPage = json['totalPage'] ?? -1;
    totalItems = json['totalItems'] ?? -1;
    currentPage = json['currentPage'] ?? -1;
    deletedCount = json['deletedCount'] ?? -1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (paginateData != null) {
      data['paginateData'] = paginateData!.map((v) => v.toJson()).toList();
    }
    data['itemsPerPage'] = itemsPerPage;
    data['totalPage'] = totalPage;
    data['totalItems'] = totalItems;
    data['currentPage'] = currentPage;
    data['deletedCount'] = deletedCount;
    return data;
  }
}
