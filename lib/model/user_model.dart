class UserModel{
  String? name, email, photoUrl;

  UserModel({required this.name, required this.email, required this.photoUrl});

  factory UserModel.fromMap(Map m1){
    return UserModel(
      name: m1['name'],
      email: m1['email'],
      photoUrl: m1['photoUrl'],
    );
  }

  Map<String, String?> toMap(UserModel user){
    return {
      'name' : user.name,
      'email' : user.email,
      'photoUrl' : user.photoUrl,
    };
  }
}