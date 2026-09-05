import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Widgets/Completion_Task_Card_Statistics.dart';
import 'package:task_flow/Widgets/Task_Completion_Status_Card_For_Statistics.dart';

import '../../Provider/Task_Provider.dart';
import '../../Utilties/App_Colors.dart';
import '../Tasks/Tasks_Detail_Screen.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<String> dataSelectionOptions = ["This Week", "This Month", "This Year"];
  late String defaultSelection = dataSelectionOptions[0];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<TaskProvider>().getTaskCountForStatistics("this week");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Statistics",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight(600),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Dropdown menu for data selection
                    DropdownButtonFormField(
                      onChanged: (value) {
                        context.read<TaskProvider>().getTaskCountForStatistics(
                          value!,
                        );
                        setState(() {
                          defaultSelection = value;
                        });
                      },
                      initialValue: defaultSelection,
                      items: dataSelectionOptions
                          .map(
                            (option) => DropdownMenuItem(
                              value: option,
                              child: Text(
                                option,
                                style: TextStyle(color: AppColors.moderateGrey),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 15),
                    CompletionTaskCardStatistics(),
                    SizedBox(height: 15),
                    //   Task Completion and Pending Task Card
                    Row(
                      children: [
                        Expanded(
                          child: TaskCompletionStatusCardForStatistics(
                            title: "Task Completed",
                            count:
                                provider.filterStatisticsCompletedTasks.length,
                          ),
                        ),
                        Expanded(
                          child: TaskCompletionStatusCardForStatistics(
                            title: "Task Pending",
                            count: provider.filterStatisticsPendingTasks.length,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    //   Task Completion and Pending Task Card
                    Text(
                      "Completed Tasks",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColors.moderateGrey,
                      ),
                    ),
                    SizedBox(height: 10),
                    provider.filterStatisticsCompletedTasks.isEmpty
                        ? SizedBox(
                            height: 200,
                            child: Center(child: Text("No Completed Task")),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:
                                provider.filterStatisticsCompletedTasks.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: AppColors.cards,
                                child: InkWell(
                                  onTap: () {
                                    context
                                        .read<TaskProvider>()
                                        .upcomingTaskTracker(
                                          provider
                                              .filterStatisticsCompletedTasks[index]
                                              .id
                                              .toString(),
                                        );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TasksDetailScreen(
                                          id: provider
                                              .filterStatisticsCompletedTasks[index]
                                              .id
                                              .toString(),
                                          tasks: provider.tasks,
                                          upcoming: provider.isUpcoming,
                                        ),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.grey.shade100,
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                    ),
                                    title: Text(
                                      provider
                                              .filterStatisticsCompletedTasks[index]
                                              .taskTitle![0]
                                              .toString()
                                              .toUpperCase() +
                                          provider
                                              .filterStatisticsCompletedTasks[index]
                                              .taskTitle!
                                              .substring(1),
                                      style: TextStyle(
                                        color: AppColors.moderateGrey,
                                      ),
                                    ),
                                    trailing: Text(
                                      "Completed",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.moderateGrey,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                    SizedBox(height: 15),
                    Text(
                      "Pending Tasks",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColors.moderateGrey,
                      ),
                    ),
                    SizedBox(height: 10),
                    provider.filterStatisticsCompletedTasks.isEmpty
                        ? SizedBox(
                            height: 200,
                            child: Center(child: Text("No Pending Task")),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:
                                provider.filterStatisticsPendingTasks.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: AppColors.cards,
                                child: InkWell(
                                  onTap: () {
                                    context
                                        .read<TaskProvider>()
                                        .upcomingTaskTracker(
                                          provider
                                              .filterStatisticsPendingTasks[index]
                                              .id
                                              .toString(),
                                        );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TasksDetailScreen(
                                          id: provider
                                              .filterStatisticsPendingTasks[index]
                                              .id
                                              .toString(),
                                          tasks: provider.tasks,
                                          upcoming: provider.isUpcoming,
                                        ),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.grey.shade100,
                                      child: Icon(
                                        Icons.pending_actions,
                                        color: AppColors.secondaryTextColor,
                                      ),
                                    ),
                                    title: Text(
                                      provider
                                              .filterStatisticsPendingTasks[index]
                                              .taskTitle![0]
                                              .toString()
                                              .toUpperCase() +
                                          provider
                                              .filterStatisticsPendingTasks[index]
                                              .taskTitle!
                                              .substring(1),
                                      style: TextStyle(
                                        color: AppColors.moderateGrey,
                                      ),
                                    ),
                                    trailing: Text(
                                      "Pending",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.moderateGrey,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
