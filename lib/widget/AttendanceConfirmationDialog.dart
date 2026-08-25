import 'package:flutter/material.dart';

class AttendanceConfirmationDialog extends StatelessWidget {
  final int status;

  const AttendanceConfirmationDialog({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    String title;
    String message;
    String buttonText;
    IconData icon;
    Color iconColor;

    switch (status) {
      case 0:
        title = "Start Your Attendance";
        message =
            "You are about to check in for today.\n\n"
            "Your current location will be used to record your attendance.";
        buttonText = "Check In";
        icon = Icons.login_rounded;
        iconColor = Colors.green;
        break;

      case 1:
        title = "End Your Attendance";
        message =
            "You are about to check out for today.\n\n"
            "Your current location will be used to record your logout time.";
        buttonText = "Check Out";
        icon = Icons.logout_rounded;
        iconColor = Colors.orange;
        break;

      case 2:
        title = "Attendance Completed";
        message =
            "Your attendance for today has already been completed.\n\n"
            "If you believe this is incorrect, please check your attendance "
            "details or contact HR.";
        buttonText = "Okay";
        icon = Icons.check_circle_rounded;
        iconColor = Colors.green;
        break;

      default:
        title = "Attendance";
        message = "Unable to determine attendance status.";
        buttonText = "Okay";
        icon = Icons.info_outline_rounded;
        iconColor = Colors.grey;
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 30,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 15,
          height: 1.5,
        ),
      ),
      actions: [
        if (status != 2)
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("Cancel"),
          ),

        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(
              context,
              status == 2 ? false : true,
            );
          },
          icon: Icon(icon),
          label: Text(buttonText),
        ),
      ],
    );
  }
}