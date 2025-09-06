import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safeher/api/user_api.dart';
// import 'package:safeher/schemas/user_schema.dart';
import 'package:safeher/utils/auth_utils.dart';
import 'package:safeher/utils/logging_utils.dart';
import 'package:safeher/widgets/text_body.dart';
import 'package:safeher/widgets/title_text.dart';
import 'dart:async';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  final List<OnboardingItem> onboardingItems = [
    OnboardingItem(
      title: 'Welcome',
      description:
          'Your personal safety companion that helps you stay protected 24/7',
      image: 'images/safegirl.png',
      backgroundColor: Colors.white,
    ),
    OnboardingItem(
      title: 'Danger Zone Alert',
      description:
          'Get instant notifications about unsafe areas and avoid potential risks',
      image: 'images/dangerzone.png',
      backgroundColor: Colors.white,
    ),
    OnboardingItem(
      title: 'SOS Alert',
      description: 'Quick access to emergency contacts with just one tap',
      image: 'images/alert.png',
      backgroundColor: Colors.white,
    ),
    OnboardingItem(
      title: 'Location Sharing',
      description: 'Share your real-time location with trusted contacts',
      image: 'images/locationsharing.png',
      backgroundColor: Colors.white,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                isLastPage = index == onboardingItems.length - 1;
              });
            },
            itemCount: onboardingItems.length,
            itemBuilder: (context, index) {
              return OnboardingPage(item: onboardingItems[index]);
            },
          ),
          Container(
  margin: const EdgeInsets.only(bottom: 60), // pushes it up 10px from bottom
  alignment: Alignment.bottomCenter,  
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    _controller.jumpToPage(onboardingItems.length - 1);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 252, 166, 175),
                  ),
                  child: const Text('Skip'),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: onboardingItems.length,
                  effect: const WormEffect(
                    spacing: 16,
                    dotColor: Colors.black26,
                    activeDotColor: Colors.pink,
                  ),
                ),
                TextButton(
                  onPressed:
                      isLastPage
                          ? () {
                            if (context.mounted) {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return ModalBottomSheet();
                                },
                              );
                            }
                          }
                          : () {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16), // size of the button
                    backgroundColor:
                        theme.colorScheme.primary, // <-- theme primary color
                  ),
                  child: Icon(
                    isLastPage ? Icons.check : Icons.arrow_forward,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final String image;
  final Color backgroundColor;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
    required this.backgroundColor,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: item.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(item.image, height: 300),
            const SizedBox(height: 30),
            TextTitle.primary(item.title),
            const SizedBox(height: 20),
            TextBody.description(
              item.description,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ModalBottomSheet extends StatefulWidget {
  const ModalBottomSheet({super.key});

  @override
  State<ModalBottomSheet> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  int screen = 0;
  late PhoneNumber phoneNumber;

  void submitNumber(PhoneNumber ph) {
    setState(() {
      phoneNumber = ph;
      screen = 1;
    });
  }

  void changeNumber() {
    setState(() {
      screen = 0;
    });
  }

  Future resendOtp() async {
    await AuthUtils().sendOtp(phoneNumber.completeNumber);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 80.0,
        left: 30.0,
        right: 30.0,
        top: 15.0,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
                child: Divider(
                  color: theme.colorScheme.secondary,
                  thickness: 2,
                ),
              ),
            ),

            if (screen == 0) ModalBottomSheetInput(submitNumber: submitNumber),
            if (screen == 1)
              ModalBottomSheetVerifyOtp(
                phoneNumber: phoneNumber,
                changeNumber: changeNumber,
                resendOtp: resendOtp,
              ),
          ],
        ),
      ),
    );
  }
}

class ModalBottomSheetInput extends StatefulWidget {
  final Function submitNumber;
  const ModalBottomSheetInput({super.key, required this.submitNumber});

  @override
  State<ModalBottomSheetInput> createState() => _ModalBottomSheetInputState();
}

class _ModalBottomSheetInputState extends State<ModalBottomSheetInput> {
  late PhoneNumber phoneNumber;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        TextTitle.primary("Let's get started"),

        IntlPhoneField(
          showCountryFlag: false,
          dropdownIconPosition: IconPosition.trailing,
          dropdownIcon: Icon(Icons.keyboard_arrow_down, size: 12),
          flagsButtonPadding: EdgeInsets.symmetric(horizontal: 6),
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSecondary,
            ),
            hintText: 'Enter Mobile Number',
            border: OutlineInputBorder(
              borderSide: BorderSide(),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          initialCountryCode: 'IN',
          onChanged: (ph) {
            setState(() {
              phoneNumber = ph;
            });
          },
        ),

        SizedBox(
          width: double.infinity,
          height: 51,
          child: TextButton(
            onPressed: () {
              try {
                if (phoneNumber.isValidNumber()) {
                  logging.i("Valid number found");
                  AuthUtils().sendOtp(phoneNumber.completeNumber);
                  widget.submitNumber(phoneNumber);
                }
              } catch (e) {
                logging.e(e);
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
            ),
            child: TextTitle.small(
              "Continue",
              color: theme.colorScheme.surface,
            ),
          ),
        ),
      ],
    );
  }
}

class ModalBottomSheetVerifyOtp extends StatefulWidget {
  final PhoneNumber phoneNumber;
  final Function changeNumber;
  final Function resendOtp;
  const ModalBottomSheetVerifyOtp({
    super.key,
    required this.phoneNumber,
    required this.changeNumber,
    required this.resendOtp,
  });

  @override
  State<ModalBottomSheetVerifyOtp> createState() =>
      _ModalBottomSheetVerifyOtpState();
}

class _ModalBottomSheetVerifyOtpState extends State<ModalBottomSheetVerifyOtp> {
  int resendDuration = 60;
  String otp = "";
  bool isLoading = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendDuration > 0) {
        setState(() {
          resendDuration--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String getFormattedTime() {
    int minutes = resendDuration ~/ 60;
    int seconds = resendDuration % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          TextTitle.medium(
            "Enter OTP",
            color: theme.colorScheme.primary,
          ),

          Column(
            children: [
              Center(
                child: TextBody.medium(
                  "We have sent a 4 digit OTP on",
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 4),
              Center(
                child: TextBody.medium(
                  widget.phoneNumber.number,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: PinCodeTextField(
              appContext: context,
              length: 4,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 50,
                fieldWidth: 50,
                activeFillColor: Colors.white,
                inactiveColor: Color(0xff3F3D56),
                activeColor: Color(0xff3F3D56),
                selectedColor: Color(0xff3F3D56),
                errorBorderColor: theme.colorScheme.error,
              ),
              onChanged: (value) {
                setState(() {
                  otp = value;
                });
              },
            ),
          ),

          Center(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Resend code in ",
                    style: theme.textTheme.labelMedium?.copyWith(fontSize: 12),
                  ),
                  TextSpan(
                    text: getFormattedTime(),
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    widget.changeNumber();
                  },
                  child: TextBody.mediumDark('Change Number'),
                ),
                Spacer(),
                if (resendDuration == 0)
                  GestureDetector(
                    onTap: () {
                      widget.resendOtp();
                      setState(() {
                        resendDuration = 300;
                      });
                      startTimer();
                    },
                    child: Text(
                      "Resend OTP",
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(
            width: double.infinity,
            height: 51,
            child: TextButton(
              onPressed:
                  isLoading
                      ? null
                      : () async {
                        if (otp.length != 4) return;

                        setState(() {
                          isLoading = true;
                        });

                        try {
                          UserSession? session = await AuthUtils().verifyOtp(
                            widget.phoneNumber.completeNumber,
                            otp,
                          );

                          if (session == null) {
                            logging.e("Invalid otp");
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Invalid OTP')),
                              );
                            }
                          } else {
                            logging.i("JWT: ${session.token}");

                            // store tokens
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString("authToken", session.token);
                            if (session.refreshToken != null) {
                              prefs.setString(
                                "refreshToken",
                                session.refreshToken!,
                              );
                            }

                            // instead of calling checkUserSignedUp here,
                            // use cached user info (from OTP response) if available
                            // if (session.userId == null) {
                            //   // user not onboarded → go to register page
                            //   if (context.mounted) {
                            //     Navigator.pushReplacementNamed(
                            //       context,
                            //       "/user-register",
                            //       arguments: UserRegistrationSchema(
                            //         number: widget.phoneNumber.completeNumber,
                            //       ),
                            //     );
                            //   }
                            //   return;
                            // }

                            // cache user globally
                            // UserApi().id = session.userId;
                            UserApi().id = 1;
                            UserApi().name = session.name ?? "User";

                            // logged in flow
                            if (context.mounted) {
                              Navigator.pushReplacementNamed(context, "/home");
                            }
                          }
                        } finally {
                          if (mounted) {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      },
              style: TextButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                disabledBackgroundColor: theme.colorScheme.primary.withAlpha(
                  50,
                ),
              ),
              child:
                  isLoading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : TextTitle.small(
                        "Continue",
                        color: theme.colorScheme.surface,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
