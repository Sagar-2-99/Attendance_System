import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:automated_attdance_system/providers/url_providers.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';

class UpdateAttendanceScreen extends ConsumerStatefulWidget {

  const UpdateAttendanceScreen({super.key, required this.attendanceDetails});
    final dynamic attendanceDetails;


  @override
  ConsumerState<UpdateAttendanceScreen> createState() {
    return _UpdateAttendanceScreenState();    
  }

}

class _UpdateAttendanceScreenState extends ConsumerState<UpdateAttendanceScreen> {

  bool _loading = false;

  Map<String, bool> studentAttendance = {

  };
  Map<String, dynamic> studentDetails = {

  };

  List<dynamic> rollNumberList = [];



  @override
  void initState() {
    print("[*] ==== Load Attendance ==== ");
    _loadAttendance(ref);
    print("*************************************************");
    print(widget.attendanceDetails['present_list']);
    print("******************************************************8");
  }

  void _loadAttendance(WidgetRef ref) async {
    _loading = true;
    final baseUrl = ref.read(baseUrlProvider);
    Uri url = Uri.http(baseUrl, "get_student_list");
    final response = await https.post(url, body: json.encode({
      "username": widget.attendanceDetails["username"],
      "course_code": widget.attendanceDetails["course_code"]
    }), headers: {
      'Content-Type': "application/json"
    });
    final responseBody = json.decode(response.body);
    final studentList = responseBody['data'];
    print(studentList);
    for(final student in studentList['student_list']) {
      if(widget.attendanceDetails['present_list'].contains(student['roll_number'])) {
        studentAttendance[student['roll_number']] = true;
      } else {
        studentAttendance[student['roll_number']] = false;
      }
      studentDetails[student['roll_number']] = student['full_name'];
      rollNumberList.add(student['roll_number']);
    }
    setState(() {
      _loading = false;
    });
  }

  void _upateAttendance(WidgetRef ref) async {

    final presentStudentList = [];
    for(final rollNumber in rollNumberList) {
      if(studentAttendance[rollNumber]!) {
        presentStudentList.add(rollNumber);
      }
    }
    print("============= present roll number =================");

    final baseUrl = ref.read(baseUrlProvider);
    Uri url = Uri.http(baseUrl, "update_attendance");
    Map<String, dynamic> reqBody = {
      "username": widget.attendanceDetails['username'],
      "course_code": widget.attendanceDetails['course_code'],
      'date': widget.attendanceDetails['date'],
      'present_list': presentStudentList
    };
    final response = await https.post(
      url,
      body: json.encode(reqBody),
      headers: {
        'Content-Type': 'application/json'
      }
    );
    final resBody = json.decode(response.body);
    if(resBody['status_code'] == 200) {
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
                  "Attedance Update",
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
        Navigator.of(context).pop();
    } else {
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
                  "Some error occured!!!",
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
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: rollNumberList.length,
      itemBuilder: (ctx, index) {
        return CheckboxListTile(
          value: studentAttendance[rollNumberList[index]],
          onChanged: (check) {
            setState(() {
              studentAttendance[rollNumberList[index]] = check!;
            });
          },
          activeColor: Theme.of(context).colorScheme.tertiary,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(studentDetails[rollNumberList[index]]),
              Text(rollNumberList[index])
            ],
          ),
        );
      },
    );

    if(_loading) {
      content = const CircularProgressIndicator();
    }


    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.attendanceDetails['course_code'].toString().toUpperCase()),
            Text(
              widget.attendanceDetails['date'],
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground
              ),
              )
          ],
        ),
      ),
      floatingActionButton: _loading ? content : ElevatedButton.icon(onPressed: () {
        _upateAttendance(ref);
      }, icon:  const Icon(Icons.update), label: const Text("update")),
      body: content,
    );
  }

}