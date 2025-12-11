import 'package:app_auth/features/auth/data/presentation/components/loading.dart';
import 'package:app_auth/features/auth/data/presentation/cubits/auth_cubit.dart';
import 'package:app_auth/features/auth/data/presentation/cubits/auth_states.dart';
import 'package:app_auth/features/auth/data/presentation/cubits/pages/auth_page.dart';

import 'package:app_auth/features/auth/data/firebase_auth_repo.dart';
import 'package:app_auth/features/home/presentation/pages/home_page.dart';
import 'package:app_auth/firebase_options.dart';
import 'package:app_auth/themes/dark_mode.dart';
import 'package:app_auth/themes/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  //auth repo
  final firebaseAuthRepo = FirebaseAuthRepo();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      //provide cubit to app
      providers: [
        //authh cubit
        BlocProvider<AuthCubit>(
          create: (context) =>
              AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),
      ],

      //app
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        darkTheme: darkMode,

        //Block Consumer
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, state) {
            print(state);

            //unauthenticated -> auth page (login/register)
            if (state is Unauthenticated) {
              return const AuthPage();
            }

            //authenticated
            if (state is Authenticated) {
              return const HomePage();
            }
            //loading..
            else {
              return const LoadingScreen();
          }
          },

          //Listen for state changes
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ),
    );
  }
}
