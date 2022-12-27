import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_network/layout/cubit/cubit.dart';
import 'package:social_network/layout/cubit/states.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var textController = TextEditingController();
    var now = DateTime.now();

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppCreatePostLoadingState) {
          Fluttertoast.showToast(
            msg: 'Post is being created',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey,
            toastLength: Toast.LENGTH_SHORT,
          );
        }

        if (state is AppCreatePostSuccessState) {
          Fluttertoast.showToast(
            msg: 'Post has been created',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey,
            toastLength: Toast.LENGTH_SHORT
          ).then((value){
            AppCubit.get(context).getPosts();
            Navigator.pop(context);
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Create post",
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus!.unfocus();
                  if (AppCubit.get(context).postImage == null) {
                    AppCubit.get(context).createPost(
                      text: textController.text,
                      dateTime: now.toString(),
                    );
                    textController.text = "";
                  } else {
                    AppCubit.get(context).uploadPostImage(
                      text: textController.text,
                      dateTime: now.toString(),
                    );
                    textController.text = "";
                  }
                },
                child: const Text(
                  'POST',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              )
            ],
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(
                        AppCubit.get(context).userModel!.image!,
                      ),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                      child: Text(
                        AppCubit.get(context).userModel!.name!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            height: 1.0),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: const InputDecoration(
                        hintText: "What's on your mind?",
                        border: InputBorder.none),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                if (AppCubit.get(context).postImage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        height: 150.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          image: DecorationImage(
                            image: FileImage(AppCubit.get(context).postImage!),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          AppCubit.get(context).removePostImage();
                        },
                        icon: const CircleAvatar(
                          radius: 17.0,
                          child: Icon(
                            Icons.close,
                            size: 17.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          AppCubit.get(context).getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.image,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              'photo/video',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.camera_alt,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              'camera',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
