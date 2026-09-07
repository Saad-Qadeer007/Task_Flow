import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Provider/Task_Provider.dart';
import 'package:task_flow/Utilties/App_Colors.dart';

class StreakCard extends StatefulWidget {
  final String title;
  final String days;

  const StreakCard({super.key, required this.title, required this.days});

  @override
  State<StreakCard> createState() => _StreakCardState();
}

class _StreakCardState extends State<StreakCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        return Card(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: provider.isDark == false
                        ? AppColors.moderateGrey
                        : AppColors.lightColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${widget.days} Days", style: TextStyle(fontSize: 16)),
                    SizedBox(width: 10),
                    widget.title.toLowerCase() == "current streak"
                        ? FaIcon(FontAwesomeIcons.fire, color: Colors.red)
                        : FaIcon(FontAwesomeIcons.trophy, color: Colors.yellow),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
