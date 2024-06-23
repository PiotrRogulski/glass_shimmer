import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:glass_shimmer/shimmer/shimmer.dart';
import 'package:glass_shimmer/shimmer/shimmer_parameters.dart';
import 'package:glass_shimmer/widgets/border_state.dart';
import 'package:glass_shimmer/widgets/card.dart';
import 'package:glass_shimmer/widgets/edge_blur.dart';
import 'package:glass_shimmer/widgets/list_tile.dart';
import 'package:glass_shimmer/widgets/text_button.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData(:colorScheme, :textTheme) = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 200,
            child: Material(
              color: colorScheme.surfaceContainerHigh,
              child: ListView.separated(
                itemCount: 25,
                padding:
                    const EdgeInsets.all(12) + EdgeBlur.blurPaddingOf(context),
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
              padding: EdgeBlur.blurPaddingOf(context),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        for (final color in Colors.primaries) ...[
                          Expanded(
                            child: Container(
                              height: 64,
                              color: color,
                            ),
                          ),
                          if (color != Colors.primaries.last)
                            const SizedBox(width: 4),
                        ],
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        for (final color in Colors.primaries) ...[
                          Container(
                            width: 8,
                            height: 64,
                            color: color,
                          ),
                          if (color != Colors.primaries.last) const Spacer(),
                        ],
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _loremIpsum,
                    style: textTheme.bodyLarge,
                  ),
                ),
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
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) {
                        final dimension = (12 + i * 24).toDouble();
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: BorderStateBuilder(
                            builder: (context, _, elevation, statesController) {
                              return Shimmer(
                                parameters: const SphereShimmer(),
                                elevation: -dimension / 2 + elevation,
                                child: SizedBox(
                                  width: dimension,
                                  height: dimension,
                                  child: Material(
                                    color: colorScheme.surfaceContainer,
                                    shape: const CircleBorder(),
                                    child: InkWell(
                                      statesController: statesController,
                                      onTap: () => log('Button tapped'),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ),
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

const _loremIpsum = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
    'In in nunc sem. Suspendisse accumsan, leo nec interdum tristique, '
    'metus dolor aliquet mauris, sit amet pellentesque metus tellus nec lorem. '
    'Proin auctor eget libero eget convallis. Aenean euismod ut leo non '
    'faucibus. Donec tristique lorem lectus, non ornare risus mollis vitae. '
    'Pellentesque eu venenatis sem, quis interdum ligula. Aenean mollis quis '
    'ex at varius. Aliquam at sem eget sapien iaculis commodo a ut sem.';
