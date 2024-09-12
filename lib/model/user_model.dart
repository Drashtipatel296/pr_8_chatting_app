class UserModel{
  String? name, email, photoUrl, token;

  UserModel({required this.name, required this.email, required this.photoUrl, required this.token});

  factory UserModel.fromMap(Map m1){
    return UserModel(
      name: m1['name'],
      email: m1['email'],
      photoUrl: m1['photoUrl'],
      token: m1['token'],
    );
  }

  Map<String, String?> toMap(UserModel user){
    return {
      'name' : user.name,
      'email' : user.email,
      'photoUrl' : user.photoUrl,
      'token' : user.token,
    };
  }
}