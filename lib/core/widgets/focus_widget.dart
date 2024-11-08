import 'package:flutter/widgets.dart';

class FocusWidget extends StatelessWidget {
  final Widget child;
  const FocusWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: child,
    );
  }
}
