import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todos_bloc_app/services/auth/auth_service.dart';
import 'package:todos_bloc_app/services/auth/user_profile_bloc/user.dart';
import 'package:todos_bloc_app/services/cloud/firebase_cloud_user_details.dart';
import 'package:todos_bloc_app/utilities/dialogs/generic_dialog.dart';
import 'package:todos_bloc_app/views/profile/user_profile_textfield.dart';
import 'package:transparent_image/transparent_image.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final FirebaseCloudStorageUserDetails _userService;
  String get userId => AuthService.firebase().currentUser?.id ?? '';
  String? profilePicUrl;
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _linkedInController = TextEditingController();
  bool _isEditMode = false;
  XFile? image;

  @override
  void initState() {
    super.initState();
    // Dispatch the FetchUser event when the widget is initialized.
    _userService = FirebaseCloudStorageUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? a;
        if (_isEditMode) {
          a = await showGenericDialog(
            context: context,
            title: 'Your changes will be lost!',
            content: 'You haven'
                't saved your changes. Are you sure you want to exit?',
            optionsBuilder: () {
              return {'Yes': true, 'No': false};
            },
          );
          if (a == true) {
            return true;
          } else {
            return false;
          }
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("profile"),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
              onPressed: () async {
                if (_isEditMode) {
                  await _userService.updateUser(
                    userId: userId,
                    city: _cityController.text,
                    state: _stateController.text,
                    pincode: _pincodeController.text,
                    linkedInUrl: _linkedInController.text,
                  );
                }
                setState(() {
                  _isEditMode = !_isEditMode;
                });
              },
              child: Text(_isEditMode ? "Save" : "Edit")),
        ),
        body: StreamBuilder(
            stream: _userService.allUserDetails(userId: userId),
            builder: (context, snapshot) {
              print("state:: ${snapshot.connectionState}");
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  _cityController.text = snapshot.data?.city ?? 'city';
                  _pincodeController.text = snapshot.data?.pincode ?? 'city';
                  _stateController.text = snapshot.data?.state ?? 'city';
                  _linkedInController.text =
                      snapshot.data?.linkedInLink ?? 'city';
                  print(
                      "snap::: ${snapshot.data.toString()}\n ${_cityController.text.length}");
                  if (snapshot.hasData) {
                    print("snap::: ${snapshot.data.toString()}");
                    final userDetails = snapshot.data as User;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 24, 24, 24),
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (_isEditMode) {
                                        image = await ImagePicker().pickImage(
                                            source: ImageSource.camera);

                                        print("object:: img: ${image?.path}");
                                        await _userService.uploadProfilePic(
                                          image,
                                          userId,
                                        );
                                        setState(() {});
                                      }
                                    },
                                    child: Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 50,
                                          child: _isEditMode && image != null
                                              ? ClipOval(
                                                  child: SizedBox(
                                                    height: 100,
                                                    width: 100,
                                                    child: Image.file(
                                                      File(image?.path ?? ''),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                )
                                              : ClipOval(
                                                  child: SizedBox(
                                                    height: 100,
                                                    width: 100,
                                                    child: FadeInImage
                                                        .memoryNetwork(
                                                      placeholder:
                                                          kTransparentImage,
                                                      image: snapshot.data
                                                              ?.profilePicUrl ??
                                                          '',
                                                      fit: BoxFit.cover,
                                                      imageErrorBuilder:
                                                          (context, _, st) {
                                                        return Container(
                                                          height: 100,
                                                          width: 100,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              userDetails.name
                                                                  .substring(
                                                                      0, 2)
                                                                  .toUpperCase(),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 30,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                        ),
                                        _isEditMode
                                            ? const Positioned(
                                                right: 6,
                                                bottom: 4,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.yellow,
                                                  radius: 12,
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.edit_outlined,
                                                      size: 12,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox.shrink()
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userDetails.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      userDetails.email,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          UserProfileTextField(
                            controller: _cityController,
                            isEditMode: _isEditMode,
                            labelText: 'City',
                          ),
                          UserProfileTextField(
                            controller: _stateController,
                            isEditMode: _isEditMode,
                            labelText: 'State',
                          ),
                          UserProfileTextField(
                            controller: _pincodeController,
                            isEditMode: _isEditMode,
                            labelText: 'PinCode',
                          ),
                          UserProfileTextField(
                            controller: _linkedInController,
                            isEditMode: _isEditMode,
                            labelText: 'LinkedIn',
                          )
                        ],
                      ),
                    );
                  } else {
                    print("${snapshot.error}");
                    return const Center(child: CircularProgressIndicator());
                  }
                default:
                  print("${snapshot.error}");
                  return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
