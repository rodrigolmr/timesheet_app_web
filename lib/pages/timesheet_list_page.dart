import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../models/timesheet.dart';

class TimesheetListPage extends ConsumerWidget {
  const TimesheetListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timesheetRepository = ref.watch(timesheetRepositoryProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timesheets'),
      ),
      body: Builder(
        builder: (context) {
          final timesheets = timesheetRepository.getLocalTimesheets();
          
          if (timesheets.isEmpty) {
            return const Center(child: Text('No timesheets found'));
          }
          
          return ListView.builder(
            itemCount: timesheets.length,
            itemBuilder: (context, index) {
              final timesheet = timesheets[index];
              return ListTile(
                title: Text('Timesheet ${timesheet.jobName}'),
                subtitle: Text('${timesheet.date.toString().split(' ')[0]}'),
                onTap: () {
                  // Navigate to timesheet detail page
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create timesheet page
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}