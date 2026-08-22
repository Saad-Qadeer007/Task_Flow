import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Provider/Task_Provider.dart';

import '../Utilties/App_Colors.dart';

class TaskCategoryChip extends StatefulWidget {
  final String category;

  const TaskCategoryChip({super.key, required this.category});

  @override
  State<TaskCategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<TaskCategoryChip> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        return ActionChip(
          elevation: 0,
          backgroundColor: provider.selectedCatagory == widget.category
              ? AppColors.primaryColor
              : AppColors.secondaryTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          label: Text(widget.category, style: TextStyle(color: Colors.white,fontSize: 14)),
          onPressed: () {
            context.read<TaskProvider>().categorySelectionHandler(widget.category);
          },
        );
      },
    );
  }
}
