// import 'package:auth0_flutter/auth0_flutter.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:intl_phone_field/phone_number.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:safeher/api/pet_api.dart';
// import 'package:safeher/api/user_api.dart';
// import 'package:safeher/schemas/pet_schema.dart';
// import 'package:safeher/schemas/user_schema.dart';
// import 'package:safeher/utils/auth_utils.dart';
// import 'package:safeher/utils/logging_utils.dart';
// import 'package:safeher/utils/request_utils.dart';
// import 'package:safeher/widgets/text_body.dart';
// import 'dart:async';

// List<Widget> getIntroCarouselImages() {
//   List<String> images = [
//     "images/splash_1.png",
//     "images/splash_2.png",
//     "images/splash_3.png",
//     "images/splash_4.png",
//   ];
//   return images.map((e) => Image.asset(e)).toList();
// }

// class IntroScreen extends StatelessWidget {
//   const IntroScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: Stack(children: [IntroScreenBody()]));
//   }
// }

// class IntroScreenBody extends StatefulWidget {
//   const IntroScreenBody({super.key});

//   @override
//   State<IntroScreenBody> createState() => _IntroScreenBodyState();
// }

// class _IntroScreenBodyState extends State<IntroScreenBody> {
//   int _currentPage = 0;
//   List<Widget> splashImages = getIntroCarouselImages();

//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 15.0),
//         child: Column(
//           children: [
//             Image.asset("assets/icons/titleLogo.png", scale: 2.0),
//             Spacer(),
//             CarouselSlider(
//               items: splashImages,
//               options: CarouselOptions(
//                 autoPlay: true,
//                 viewportFraction: 1,
//                 height: MediaQuery.of(context).size.height * 0.38,
//                 onPageChanged: (index, reason) {
//                   setState(() {
//                     _currentPage = index;
//                   });
//                 },
//               ),
//             ),

//             SizedBox(height: 20),

//             Text.rich(
//               TextSpan(
//                 style: theme.textTheme.labelLarge!.copyWith(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 children: [
//                   TextSpan(text: "Where Pet "),
//                   TextSpan(
//                     text: "Health",
//                     style: TextStyle(color: theme.colorScheme.primary),
//                   ),
//                 ],
//               ),
//             ),
//             Text.rich(
//               TextSpan(
//                 style: theme.textTheme.labelLarge!.copyWith(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 children: [
//                   TextSpan(text: "Meets "),
//                   TextSpan(
//                     text: "Convenience",
//                     style: TextStyle(color: theme.colorScheme.primary),
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(height: 60),
//             CarouselDotsIndicator(
//               currentPage: _currentPage,
//               pageCount: splashImages.length,
//             ),

//             SizedBox(height: 20),
//             GestureDetector(
//               onTap: () {
//                 showModalBottomSheet(
//                   context: context,
//                   isScrollControlled: true,
//                   builder: (context) {
//                     return ModalBottomSheet();
//                   },
//                 );
//               },
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 padding: EdgeInsets.all(15),
//                 decoration: BoxDecoration(
//                   color: theme.colorScheme.primary,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Center(
//                   child: Text(
//                     "Enter Mobile",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 17,
//                       color: Theme.of(context).colorScheme.surface,
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 40.0),
//               child: Text(
//                 "By clicking Login, you agree to our Terms and acknowledge that you have read our Privacy Policy.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontWeight: FontWeight.w400,
//                   fontSize: 11.5,
//                   color: Color(0xff1B1B1B),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CarouselDotsIndicator extends StatelessWidget {
//   final int currentPage;
//   final int pageCount;
//   const CarouselDotsIndicator({
//     super.key,
//     required this.currentPage,
//     required this.pageCount,
//   });

//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: List.generate(pageCount, (index) {
//           return AnimatedContainer(
//             duration: Duration(milliseconds: 300),
//             margin: EdgeInsets.symmetric(horizontal: 5.0),
//             height: 10.0,
//             width: currentPage == index ? 20.0 : 10.0,
//             decoration: BoxDecoration(
//               color:
//                   currentPage == index
//                       ? theme.colorScheme.primary
//                       : Colors.grey,
//               borderRadius: BorderRadius.circular(5.0),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

// class ModalBottomSheet extends StatefulWidget {
//   const ModalBottomSheet({super.key});

//   @override
//   State<ModalBottomSheet> createState() => _ModalBottomSheetState();
// }

// class _ModalBottomSheetState extends State<ModalBottomSheet> {
//   int screen = 0;
//   late PhoneNumber phoneNumber;

//   void submitNumber(PhoneNumber ph) {
//     setState(() {
//       phoneNumber = ph;
//       screen = 1;
//     });
//   }

//   void changeNumber() {
//     setState(() {
//       screen = 0;
//     });
//   }

//   Future resendOtp() async {
//     await AuthUtils().sendOtp(phoneNumber.completeNumber);
//   }

//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     return Container(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom + 80.0,
//         left: 30.0,
//         right: 30.0,
//         top: 15.0,
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.1,
//                 child: Divider(
//                   color: theme.colorScheme.secondary,
//                   thickness: 2,
//                 ),
//               ),
//             ),

//             if (screen == 0) ModalBottomSheetInput(submitNumber: submitNumber),
//             if (screen == 1)
//               ModalBottomSheetVerifyOtp(
//                 phoneNumber: phoneNumber,
//                 changeNumber: changeNumber,
//                 resendOtp: resendOtp,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ModalBottomSheetInput extends StatefulWidget {
//   final Function submitNumber;
//   const ModalBottomSheetInput({super.key, required this.submitNumber});

//   @override
//   State<ModalBottomSheetInput> createState() => _ModalBottomSheetInputState();
// }

// class _ModalBottomSheetInputState extends State<ModalBottomSheetInput> {
//   late PhoneNumber phoneNumber;
//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       spacing: 20,
//       children: [
//         Text(
//           "Let's get started",
//           style: theme.textTheme.titleLarge!.copyWith(
//             color: theme.colorScheme.primary,
//           ),
//         ),

//         IntlPhoneField(
//           showCountryFlag: false,
//           dropdownIconPosition: IconPosition.trailing,
//           dropdownIcon: Icon(Icons.keyboard_arrow_down, size: 12),
//           flagsButtonPadding: EdgeInsets.symmetric(horizontal: 6),
//           style: theme.textTheme.bodyMedium,
//           decoration: InputDecoration(
//             hintStyle: theme.textTheme.bodyMedium?.copyWith(
//               color: theme.colorScheme.onSecondary,
//             ),
//             hintText: 'Enter Mobile Number',
//             border: OutlineInputBorder(
//               borderSide: BorderSide(),
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           initialCountryCode: 'IN',
//           onChanged: (ph) {
//             setState(() {
//               phoneNumber = ph;
//             });
//           },
//         ),

//         SizedBox(
//           width: double.infinity,
//           height: 51,
//           child: TextButton(
//             onPressed: () {
//               try {
//                 if (phoneNumber.isValidNumber()) {
//                   logging.i("Valid number found");
//                   AuthUtils().sendOtp(phoneNumber.completeNumber);
//                   widget.submitNumber(phoneNumber);
//                 }
//               } catch (e) {
//                 logging.e(e);
//               }
//             },
//             style: TextButton.styleFrom(
//               backgroundColor: theme.colorScheme.primary,
//             ),
//             child: Text(
//               "Continue",
//               style: theme.textTheme.titleSmall!.copyWith(
//                 color: theme.colorScheme.surface,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ModalBottomSheetVerifyOtp extends StatefulWidget {
//   final PhoneNumber phoneNumber;
//   final Function changeNumber;
//   final Function resendOtp;
//   const ModalBottomSheetVerifyOtp({
//     super.key,
//     required this.phoneNumber,
//     required this.changeNumber,
//     required this.resendOtp,
//   });

//   @override
//   State<ModalBottomSheetVerifyOtp> createState() =>
//       _ModalBottomSheetVerifyOtpState();
// }

// class _ModalBottomSheetVerifyOtpState extends State<ModalBottomSheetVerifyOtp> {
//   int resendDuration = 60; // 1 minutes in seconds
//   String otp = "";
//   bool isLoading = false;
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   void startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (resendDuration > 0) {
//         setState(() {
//           resendDuration--;
//         });
//       } else {
//         timer.cancel();
//       }
//     });
//   }

//   String getFormattedTime() {
//     int minutes = resendDuration ~/ 60;
//     int seconds = resendDuration % 60;
//     return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
//   }

//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         spacing: 20,
//         children: [
//           Text(
//             "Enter OTP",
//             style: theme.textTheme.titleMedium!.copyWith(
//               color: theme.colorScheme.primary,
//             ),
//           ),

//           Column(
//             children: [
//               Center(
//                 child: Text(
//                   "We have sent a 4 digit OTP on",
//                   style: theme.textTheme.labelMedium,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               SizedBox(height: 4), 
//               Center(
//                 child: Text(
//                   widget.phoneNumber.number,
//                   style: theme.textTheme.labelMedium?.copyWith(
//                     fontWeight: FontWeight.w600,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ],
//           ),

//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: PinCodeTextField(
//               appContext: context,
//               length: 4,
//               pinTheme: PinTheme(
//                 shape: PinCodeFieldShape.box,
//                 borderRadius: BorderRadius.circular(8),
//                 fieldHeight: 50,
//                 fieldWidth: 50,
//                 activeFillColor: Colors.white,
//                 inactiveColor: Color(0xff3F3D56),
//                 activeColor: Color(0xff3F3D56),
//                 selectedColor: Color(0xff3F3D56),
//                 errorBorderColor: theme.colorScheme.error,
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   otp = value;
//                 });
//               },
//             ),
//           ),

//           Center(
//             child: Text.rich(
//               TextSpan(
//                 children: [
//                   TextSpan(text: "Resend code in ",style: theme.textTheme.labelMedium?.copyWith(
//                     fontSize: 12,
//                   )),
//                   TextSpan(
//                     text: getFormattedTime(),
//                     style: TextStyle(color: theme.colorScheme.primary),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           SizedBox(height: 0),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     widget.changeNumber();
//                   },
//                   child: TextBody.mediumDark('Change Number'),
//                 ),
//                 Spacer(),
//                 if (resendDuration == 0)
//                   GestureDetector(
//                     onTap: () {
//                       widget.resendOtp();
//                       setState(() {
//                         resendDuration = 300;
//                       });
//                       startTimer();
//                     },
//                     child: Text(
//                       "Resend OTP",
//                       style: TextStyle(color: theme.colorScheme.primary),
//                     ),
//                   ),
//               ],
//             ),
//           ),

//         //   SizedBox(
//         //     width: double.infinity,
//         //     height: 51,
//         //     child: TextButton(
//         //       onPressed:
//         //           isLoading
//         //               ? null
//         //               : () async {
//         //                 if (otp.length != 4) return;

//         //                 setState(() {
//         //                   isLoading = true;
//         //                 });

//         //                 try {
//         //                   // Credentials? creds = await AuthUtils().verifyOtp(
//         //                   //   widget.phoneNumber.completeNumber,
//         //                   //   otp,
//         //                   // );

//         //                   if (creds == null) {
//         //                     logging.e("Invalid otp");
//         //                     if (context.mounted) {
//         //                       ScaffoldMessenger.of(context).showSnackBar(
//         //                         SnackBar(content: Text('Invalid OTP')),
//         //                       );
//         //                     }
//         //                   } else {
//         //                     logging.i(
//         //                       "user: ${creds.user}, refresh token: ${creds.refreshToken}",
//         //                     );
//         //                     ServerResponse user =
//         //                         await AuthUtils().checkUserSignedUp();
//         //                     logging.i(user.data);
//         //                     SharedPreferences prefs =
//         //                         await SharedPreferences.getInstance();
//         //                     prefs.setString(
//         //                       "refreshToken",
//         //                       creds.refreshToken!,
//         //                     );

//         //                     if (user.data == null) {
//         //                       if (context.mounted) {
//         //                         Navigator.pushReplacementNamed(
//         //                           context,
//         //                           "/user-register",
//         //                           arguments: UserRegistrationSchema(
//         //                             number: creds.user.name,
//         //                           ),
//         //                         );
//         //                         return;
//         //                       }
//         //                     }

//         //                     UserApi().id = user.data["id"];
//         //                     UserApi().name = user.data["name"];

//         //                     // check if user has a pet registered
//         //                     bool hasPet = await PetApi().hasPet(
//         //                       user.data["id"],
//         //                     );
//         //                     if (!hasPet) {
//         //                       if (context.mounted) {
//         //                         Navigator.pushReplacementNamed(
//         //                           context,
//         //                           "/add-pet",
//         //                           arguments: CreatePetSchema(
//         //                             userId: user.data["id"],
//         //                             firstPet: true,
//         //                           ),
//         //                         );
//         //                         return;
//         //                       }
//         //                     }

//         //                     // logged in flow
//         //                     if (context.mounted) {
//         //                       Navigator.pushReplacementNamed(context, "/home");
//         //                       return;
//         //                     }
//         //                   }
//         //                 } finally {
//         //                   if (mounted) {
//         //                     setState(() {
//         //                       isLoading = false;
//         //                     });
//         //                   }
//         //                 }
//         //               },
//         //       style: TextButton.styleFrom(
//         //         backgroundColor: theme.colorScheme.primary,
//         //         disabledBackgroundColor: theme.colorScheme.primary.withAlpha(
//         //           50,
//         //         ),
//         //       ),
//         //       child:
//         //           isLoading
//         //               ? SizedBox(
//         //                 width: 20,
//         //                 height: 20,
//         //                 child: CircularProgressIndicator(
//         //                   color: theme.colorScheme.surface,
//         //                   strokeWidth: 2,
//         //                 ),
//         //               )
//         //               : Text(
//         //                 "Continue",
//         //                 style: theme.textTheme.titleSmall!.copyWith(
//         //                   color: theme.colorScheme.surface,
//         //                 ),
//         //               ),
//         //     ),
//         //   ),
//         ],
//       ),
//     );
//   }
// }
