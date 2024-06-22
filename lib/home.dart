import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:glass_shimmer/widgets/card.dart';
import 'package:glass_shimmer/widgets/edge_blur.dart';
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
                itemCount: 25,
                padding:
                    const EdgeInsets.all(8) + EdgeBlur.blurPaddingOf(context),
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(_loremIpsum),
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

const _loremIpsum = '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit. In in nunc sem. Suspendisse accumsan, leo nec interdum tristique, metus dolor aliquet mauris, sit amet pellentesque metus tellus nec lorem. Proin auctor eget libero eget convallis. Aenean euismod ut leo non faucibus. Donec tristique lorem lectus, non ornare risus mollis vitae. Pellentesque eu venenatis sem, quis interdum ligula. Aenean mollis quis ex at varius. Aliquam at sem eget sapien iaculis commodo a ut sem.

Donec pulvinar justo at magna congue finibus. Ut vulputate tortor nec diam molestie tempor. Donec quis rhoncus leo, non aliquam turpis. Aenean dignissim faucibus nulla eget ultrices. Nam velit nibh, rhoncus sed scelerisque nec, porttitor et metus. Nulla turpis nunc, rhoncus auctor posuere id, dignissim tincidunt orci. Nunc elementum, nulla sit amet rutrum tempus, metus dolor vehicula dolor, ut iaculis lectus lacus sed nibh. Aliquam sed faucibus enim, at sagittis mi. Aliquam porttitor leo nibh, at sollicitudin lectus tincidunt id. Curabitur hendrerit ex eu condimentum iaculis. Nam convallis ut risus ut ullamcorper. Sed et sapien nisi. Fusce sit amet odio turpis. Pellentesque in efficitur mauris. Pellentesque laoreet vel ligula vitae interdum. Praesent egestas turpis vel diam consectetur luctus.
''';
