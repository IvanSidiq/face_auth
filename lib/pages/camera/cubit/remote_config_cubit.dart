import 'package:bloc/bloc.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../repositories/remot_config_repository.dart';

part 'remote_config_state.dart';

class RemoteConfigCubit extends Cubit<RemoteConfigState> {
  RemoteConfigCubit() : super(RemoteConfigInitial());

  final _repo = RemoteConfigRepository();
  double threshold = 0.5;

  Future<void> initGetThreshold() async {
    await GetIt.I<FirebaseRemoteConfig>()
        .setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(seconds: 30),
    ));

    await GetIt.I<FirebaseRemoteConfig>().fetchAndActivate();

    final responseThreshold = (await _repo.getThreshold()).data;
    final thresholdr = responseThreshold;
    if (responseThreshold == null) {
      emit(GetThresholdFailed());
    } else {
      emit(GetThresholdSuccess(thresholdr));
    }
  }
}
