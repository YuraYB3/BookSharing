// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../Shared/appTheme.dart';

class ReadMoreButton extends StatelessWidget {
  const ReadMoreButton({
    super.key,
    required this.context,
    required this.review,
  });

  final BuildContext context;
  final String review;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ElevatedButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 450,
                child: AlertDialog(
                  backgroundColor: AppTheme.secondBackgroundColor,
                  content: Text(
                    review,
                    style: const TextStyle(color: AppTheme.textColor),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text(
                        'Close',
                        style: TextStyle(color: AppTheme.iconColor),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            Colors.amber,
          ),
        ),
        child: const Text(
          "Read more",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
