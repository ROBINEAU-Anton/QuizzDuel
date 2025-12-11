import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/zoom_provider.dart';

class ZoomControls extends StatelessWidget {
  const ZoomControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, color: Colors.white, size: 20),
            onPressed: () {
              final provider = context.read<ZoomProvider>();
              provider.setScale(provider.textScaleFactor - 0.1);
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Consumer<ZoomProvider>(
            builder: (_, provider, __) => Text(
              '${(provider.textScaleFactor * 100).round()}%',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 20),
            onPressed: () {
              final provider = context.read<ZoomProvider>();
              provider.setScale(provider.textScaleFactor + 0.1);
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
