import 'dart:io';

import 'package:face_auth/models/attendance_face.dart';

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
      'nis': search,
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

  Future<BaseResponse> getAttendanceData({
    String userId = '',
  }) async {
    final response = await fetch(kApiAttendanceStudentData, queryParameters: {
      'userId': userId,
    });

    if (response.statusCode == 200) {
      final Attendance data = Attendance.fromJson(response.data);
      return BaseResponse(
        statusCode: response.statusCode,
        data: data,
      );
    }
    return response;
  }

  Future<BaseResponse> getAttendanceFaceData({
    String userId = '',
  }) async {
    final response = await fetch('$kApiAttendanceStudentFace/$userId');

    if (response.statusCode == 200) {
      final AttendanceFace data = AttendanceFace.fromJson(response.data);
      return BaseResponse(
        statusCode: response.statusCode,
        data: data,
      );
    }
    return response;
  }

  Future<BaseResponse> postAttendanceAttend({
    required double similarityC,
    required String attendanceId,
    required String dateId,
    required File faceFile,
  }) async {
    final responseUrl =
        await uploadFileUrl(attendanceId: attendanceId, dateId: dateId);
    if (responseUrl.statusCode == 201) {
      final AttendanceUrl data2 = responseUrl.data;
      await uploadFile(signedUrl: data2.signedUrl!, file: faceFile);
      final res = await attend(
        similarityC: similarityC,
        dateId: dateId,
        attendanceId: attendanceId,
      );
      return res;
    } else {
      return responseUrl;
    }
  }

  Future<BaseResponse> attend({
    required double similarityC,
    required String dateId,
    required String attendanceId,
  }) async {
    final response = await patch('$kApiAttendanceAttend/$attendanceId', data: {
      'confidence': similarityC,
      'selfieFileName': 'schools-$attendanceId-$dateId.jpg'
    });

    if (response.statusCode == 200) {
      final AttendanceFace data = AttendanceFace.fromJson(response.data);
      return BaseResponse(
        statusCode: response.statusCode,
        data: data,
      );
    }
    return response;
  }

  Future<BaseResponse> uploadFileUrl({
    required String attendanceId,
    required String dateId,
  }) async {
    final response = await fetch(kApiAttendanceUploadFileUrl, queryParameters: {
      'folder': 'schools',
      'file-name': 'schools-$attendanceId-$dateId.jpg'
    });

    if (response.statusCode == 201) {
      final AttendanceUrl data = AttendanceUrl.fromJson(response.data);
      return BaseResponse(
        statusCode: response.statusCode,
        data: data,
      );
    } else {
      return response;
    }
  }

  Future<BaseResponse> uploadFile({
    required String signedUrl,
    required File file,
  }) async {
    final response = await putFile(signedUrl, null, data: file);

    if (response.statusCode == 200) {
      return response;
    } else {
      return response;
    }
  }
}
