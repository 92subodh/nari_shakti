// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:safeher/api/user_api.dart';
// import 'package:safeher/widgets/avatar_edit.dart';
// import 'package:safeher/widgets/icon_row.dart';

// import '../utils/logging_utils.dart';

// class UserProfile extends StatefulWidget {
//   const UserProfile({super.key});

//   @override
//   State<UserProfile> createState() => _UserProfileState();
// }

// class _UserProfileState extends State<UserProfile> {
//   final ImagePicker _imagePicker = ImagePicker();
//   File? _image;
//   bool uploadingImage = false;
//   String? imageUrl;
//   String? userName;
//   bool? edited = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     final url = await UserApi().getImageUrl();
//     setState(() {
//       imageUrl = url;
//       userName = UserApi().name;
//     });
//   }

//   Future<void> _refreshUserData() async {
//     final url = await UserApi().getImageUrl();
//     setState(() {
//       userName = UserApi().name;
//       imageUrl = url;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("User Profile", style: theme.textTheme.titleMedium),
//         leading: IconButton(
//           onPressed: () async {
//             Navigator.pop(context, edited == true);
//           },
//           icon: Icon(Icons.chevron_left),
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15.0),
//             child: Column(
//               spacing: 10,
//               children: [
//                 GestureDetector(
//                   onTap: () async {
//                     final pickedFile = await _imagePicker.pickImage(
//                       source: ImageSource.gallery,
//                       imageQuality: 5,
//                     );

//                     if (pickedFile != null) {
//                       setState(() {
//                         _image = File(pickedFile.path);
//                       });

//                       // await _uploadImage(_image!);
//                       try {
//                         String generatedUrl = await UserApi()
//                             .uploadProfilePicture(_image!);
//                         setState(() {
//                           imageUrl = generatedUrl;
//                         });
//                       } catch (e) {
//                         logging.e(e);
//                         _image = null;
//                         uploadingImage = false;
//                       }
//                     }
//                   },
//                   child: AvatarEdit(
//                     source: imageUrl,
//                     name: userName ?? ".",
//                     size: 125,
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(userName ?? "", style: theme.textTheme.titleLarge),
//                     // Icon(Icons.keyboard_arrow_down_outlined),
//                   ],
//                 ),

//                 SizedBox(height: 10),

//                 Divider(color: theme.colorScheme.outline),
//                 GestureDetector(
//                   onTap: () async {
//                     final result = await Navigator.of(
//                       context,
//                     ).pushNamed("/edit-user-account");
//                     if (result == true) {
//                       await _refreshUserData();
//                       setState(() {
//                         edited = true;
//                       });
//                     }
//                   },
//                   child: IconRow(
//                     icon: Image.asset("assets/icons/pencilIcon.png", width: 25),
//                     text: "Edit Account",
//                   ),
//                 ),
//                 Divider(color: theme.colorScheme.outline),
//                 IconRow(
//                   icon: Icon(Icons.notifications_outlined, size: 25),
//                   text: "Notifications",
//                 ),
//                 Divider(color: theme.colorScheme.outline),
//                 IconRow(icon: Icon(Icons.info_outline, size: 25), text: "Help"),
//                 Divider(color: theme.colorScheme.outline),
//                 IconRow(icon: Icon(Icons.logout, size: 25), text: "Logout"),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
