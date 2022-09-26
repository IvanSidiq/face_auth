class School {
  String id = '';
  String domain = '';
  String name = '';
  String phone = '';
  String email = '';
  double longitude = -1;
  double latitude = -1;
  String address = '';
  String addressProvince = '';
  String addressCity = '';
  String addressDistrict = '';
  String vision = '';
  String mission = '';
  String greeting = '';
  dynamic organizationChart;
  String logo = '';
  List<String>? banner;
  String visionThumbnail = '';
  String greetingThumbnail = '';
  String staffThumbnail = '';
  String map = '';
  int type = -1;
  String contactName = '';
  String formalName = '';
  String bannerBook = '';
  String bannerTitle = '';
  String registrationCode = '';
  String registrationStartedAt = '';
  String registrationExpiredAt = '';

  School({
    this.id = '',
    this.domain = '',
    this.name = '',
    this.phone = '',
    this.email = '',
    this.longitude = -1,
    this.latitude = -1,
    this.address = '',
    this.addressProvince = '',
    this.addressCity = '',
    this.addressDistrict = '',
    this.vision = '',
    this.mission = '',
    this.greeting = '',
    this.organizationChart,
    this.logo = '',
    this.banner,
    this.visionThumbnail = '',
    this.greetingThumbnail = '',
    this.staffThumbnail = '',
    this.map = '',
    this.type = -1,
    this.contactName = '',
    this.formalName = '',
    this.bannerBook = '',
    this.bannerTitle = '',
    this.registrationCode = '',
    this.registrationExpiredAt = '',
    this.registrationStartedAt = '',
  });

  School.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    domain = json['domain'] ?? '';
    name = json['name'] ?? '';
    phone = json['phone'] ?? '';
    email = json['email'] ?? '';
    longitude = json['longitude'] ?? -1;
    latitude = json['latitude'] ?? -1;
    address = json['address'] ?? '';
    addressProvince = json['address_province'] ?? '';
    addressCity = json['address_city'] ?? '';
    addressDistrict = json['address_district'] ?? '';
    vision = json['vision'] ?? '';
    mission = json['mission'] ?? '';
    greeting = json['greeting'] ?? '';
    organizationChart = json['organization_chart'];
    logo = json['logo'] ?? '';
    banner = json['banner'].cast<String>();
    visionThumbnail = json['vision_thumbnail'] ?? '';
    greetingThumbnail = json['greeting_thumbnail'] ?? '';
    staffThumbnail = json['staff_thumbnail'] ?? '';
    map = json['map'] ?? '';
    type = json['type'] ?? -1;
    contactName = json['contact_name'] ?? '';
    formalName = json['formalName'] ?? '';
    bannerBook = json['bannerBook'] ?? '';
    bannerTitle = json['bannerTitle'] ?? '';
    registrationCode = json['registrationCode'] ?? '';
    registrationExpiredAt = json['registrationExpiredAt'] ?? '';
    registrationStartedAt = json['registrationStartedAt'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['domain'] = domain;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['address'] = address;
    data['address_province'] = addressProvince;
    data['address_city'] = addressCity;
    data['address_district'] = addressDistrict;
    data['vision'] = vision;
    data['mission'] = mission;
    data['greeting'] = greeting;
    data['organization_chart'] = organizationChart;
    data['logo'] = logo;
    data['banner'] = banner;
    data['vision_thumbnail'] = visionThumbnail;
    data['greeting_thumbnail'] = greetingThumbnail;
    data['staff_thumbnail'] = staffThumbnail;
    data['map'] = map;
    data['type'] = type;
    data['contact_name'] = contactName;
    data['formalName'] = formalName;
    data['bannerBook'] = bannerBook;
    data['bannerTitle'] = bannerTitle;
    data['registrationCode'] = registrationCode;
    data['registrationExpiredAt'] = registrationExpiredAt;
    data['registrationStartedAt'] = registrationStartedAt;
    return data;
  }
}
