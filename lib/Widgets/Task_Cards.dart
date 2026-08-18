import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Utilties/App_Colors.dart';

class TaskCards extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> data;

  const TaskCards({super.key, required this.data});

  @override
  State<TaskCards> createState() => _TaskCardsState();
}

class _TaskCardsState extends State<TaskCards> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 1,
        color: Theme.of(context).cardColor,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                child: Icon(Icons.done_rounded, color: Colors.green),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data.data()["taskTitle"],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    (widget.data.data()["createdAt"].toDate())
                        .toString()
                        .substring(0, 19),
                    style: TextStyle(color: AppColors.moderateGrey),
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.moderateGrey,
                    size: 18,
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.data.data()["taskPriority"],
                    style: TextStyle(
                      color:
                          widget.data
                                  .data()["taskPriority"]
                                  .toString()
                                  .toLowerCase() ==
                              "low"
                          ? Colors.cyan.shade800
                          : widget.data
                                    .data()["taskPriority"]
                                    .toString()
                                    .toLowerCase() ==
                                "medium"
                          ? Colors.orange.shade600
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
