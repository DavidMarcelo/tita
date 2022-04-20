class UserModel {
  String? user_id;
  String? email;
  //String? name;
  //int? phone;

  UserModel({
    this.user_id,
    this.email,
  });

//REciving dat from server
  factory UserModel.fromMap(map) {
    return UserModel(
      user_id: map['user_id'],
      email: map['email'],
    );
  }

  //sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'email': email,
    };
  }
}
