// import 'package:flutter/material.dart';
// // import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:safeher/api/user_api.dart';
// // import 'package:safeher/widgets/default_appbar.dart';
// // import 'package:safeher/widgets/default_text_input.dart';
// import 'package:safeher/widgets/title_text.dart';

// class UserAccountEdit extends StatefulWidget {
//   const UserAccountEdit({super.key});

//   @override
//   State<UserAccountEdit> createState() => _UserAccountEditState();
// }

// class _UserAccountEditState extends State<UserAccountEdit> {
//   String name = "";
//   String areaCode = "";
//   String phone = "";
//   String email = "";
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     name = UserApi().name ?? "";
//   }

//   Future<void> _saveChanges() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       List<String> nameParts = name.trim().split(' ');
//       String firstName = nameParts.first;
//       String lastName =
//           nameParts.length > 1 ? nameParts.sublist(1).join(' ') : "";
//       String formattedPhone = phone.isNotEmpty ? "$areaCode$phone" : "";

//       await UserApi().updateProfile(
//         firstName: firstName,
//         lastName: lastName,
//         email: email.isNotEmpty ? email : null,
//         mobileNumber: formattedPhone.isNotEmpty ? formattedPhone : null,
//       );

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
//       Navigator.pop(context, true);
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to update profile: ${error.toString()}'),
//         ),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     return Scaffold(
//       // appBar: DefaultAppbar(title: "Edit Account"),
//       body:
//           isLoading
//               ? Center(child: CircularProgressIndicator())
//               : Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     TextTitle.small("Name"),
//                     DefaultTextInput(
//                       onChanged: (value) {
//                         setState(() {
//                           name = value;
//                         });
//                       },
//                       hintText: "Enter your name",
//                       initialValue: name,
//                     ),

//                     SizedBox(height: 10),
//                     TextTitle.small("Phone Number"),
//                     IntlPhoneField(
//                       showCountryFlag: false,
//                       dropdownIconPosition: IconPosition.trailing,
//                       dropdownIcon: Icon(Icons.keyboard_arrow_down, size: 12),
//                       style: theme.textTheme.bodyMedium,
//                       decoration: InputDecoration(
//                         hintStyle: theme.textTheme.bodyMedium,
//                         labelStyle: theme.textTheme.bodyMedium,
//                         labelText: 'Phone Number',
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       initialCountryCode: 'IN',
//                       onChanged: (ph) {
//                         setState(() {
//                           areaCode = ph.countryCode;
//                           phone = ph.number;
//                         });
//                       },
//                     ),
//                     SizedBox(height: 10),

//                     TextTitle.small("Email Address"),
//                     DefaultTextInput(
//                       onChanged: (value) {
//                         setState(() {
//                           email = value;
//                         });
//                       },
//                       hintText: "Enter your Email Address",
//                       initialValue: email,
//                     ),

//                     SizedBox(height: 30),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.9,
//                       child: ElevatedButton(
//                         onPressed: _saveChanges,
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           backgroundColor:
//                               Theme.of(context).colorScheme.primary,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: Center(
//                           child: Text(
//                             'SAVE',
//                             style: Theme.of(
//                               context,
//                             ).textTheme.titleMedium!.copyWith(
//                               fontWeight: FontWeight.bold,
//                               color: Theme.of(context).colorScheme.surface,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//     );
//   }
// }
