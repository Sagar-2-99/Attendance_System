import 'package:flutter/material.dart';
import 'package:automated_attdance_system/screens/signup_screen.dart';
import 'package:automated_attdance_system/screens/home_screen.dart';
import 'package:automated_attdance_system/screens/change_base_url.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:automated_attdance_system/providers/url_providers.dart';
import 'dart:convert';
import 'package:http/http.dart' as https;

class SigninScreen extends ConsumerStatefulWidget {
  const SigninScreen({super.key});

  @override
  ConsumerState<SigninScreen> createState() {
    return _SiginScreenState();
  }
}

class _SiginScreenState extends ConsumerState<SigninScreen> {
  var _usrName;
  var _userPasswd;

  final _loginFormKey = GlobalKey<FormState>();

  void _submitLogin() async {
    if(_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();
      final baseUrl = ref.read(baseUrlProvider);
      print(baseUrl);
      Map<String, String> userDetails = {
        'username': _usrName,
        'password': _userPasswd
      };
      final url = Uri.http(baseUrl, "login");
      final response = await https.post(url, body: json.encode(userDetails));
      print(response.statusCode);
      Map<String, dynamic> resBody = json.decode(response.body);
      print(resBody);
      if(resBody['status_code'] != 200) {
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(
                "Alert",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground
              ),
                ),
              content: SingleChildScrollView(
                child: Text(
                  resBody['message'],
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground
                  ),
                  ),
              ),
              actions: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                }, child: const Text("ok"))
              ],
            );
          }
        );
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
          return HomeScreen(mp : resBody['data']);
      }));
      }
    }
  }

  void _selectSignupOption() async {
    print("**********************");
    final Map<String, dynamic>? res = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => SignupScreen()
      )
    );
    if(res == null) {
      return;
    }
    if(res['account_created']) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
        return HomeScreen(mp : res);
      }));
    }
  }

  void _setBaseUrl() {
    Navigator.of(context).push(MaterialPageRoute(builder: (cxt) => const ChangeBaseURLScreen()));
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance System"),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text("Sign up"),
            onPressed: _selectSignupOption,
          ),
          IconButton(
            onPressed: _setBaseUrl, 
            icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.primary,)
          )
        ],
      ),
      body:  SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
          decoration: BoxDecoration(
            // border: Border.all(width: 1, color: Theme.of(context).colorScheme.primary),
            // borderRadius: const BorderRadius.all(
              // Radius.circular(1)
            // )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Log In",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 20
                ),  
              ),
              SizedBox(height: 20,),
              Form(
                key: _loginFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.account_circle_sharp, color: Theme.of(context).colorScheme.primary),
                        label: const Text("user name"),
                      ),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground
                      ),
                      onSaved: (value) {
                        _usrName = value;
                      },
                      validator: (value) {
                        if(value == null || value.trim().isEmpty || value.trim().length > 50) {
                          return "Enter valid username";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20,),
                    TextFormField(
                      obscureText: true,
                      decoration:  InputDecoration(
                        icon: Icon(Icons.key_sharp, color: Theme.of(context).colorScheme.primary),
                        label: const Text("password")
                      ),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground
                      ),
                      onSaved: (value) {
                        _userPasswd = value;
                      },
                      validator: (value) {
                        if(value == null || value.trim().isEmpty || value.trim().length > 50) {
                          return "Enter valid username";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16,),
                    Center(
                      child: TextButton.icon(
                        onPressed: _submitLogin, 
                        icon: const Icon(Icons.amp_stories_rounded), label: const Text("Log in"))
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Create a new Account", style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground
                  ),),
                  TextButton(onPressed: _selectSignupOption, 
                  child: const Text("Sign up"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}