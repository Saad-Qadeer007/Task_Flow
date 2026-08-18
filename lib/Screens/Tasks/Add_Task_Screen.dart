import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Models/Task_Model.dart';
import 'package:task_flow/Provider/Task_Provider.dart';
import 'package:task_flow/Screens/Home/Home_Screen.dart';
import 'package:task_flow/Widgets/Success_SnackBar.dart';
import '../../Utilties/App_Colors.dart';
import '../../Widgets/Task_Priority_Chips.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final List<String> taskCategories = [
    'Study',
    'Work',
    'Personal',
    'Health',
    'Shopping',
    'Finance',
    'Projects',
    'Other',
  ];

  final List<String> taskPriority = ["Low", "Medium", "High"];

  final addTaskScreenFormKey = GlobalKey<FormState>();

  final List<String> reminderOptionList = [
    "5 Minutes Before",
    "10 Minutes Before",
    "30 Minutes Before",
    "1 Hour Before",
  ];

  DateTime? gettedDate;
  DateTime? selectedDate;
  TimeOfDay? gettedTime;
  TimeOfDay? selectedTime;
  late String defaultReminder = reminderOptionList[0];

  TextEditingController dueDateController = TextEditingController();
  TextEditingController dueTimeController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController reminderController = TextEditingController();
  TextEditingController repeatController = TextEditingController();

  late String selectedCategory = taskCategories[0];

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    // Header of the add task screen
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.moderateGrey,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "Create Task",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight(600),
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.done_rounded, color: AppColors.primaryColor),
                      ],
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: addTaskScreenFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Task Title
                          Text(
                            "Task Title",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight(600),
                              color: AppColors.moderateGrey,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: titleController,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: "Complete Flutter Project",
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Task Title";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          // Task Description
                          Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight(600),
                              color: AppColors.moderateGrey,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: descriptionController,
                            maxLines: 2,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: "Description...",
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Task Description";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          //   Task Category
                          Text(
                            "Category",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight(600),
                              color: AppColors.moderateGrey,
                            ),
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField(
                            validator: (value) {
                              if (value == null) {
                                return "Please Select Task Category";
                              } else {
                                return null;
                              }
                            },
                            initialValue: selectedCategory,
                            items: taskCategories
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                        color: AppColors.moderateGrey,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            hint: Text("Select Task Category"),
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value!;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          //   Task priority
                          Row(
                            children: [
                              Text(
                                "Priority",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight(600),
                                  color: AppColors.moderateGrey,
                                ),
                              ),
                              Spacer(),
                              Text(
                                provider.priority,
                                style: TextStyle(
                                  color: AppColors.moderateGrey,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            spacing: 10,
                            children: taskPriority.map((items) {
                              return Expanded(
                                child: TaskPriorityChips(item: items),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 20),
                          //   Due Date
                          Text(
                            "Due Date",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight(600),
                              color: AppColors.moderateGrey,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (selectedDate == null) {
                                return "Please Select Due Date";
                              } else {
                                return null;
                              }
                            },
                            controller: dueDateController,
                            readOnly: true,
                            onTap: () async {
                              gettedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (gettedDate != null) {
                                setState(() {
                                  selectedDate = gettedDate;
                                  print(selectedDate);
                                  dueDateController.text =
                                      "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
                                });
                              }
                            },
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.calendar_month_rounded),
                              hintText: "Select Due Date",
                            ),
                          ),
                          SizedBox(height: 20),
                          //   Due Time
                          Text(
                            "Due Time",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight(600),
                              color: AppColors.moderateGrey,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (selectedDate == null) {
                                return "Please Select Due Time";
                              } else {
                                return null;
                              }
                            },
                            controller: dueTimeController,
                            readOnly: true,
                            onTap: () async {
                              gettedTime = (await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ));
                              if (gettedTime != null) {
                                setState(() {
                                  selectedTime = gettedTime;
                                  dueTimeController.text =
                                      "${selectedTime!.hour}:${selectedTime!.minute} ${selectedTime!.period.name}";
                                });
                              }
                            },
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.calendar_month_rounded),
                              hintText: "Select Due Time",
                            ),
                          ),
                          SizedBox(height: 20),
                          //   Reminder
                          Text(
                            "Reminder",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight(600),
                              color: AppColors.moderateGrey,
                            ),
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField(
                            initialValue: defaultReminder,
                            items: reminderOptionList
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                        color: AppColors.moderateGrey,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            hint: Text("Select Task Category"),
                            onChanged: (value) {
                              setState(() {
                                defaultReminder = value!;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          //   Repeat
                          Text(
                            "Repeat",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight(600),
                              color: AppColors.moderateGrey,
                            ),
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField(
                            initialValue: defaultReminder,
                            items: reminderOptionList
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                        color: AppColors.moderateGrey,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            hint: Text("Select Task Category"),
                            onChanged: (value) {
                              setState(() {
                                defaultReminder = value!;
                              });
                            },
                          ),
                          SizedBox(height: 20),

                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: AppColors.lightColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                print(provider.priority);
                                if (addTaskScreenFormKey.currentState!
                                    .validate()) {
                                  context.read<TaskProvider>().addTask(
                                    TaskModel(
                                      id: "",
                                      taskTitle: titleController.text.trim(),
                                      taskDescription: descriptionController
                                          .text
                                          .trim(),
                                      taskCategory: selectedCategory,
                                      taskPriority: provider.priority,
                                      taskDueDate: selectedDate,
                                      taskDueTime: selectedTime,
                                      taskReminder: '',
                                      taskRepeat: '',
                                    ),
                                  );

                                  SuccessSnackBar.showSuccessSnackBar(
                                    context,
                                    "Task Created Successfully",
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                "Create Task",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
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
