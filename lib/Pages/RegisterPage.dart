import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mega_mall/Pages/LoginPage.dart';
import 'package:provider/provider.dart';

import '../Services/FireBaseServices.dart';
import 'HomePage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  late double _deviceHeight = MediaQuery.of(context).size.height;
  late double _deviceWidth = MediaQuery.of(context).size.width;

  final _formKey = GlobalKey<FormState>();

  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<FireBaseServices>(
          builder: (context, fireBaseServices, child) {
        return LoginBody(fireBaseServices);
      }),
    );
  }

  Widget LoginBody(FireBaseServices fireBaseServices) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Title(),
          Column(
            children: [
              UserFormField(),
              EmailFormField(),
              PassFormField(),
              SignInButton(fireBaseServices),
            ],
          ),
          OptionsButton()
        ],
      ),
    );
  }

  Widget Title() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Welcome back to Mega Mall",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text("Please sign in into your account",
            style: Theme.of(context).textTheme.bodyMedium)
      ],
    );
  }

  Widget UserFormField() {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        controller: _userController,
        decoration: InputDecoration(
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          hintText: 'Enter Your Name',
          hintStyle: Theme.of(context).textTheme.bodySmall,
          border: OutlineInputBorder(),
        ),
        style: Theme.of(context).textTheme.bodySmall,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter UserName';
          }
          final userNameRegex = RegExp(r'^[a-zA-Z][a-zA-Z0-9._]{2,19}$');
          if (!userNameRegex.hasMatch(value)) {
            return 'UserName not valide';
          }
          return null;
        },
      ),
    );
  }

  Widget EmailFormField() {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          hintText: 'Enter Your Email',
          hintStyle: Theme.of(context).textTheme.bodySmall,
          border: OutlineInputBorder(),
        ),
        style: Theme.of(context).textTheme.bodySmall,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          final emailRegex =
              RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
          if (!emailRegex.hasMatch(value)) {
            return 'Please enter a valid email';
          }
          return null; // Input is valid
        },

        // maxLines: null,
      ),
    );
  }

  Widget PassFormField() {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        obscureText: isHidden,
        controller: _passController,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                isHidden = !isHidden;
              });
            },
            child: isHidden
                ? const Icon(Icons.remove_red_eye)
                : const Icon(Icons.remove_red_eye_outlined),
          ),
          hintText: 'Enter Your Pass',
          hintStyle: Theme.of(context).textTheme.bodySmall,
          border: const OutlineInputBorder(),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your pass';
          }
          return null; // Input is valid
        },
        style: Theme.of(context).textTheme.bodySmall,
        // maxLines: null,
      ),
    );
  }

  Widget SignInButton(FireBaseServices fireBaseServices) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (_formKey.currentState!.validate()) {

              await _signUp(fireBaseServices);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: const Text(
          'Sign Up',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  Widget OptionsButton() {
    return TextButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (context) => LoginPage()), (route)=>false);
          },
          child: Text("Already Have an account ?Sign In"));
  }

  Future<void> _signUp(FireBaseServices fireBaseServices) async {
    String name = _userController.text.trim();
    String email = _emailController.text.trim();
    String password = _passController.text;

    try {
      await fireBaseServices.signUpWithEmail(name, email, password);

      if (fireBaseServices.user != null) {
        // Navigate to the home page or display a success message
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    } on FirebaseAuthException catch (e) {
      // Display error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to sign up: ${e.message}")),
      );
    }
  }

}
