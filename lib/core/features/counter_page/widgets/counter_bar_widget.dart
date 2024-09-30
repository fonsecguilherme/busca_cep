import 'package:flutter/material.dart';

class CounterBarWidget extends StatelessWidget {
  final int value;
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const CounterBarWidget({
    super.key,
    required this.value,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: _containerStyle(context),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onTertiary,
                          fontWeight: FontWeight.w400,
                        ),
                    overflow: TextOverflow.ellipsis,
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
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
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
