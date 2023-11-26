import 'package:flutter/material.dart';

class CounterBarWidget extends StatelessWidget {
  final int value;
  final IconData icon;
  final String text;

  const CounterBarWidget({
    super.key,
    required this.value,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                ),
              ),
              Text(
                value.toString(),
              ),
            ],
          ),
        ),
      );
}
