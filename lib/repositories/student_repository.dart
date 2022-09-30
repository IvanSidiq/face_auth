import '../helper/base_repository.dart';
import '../models/attendance.dart';
import '../models/base_response.dart';
import '../models/meta.dart';
import '../utils/api.dart';

class AttendanceRepository extends BaseRepository {
  Future<BaseResponse> getAttendanceList({
    String search = '',
    int page = 0,
    int pageSize = 10,
    bool recomended = false,
  }) async {
    final response = await fetch(kApiAttendanceList, queryParameters: {
      'search': search,
      'pageNumber': page,
      'pageSize': pageSize,
    });

    if (response.statusCode == 200) {
      final Meta meta = Meta.fromJson(response.data);
      final List<Attendance> data = List.from(response.data['paginateData'])
          .map((e) => Attendance.fromJson(e))
          .toList();
      return BaseResponse(
        statusCode: response.statusCode,
        data: data,
        meta: meta,
      );
    }
    return response;
  }
}
