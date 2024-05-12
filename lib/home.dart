import 'package:flutter/material.dart';
import 'package:glass_shimmer/widgets/card.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
    );
  }
}
