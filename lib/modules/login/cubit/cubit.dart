import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/modules/login/cubit/states.dart';


class LoginCubit extends Cubit<LoginStates>
{
  LoginCubit() : super(AppLoginInitialState());

  static LoginCubit get(context)=> BlocProvider.of(context);


  void userLogin({
  required String email,
  required String password,
})
  {
    emit(AppLoginLoadingState());

      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      ).then((value)
      {
        emit(AppLoginSuccessState(value.user!.uid));

      }).catchError((error){

        emit(AppLoginErrorState(error.toString()));
      });


  }

  IconData suffix =Icons.visibility_off_outlined;
  bool isPassword = true;

  void changePasswordVisibility()
  {
   isPassword =!isPassword;
  suffix = isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined ;
    emit(AppChangePasswordVisibilityState());
  }


}