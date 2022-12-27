import 'package:animate_do/animate_do.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/layout/app_layout.dart';
import 'package:social_network/modules/login/cubit/cubit.dart';
import 'package:social_network/modules/login/cubit/states.dart';
import 'package:social_network/modules/register/register_screen.dart';
import 'package:social_network/shared/components/components.dart';
import 'package:social_network/shared/components/constant.dart';
import 'package:social_network/shared/network/local/cache_helper.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
          listener: (context, state)
          {
            // if(state is AppLoginErrorState)
            //   {
            //     showToast(message: state.error, state: ToastStates.ERROR);
            //
            //   }

            if(state is AppLoginSuccessState)
              {
                CacheHelper.saveData(key: 'uId',
                    value:state.uId)
                    .then((value)
                {
                  uId = state.uId;
                  print('$uId hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
                  navigateAndFinish(context,  SlideInRight(child: AppLayout()));
                });


              }
          },
          builder: (context, state) {
            return Scaffold(
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child:  Text(
                              'Social Network',
                              style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          defaultFormField(
                              textController: emailController,
                              type: TextInputType.emailAddress,
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return "Please enter your Email address";
                                }
                              },
                              onSubmit: (value) {},
                              inputAction: TextInputAction.next,
                              hintText: "Email",
                              prefix: Icons.email
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          defaultFormField(
                            textController: passwordController,
                            type: TextInputType.visiblePassword,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return "Password is too short";
                              }
                            },
                            onSubmit: (value) {
                              if (formKey.currentState!.validate()) {
                                LoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text
                              );
                            }
                            },
                            hintText: "Password",
                            prefix: Icons.lock,
                            suffix: LoginCubit
                                .get(context)
                                .suffix,
                            suffixPressed: () {
                              LoginCubit.get(context)
                                  .changePasswordVisibility();
                            },
                            isPassword: LoginCubit
                                .get(context)
                                .isPassword,
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          ConditionalBuilder(
                            condition: state is! AppLoginLoadingState,
                            builder: (context) =>
                                defaultButton(
                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      LoginCubit.get(context).userLogin(
                                          email: emailController.text,
                                          password: passwordController.text);
                                    }
                                  },
                                  text: "LOGIN",
                                ),
                            fallback: (context) => Container(
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.grey,
                              ),
                              child: const Center(
                                child:  Text(
                                  "Loading ...",
                                  style:  TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),

                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account ?",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () {
                                  navigateTo(context, const RegisterScreen());
                                },
                                child: const Text('Register'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
