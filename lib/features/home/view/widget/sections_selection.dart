import 'package:flutter/material.dart';
import '../../../../core/widget/constants.dart';

class SelectionTypeSection extends StatefulWidget {
  const SelectionTypeSection({super.key, required this.tasksTypeChange});

  final Function(SelectionType type) tasksTypeChange;

  @override
  State<SelectionTypeSection> createState() => _SelectionTypeSectionState();
}

class _SelectionTypeSectionState extends State<SelectionTypeSection> {
  var currentSelectionType = SelectionType.all;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            onClicked(SelectionType.all);
          },
          style: TextButton.styleFrom(
            backgroundColor: currentSelectionType == SelectionType.all
                ? Constants.mainColor
                : const Color(0x1A00CA5D),
          ),
          child: Text(
            'All',
            style: TextStyle(
              color: currentSelectionType == SelectionType.all
                  ? Colors.white
                  : Constants.mainColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextButton(
            onPressed: () {
              onClicked(SelectionType.notDone);
            },
            style: TextButton.styleFrom(
              backgroundColor: currentSelectionType == SelectionType.notDone
                  ? Constants.mainColor
                  : const Color(0x1A00CA5D),
            ),
            child: Text(
              'Not Done',
              style: TextStyle(
                color: currentSelectionType == SelectionType.notDone
                    ? Colors.white
                    : Constants.mainColor,
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            onClicked(SelectionType.done);
          },
          style: TextButton.styleFrom(
            backgroundColor: currentSelectionType == SelectionType.done
                ? Constants.mainColor
                : const Color(0x1A00CA5D),
          ),
          child: Text(
            'Done',
            style: TextStyle(
              color: currentSelectionType == SelectionType.done
                  ? Colors.white
                  : Constants.mainColor,
            ),
          ),
        ),
      ],
    );
  }

  void onClicked(SelectionType newType) {
    if (newType != currentSelectionType) {
      widget.tasksTypeChange.call(newType);
      setState(() {
        currentSelectionType = newType;
      });
    }
  }
}

enum SelectionType {
  all,
  notDone,
  done,
}
