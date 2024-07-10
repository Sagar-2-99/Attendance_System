import 'package:automated_attdance_system/providers/url_providers.dart';
import 'package:automated_attdance_system/widgets/image_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
// import 'package:intl/intl.dart';

// final formatter = DateFormat.yMd();


class NewStudentRegister extends ConsumerStatefulWidget { 

  const NewStudentRegister({super.key, required this.courseDetails});
  final dynamic courseDetails;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _NewStudentRegsiterState();
  }

}

class _NewStudentRegsiterState extends ConsumerState<NewStudentRegister> {


  final _courseCodeController = TextEditingController();
  final _rollNumberController = TextEditingController();
  final _fullNameController = TextEditingController();
  File? _studentImage;
  // DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // _courseCodeController = TextEditingController(text : widget.courseDetails['course_code']);
    _courseCodeController.text = widget.courseDetails['course_code'];
  }

  void _registerStudent(WidgetRef ref) async {
    final baseUrl = ref.read(baseUrlProvider);
    // Uri url = Uri.http(baseUrl, "register_student");
    var request = http.MultipartRequest("POST", Uri.parse("http://$baseUrl/register_student"));
    request.files.add(http.MultipartFile.fromBytes("picture", File(_studentImage!.path).readAsBytesSync(),filename: _studentImage!.path));
    request.fields['course_code'] = _courseCodeController.text;
    request.fields['roll_number'] = _rollNumberController.text;
    request.fields['full_name'] = _fullNameController.text;
    request.fields['username'] = widget.courseDetails['username'];
    final res = await request.send();
    var response = await http.Response.fromStream(res);
    final Map<String, dynamic> resBody = jsonDecode(response.body);
    if(resBody['status_code'] != 200) {
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
                resBody['message'],
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
      await showDialog(
        context: context, builder: (ctx) {
          return AlertDialog(
            title: Text(
              "Student Registered",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground
              ),
              ),
            content: SingleChildScrollView(
              child: Text(
                "Student Registered Successfully",
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
      Navigator.of(context).pop();
    }

  }

  // final todayDate = DateTime.now();
  // final firstDate = DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);


  // void _presentDatePicker() async {
  //   _selectedDate = await showDatePicker(context: context, firstDate: firstDate, lastDate: todayDate, initialDate: todayDate);
  //   print(_selectedDate);
  //   print(formatter.format);
  // }
  



  // void _registerStudent(WidgetRef ref) async {

  // }

  void _onSelectImage(img) {
    _studentImage = img;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Student"),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      label: Text("Course Code")
                    ),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground
                    ),
                    controller: _courseCodeController,
                  ),
                ),
                const SizedBox(width: 12,),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      label: Text("Roll no"),
                    ),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground
                    ),
                    controller: _rollNumberController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16,),
            TextField(
                decoration: const InputDecoration(
                  label: Text("Full name")
                ),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground
                ),
                controller: _fullNameController,
              ),
            const SizedBox(height: 16,),
            ImageInput(onPickedImage: (img) {
              _onSelectImage(img);
            }),
            const SizedBox(height: 16,),
            Center(
              child: ElevatedButton(
                child: const Text("Register"),
                onPressed: () {
                  _registerStudent(ref);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

}