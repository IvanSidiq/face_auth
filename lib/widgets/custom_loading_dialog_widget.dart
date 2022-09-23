import 'package:flutter/material.dart';

class CustomLoadingDialogWidget extends StatelessWidget {
  const CustomLoadingDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: SizedBox(
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
