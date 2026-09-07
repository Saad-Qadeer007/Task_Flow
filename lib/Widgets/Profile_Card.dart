import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Provider/Task_Provider.dart';

import '../Utilties/App_Colors.dart';

class ProfileCard extends StatefulWidget {
  final IconData icon;
  final String title;

  const ProfileCard({super.key, required this.icon, required this.title});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            Icon(
              widget.icon,
              color: provider.isDark == false
                  ? AppColors.moderateGrey
                  : AppColors.lightColor,
            ),
            SizedBox(width: 10),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: provider.isDark == false
                    ? AppColors.moderateGrey
                    : AppColors.lightColor,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: provider.isDark == false
                  ? AppColors.moderateGrey
                  : AppColors.lightColor,
            ),
          ],
        );
      },
    );
  }
}
