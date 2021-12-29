import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_streamo_github/auth/app/cubits/cubit/authentication_cubit.dart';
import 'package:i_streamo_github/auth/infrastructure/firebase_authenticator.dart';
import 'package:i_streamo_github/core/presentation/splash_page.dart';
import 'package:i_streamo_github/repos/app/cubit/github_repos_cubit.dart';
import 'package:i_streamo_github/repos/infrastructure/github_repository.dart';
import 'package:i_streamo_github/repos/infrastructure/sembast_database.dart';
import 'package:i_streamo_github/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((_) {
    SembastDatabase.init().then((_) {
      runApp(const MyApp());
    });
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthenticationCubit(FirebaseAuthenticator(FirebaseAuth.instance)),
        ),
        BlocProvider(
          create: (context) => GithubReposCubit(GithubRepository()),
        )
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: () => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            onGenerateRoute: CustomRouter().generateRoute,
            home: const SplashPage()),
      ),
    );
  }
}
