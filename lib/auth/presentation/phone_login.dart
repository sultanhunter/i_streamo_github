import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_streamo_github/auth/app/cubits/cubit/authentication_cubit.dart';
import 'package:i_streamo_github/auth/app/phone_number_formatter.dart';

///
class PhoneLogin extends StatefulWidget {
  ///
  const PhoneLogin({Key? key}) : super(key: key);

  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  late final TextEditingController _countryMobileCodeController;
  late final TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _countryMobileCodeController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _countryMobileCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationSuccess) {
          print('authenticated');
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home', (route) => false);
        } else if (state is AuthenticationOtpSending) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Sending Otp')));
        } else if (state is AuthenticationOtpSent) {
          Navigator.of(context)
              .pushNamed('/otp', arguments: _phoneNumberController.text);
        } else if (state is AuthenticationVerifyingOtp) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Verifyin Otp')));
        } else if (state is AuthenticationError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.errorMessage ??
                  'Some Error Occured, Please Try again')));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 55),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Welcome to iStreamo",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Gotham',
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold),
                      ), //changing this back to default Text Widget because the word Housy was not being rendered
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Enter your mobile number.",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: (65)),
                Container(
                    margin: const EdgeInsets.only(left: 5, bottom: 10),
                    child: const Text(
                      "Mobile Number",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.1)),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          autofocus: true,
                          controller: _phoneNumberController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(12),
                            PhoneNumberFormatter(),
                          ],
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            hintText: "987-678-XXXX",
                            hintStyle: TextStyle(
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade700,
                                fontSize: 16),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                SizedBox(
                  height: (52),
                  child: MaterialButton(
                    onPressed: () {
                      const _countryCode = '+91';
                      final completePhone =
                          '$_countryCode-${_phoneNumberController.text}';
                      context
                          .read<AuthenticationCubit>()
                          .signInWithPhone(completePhone);
                    },
                    color: Colors.teal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      "Send OTP",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
