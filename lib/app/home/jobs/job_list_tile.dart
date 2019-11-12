import 'package:flutter/material.dart';
import 'package:time_tracker_test/app/home/models/job.dart';

class JobListTile extends StatelessWidget {
  JobListTile({this.job, this.onTap});

  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
