import 'package:flutter/material.dart';

class QuantityInput extends StatelessWidget {
  final double value;
  final void Function(double) onChanged;
  final double step;
  final String? unitLabel;

  const QuantityInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.step = 1.0,
    this.unitLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () {
            final next = (value - step).clamp(0, 999999).toDouble();
            onChanged(next);
          },
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text(
          value.toStringAsFixed(step % 1 == 0 ? 0 : 2) + (unitLabel != null ? ' $unitLabel' : ''),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () => onChanged((value + step).toDouble()),
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
