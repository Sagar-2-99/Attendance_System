import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:automated_attdance_system/providers/url_providers.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';


class CourseRegisterScreen extends ConsumerStatefulWidget {

  const CourseRegisterScreen({super.key, required this.userDetails});

  final Map<String, dynamic> userDetails;

  @override
  ConsumerState<CourseRegisterScreen> createState() {
    return _CourseRegisterScreenState();
  }
}

class _CourseRegisterScreenState extends ConsumerState<CourseRegisterScreen> {

  final _courseRegisterFormKey = GlobalKey<FormState>();

  var _courseName;
  var _courseCode;
  var _department;
  var _courseStrength;


  void _registerNewCourse(WidgetRef ref) async {
    if(_courseRegisterFormKey.currentState!.validate()) {


      final baseUrl = ref.read(baseUrlProvider);
      print(baseUrl);

      _courseRegisterFormKey.currentState!.save();
      print(_courseName);
      print(_courseCode);
      print(_department);
      print(_courseStrength);
      Map<String, String> courseDetails = {
        'course_name': _courseName,
        'course_code': _courseCode,
        'department': _department,
        'course_strength' : _courseStrength,
        'username': widget.userDetails['username']
      };
      print(courseDetails);
      final url = Uri.http(baseUrl, 'regiter_course');
      final response = await https.post(url, body: json.encode(courseDetails), headers: {
        'Content-Type': 'application/json'
      });
      print(response.statusCode);
      final Map<String, dynamic> res = json.decode(response.body);
      if(res['status_code'] != 200) {
        await showDialog(context: context, builder: (ctx) {
          return AlertDialog(
            title: Text(
              "Registration Failed",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground
              ),              
              ),
            content: SingleChildScrollView(
              child: Text(
                res['message'],
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground
              ),
                ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(onPressed: () {
                    Navigator.of(context).pop();
                  }, child: const Text("Ok"))
                ],
              )
            ],
          );
        });
      } else {
        final flag = await showDialog(context: context, builder: (ctx) {
          return AlertDialog(
            title: Text(
              "Course Registered",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground
              ),
              ),
            content: SingleChildScrollView(
              child: Text(
                "Course Registered Successfully",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground
              ),
                ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(onPressed: () {
                    Navigator.of(context).pop();
                  }, child: const Text("Ok"))
                ],
              )
            ],
          );
        }
      );
      _courseRegisterFormKey.currentState!.reset();
      Navigator.of(context).pop({
        'course_name': _courseName,
        'course_code': _courseCode,
        'department': _department,
        'course_strength' : _courseStrength,
        'username': widget.userDetails['username']
      });
    }
  }
  }
  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Course Register",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground
          ),         
          ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 70),
        child: Form(
          key: _courseRegisterFormKey,
          child: Column(
            children: [
              Center(
                child: Text(
                  "Register Course",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 20
                ),  
                
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("course name"),
                ),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground
                ),
                validator: (value) {
                  if(value == null || value.trim().isEmpty) {
                    return "Enter valid course name";
                  }
                  return null;
                },
                onSaved: (value) {
                  _courseName = value!;
                },
              ),
              const SizedBox(height: 12,),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("course code")
                ),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground
                ),
                validator: (value) {
                  if(value == null || value.trim().isEmpty) {
                    return "Enter valid course code";
                  }
                  return null;
                },   
                onSaved: (value) {
                  _courseCode = value!;
                },         
              ),
              const SizedBox(height: 12,),
              DropdownButtonFormField(
                items: [
                  DropdownMenuItem(
                    value: "CSE",
                    child: Text(
                      "CSE",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground
                    ),                    ),
                  ),
                  DropdownMenuItem(
                    value: "ECE",
                    child: Text(
                      "ECE",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground
                    ),                    ),
                  ),
                ],
                decoration: const InputDecoration(
                  label: Text("department")
                ),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground
                ),  
                onChanged: (value) {
      
                },   
                validator: (value) {
                  if(value == null) {
                    return "select valid department";
                  }
                  return null;
                }, 
                onSaved: (value) {
                  _department = value!;
                },        
              ),
              const SizedBox(height: 12,),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  label: Text("strength"),
                ),
                items: [
                DropdownMenuItem(
                  value: "Low",
                  child: Text(
                    "Low",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground
                    ),  
                  ),
                ),
                DropdownMenuItem(
                  value: "Medium",
                  child: Text(
                    "Medium",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground
                    ),  
                  ),
                ),
                DropdownMenuItem(
                  value: "High",
                  child: Text(
                    "High",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground
                    ),  
                  ),
                ),
              ], onChanged: (value) {

              },
              validator: (value) {
                if(value == null) {
                  return "Select valid strength";
                }
                return null;
              },
              onSaved: (value) {
                _courseStrength = value;
              },
              ),
              const SizedBox(height: 16,),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _registerNewCourse(ref);
                  },
                  child: const Text("Register Course"),
                ),
              )
            ],

          ),
        ),
      ),
    );
  }
}

