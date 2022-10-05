import 'package:face_auth/helper/base_repository.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';

import '../models/base_response.dart';

class RemoteConfigRepository extends BaseRepository {
  Future<BaseResponse> getThreshold() async {
    final response =
        GetIt.I<FirebaseRemoteConfig>().getDouble("face_threshold");

    return BaseResponse(
      statusCode: 200,
      data: response,
    );
  }
}
