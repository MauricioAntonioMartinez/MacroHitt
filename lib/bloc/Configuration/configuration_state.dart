part of 'configuration_bloc.dart';

abstract class ConfigurationState extends Equatable {
  const ConfigurationState();
  @override
  List<Object> get props => [];
}

class ConfigurationInitial extends ConfigurationState {}

class ConfigurationLoading extends ConfigurationState {}

class ConfigurationFailure extends ConfigurationState {
  final String message;
  final int statusCode;
  ConfigurationFailure({this.message, this.statusCode});
}
