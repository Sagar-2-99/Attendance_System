import 'package:flutter/material.dart';
import 'package:automated_attdance_system/models/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:automated_attdance_system/providers/url_providers.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';

class SignupScreen extends ConsumerStatefulWidget {

  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() {
    return _SignupScreenState();
  }
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  
  final _signupFormKey = GlobalKey<FormState>();

  var _usrName; 
  var _usrPswd;
  var _usrEmail;
  var _enteredRole;
  var _fullname;

  void _getBackLoginPaget() {
    Navigator.of(context).pop({
      'account_created': false
    });
  }

  void _submitSignupForm() async {
    if(_signupFormKey.currentState!.validate()) {
      _signupFormKey.currentState!.save();
      Map<String, String> usrDetails = {
        "username": _usrName,
        "password": _usrPswd,
        "role": _enteredRole,
        "fullname": _fullname,
        'email': _usrEmail
      };
      final baseUrl = ref.read(baseUrlProvider);
      final uri = Uri.http(baseUrl, "register");
      final response = await https.post(uri, body: json.encode(usrDetails));
      final Map<String, dynamic> resBody  = json.decode(response.body);
      print(resBody['status_code']);
      if(resBody['status_code'] != 200) {
        await showDialog(
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
        print(resBody['data']);
        resBody['data']['account_created'] = true;
        Navigator.of(context).pop(resBody['data']);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    print("==================== signup screen ===== build ==============");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up"),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.person),
            onPressed: _getBackLoginPaget,
            label: const Text("Log In"),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 70),
          child: Form(
            key: _signupFormKey,
            child: Column(
              children: [
                Text(
                  "Sign up",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 20
                  ),  
                ),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.person, color: Theme.of(context).colorScheme.primary,),
                    label: const Text("full name")
                  ),
                  validator: (value) {
                    if(value == null || value.trim().isEmpty) {
                      return "Enter valid name";
                    }
                    return null;
                  },
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground
                  ),
                  onSaved: (value) {
                    _fullname = value!;
                  },
                ),
                const SizedBox(height: 12,),
        
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.star, color: Theme.of(context).colorScheme.primary,),
                    label: const Text("username")
                  ),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground
                  ),
                  validator: (value) {
                    if(value == null || value.trim().isEmpty) {
                      return "Enter value username";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _usrName = value!;
                  },
                ),
                const SizedBox(height: 12,),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: Icon(Icons.key, color : Theme.of(context).colorScheme.primary),
                    label: const Text("password")
                  ),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground
                  ),
                  validator: (value) {
                    if(value == null || value.trim().isEmpty) {
                      return "password can not be empty";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _usrPswd = value!;
                  },
                ),
                const SizedBox(height: 12,),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.email, color: Theme.of(context).colorScheme.primary,),
                    label: const Text("email")
                  ),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground
                  ),
                  validator: (value) {
                    if(value == null || value.trim().isEmpty) {
                      return "password can not be empty";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _usrEmail = value!;
                  },
                ),
                const SizedBox(height: 12,),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.rocket, color: Theme.of(context).colorScheme.primary,),
                    label: const Text("role")
                  ),
                  items: 
                  Roles.values.map((role) {
                    return DropdownMenuItem(
                      value: role.name,
                      child: Text(
                        role.name,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground
                        ),
                        ),
                    );
                  }).toList()
                , 
                validator: (value) {
                  if(value == null || value == '') {
                    return "Select a role";
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredRole = value;
                }, 
                onChanged: (value) {
                  _enteredRole = value;
                },
                ),
                const SizedBox(height: 12,),
                Center(
                  child: ElevatedButton(
                    child: const Text("sign up"),
                    onPressed: _submitSignupForm,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}