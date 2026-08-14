import 'package:flutter/material.dart';

class BTMobileFrame extends StatelessWidget {
  final Widget child;

  const BTMobileFrame({
    super.key,
    required this.child,
  });

  static const double maxContentWidth = 520;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth > maxContentWidth
            ? maxContentWidth
            : constraints.maxWidth;

        final isWideScreen = constraints.maxWidth > maxContentWidth;

        final backgroundColor = Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF151515)
            : const Color(0xFFE5E7EB);

        return ColoredBox(
          color: backgroundColor,
          child: Center(
            child: Container(
              width: contentWidth,
              height: constraints.maxHeight,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: isWideScreen
                    ? const [
                        BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 18,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: MediaQuery(
                data: mediaQuery.copyWith(
                  size: Size(
                    contentWidth,
                    mediaQuery.size.height,
                  ),
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
