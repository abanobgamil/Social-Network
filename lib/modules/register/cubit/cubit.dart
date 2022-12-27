import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/models/user_model.dart';
import 'package:social_network/modules/register/cubit/states.dart';


class RegisterCubit extends Cubit<RegisterStates>
{
  RegisterCubit() : super(AppRegisterInitialState());

  static RegisterCubit get(context)=> BlocProvider.of(context);

  void userRegister({
  required String name,
  required String email,
  required String password,
  required String phone,
})
  {
    emit(AppRegisterLoadingState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      print(value.user!.email);
      userCreate(
        name: name,
        phone: phone,
        email: email,
        uId: value.user!.uid,
      );

    }).catchError((error){
      print(error.toString());
      emit(AppRegisterErrorState(error.toString()));
    });




  }


  void userCreate({
    required String name,
    required String email,
    required String phone,
    required String uId,
})
  {
      UserModel model = UserModel(
        name: name,
        phone: phone,
        email: email,
        uId: uId,
        image: 'https://image.freepik.com/free-vector/man-shows-gesture-great-idea_10045-637.jpg',
        cover: 'https://image.freepik.com/free-vector/laptop-with-rocket_23-2147503371.jpg',
        bio: "Your Bio",
        isEmailVerified: false,
      );


      FirebaseFirestore.instance.collection("users").doc(uId)
          .set(
          model.toMap()
          ).then((value)
      {

        emit(AppCreateUserSuccessState());

      }).catchError((error)
      {
        emit(AppCreateUserErrorState(error.toString()));

      });

  }

  IconData suffix =Icons.visibility_off_outlined;
  bool isPassword = true;

  void changePasswordVisibility()
  {
   isPassword =!isPassword;
  suffix = isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined ;
    emit(AppRegisterChangePasswordVisibilityState());
  }


}