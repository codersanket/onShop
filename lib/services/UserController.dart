import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  User user;

  setProfile() {
    print("Hello");
    user = FirebaseAuth.instance.currentUser;
    int rng = Random().nextInt(100);
    if (user != null) {
      if (user.photoURL == null) {
        user.updateProfile(
            displayName: "User $rng",
            photoURL:
                "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2Fthumb%2F7%2F7e%2FCircle-icons-profile.svg%2F1200px-Circle-icons-profile.svg.png&f=1&nofb=1");

        print("Updated");
        update();
        print(user);
      }
    }
  }
}
