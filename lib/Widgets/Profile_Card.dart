import 'package:flutter/material.dart';

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
    return Row(
      children: [
        Icon(widget.icon, color: AppColors.moderateGrey),
        SizedBox(width: 10),
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.moderateGrey,
          ),
        ),
        Spacer(),
        Icon(Icons.arrow_forward_ios_rounded, color: AppColors.moderateGrey),
      ],
    );
  }
}
