import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class RCFooterComponent extends StatelessWidget {
  const RCFooterComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Powered by:',
          style: secondaryTextStyle(size: 14),
        ),
        4.height,
        Text(
          'BITSOFMX',
          style: boldTextStyle(size: 16),
        ),
      ],
    );
  }
}
