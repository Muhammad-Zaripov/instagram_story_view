import 'package:flutter/widgets.dart';

typedef StoryBuilder = Widget Function(BuildContext context, Size size);

class StoryItem {
  final ImageProvider image;
  final StoryBuilder? builder;
  const StoryItem({required this.image, this.builder});
}
