import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_streamo_github/auth/app/cubits/cubit/authentication_cubit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationSuccess) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home', (route) => false);
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/authentication',
            (route) => false,
          );
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                MdiIcons.github,
                size: 150,
              ),
              SizedBox(
                height: 16.0,
              ),
              LinearProgressIndicator(
                color: Colors.teal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
