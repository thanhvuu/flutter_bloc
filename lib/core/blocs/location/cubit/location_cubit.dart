import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_app_demo/domain/repositories/location_repository.dart';


part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationRepository _repository;

  LocationCubit({required LocationRepository repository}) 
      : _repository = repository, 
        super(LocationInitial());

  Future<void> fetchLocation() async {
    emit(LocationLoading());
    
    final result = await _repository.getUserLocation();
    
        result.fold(
      (failure) => emit(LocationError(failure.message)),
      (address) => emit(LocationSuccess(address)),
    );
  }
}