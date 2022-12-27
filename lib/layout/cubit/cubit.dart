import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network/layout/cubit/states.dart';
import 'package:social_network/models/comment_model.dart';
import 'package:social_network/models/like_model.dart';
import 'package:social_network/models/notification_model.dart';
import 'package:social_network/models/post_model.dart';
import 'package:social_network/models/user_model.dart';
import 'package:social_network/my_app.dart';
import 'package:social_network/shared/components/components.dart';
import 'package:social_network/shared/components/constant.dart';
import 'package:social_network/shared/network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int ? tabIndex ;


  UserModel? userModel;

  void getUserData() {
    emit(AppGetUserLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      print(value.data().toString());
      userModel = UserModel.fromJson(value.data()!);
      emit(AppGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AppGetUserErrorState(error.toString()));
    }).then((value) {
      getPosts();
      getNotifications();
    });
  }



  File? postImage;
  var picker = ImagePicker();

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(AppProfileImagePickedSuccessState());
    } else {
      print('No Image selected');
      emit(AppProfileImagePickedErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(AppRemovePostImageState());
  }



  void createPost({
    required String text,
    required String dateTime,
    String? postImage,
  }) {
    emit(AppCreatePostLoadingState());
    PostModel model = PostModel(
        name: userModel!.name,
        uId: userModel!.uId,
        dateTime: dateTime,
        text: text,
        postImage: postImage ?? '',
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(AppCreatePostSuccessState());
    }).catchError((error) {
      emit(AppCreatePostErrorState());
    });
  }

  void uploadPostImage({
    required String text,
    required String dateTime,
  }) {
    emit(AppCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(
          text: text,
          dateTime: dateTime,
          postImage: value,
        );
      }).catchError((error) {
        emit(AppCreatePostErrorState());
      });
    }).catchError((error) {
      emit(AppCreatePostErrorState());
    });
  }


  Map<String,UserModel> users = {};
  Map<String,PostModel> posts = {};
  List<String> postsId = [];
  Map<String,int> likesCount = {};
  Map<String,bool> myLikes = {};
  Map <String,int> commentsCount = {};


  void getPosts()  {
    users = {};
    posts = {};
    postsId = [];
    likesCount = {};
    myLikes = {};
    commentsCount = {};

    FirebaseFirestore.instance.collection('users').get().then((value) {

      value.docs.forEach((element) {

        users.addAll({element.id : UserModel.fromJson(element.data())});

        element.reference.collection('posts').get().then((value) {

          value.docs.forEach((post) {

            post.reference.collection('likes').get().then((value) {

              if (value.docs.isEmpty) {
                myLikes.addAll({post.id : false});
              } else
              {
                for (var element in value.docs) {
                  if (element.data()['uId'] == userModel!.uId)
                  {
                    myLikes.addAll({post.id : true});
                    break;
                  }
                  else {
                    myLikes.addAll({post.id : false});
                  }
                }
              }
              likesCount.addAll({post.id : value.docs.length});
              postsId.add(post.id);
              posts.addAll({post.id : PostModel.fromJson(post.data())});
              emit(AppGetPostsSuccessState());

            }).catchError((onError){
              print(onError.toString());
              emit(AppGetPostsErrorState(onError.toString()));
            });

            post.reference.collection('comments').get().then((value) {
              commentsCount.addAll({post.id : value.docs.length});
              emit(AppGetPostsSuccessState());
            });
            emit(AppGetPostsSuccessState());
          });
          emit(AppGetPostsSuccessState());
        }).catchError((onError) {
          print(onError.toString());
          emit(AppGetPostsErrorState(onError.toString()));
        });
        emit(AppGetPostsSuccessState());
      });
      emit(AppGetPostsSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(AppGetPostsErrorState(onError.toString()));
    });
    emit(AppGetPostsSuccessState());
  }


  Future<void> onRefresh() async
  {
    getPosts();
  }

  void addLike({required String postId}) {
    myLikes[postId] = !myLikes[postId]!;
    emit(AppAddLikePostSuccessState());

    LikeModel likeModel = LikeModel(
      name: userModel!.name,
      image: userModel!.image,
      like: true,
      dateTime: DateTime.now().toString(),
      uId: userModel!.uId,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(posts[postId]!.uId)
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .add(likeModel.toMap())
        .catchError((onError){
          emit(AppAddLikePostErrorState(onError.toString()));
    }).then((value) {

      if (posts[postId]!.uId != userModel!.uId) {
        NotificationModel notificationModel = NotificationModel(
          name: userModel!.name,
          image: userModel!.image,
          dateTime: DateTime.now().toString(),
          like: true,
          postUId: postId,
          userUId: userModel!.uId,
        );

        FirebaseFirestore.instance
            .collection('users')
            .doc(posts[postId]!.uId)
            .collection('notification')
            .add(notificationModel.toMap())
            .then((value){})
            .catchError((onError){
          print(onError.toString());
        });
      }
    });
    likesCount[postId] = likesCount[postId]! + 1;
    emit(AppAddLikePostSuccessState());
  }



  void removeLike({required String postId}) {
    myLikes[postId] = !myLikes[postId]!;
    emit(AppRemoveLikePostSuccessState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(posts[postId]!.uId)
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .get().then((value) {
          for (var element in value.docs) {
            if(element.data()['uId']==userModel!.uId)
              {
                element.reference.delete();
                break;
              }
          }
    }).catchError((error) {
      emit(AppRemoveLikePostErrorState(error.toString()));
    });
    likesCount[postId] = likesCount[postId]! - 1;

    FirebaseFirestore.instance
        .collection('users')
        .doc(posts[postId]!.uId)
        .collection('notification')
        .get().then((value) {
            for (var element in value.docs) {
              if(element.data()['postUId'] == postId && element.data()['userUId'] == userModel!.uId)
                {
                  element.reference.delete();
                  break;
                }
            }
    });

    emit(AppRemoveLikePostSuccessState());
  }



  void addComment({
    required String text,
    required String dateTime,
    required String postId,
    String? postImage,
  }) {
  //  emit(AppCreatePostLoadingState());
    CommentModel model = CommentModel(
      name: userModel!.name,
      uId: userModel!.uId,
      image: userModel!.image,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(posts[postId]!.uId)
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(model.toMap())
        .then((value) {
          getComments(postId: postId);
      emit(AppAddCommentsSuccessState());
    }).catchError((error) {
      emit(AppAddCommentsErrorState());
    })
        .then((value) {

      if (posts[postId]!.uId != userModel!.uId) {
        NotificationModel notificationModel = NotificationModel(
          name: userModel!.name,
          image: userModel!.image,
          dateTime: DateTime.now().toString(),
          text: text,
          postUId: postId,
        );

        FirebaseFirestore.instance
            .collection('users')
            .doc(posts[postId]!.uId)
            .collection('notification')
            .add(notificationModel.toMap())
            .then((value){

        }).catchError((onError){
          print(onError.toString());
        });
      }

    });
  }



  List<LikeModel> likes =[];

  void getLikes({
    required String postId,
    context,
  })
{
  likes=[];
  FirebaseFirestore.instance
      .collection('users')
      .doc(posts[postId]!.uId)
      .collection('posts')
      .doc(postId)
      .collection('likes')
      .orderBy("dateTime")
      .get()
      .then((value) {
    value.docs.forEach((element) {
      likes.add(LikeModel.fromJson(element.data()));
    });
    emit(AppGetLikesSuccessState());
    likesCount[postId]=likes.length;
  });


}




  List<CommentModel> comments=[];

  void getComments({
    required String postId,
      context,
}) {
    comments=[];
    FirebaseFirestore.instance
        .collection('users')
        .doc(posts[postId]!.uId)
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy("dateTime")
        .get()
        .then((value) {
          value.docs.forEach((element) {
            comments.add(CommentModel.fromJson(element.data()));
          });
          emit(AppGetCommentsSuccessState());
          commentsCount[postId] = comments.length;
    });

  }



  List<NotificationModel> notifications = [];
  List<String> newNotifications = [];
   int  newNotificationCount = 0;

  void getNotifications() {

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('notification')
        .limit(10)
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {

          notifications = [];
          newNotifications=[];
          newNotificationCount=0;

         event.docs.forEach((element) {
           if(element.data()['seen'] == false)
             {
               newNotifications.add(element.id);
               newNotificationCount = newNotificationCount + 1;
             }
           notifications.add(NotificationModel.fromJson(element.data()));
           if(tabIndex==3)
           {
             notificationSeen();
           }
         });
          emit(AppGetNotificationState());
    });
    emit(AppGetNotificationState());
  }


  void notificationSeen()
  {
    newNotifications.forEach((element) {

      FirebaseFirestore.instance
          .collection('users')
          .doc(userModel!.uId)
          .collection('notification')
          .doc(element)
          .update(
          {'seen': true}
      ).then((value) {
        newNotificationCount = 0;

        emit(AppSeenNotificationState());
      }).catchError((onError){
        print(onError.toString());
      });

    });

  }


  void signOut(context)
  {

    CacheHelper.removeData(key:'uId').then((value) {
      if(value)
        {
          uId = null;
          navigateAndFinish(context, const MyApp());
        }
    });


  }


  












}
