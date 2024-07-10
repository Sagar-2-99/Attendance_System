import 'package:flutter/material.dart';
import 'package:automated_attdance_system/widgets/course_item.dart';

class CourseListView extends StatelessWidget {

  const CourseListView({super.key, required this.courseList, required this.onTapCourse});

  final List<dynamic> courseList;
  final void Function(dynamic) onTapCourse;

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3 / 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
      children: courseList.map((course) {
        return CourseItem(
          courseDetails: course,
          onTapCourse: onTapCourse,
          );
      }).toList()
    );
  }
}

