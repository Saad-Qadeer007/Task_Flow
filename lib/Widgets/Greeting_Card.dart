import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Utilties/App_Colors.dart';

class GreetingCard extends StatefulWidget {
  const GreetingCard({super.key});

  @override
  State<GreetingCard> createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good Morning.",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight(400)),
            ),
            Row(
              children: [
                Text(
                  "Saad",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight(400)),
                ),
                SizedBox(width: 10,),
                FaIcon(
                  FontAwesomeIcons.user,
                  size: 25,
                  color: AppColors.moderateGrey,
                ),
              ],
            ),
          ],
        ),
        Spacer(),
        Icon(
          Icons.notifications_none,
          size: 35,
          color: AppColors.moderateGrey,
        ),
      ],
    );
  }
}
