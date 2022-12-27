import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/layout/cubit/cubit.dart';
import 'package:social_network/layout/cubit/states.dart';
import 'package:social_network/models/like_model.dart';

class LikeScreen extends StatelessWidget {
  const LikeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(
      listener:(context,state){} ,
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(
            title: const Text(
                "People who reacted",
            style: TextStyle(
              fontSize: 17
            ),
            ),
            elevation: 1,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          body:  SingleChildScrollView(
            child: Column(
              children: [
                ListView.separated(
                  itemBuilder: (context,index) {
                    return likeItem(
                        AppCubit.get(context).likes[index]
                    );
                  },
                  separatorBuilder: (context,index)=> const SizedBox(
                    height: 10,
                  ),
                  itemCount: AppCubit.get(context).likes.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  Widget likeItem(LikeModel likeModel) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.black12,
              backgroundImage: NetworkImage(
                likeModel.image!,
              ),
            ),
            const CircleAvatar(
              radius: 11,
              child: Icon(
                Icons.thumb_up,
                size: 12,
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 15.0,
        ),
        Text(likeModel.name!),
      ],
    ),
  );


}
