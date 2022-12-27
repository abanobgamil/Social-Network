import 'package:animate_do/animate_do.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:social_network/layout/cubit/cubit.dart';
import 'package:social_network/layout/cubit/states.dart';
import 'package:social_network/modules/comment/comment_screen.dart';
import 'package:social_network/modules/like/like_screen.dart';
import 'package:social_network/modules/new%20post/new_post_screen.dart';
import 'package:social_network/shared/components/components.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({required this.uId});

  String? uId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[200],
          body: ConditionalBuilder(
            condition: AppCubit.get(context).posts.isNotEmpty &&
                AppCubit.get(context).users.isNotEmpty &&
                AppCubit.get(context).commentsCount.isNotEmpty &&
                AppCubit.get(context).postsId.isNotEmpty &&
                AppCubit.get(context).likesCount.isNotEmpty &&
                AppCubit.get(context).myLikes.isNotEmpty &&
                AppCubit.get(context).userModel != null,
            builder: (context) => RefreshIndicator(
              onRefresh: AppCubit.get(context).onRefresh,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            height: 200.0,
                            child: Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional.topCenter,
                                  child: Container(
                                    height: 150.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          '${AppCubit.get(context).users[uId]!.cover}',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 64.0,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 60.0,
                                    backgroundColor: Colors.black12,
                                    backgroundImage: NetworkImage(
                                      '${AppCubit.get(context).users[uId]!.image}',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            '${AppCubit.get(context).users[uId]!.name}',
                            style: const TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${AppCubit.get(context).users[uId]!.bio}',
                            style: const TextStyle(
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20.0,
                              backgroundColor: Colors.black12,
                              backgroundImage: NetworkImage(
                                '${AppCubit.get(context).userModel!.image}',
                              ),
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            Expanded(
                                child: InkWell(
                                  onTap: () {
                                    navigateTo(context, SlideInUp(child: const NewPostScreen()));
                                  },
                                  child: Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black26),
                                        borderRadius: BorderRadius.circular(10)),
                                    child: const Padding(
                                      padding: EdgeInsets.only(left: 10.0, top: 6.5),
                                      child: Text("What's on your mind?"),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (AppCubit.get(context).posts[AppCubit.get(context).postsId[index]]!.uId == uId) {
                          return buildPostItem(
                              AppCubit.get(context).postsId[index], context);
                        }
                        return const SizedBox();
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 1,
                      ),
                      itemCount: AppCubit.get(context).posts.length,
                    )
                  ],
                ),
              ),
            ),
            fallback: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }

  Widget buildPostItem(String postId, context) => Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.black12,
                  backgroundImage: NetworkImage(
                    '${AppCubit.get(context).userModel!.image}',
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppCubit.get(context).posts[postId]!.name}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            height: 1.0),
                      ),
                      Text(
                        Jiffy('${AppCubit.get(context).posts[postId]!.dateTime}')
                            .fromNow(),
                        style: const TextStyle(
                            height: 1.6, color: Colors.grey, fontSize: 13.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_horiz,
                    size: 20.0,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(
                height: 10,
              ),
            if(AppCubit.get(context).posts[postId]!.text!.isNotEmpty)
                Text(
              '${AppCubit.get(context).posts[postId]!.text}',
              style: const TextStyle(
                  fontSize: 16.0, fontWeight: FontWeight.w600, height: 1.4),
            ),
            const SizedBox(
                height: 7,
              ),
            if ('${AppCubit.get(context).posts[postId]!.postImage}'.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top:5.0),
                child: Container(
                  height: 250.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(5.0),
                    image: DecorationImage(
                      image: NetworkImage(
                        '${AppCubit.get(context).posts[postId]!.postImage}',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  if (AppCubit.get(context).likesCount[postId] != 0)
                  InkWell(
                    onTap: () {
                      navigateTo(context, SlideInUp(child: const LikeScreen()));
                      AppCubit.get(context).getLikes(postId: postId);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.thumb_up_alt_outlined,
                          size: 20.0,
                          color: Colors.black45,
                        ),
                        const SizedBox(
                          width: 3.0,
                        ),
                        Text('${AppCubit.get(context).likesCount[postId]}'),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (AppCubit.get(context).commentsCount[postId] != 0)
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SlideInUp(child: CommentScreen(postId))));
                        AppCubit.get(context)
                            .getComments(postId: postId, context: context);
                      },
                      child: Text(
                          '${AppCubit.get(context).commentsCount[postId]} Comments')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppCubit.get(context).myLikes[postId]!
                            ? const Icon(
                                Icons.thumb_up_alt_outlined,
                                size: 20.0,
                                color: Colors.blue,
                              )
                            : const Icon(
                                Icons.thumb_up_alt_outlined,
                                size: 20.0,
                                color: Colors.black45,
                              ),
                        const SizedBox(
                          width: 3.0,
                        ),
                        Text(
                          'Like',
                          style: TextStyle(
                              color: AppCubit.get(context).myLikes[postId]!
                                  ? Colors.blue
                                  : Colors.black),
                        ),
                      ],
                    ),
                    onTap: () {
                      if (AppCubit.get(context).myLikes[postId]!) {
                        AppCubit.get(context).removeLike(postId: postId);
                      } else {
                        AppCubit.get(context).addLike(postId: postId);
                      }
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 20.0,
                          color: Colors.black45,
                        ),
                        SizedBox(
                          width: 3.0,
                        ),
                        Text(
                          'comment',
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SlideInUp(child: CommentScreen(postId))));
                      AppCubit.get(context)
                          .getComments(postId: postId, context: context);
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.share,
                          size: 20.0,
                          color: Colors.black45,
                        ),
                        SizedBox(
                          width: 3.0,
                        ),
                        Text(
                          'share',
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ]),
        ),
      );
}
