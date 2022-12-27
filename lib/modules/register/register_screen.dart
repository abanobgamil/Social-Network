import 'package:animate_do/animate_do.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/layout/app_layout.dart';
import 'package:social_network/modules/register/cubit/cubit.dart';
import 'package:social_network/modules/register/cubit/states.dart';
import 'package:social_network/shared/components/components.dart';



class RegisterScreen extends StatelessWidget {

   const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var formKey = GlobalKey<FormState>();
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var phoneController = TextEditingController();


    return BlocProvider(
      create: (BuildContext context)=> RegisterCubit(),
      child: BlocConsumer<RegisterCubit,RegisterStates>(
        listener: (context,state)
        {
          if (state is AppCreateUserSuccessState) {

            navigateAndFinish(context,  SlideInRight(child: AppLayout()));
          }

        },
        builder:(context,state) {
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
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),

                      defaultFormField(
                          textController: nameController,
                          type: TextInputType.name,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return "Please enter your Name";
                            }
                          },
                          onSubmit: (value) {},
                          inputAction: TextInputAction.next,
                          hintText: "User Name",
                          prefix: Icons.person
                      ),
                      const SizedBox(
                        height: 15.0,
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
                          prefix: Icons.email),
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

                        },
                        hintText: "Password",
                        prefix: Icons.lock,
                        suffix: RegisterCubit.get(context).suffix,
                        suffixPressed: () {
                          RegisterCubit.get(context)
                              .changePasswordVisibility();
                        },
                        isPassword: RegisterCubit.get(context).isPassword,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),

                      defaultFormField(
                          textController: phoneController,
                          type: TextInputType.phone,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return "Please enter your Phone Number";
                            }
                          },
                          onSubmit: (value) {},
                          inputAction: TextInputAction.next,
                          hintText: "Phone Number",
                          prefix: Icons.phone
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),

                      ConditionalBuilder(
                        condition: state is! AppRegisterLoadingState,
                        builder: (context) => defaultButton(
                          function: () {
                            if (formKey.currentState!.validate()) {
                              RegisterCubit.get(context).userRegister(
                                  name:  nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                              );
                            }
                          },
                          text: "REGISTER",
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

                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        },
      ),
    );
  }
}
