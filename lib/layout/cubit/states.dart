abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppGetUserLoadingState extends AppStates {}

class AppGetUserSuccessState extends AppStates {}

class AppGetUserErrorState extends AppStates
{
  final String error;

  AppGetUserErrorState(this.error);

}

class AppChangeBottomNavState extends AppStates {}

class AppNewPostState extends AppStates {}

class AppProfileImagePickedSuccessState extends AppStates {}

class AppProfileImagePickedErrorState extends AppStates {}

class AppCoverImagePickedSuccessState extends AppStates {}

class AppCoverImagePickedErrorState extends AppStates {}

class AppUploadProfileImageSuccessState extends AppStates {}

class AppUploadProfileImageErrorState extends AppStates {}

class AppUploadCoverImageSuccessState extends AppStates {}

class AppUploadCoverImageErrorState extends AppStates {}

class AppProfileUpdateLoadingState extends AppStates {}

class AppCoverUpdateLoadingState extends AppStates {}

class AppUserUpdateErrorState extends AppStates {}


class AppCreatePostLoadingState extends AppStates {}

class AppCreatePostSuccessState extends AppStates {}

class AppCreatePostErrorState extends AppStates {}

class AppPostImagePickedSuccessState extends AppStates {}

class AppPostImagePickedErrorState extends AppStates {}

class AppRemovePostImageState extends AppStates {}

class AppGetNotificationState extends AppStates {}

class AppSeenNotificationState extends AppStates {}


// GetPost
class AppGetPostsLoadingState extends AppStates {}

class AppGetPostsSuccessState extends AppStates {}

class AppGetPostsErrorState extends AppStates
{
  final String error;

  AppGetPostsErrorState(this.error);

}


class AppAddLikePostSuccessState extends AppStates {}

class AppAddLikePostErrorState extends AppStates
{
  final String error;

  AppAddLikePostErrorState(this.error);

}


class AppRemoveLikePostSuccessState extends AppStates {}


class AppRemoveLikePostErrorState extends AppStates {
  final String error;

  AppRemoveLikePostErrorState(this.error);
}

class AppGetCommentsSuccessState extends AppStates {}

class AppAddCommentsSuccessState extends AppStates {}
class AppAddCommentsErrorState extends AppStates {}

class AppGetLikesSuccessState extends AppStates {}




class AppGetAllUsersLoadingState extends AppStates {}

class AppGetAllUsersSuccessState extends AppStates {}

class AppGetAllUsersErrorState extends AppStates
{
  final String error;

  AppGetAllUsersErrorState(this.error);

}




class AppSendMessageSuccessState extends AppStates {}

class AppSendMessageErrorState extends AppStates
{
  final String error;

  AppSendMessageErrorState(this.error);

}

class AppGetMessageSuccessState extends AppStates {}

