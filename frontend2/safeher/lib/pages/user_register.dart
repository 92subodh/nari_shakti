// import 'package:flutter/material.dart';
// import 'package:safeher/api/user_api.dart';
// import 'package:safeher/schemas/pet_schema.dart';
// import 'package:safeher/schemas/user_schema.dart';
// import 'package:safeher/utils/logging_utils.dart';
// import 'package:safeher/widgets/default_text_input.dart';

// class UserRegister extends StatefulWidget {
//   const UserRegister({super.key});

//   @override
//   State<UserRegister> createState() => _UserRegisterState();
// }

// class _UserRegisterState extends State<UserRegister> {
//   String name = "";

//   @override
//   Widget build(BuildContext context) {
//     UserRegistrationSchema args =
//         ModalRoute.of(context)!.settings.arguments as UserRegistrationSchema;

//     ThemeData theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Image.asset("assets/icons/titleLogo.png", scale: 2),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           spacing: 20,
//           children: [
//             Text.rich(
//               style: Theme.of(context).textTheme.titleMedium,
//               TextSpan(
//                 children: [
//                   TextSpan(text: "We can "),
//                   TextSpan(
//                     text: "sniff ",
//                     style: TextStyle(color: theme.colorScheme.primary),
//                   ),
//                   TextSpan(text: "a pet parent"),
//                 ],
//               ),
//             ),

//             DefaultTextInput(
//               hintText: "Enter your name",
//               onChanged: (value) {
//                 name = value;
//               },
//             ),
//           ],
//         ),
//       ),

//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () async {
//           logging.i("Continue with name: $name");
//           if (name.trim() == "") return;

//           // create user then allow them to add pet
//           args.name = name;
//           int id = await UserApi().createUser(args);

//           if (context.mounted) {
//             Navigator.pushNamed(
//               context,
//               "/add-pet",
//               arguments: CreatePetSchema(userId: id, firstPet: true),
//             );
//           }
//         },
//         label: SizedBox(
//           width: MediaQuery.of(context).size.width * 0.8,
//           child: Center(
//             child: Text(
//               "Continue",
//               style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                 color: Theme.of(context).colorScheme.surface,
//               ),
//             ),
//           ),
//         ),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//       ),
//     );
//   }
// }
