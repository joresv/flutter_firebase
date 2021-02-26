import 'package:firebase_app/model/user.dart';
import 'package:firebase_app/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googlesignIn = GoogleSignIn();

  Future signinAnonimous() async {
    try {
      final result = await auth.signInAnonymously();
      return result.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> get user async {
    final user = FirebaseAuth.instance.currentUser;
    return user;
  }

  Future<bool> signup(String email, pass, String pseudo) async {
    try {
      final result = await auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      if (result.user != null) {
        await DBServices()
            .saveUser(UserM(id: result.user.uid, email: email, pseudo: pseudo));
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signin(String email, String pass) async {
    try {
      final result =
          await auth.signInWithEmailAndPassword(email: email, password: pass);
      if (result.user != null) return true;
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> resetpassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> googleSignIn() async {
    try {
      GoogleSignInAccount googleUser = await googlesignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final user = await auth.signInWithCredential(credential);
      if (user != null) return true;
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future signOut() async {
    try {
      return auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
