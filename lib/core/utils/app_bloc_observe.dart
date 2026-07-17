import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    developer.log('🔵 [BLoC Event] ${bloc.runtimeType} -> $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    developer.log('🟢 [BLoC State Change] ${bloc.runtimeType} -> Current: ${change.currentState} | Next: ${change.nextState}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    developer.log('🔴 [BLoC Error] ${bloc.runtimeType} -> Error: $error', stackTrace: stackTrace);
  }
}