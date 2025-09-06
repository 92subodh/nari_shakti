import 'dart:io';
import 'package:safeher/schemas/user_schema.dart';
import 'package:safeher/utils/request_utils.dart';

class UserApi {
  UserApi._internal();
  static final UserApi _singleton = UserApi._internal();
  factory UserApi() => _singleton;

  int? id;
  String? name;

  // returns the created user id
  Future<int> createUser(UserRegistrationSchema user) async {
    var res = await post(route: "/user/create", body: user.toJson());
    if (res.success) {
      UserApi().id = res.data["id"];
      UserApi().name = user.name;
      return res.data["id"];
    } else {
      throw Exception("Could not create user");
    }
  }
  Future<String> uploadProfilePicture(File imageFile) async {
    ServerResponse res = await uploadFile(
      file: imageFile,
      route: "/user/upload-profile-picture",
      fields: {"id": id.toString()},
    );

    return res.data["url"];
  }

  Future<String?> getImageUrl() async {
    ServerResponse res = await fetch(
      route: "/user/imageUrl",
      params: {"id": id},
    );

    return res.data["url"];
  }

  // Future<void> updateProfile({
  //   String? firstName,
  //   String? lastName,
  //   String? email,
  //   String? mobileNumber,
  // }) async {
  //   if (id == null) {
  //     throw Exception("User must be logged in to update profile");
  //   }

  //   final Map<String, dynamic> updateData = {"id": id.toString()};

  //   if (firstName != null) {
  //     updateData["first_name"] = firstName;
  //   }
  //   if (lastName != null) {
  //     updateData["last_name"] = lastName;
  //   }
  //   if (email != null && email.isNotEmpty) {
  //     updateData["email"] = email;
  //   }
  //   if (mobileNumber != null && mobileNumber.isNotEmpty) {
  //     updateData["mobile_number"] = mobileNumber;
  //   }

  //   final res = await post(
  //     route: "/user/update-profile",
  //     body: jsonEncode(updateData),
  //   );

  //   if (!res.success) {
  //     throw Exception("Failed to update profile: ${res.message}");
  //   }

  //   if (firstName != null || lastName != null) {
  //     String newName = "";
  //     if (firstName != null) newName += firstName;
  //     if (lastName != null) newName += " ${lastName}";
  //     if (newName.trim().isNotEmpty) {
  //       UserApi().name = newName.trim();
  //     }
  //   }
  // }
}
