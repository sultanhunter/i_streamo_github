import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_streamo_github/auth/app/cubits/cubit/authentication_cubit.dart';
import 'package:i_streamo_github/core/app/constants.dart';
import 'package:pinput/pin_put/pin_put.dart';

///
class OtpScreen extends StatefulWidget {
  ///
  final String _phone;

  ///
  const OtpScreen(this._phone);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  ///
  late final TextEditingController _otpController;
  String? _otp;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Flex(
            mainAxisSize: MainAxisSize.min,
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 55),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          "OTP Verification",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Enter the OTP you have received on your mobile number ${widget._phone}.",
                      style: const TextStyle(
                          color: Color.fromRGBO(126, 126, 126, 1),
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),

              // OtpTimer(),
              const SizedBox(
                height: (63),
              ),
              SizedBox(
                height: 50,
                child: PinPut(
                  textStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: (text) {
                    setState(() {
                      _otp = text;
                    });
                  },
                  controller: _otpController,
                  fieldsCount: 6,
                  submittedFieldDecoration: pinputDecoration,
                  selectedFieldDecoration: pinputDecoration,
                  followingFieldDecoration: pinputDecoration,
                  pinAnimationType: PinAnimationType.slide,
                  eachFieldWidth: 50,
                  animationDuration: const Duration(milliseconds: 50),
                  onSubmit: (text) {},
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              TextButton(
                  onPressed: () {
                    context
                        .read<AuthenticationCubit>()
                        .signInWithPhone(widget._phone);
                  },
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Didn’t receive the OTP? ",
                          style: TextStyle(
                              fontFamily: Platform.isIOS ? 'Poppins' : 'Gotham',
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 14)),
                      TextSpan(
                          text: "Resend it",
                          style: TextStyle(
                              fontFamily: Platform.isIOS ? 'Poppins' : 'Gotham',
                              fontWeight: FontWeight.w400,
                              color: Colors.teal,
                              fontSize: 14))
                    ]),
                  )),
              Expanded(
                child: Container(),
              ),
              // ignore: deprecated_member_use
              SizedBox(
                height: (52),
                child: MaterialButton(
                  disabledColor: Colors.grey,
                  onPressed: _otp == null
                      ? null
                      : _otp!.length < 6
                          ? null
                          : () {
                              context
                                  .read<AuthenticationCubit>()
                                  .verifyOtpfromTheProfessional(
                                      otp: _otpController.text);
                            },
                  shape: roundedRectangleBorder,
                  color: Colors.teal,
                  child: const Text(
                    "Verify",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
