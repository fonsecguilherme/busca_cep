import 'package:flutter/material.dart';

class TagBuilder extends StatelessWidget {
  const TagBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> tags = ['tag 1', 'casa', 'pai', 'casa', 'pai'];

    return Wrap(
      spacing: 6.0,
      runSpacing: 8.0,
      children: [
        ...List.generate(
          tags.length,
          (index) => _TagWidget2(
            tagName: tags.elementAt(index),
            action: () {},
          ),
        ),
        Visibility(
          visible: tags.length < 5,
          child: _TagWidget2(
            action: () {},
          ),
        )
      ],
    );
  }
}

class _TagWidget2 extends StatelessWidget {
  final String? tagName;
  final VoidCallback action;

  const _TagWidget2({this.tagName, required this.action});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Container(
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          shape: const StadiumBorder(
            side: BorderSide(
              color: Colors.blue,
              width: 2,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 8.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tagName ?? 'Adicionar tag',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.sell_outlined,
                size: 16,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
