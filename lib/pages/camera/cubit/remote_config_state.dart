part of 'remote_config_cubit.dart';

@immutable
abstract class RemoteConfigState {}

class RemoteConfigInitial extends RemoteConfigState {}

class GetThresholdSuccess extends RemoteConfigState {
  final double threshold;

  GetThresholdSuccess(this.threshold);
}

class GetThresholdFailed extends RemoteConfigState {}
