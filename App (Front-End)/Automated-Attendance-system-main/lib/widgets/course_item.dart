import 'package:flutter/material.dart';

class CourseItem extends StatelessWidget {
  const CourseItem({super.key, required this.courseDetails, required this.onTapCourse});

  final dynamic courseDetails; 
  final void Function(dynamic) onTapCourse;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).colorScheme.secondary,
      onTap: (){
        onTapCourse(courseDetails);
      },
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.secondary.withOpacity(0.8)
            ],
            begin: Alignment.topLeft,
            end: Alignment.topRight
          )
        ),
        child: Center(
          child: Text(
          courseDetails['course_code'],
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: 20
          ),
          )
        ),
      ),
    );
  }
}