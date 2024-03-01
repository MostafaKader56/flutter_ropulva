import 'package:flutter/material.dart';
import '../../../../core/model/task_model.dart';
import '../../../../core/utils/functions.dart';

import '../../../../core/widget/constants.dart';

class CreateTaskBottomSheet extends StatefulWidget {
  const CreateTaskBottomSheet(
      {super.key, this.isEdit = false, this.model, required this.onFinished});

  final bool isEdit;
  final TaskModel? model;
  final Function(bool isEdit, TaskModel model) onFinished;

  @override
  State<CreateTaskBottomSheet> createState() => _CreateTaskBottomSheetState();
}

class _CreateTaskBottomSheetState extends State<CreateTaskBottomSheet> {
  DateTime? _selectedDate;

  late TextEditingController dueDateConteroller = TextEditingController();
  late TextEditingController titleConteroller = TextEditingController();

  String? titleError;
  String? dueDateError;

  @override
  void initState() {
    super.initState();

    if (widget.isEdit && widget.model != null) {
      titleConteroller.text = widget.model!.title;
      dueDateConteroller.text = Functions.formatDueDate(widget.model!.dateTime);
      _selectedDate = widget.model!.dateTime;
    }

    dueDateConteroller.addListener(() {
      if (dueDateError != null) {
        setState(() {
          dueDateError = null;
        });
      }
    });

    titleConteroller.addListener(() {
      if (titleError != null) {
        setState(() {
          titleError = null;
        });
      }
    });
  }

  @override
  void dispose() {
    dueDateConteroller.dispose();
    titleConteroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 20.0 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close, color: Colors.red),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create New Task',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0x33D9D9D9),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    controller: titleConteroller,
                    decoration: const InputDecoration(
                        hintText: 'Task title',
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Color(0x33000000))),
                  ),
                ),
                if (titleError != null)
                  Text(
                    titleError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20.0),
                InkWell(
                  onTap: () {
                    dueDateEditTextClicked();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0x33D9D9D9),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: AbsorbPointer(
                      absorbing: true,
                      child: TextFormField(
                        controller: dueDateConteroller,
                        enabled: false,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                            hintText: 'Due Date',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20.0),
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Color(0x33000000))),
                      ),
                    ),
                  ),
                ),
                if (dueDateError != null)
                  Text(
                    dueDateError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  height: 65,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        bool isValid = true;
                        if (titleConteroller.text.trim().isEmpty) {
                          titleError = 'Enter task title';
                          isValid = false;
                        }
                        if (_selectedDate == null) {
                          dueDateError = 'Select task due date';
                          isValid = false;
                        }

                        if (!isValid) {
                          setState(() {});
                          return;
                        }

                        if (widget.isEdit && widget.model != null) {
                          if (widget.model!.title ==
                                  titleConteroller.text.trim() &&
                              widget.model!.dateTime == _selectedDate!) {
                            Navigator.of(context).pop();
                            return;
                          }
                          widget.model!.title = titleConteroller.text.trim();
                          widget.model!.dateTime = _selectedDate!;
                          widget.onFinished(widget.isEdit, widget.model!);
                        } else {
                          final model = TaskModel(
                            id: Functions.generateCustomId(),
                            title: titleConteroller.text.trim(),
                            dateTime: _selectedDate!,
                          );
                          widget.onFinished(widget.isEdit, model);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Save Task',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> dueDateEditTextClicked() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      _selectedDate = pickedDate;
      dueDateConteroller.text = Functions.formatDueDate(pickedDate);
    }
  }
}
