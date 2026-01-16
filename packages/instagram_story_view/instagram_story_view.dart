import 'package:flutter/material.dart';

import 'src/models/story_item.dart';
import 'src/story_overlay.dart';

class InstagramStoryView extends StatefulWidget {
  const InstagramStoryView({
    super.key,
    required this.items,
    this.avatarRadius = 35,
    this.borderWidth = 2,
    this.spacing = 12,
  });

  final List<StoryItem> items;
  final double avatarRadius;
  final double borderWidth;
  final double spacing;

  @override
  State<InstagramStoryView> createState() => _InstagramStoryViewState();
}

class _InstagramStoryViewState extends State<InstagramStoryView> {
  late final List<GlobalKey> _keys;

  @override
  void initState() {
    super.initState();
    _keys = List.generate(widget.items.length, (_) => GlobalKey());
  }

  void _openStory(int index) {
    final ctx = _keys[index].currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox;
    final pos = box.localToGlobal(Offset.zero);
    final size = box.size;

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return StoryOverlay(
            items: widget.items,
            initialIndex: index,
            startPosition: pos,
            startSize: size,
          );
        },
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return child;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.avatarRadius * 2 + widget.borderWidth * 2,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.items.length,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: widget.spacing);
        },
        itemBuilder: (_, index) {
          return Container(
            key: _keys[index],
            padding: EdgeInsets.all(widget.borderWidth),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: widget.borderWidth),
            ),
            child: InkWell(
              onTap: () => _openStory(index),
              child: Hero(
                tag: 'ig-story-$index',
                child: CircleAvatar(
                  radius: widget.avatarRadius,
                  backgroundImage: widget.items[index].image,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
