import 'package:flutter/material.dart';
import 'package:mega_mall/Services/FireBaseServices.dart';
import 'package:provider/provider.dart';

import 'HomePage.dart';
import 'RegisterPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          focusedErrorBorder: OutlineInputBorder(
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
      margin: EdgeInsets.all(5),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (_formKey.currentState!.validate()) {
              String email = _emailController.text.trim();
              String pass = _passController.text.trim();
              await _signIn(email, pass, fireBaseServices);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: Text(
          'Sign In',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  Widget OptionsButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        TextButton(onPressed: () {}, child: Text("Forgot Password ?")),
        TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) => RegisterPage()), (route) => false,);
            },
            child: Text("Sign Up")),
      ],
    );
  }

  Future<void> _signIn(
      String email, String pass, FireBaseServices fireBaseServices) async {
    try {
      if (await fireBaseServices.signIn(email, pass)) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'incorrect email or password',
            style: TextStyle(color: Colors.white),
          )),
        );
      }
    } catch (e) {
      // Show error message to the user, you might want to use a SnackBar or Dialog here
      print("Sign In Failed: $e");
    }
  }
}
