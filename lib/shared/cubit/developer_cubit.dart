import 'package:flutter_bloc/flutter_bloc.dart';

part 'developer_state.dart';

class DeveloperCubit extends Cubit<DeveloperState> {
  DeveloperCubit() : super(DeveloperInitial());

  void login(String username, String password) {
    // Hardcoded credentials for the developer gateway
    if (username == 'admin' && password == 'admin123') {
      emit(DeveloperAuthSuccess());
    } else {
      emit(DeveloperAuthFailed('Invalid username or password'));
    }
  }

  void selectEnvironment(String environment) {
    emit(DeveloperEnvironmentSelected(environment));
    // Additional logic to change the environment can be added later
  }
}
