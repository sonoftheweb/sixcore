import 'package:flutter/material.dart';

import '../Constants/colors.dart';

class LastActivities extends StatelessWidget {
  final bool completed;
  final int time;
  final String date;
  final int calorieBurn;

  const LastActivities({
    Key? key,
    required this.completed,
    required this.time,
    required this.date,
    required this.calorieBurn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: completed ? AppColor.teal : AppColor.warning,
        borderRadius: BorderRadius.circular(10),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.2),
        //     spreadRadius: 2,
        //     blurRadius: 7,
        //     offset: const Offset(2, 0),
        //   ),
        // ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            completed ? Icons.thumb_up_alt_sharp : Icons.thumb_down_alt_sharp,
            color: AppColor.blue,
            size: 20,
          ),
          Text(
            'Completed $time mins',
            style: TextStyle(
              color: AppColor.blue,
            ),
          ),
          Text(
            'Burnt $calorieBurn kCal',
            style: TextStyle(
              color: AppColor.blue,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              color: AppColor.blue,
            ),
          ),
        ],
      ),
    );
  }
}
