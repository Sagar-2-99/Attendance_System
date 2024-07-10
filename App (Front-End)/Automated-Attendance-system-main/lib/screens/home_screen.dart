import 'package:automated_attdance_system/screens/course_attendance_screen.dart';
import 'package:automated_attdance_system/screens/course_register_screen.dart';
import 'package:flutter/material.dart';
import 'package:automated_attdance_system/widgets/course_list.dart';
import 'package:automated_attdance_system/screens/signin_screen.dart';

class HomeScreen extends StatefulWidget {

  HomeScreen({super.key, required this.mp});

  Map<String, dynamic>? mp;

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }

}

class _HomeScreenState extends State<HomeScreen> {

  void _loadCourseRegisterScreen() async {

    final dynamic courseDetails = await Navigator.of(context).push(
      MaterialPageRoute(builder: (cxt) {
        return CourseRegisterScreen(userDetails: widget.mp!['user_details'],);
      }
      )
    );
    print(courseDetails);
    if(courseDetails == null) {
      return;
    }
    setState(() {
      print("------------------------------------------------------");
      widget.mp!['course_details'].add(courseDetails);
      print("-------------------------------------------------------");
    });
  }

  void _loadCourseAttendanceScreen(dynamic courseDetail) async {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (cxt) {
          return CourseAttendenceScreen(courseDetails: courseDetail);
        }
      )
    );
  }
  

  @override
  Widget build(BuildContext context) {
    print(widget.mp!['course_details']);
    final List<dynamic> courseList = widget.mp!['course_details'];

    Widget content = CourseListView(
        courseList: courseList,
        onTapCourse: _loadCourseAttendanceScreen,
      );
    
    if(courseList.isEmpty) {
      content = Center(
        child: Text(
          "No Course Registered Yet!",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mp!['user_details']['fullname'], maxLines: 1,),
      ),
      drawer: Drawer(
        child: ListView(
          children:  [
            DrawerHeader(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.person, size: 90,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    widget.mp!['user_details']['fullname'],
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary

                    ),
                  )
                ],
              ),
            ),
            ListTile(
              title: const Text("Register Course"),
              onTap:_loadCourseRegisterScreen,
            ),
            ListTile(
              title: const Text("Logout"),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const SigninScreen()));
              },
            )
          ],
        ),
      ),
      body: content
    );
  }

}