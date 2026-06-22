import 'package:flutter/material.dart';
import '../../app/app_state.dart';
import 'farm_tile_widget.dart';

class FarmGridWidget extends StatelessWidget {
  final AppState state;

  const FarmGridWidget({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 320,
        child: GridView.builder(
          itemCount: 9,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return FarmTileWidget(
              index: index,
              state: state,
            );
          },
        ),
      ),
    );
  }
}