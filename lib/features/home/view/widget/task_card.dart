import 'package:flutter/material.dart';
import '../../../../core/model/task_model.dart';
import '../../../../core/utils/functions.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.model,
    required this.onLongPress,
    required this.onDonePressed,
  });

  final TaskModel model;
  final Function(
    TaskModel model,
    void Function(TaskModel newModel) onEdit,
  ) onLongPress;

  final Function(
    TaskModel model,
    void Function(TaskModel newModel) onEdit,
  ) onDonePressed;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late TaskModel ourModel;

  @override
  void initState() {
    ourModel = widget.model;
    super.initState();
  }

  void _onEdit(TaskModel newModel) {
    setState(() {
      ourModel = newModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      child: InkWell(
        onTap: () {
          Functions.showSnackBar(text: 'Long press please');
        },
        onLongPress: () {
          widget.onLongPress.call(ourModel, _onEdit);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.model.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(Functions.formatDueDate(widget.model.dateTime)),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  widget.onDonePressed.call(ourModel, _onEdit);
                },
                icon: Image.asset(
                  widget.model.isDone
                      ? 'assets/done.png'
                      : 'assets/not_done.png',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
