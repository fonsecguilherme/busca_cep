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
  Widget build(BuildContext context) => Container(
        decoration: _containerStyle(context),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
                child: Center(
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  BoxDecoration _containerStyle(BuildContext context) => BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.all(
          Radius.circular(30),
        ),
      );
}
