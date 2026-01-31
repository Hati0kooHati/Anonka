import 'package:anonka/src/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class ReportWidget extends StatelessWidget {
  final String postId;
  final Function({required String reportType, required String postId}) report;

  const ReportWidget({super.key, required this.report, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (String reportType in [
          AppStrings.report1,
          AppStrings.report2,
          AppStrings.report3,
          AppStrings.report4,
          AppStrings.report5,
          AppStrings.report7,
          AppStrings.report8,
        ]) ...[
          TextButton(
            onPressed: () {
              report(reportType: reportType, postId: postId);
              Navigator.pop(context);
            },
            child: Text(reportType),
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}
