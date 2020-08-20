import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import '../../data/configurations.dart';
import '../Model/model.dart';

part 'configuration_event.dart';
part 'configuration_state.dart';

class ConfigurationBloc extends Bloc<ConfigurationEvent, ConfigurationState> {
  ConfigurationBloc() : super(ConfigurationLoading()) {
    add(GetConfigurations());
  }

  @override
  Stream<ConfigurationState> mapEventToState(
    ConfigurationEvent event,
  ) async* {
    if (event is GetConfigurations) {
      yield* _getConfigurations(event);
    }
  }

  Stream<ConfigurationState> _getConfigurations(
      GetConfigurations event) async* {
    yield ConfigurationLoading();
    try {
      final macros = goalsConfigration;
      yield ConfigurationSuccess(macros);
    } catch (e) {
      yield ConfigurationFailure(
          message: 'CANNOT LOAD CONFIGURATIONS', statusCode: 404);
    }
  }
}
