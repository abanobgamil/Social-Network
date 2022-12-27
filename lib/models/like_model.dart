class LikeModel{
  String ? name;
  String ? uId;
  String ? image;
  String ? dateTime;
  bool ? like ;


  LikeModel({
    this.name,
    this.uId,
    this.image,
    this.dateTime,
    this.like
  });


  LikeModel.fromJson(Map<String,dynamic>  json)
  {
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
    dateTime = json['dateTime'];
    like = json['like'];
  }

  Map<String,dynamic> toMap()
  {
    return {
      'name' : name,
      'uId' : uId,
      'image' : image,
      'dateTime' : dateTime,
      'like' : like,
    };

  }



}