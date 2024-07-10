import 'package:automated_attdance_system/screens/attendance_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:automated_attdance_system/screens/update_attendance_screen.dart';
import 'package:automated_attdance_system/providers/url_providers.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';

class PresentStudentScreen extends ConsumerStatefulWidget {
  const PresentStudentScreen({super.key, required this.attendanceDetails});
  final dynamic attendanceDetails;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PresentStudentScreenState();
  }

}

class _PresentStudentScreenState extends ConsumerState<PresentStudentScreen> {


    _loadAttendance(WidgetRef ref) async {
    final baseUrl = ref.read(baseUrlProvider);
    Uri url = Uri.http(baseUrl, "get_attendance_date");
    print(baseUrl);
    Map<String, String> query = {
      'course_code': widget.attendanceDetails['course_code'],
      'username': widget.attendanceDetails['username'],
      'date': widget.attendanceDetails['date']
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
    print(resBody);
    setState(() {
      widget.attendanceDetails['present_list'] = resBody['data']['attendance_data'][0]['present_list'];
    });
  }

  void _loadUpdateAttendanceScrren(WidgetRef ref) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) {
        return UpdateAttendanceScreen(attendanceDetails: widget.attendanceDetails);
      }
    ));
    await _loadAttendance(ref);
  }

  @override
  Widget build(BuildContext context) {

    Widget content = Center(
      child: Text(
        "No one present",
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.onBackground
        ),
      ),
    );

    if(widget.attendanceDetails['present_list'].isNotEmpty) {
      content = ListView.builder(
        itemCount: widget.attendanceDetails['present_list'].length,
        itemBuilder: (cxt, index) {
          return ListTile(
            contentPadding: const EdgeInsets.all(10),
            splashColor: Theme.of(context).colorScheme.onPrimary,
            subtitle: const Text("present"),
            onTap: () {
              
            },
            isThreeLine: true,
            title: Text(widget.attendanceDetails['present_list'][index]),
          );
        }
      );
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
        actions: [
          ElevatedButton(onPressed: () {
            _loadUpdateAttendanceScrren(ref);
          }, child: const Text("override"))
        ],
      ),
      body: content
    );
  }

}