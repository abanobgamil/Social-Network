import 'package:badges/badges.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/layout/cubit/cubit.dart';
import 'package:social_network/layout/cubit/states.dart';
import 'package:social_network/modules/feeds/feeds_screen.dart';
import 'package:social_network/modules/notification/notification_screen.dart';
import 'package:social_network/modules/profile/profile_screen.dart';
import 'package:social_network/modules/settings/settings_screen.dart';

class AppLayout extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                  "Social Network",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w700
              ),
              ),
              actions: [
                IconButton(
                    onPressed: (){
                      AppCubit.get(context).signOut(context);
                    },
                    icon: const Icon(
                        Icons.logout,
                      color: Colors.blue,
                    ),
                ),
              ],
              bottom: TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black26,
                onTap: (index)
                {
                  AppCubit.get(context).tabIndex = index;
                },
                tabs:[
                  const Tab(
                    icon: Icon(Icons.home),
                  ),
                  const Tab(
                    icon: Icon(Icons.person),
                  ),
                  Tab(
                    icon:
                        AppCubit.get(context).newNotificationCount == 0
                        ? const Icon(Icons.notifications)
                        : Badge(
                          animationType: BadgeAnimationType.scale,
                        badgeContent: Text('${AppCubit.get(context).newNotificationCount}'),
                        child:const Icon(Icons.notifications)),
                  ),
                  const Tab(
                    icon: Icon(Icons.menu),
                  ),
                ],
              ),
              backgroundColor: Colors.white,
              elevation: 1,
            ),
            body:  ConditionalBuilder(
              condition: AppCubit.get(context).userModel != null,
              builder: (context)=> TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const FeedsScreen(),
                    ProfileScreen(uId: AppCubit.get(context).userModel!.uId),
                    const NotificationScreen(),
                    const SettingsScreen(),
                  ]),
              fallback: (BuildContext context)=> const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ) ;
      },
    );
  }
}
