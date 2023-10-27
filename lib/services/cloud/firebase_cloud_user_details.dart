import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todos_bloc_app/services/cloud/user.dart';
import 'package:todos_bloc_app/services/cloud/cloud_storage_exceptions.dart';
import 'package:dartx/dartx.dart';

class FirebaseCloudStorageUserDetails {
  final user = FirebaseFirestore.instance.collection('user');

  Future<void> updateUser({
    required String userId,
    String? city,
    String? pincode,
    String? state,
    String? linkedInUrl,
    String? profilePicUrl,
  }) async {
    try {
      print("object userId:: $userId");
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user') // Replace with your collection name
          .where('user_id',
              isEqualTo: userId) // Replace with the name of your UID field
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print("querySnapshot.docs.first.id: ${querySnapshot.docs.first.id}");
        await user.doc(querySnapshot.docs.first.id).update({
          if (city.isNotNullOrEmpty) 'city': city,
          if (pincode.isNotNullOrEmpty) 'pincode': pincode,
          if (state.isNotNullOrEmpty) "state": state,
          if (linkedInUrl.isNotNullOrEmpty) "linkedInLink": linkedInUrl,
          if (profilePicUrl.isNotNullOrEmpty) "profilePicUrl": profilePicUrl,
        });
        Fluttertoast.showToast(msg: 'Changes Saved');
      } else {
        throw Exception();
      }
    } catch (e, st) {
      print("error is: $e \n st: $st");

      print("object userId:: $userId");
      Fluttertoast.showToast(msg: 'Failed to save. Please try again');
      throw CouldNotUpdateTodoException();
    }
  }

  Future<void> uploadProfilePic(XFile? image, String userId) async {
    print('img:: ${image?.path}');
    if (image != null) {
      try {
        print("object: $userId");
        // Reference to Firebase Storage
        final storageReference =
            FirebaseStorage.instance.ref().child('profile_pics/$userId.jpg');

        // Upload the image to Firebase Storage
        final uploadTask = storageReference.putFile(File(image.path));

        // Get the URL of the uploaded image
        final TaskSnapshot taskSnapshot = await uploadTask;
        final imageUrl = await taskSnapshot.ref.getDownloadURL();
        print("url is $imageUrl");

        try {
          await updateUser(
            userId: userId,
            profilePicUrl: imageUrl,
          );
        } catch (e, st) {
          print("error img updateUser :: $e, \n st:: $st");
        }
      } catch (err, st) {
        print("error img :: $err, \n st:: $st");
      }
    }

    // Update the UI with the new image
  }

  Stream<User> allUserDetails({required String userId}) {
    print("userID:: $userId");
    try {
      print("try");
      final allUserDetails = user
          .where('user_id', isEqualTo: userId)
          .snapshots()
          .map((event) => event.docs.map((doc) {
                print("aaa::: ${doc.data().keys.toList().join(", ")}");
                print("aaa::: ${doc.data().values.toList().join(", ")}");
                return User.fromSnapshot(doc);
              }).first);
      // print("allUserDetails:: ${allUserDetails.}");
      return allUserDetails;
    } catch (e, st) {
      print("Error:: $e \n st: $st");
      throw Error();
    }
  }

  static final FirebaseCloudStorageUserDetails _shared =
      FirebaseCloudStorageUserDetails._sharedInstance();
  FirebaseCloudStorageUserDetails._sharedInstance();
  factory FirebaseCloudStorageUserDetails() => _shared;
}
