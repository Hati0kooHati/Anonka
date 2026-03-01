import 'package:anonka/src/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class UpdateAppDialog extends StatelessWidget {
  const UpdateAppDialog({
    super.key,
    required this.launchUpdateUrl,
    required this.skipUpdate,
  });

  final Function() launchUpdateUrl;
  final Function() skipUpdate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Dialog(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        elevation: 0,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: skipUpdate,
                  child: Text(
                    AppStrings.skip,
                    style: TextStyle(color: Colors.blue.shade700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    AppStrings.updateAvailable,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    AppStrings.updateSlogan,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Center(
                        child: GestureDetector(
                          onTap: launchUpdateUrl,
                          child: Text(
                            AppStrings.update,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
