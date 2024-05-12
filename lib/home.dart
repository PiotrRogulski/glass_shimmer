import 'package:flutter/material.dart';
import 'package:glass_shimmer/widgets/card.dart';
import 'package:glass_shimmer/widgets/list_tile.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 200,
            child: Material(
              color: colorScheme.surfaceContainer,
              child: ListView.separated(
                itemCount: 5,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) => ShimmerListTile(
                  title: Text('Item $index'),
                  onTap: () => debugPrint('Item $index tapped'),
                ),
                separatorBuilder: (context, index) => const SizedBox(height: 8),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < 5; i++)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SizedBox.square(
                        dimension: 100,
                        child: ShimmerCard(
                          onTap: () => debugPrint('Card $i tapped'),
                          child: Center(
                            child: Text(
                              '$i',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
