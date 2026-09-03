import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Models/Habit_Model.dart';
import 'package:task_flow/Provider/Habit_Provider.dart';
import '../../Utilties/App_Colors.dart';
import '../../Widgets/Success_SnackBar.dart';


class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  TextEditingController habitTitleController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<String> habitFrequency = ["Everyday", "Weekly", "Monthly"];

  late String selectedFrequency = habitFrequency[0];

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    // Header of the add Habit screen
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          // onTap: () {
                          //   provider.editMode == false
                          //       ? Navigator.pushReplacement(
                          //           context,
                          //           MaterialPageRoute(
                          //             builder: (context) => HomeScreen(),
                          //           ),
                          //         )
                          //       : Navigator.pop(context);
                          //   provider.setEditModeToOff();
                          // },
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.moderateGrey,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "Create Habit",
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
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Task Title
                          Text(
                            "Habit Title",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight(600),
                              color: AppColors.moderateGrey,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: habitTitleController,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: "Read 20 pages",
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Habit Title";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          //   Habit frequency
                          Text(
                            "Habit Frequency",
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
                                return "Please Select Habit Frequency";
                              } else {
                                return null;
                              }
                            },
                            initialValue: selectedFrequency,
                            items: habitFrequency
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
                            hint: Text("Select Habit Frequency"),
                            onChanged: (value) {
                              setState(() {
                                selectedFrequency = value!;
                              });
                            },
                          ),
                          SizedBox(height: 20),

                          SizedBox(
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
                                if (formKey.currentState!.validate()) {
                                  print(
                                    "Validated Successfully -------------------------------------------------------------------------------------------------------",
                                  );
                                  context.read<HabitProvider>().addHabit(
                                    HabitModel(
                                      habitId: "",
                                      habitTitle: habitTitleController.text
                                          .trim(),
                                      habitFrequency: selectedFrequency,
                                      habitStatus: false,
                                      habitCompletedDates: [],
                                    ),
                                  );
                                  SuccessSnackBar.showSuccessSnackBar(
                                    context,
                                    "Habit Created Successfully",
                                  );
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                "Create Habit",
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
