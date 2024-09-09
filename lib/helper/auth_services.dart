import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthServices{
  static AuthServices authServices = AuthServices._();
  AuthServices._();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> createAccount(String email, String password) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
    print(userCredential.user!.email);
  }

  Future<User?> signInUser(String email, String password) async {
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    }catch(e){
      print(e);
      return null;
    }
  }

  Future<bool> checkEmail(String email) async {
    try{
      List<String> signInMethods = await auth.fetchSignInMethodsForEmail(email);
      return signInMethods.isNotEmpty;
    }catch(e){
      print(e);
      return false;
    }
  }

  Future<void> signOutUser() async {
    await auth.signOut();
    User? user = auth.currentUser;
    if(user == null){
      Get.back();
    }
  }
}