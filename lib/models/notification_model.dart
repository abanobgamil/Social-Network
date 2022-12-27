class NotificationModel{
  String ? name;
  String ? image;
  String ? dateTime;
  String ? text;
  bool ? like;
  String ? postUId;
  String ? userUId;
  bool  seen = false ;


  NotificationModel({
    this.name,
    this.image,
    this.dateTime,
    this.text,
    this.like,
    this.postUId,
    this.userUId,
  });


  NotificationModel.fromJson(Map<String,dynamic>  json)
  {
    name = json['name'];
    image = json['image'];
    dateTime = json['dateTime'];
    text = json['text'];
    like = json['like'];
    postUId = json['postUId'];
    userUId = json['userUId'];
    seen = json['seen'];
  }


  Map<String,dynamic> toMap()
  {
    return {
      'name' : name,
      'image' : image,
      'dateTime' : dateTime,
      'text' : text,
      'like' : like,
      'postUId' : postUId,
      'userUId' : userUId,
      'seen' : seen,
    };


  }


}