import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:social_network/layout/cubit/cubit.dart';
import 'package:social_network/layout/cubit/states.dart';
import 'package:social_network/models/notification_model.dart';

class NotificationScreen extends StatelessWidget {

  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit.get(context).notificationSeen();

        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Align(
                       alignment: Alignment.topLeft,
                       child:  Text(
                          "Notifications",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                     ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return notificationItem(
                                AppCubit.get(context).notifications[index], context);
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          itemCount: AppCubit.get(context).notifications.length
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );

  }

  Widget notificationItem(NotificationModel notificationModel, context) {
    if (notificationModel.like != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.black12,
                backgroundImage: NetworkImage(
                  '${notificationModel.image}',
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${notificationModel.name} reacted to your post: "${AppCubit.get(context).posts[notificationModel.postUId]!.text}"',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      height: 1.3,
                  ),
                  maxLines: 2,
                ),
              const  SizedBox(
                  height: 1.5,
                ),
                Text(
                  Jiffy('${notificationModel.dateTime}').fromNow(),
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
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.black12,
                backgroundImage: NetworkImage(
                  '${notificationModel.image}',
                ),
              ),
              const CircleAvatar(
                radius: 11,
                child: Icon(
                  Icons.chat_bubble,
                  size: 12,
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 15.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${notificationModel.name} added comment to your post: "${AppCubit.get(context).posts[notificationModel.postUId]!.text}"',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16.0, height: 1.3),
                  maxLines: 2,
                ),
                const SizedBox(
                  height: 1.5,
                ),
                Text(
                  Jiffy('${notificationModel.dateTime}').fromNow(),
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
      );
    }
  }
}
