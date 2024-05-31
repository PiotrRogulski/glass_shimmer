import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:glass_shimmer/widgets/card.dart';
import 'package:glass_shimmer/widgets/list_tile.dart';
import 'package:glass_shimmer/widgets/text_button.dart';

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
                itemBuilder: (context, i) => ShimmerListTile(
                  title: Text('Item ${i + 1}'),
                  onTap: () => log('Item ${i + 1} tapped'),
                ),
                separatorBuilder: (context, index) => const SizedBox(height: 8),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Wrap(
                    children: [
                      for (var i = 0; i < 5; i++)
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: SizedBox.square(
                            dimension: 128,
                            child: ShimmerCard(
                              onTap: () => log('Card ${i + 1} tapped'),
                              child: Center(
                                child: Text(
                                  '${i + 1}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                for (var i = 0; i < 5; i++)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: ShimmerTextButton(
                        onTap: () => log('Button ${i + 1} tapped'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                          child: Text(
                            Iterable.generate(i + 1, (i) => i + 1).join('   '),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
