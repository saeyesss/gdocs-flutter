import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdocs_flutter/colors.dart';
import 'package:gdocs_flutter/repository/auth_repository.dart';
import 'package:gdocs_flutter/screens/home_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final sMessanger =
        ScaffoldMessenger.of(context); // no build contexts across async gaps
    final navigator = Navigator.of(context);
    final errorModel =
        await ref.read(authRepositoryProvider).signInWithGoogle();

    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator.push(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      sMessanger.showSnackBar(
        SnackBar(
          content: Text(errorModel.error!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          icon: Image.asset(
            'assets/images/g-logo.png',
            height: 20,
          ),
          onPressed: () => signInWithGoogle(ref, context),
          label: const Text(
            'Sign in with Google',
            style: TextStyle(color: kBlackColor),
          ),
          style: ElevatedButton.styleFrom(
              primary: kWhiteColor, minimumSize: const Size(150, 50)),
        ),
      ),
    );
  }
}
