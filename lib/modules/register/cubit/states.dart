
abstract class RegisterStates {}

class AppRegisterInitialState extends RegisterStates {}

class AppRegisterLoadingState extends RegisterStates {}

class AppRegisterSuccessState extends RegisterStates {}

class AppRegisterErrorState extends RegisterStates
{
    final String error;

  AppRegisterErrorState(this.error);
}

class AppCreateUserSuccessState extends RegisterStates {}

class AppCreateUserErrorState extends RegisterStates
{
  final String error;

  AppCreateUserErrorState(this.error);
}

class AppRegisterChangePasswordVisibilityState extends RegisterStates {}