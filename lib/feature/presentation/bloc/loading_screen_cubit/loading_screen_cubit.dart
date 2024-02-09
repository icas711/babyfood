import 'package:babyfood/feature/presentation/bloc/loading_screen_cubit/loading_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingStringCubit extends Cubit<String>{
  LoadingStringCubit() : super('Привет...');




  void updateState(String newState){
    emit(newState);

  }
}

