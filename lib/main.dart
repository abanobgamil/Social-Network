import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_network/bloc_observer.dart';
import 'package:social_network/my_app.dart';
import 'package:social_network/shared/components/constant.dart';
import 'package:social_network/shared/network/local/cache_helper.dart';

void main() async{

  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  uId = CacheHelper.getData(key: 'uId');


  runApp(const MyApp());

}
