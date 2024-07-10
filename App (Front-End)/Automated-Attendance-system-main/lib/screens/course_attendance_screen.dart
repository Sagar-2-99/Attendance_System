import 'package:automated_attdance_system/providers/url_providers.dart';
import 'package:automated_attdance_system/screens/new_student_regiter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:automated_attdance_system/screens/attendance_screen.dart';
import 'package:automated_attdance_system/screens/present_screen.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';

class CourseAttendenceScreen extends ConsumerStatefulWidget {
  const CourseAttendenceScreen({super.key, required this.courseDetails});
  final dynamic courseDetails;


  @override 
  ConsumerState<CourseAttendenceScreen> createState() {
    return _CourseAttendenceScreenState();
  }

}

class _CourseAttendenceScreenState extends ConsumerState<CourseAttendenceScreen> {

  List<dynamic> _attendanceDataList = [];

  @override
  void initState() {
    super.initState();
    _loadAttendance(ref);
  }

  _loadAttendance(WidgetRef ref) async {
    final baseUrl = ref.read(baseUrlProvider);
    Uri url = Uri.http(baseUrl, "get_attendance");
    print(baseUrl);
    Map<String, String> query = {
      'course_code': widget.courseDetails['course_code'],
      'username': widget.courseDetails['username']
    };
    print("[**********************************************]");
    final response = await https.post(
      url,
      body: json.encode(query),
      headers: {
        "Content-Type": "application/json"
      }
    );
    print("[*]==================== | ====================================");
    final Map<String, dynamic> resBody = json.decode(response.body);
    setState(() {
      _attendanceDataList = resBody['data']['attendance_data'];
    });
    print(_attendanceDataList);
  }

  void _showAttdenceScreen(WidgetRef ref) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return AttendanceScreen(courseDetails: widget.courseDetails);
    }));
    await _loadAttendance(ref);
    print("================================");
    setState(() {
      
    });
  }

  void _registerNewStudent() async {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return NewStudentRegister(courseDetails: widget.courseDetails);
    }));
  }


  void _showDateAttendence(dynamic attendanceDetails) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (cxt) => PresentStudentScreen(attendanceDetails: attendanceDetails,)
      )
    );
    await _loadAttendance(ref);
    setState(() {
      
    });

  }

  @override
  Widget build(BuildContext context) {

    Widget content = Center(
      child: Text(
        "Not attendance registered yet",
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.onBackground
        ),
      ),
    );

    if(_attendanceDataList.isNotEmpty) { 
      content = ListView.builder(
        itemCount: _attendanceDataList.length,
        itemBuilder: (ctx, index) => ListTile(
          hoverColor: Theme.of(context).colorScheme.onPrimary,
          isThreeLine: true,
          onTap: () {
            _showDateAttendence(_attendanceDataList[index]);
          },
          splashColor: Theme.of(context).colorScheme.onTertiary,
          title: Text(_attendanceDataList[index]['date']),
          subtitle: Text("${_attendanceDataList[index]['present_list'].length} present"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseDetails['course_code']),
        actions: [
          ElevatedButton(
            onPressed: _registerNewStudent, 
          child: const Text("Register Student"))
        ],
      ),
      floatingActionButton: IconButton(
        icon: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.secondary,
          size: 30,
          ),
        onPressed: () {
          _showAttdenceScreen(ref);
        },
      ),
      body: content,
    );
  }
}