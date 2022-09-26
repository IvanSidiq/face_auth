import '../helper/base_repository.dart';
import '../models/base_response.dart';
import '../models/school.dart';
import '../utils/api.dart';

class SchoolRepository extends BaseRepository {
  Future<BaseResponse> getSchoolProfile() async {
    final response = await fetch(kApiSchoolProfileNogosari);

    if (response.statusCode == 200) {
      final school = School.fromJson(response.data);
      return BaseResponse(
        statusCode: response.statusCode,
        data: school,
      );
    }
    return response;
  }
}
