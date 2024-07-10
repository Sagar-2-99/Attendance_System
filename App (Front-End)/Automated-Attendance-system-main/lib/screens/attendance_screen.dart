import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:automated_attdance_system/providers/url_providers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:automated_attdance_system/widgets/multiple_image_input.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

final formatter = DateFormat.yMd();

class AttendanceScreen extends ConsumerStatefulWidget {

  const AttendanceScreen({super.key, required this.courseDetails});
  final dynamic courseDetails;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AttendaneScreenState();
  }

}

class _AttendaneScreenState extends ConsumerState<AttendanceScreen> {

  DateTime? _selectedDate;
  final  _courseCodeController = new TextEditingController();
  List<XFile>? _selectedImages;

  @override
  void initState() {
    super.initState();
    _courseCodeController.text = widget.courseDetails['course_code'];
  }
  final todayDate = DateTime.now();
  final firstDate = DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);

  void _presentDatePicker() async {
    _selectedDate = await showDatePicker(context: context, firstDate: firstDate, lastDate: todayDate, initialDate: todayDate);
    setState(() {
      
    });
    print(_selectedDate);
    print(formatter.format);
  }

  void _onPickImages(image_list) {
    _selectedImages = image_list;
  }

  void _registerAttendence(WidgetRef ref) async {
    if(_selectedDate == null || _selectedImages == null) {
        await showDialog(context: context, builder: (ctx) {
          return AlertDialog(
            title: Text(
              "Aert",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground
              ),              
              ),
            content: SingleChildScrollView(
              child: Text(
                "Please fill all the fields",
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
      final baseUrl = ref.read(baseUrlProvider);

      var request = http.MultipartRequest("POST", Uri.parse("http://$baseUrl/register_attendance"));
      for(var i = 0; i < _selectedImages!.length; i++) {
        request.files.add(http.MultipartFile.fromBytes("picture$i", File(_selectedImages![i].path).readAsBytesSync(),filename: _selectedImages![i].path));
      }
      request.fields['course_code'] = widget.courseDetails['course_code'];
      request.fields['username'] = widget.courseDetails['username'];
      request.fields['number_of_picture'] = _selectedImages!.length.toString();
      request.fields['date'] = formatter.format(_selectedDate!);
      final res = await request.send();
      var response = await http.Response.fromStream(res);
      final Map<String, dynamic> resBody = json.decode(response.body);
      if(resBody['status_code'] != 200) {
        await showDialog(context: context, builder: (ctx) {
          return AlertDialog(
            title: Text(
              "Failed",
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
        final flag = await showDialog(context: context, builder: (ctx) {
          return AlertDialog(
            title: Text(
              "Attendance Registered",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground
              ),
              ),
            content: SingleChildScrollView(
              child: Text(
                "Attendance Registered Successfully",
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
      Navigator.of(context).pop({});
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Take Attendance - ${widget.courseDetails['course_code']}"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Text(
                "Attendance Form",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      label: Text(
                        "Course Coude",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground
                        )
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground
                    ),
                    controller: _courseCodeController,
                  )
                ),
                SizedBox(width: 10,),
                _selectedDate == null ? Text(
                  "select date", 
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground
                  ),
                  ) : Text(
                    formatter.format(_selectedDate!),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground
                    ),
                  ),
                SizedBox(width: 10,),
                IconButton(onPressed: _presentDatePicker, icon: Icon(Icons.calendar_month, color: Theme.of(context).colorScheme.onBackground,))
              ],
            ),
            const SizedBox(height: 16,),
            MultipleImageInput(onPickedImage: _onPickImages),
            const SizedBox(height: 16,),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _registerAttendence(ref);
                },
                child: const Text("Add Attendence"),
              ),
            )
          ],
        ),
      ),
    );
  }

}