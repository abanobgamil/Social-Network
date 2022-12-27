import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:social_network/layout/cubit/cubit.dart';
import 'package:social_network/layout/cubit/states.dart';
import 'package:social_network/models/comment_model.dart';

class CommentScreen extends StatelessWidget {
   CommentScreen(this.postId);

   String  postId ;

  @override
  Widget build(BuildContext context) {
    var commentController = TextEditingController();

    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Comments"
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context,index)=> commentItem(AppCubit.get(context).comments[index]),
                  separatorBuilder: (context,index)=> const SizedBox(
                    height: 10,
                  ),
                  itemCount: AppCubit.get(context).comments.length,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: commentController,
                        decoration:  InputDecoration(
                          contentPadding:const EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.grey[75],
                            hintText: 'Write a comment...'
                        ),
                      ),
                    ),
                    // Container(
                    //   decoration: const BoxDecoration(
                    //       borderRadius: BorderRadius.only(
                    //         topRight: Radius.circular(15.0),
                    //         bottomRight: Radius.circular(15.0),
                    //       )),
                    //   child: MaterialButton(
                    //     onPressed: () {
                    //       AppCubit.get(context).addComment(
                    //           text:commentController.text, dateTime: DateTime.now().toString(), postId: postId);
                    //       AppCubit.get(context).commentsCount[postId] = AppCubit.get(context).commentsCount[postId]! +1;
                    //     },
                    //     color: Colors.blue,
                    //     minWidth: 1.0,
                    //     height: 60,
                    //     child: const Icon(
                    //       Icons.send,
                    //       color: Colors.white,
                    //       size: 16.0,
                    //     ),
                    //   ),
                    // ),
                    IconButton(
                        onPressed: (){
                          AppCubit.get(context).addComment(
                           text: commentController.text,
                              dateTime: DateTime.now().toString(),
                              postId: postId
                          );
                           AppCubit.get(context).commentsCount[postId] = AppCubit.get(context).commentsCount[postId]! +1;
                           commentController.text = "";
                        },
                        icon:const Icon(
                            Icons.send
                        ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget commentItem(CommentModel commentModel) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         CircleAvatar(
          radius: 25.0,
           backgroundColor: Colors.black12,
           backgroundImage: NetworkImage(
            commentModel.image!,
          ),
        ),
        const SizedBox(
          width: 15.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                    "${commentModel.name}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                    ),
                    Text(commentModel.text!),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Row(
              children: [
                Text(
                 Jiffy("${commentModel.dateTime}").fromNow(),
                  style: const TextStyle(
                    color: Colors.black54
                  ),
                ),
                const SizedBox(
                  width: 13,
                ),
                const InkWell(
                  child: Text(
                    "Like",
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const InkWell(
                  child: Text(
                    "Reply",
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}