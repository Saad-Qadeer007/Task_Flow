import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Provider/Task_Provider.dart';
import 'package:task_flow/Widgets/Task_Catagory_Chip.dart';
import '../../Utilties/App_Colors.dart';
import '../../Widgets/Task_Cards.dart';
import '../../Widgets/Task_Priority_Chips.dart';
import '../Home/Home_Screen.dart';
import 'Tasks_Detail_Screen.dart';

class ShowTasksScreen extends StatefulWidget {
  const ShowTasksScreen({super.key});

  @override
  State<ShowTasksScreen> createState() => _ShowTasksScreenState();
}

class _ShowTasksScreenState extends State<ShowTasksScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().getTasks();
    });
  }

  List<String> dateChipList = ["All", "Today", "Upcoming", "Completed"];
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

  final now = DateTime.now();

  late final startOfDay = DateTime(now.year, now.month, now.day);

  late final endOfDay = startOfDay.add(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //   AppBar For The Show All Task Screen
                    // Header of the add task screen
                    SizedBox(height: 10),
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
                        InkWell(
                          onTap: () {
                            print(
                              "Filtered List : ${provider.filteredList.length}",
                            );
                            print(provider.tasks.length);
                            print("End Date : ${provider.endOfDay}");
                          },
                          child: Text(
                            "All Tasks",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight(600),
                            ),
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            context
                                .read<TaskProvider>()
                                .setSearchModeByTextField();
                          },
                          child: Icon(
                            Icons.search,
                            color: AppColors.moderateGrey,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () async {
                            await showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return SafeArea(
                                  child: SingleChildScrollView(
                                    child: Container(
                                      padding: EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadiusGeometry.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      child: Consumer<TaskProvider>(
                                        builder: (context, provider, child) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Filter Notes",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: AppColors.darkGrey,
                                                  fontWeight: FontWeight(600),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                "Filter By Category",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.darkGrey,
                                                ),
                                              ),
                                              SizedBox(height: 15),
                                              Wrap(
                                                spacing: 10,
                                                children: taskCategories.map((
                                                  item,
                                                ) {
                                                  return TaskCategoryChip(
                                                    category: item,
                                                  );
                                                }).toList(),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Filter For Priority",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors.darkGrey,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    provider.priority,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors
                                                          .moderateGrey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15),
                                              Wrap(
                                                spacing: 10,
                                                children: provider.taskPriority
                                                    .map((item) {
                                                      return TaskPriorityChips(
                                                        item: item,
                                                      );
                                                    })
                                                    .toList(),
                                              ),
                                              SizedBox(height: 20),
                                              Container(
                                                width: MediaQuery.of(
                                                  context,
                                                ).size.width,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.primaryColor,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8.0,
                                                          ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    context
                                                        .read<TaskProvider>()
                                                        .searchWithCatagory();
                                                    context
                                                        .read<TaskProvider>()
                                                        .searchWithPriority();
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "Apply Filter",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              SizedBox(height: 10),
                                              Container(
                                                width: MediaQuery.of(
                                                  context,
                                                ).size.width,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.primaryColor,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8.0,
                                                          ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    context
                                                        .read<TaskProvider>()
                                                        .clearFilter();
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "Clear Filter",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ).animate().fadeIn(duration: 500.ms),
                                  ),
                                );
                              },
                            );
                          },
                          child:
                              FaIcon(
                                FontAwesomeIcons.filter,
                                color: Colors.grey.shade700,
                              ).animate().shimmer(
                                duration: Duration(milliseconds: 1000),
                                color: Colors.grey.shade400,
                              ),
                        ),
                      ],
                    ),

                    provider.searchModeByTextField
                        ? Container(
                                padding: EdgeInsets.only(top: 20),
                                width: double.infinity,
                                child: TextField(
                                  onChanged: (value) {
                                    context
                                        .read<TaskProvider>()
                                        .searchByTextField(value);
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: AppColors.moderateGrey,
                                    ),
                                    hintText: "Search",
                                    hintStyle: TextStyle(
                                      color: AppColors.moderateGrey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 500.ms)
                              .slideX(begin: 0.5, end: 0.0)
                        : Container(),

                    SizedBox(height: 20),
                    //   Chips For Filter By Date
                    Wrap(
                      runSpacing: 2,
                      spacing: 1,
                      children: dateChipList
                          .map(
                            (e) => ActionChip(
                              backgroundColor: provider.activeDateChip == e
                                  ? AppColors.primaryColor
                                  : AppColors.background,
                              onPressed: () {
                                setState(() {
                                  provider.activeDateChip = e;
                                  print(provider.activeDateChip);
                                  context.read<TaskProvider>().searchWithDate();
                                });
                              },
                              label: Text(
                                e,
                                style: TextStyle(
                                  color: provider.activeDateChip == e
                                      ? AppColors.lightColor
                                      : AppColors.moderateGrey,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 20),
                    //   Showing the data from the firebase
                    provider.tasks.isEmpty
                        ? Container(
                            height: 400,
                            child: Center(
                              child: Text(
                                "No Task Yet",
                                style: TextStyle(color: AppColors.moderateGrey),
                              ),
                            ),
                          )
                        : provider.filteredList.isEmpty
                        ? Container(
                            height: 400,
                            child: Center(
                              child: Text(
                                "No Tasks Found",
                                style: TextStyle(color: AppColors.moderateGrey),
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                provider.activeDateChip == "All"
                                    ? "All Tasks"
                                    : provider.activeDateChip == "Today"
                                    ? "Today's Tasks"
                                    : provider.activeDateChip == "Upcoming"
                                    ? "Upcoming Tasks"
                                    : "Completed Tasks",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight(600),
                                  color: AppColors.moderateGrey,
                                ),
                              ),
                              SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: provider.filteredList.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      context
                                          .read<TaskProvider>()
                                          .upcomingTaskTracker(
                                            provider.filteredList[index].id
                                                .toString(),
                                          );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TasksDetailScreen(
                                                id: provider
                                                    .filteredList[index]
                                                    .id
                                                    .toString(),
                                                tasks: provider.filteredList,
                                                upcoming: provider.isUpcoming,
                                                date: "this week",
                                              ),
                                        ),
                                      );
                                    },
                                    child:
                                        TaskCards(
                                          id: provider.filteredList[index].id
                                              .toString(),
                                          tasks: provider.filteredList,
                                        ).animate().fade().slideX(
                                          begin: 0.5,
                                          end: 0.0,
                                          duration: Duration(milliseconds: 500),
                                        ),
                                  );
                                },
                              ),
                            ],
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
