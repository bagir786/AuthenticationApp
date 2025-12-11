// Firebase is our backend
import 'package:google_sign_in/google_sign_in.dart';
import 'package:app_auth/features/auth/data/domain/entities/app_user.dart';
import 'package:app_auth/features/auth/data/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthRepo implements AuthRepo {
  // akses ke firebase
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login email dan password
  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      //attemp sign in
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      //create user
      AppUser user = AppUser(uid: userCredential.user!.uid, email: email);

      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  //register email dan pass
  @override
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      // Firebase create
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final firebaseUser = userCredential.user;

      if (firebaseUser == null) return null;

      return AppUser(uid: firebaseUser.uid, email: firebaseUser.email!);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  //hapus akun
  @override
  Future<void> deleteAccount() async {
    try {
      final user = firebaseAuth.currentUser;

      if (user == null) throw Exception('No User Logged in..');

      //delete
      await user.delete();

      //logout
      await logout();
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    // gt current logged in user from firebase
    final firebaseUser = firebaseAuth.currentUser;

    // no logged in user exist
    if (firebaseUser == null) return null;

    // no logged in user exist
    return AppUser(uid: firebaseUser.uid, email: firebaseUser.email!);
  }

  //logout
  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  //Reset Password
  @override
  Future<String> sendPaswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return "password reset email! Check your inbox.";
    } catch (e) {
      return "An error occured: $e";
    }
  }

  // apple
  @override
  Future<AppUser?> signInWithApple() async {
    try {
      //request apple ID credentials
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      //create an OAuth credential
      final oAuthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // sign in with the credential
      UserCredential userCredential = await firebaseAuth.signInWithCredential(
        oAuthCredential,
      );

      //firebase user
      final firebaseUser = userCredential.user;

      // user cancelled the sign-in process
      if (firebaseUser == null) return null;

      AppUser appUser = AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
      );

      return appUser;
    } catch (e) {
      throw Exception('Apple sign-in failed: $e');
    }
  }

  // google
  @override
  Future<AppUser?> signInWithGoogle() async {
    try {
      // Create GoogleSignIn instance
      final GoogleSignIn googleSignIn = GoogleSignIn();
      
      // begin the sign-in flow
      final GoogleSignInAccount? gUser = await googleSignIn.signIn();

      if (gUser == null) return null;

      // obtain the auth details
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // create credential
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // sign in to firebase
      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) return null;

      return AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
      );
    } catch (e) {
      throw Exception('Google sign-in failed: $e');
    }
  }
}