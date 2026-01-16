import 'package:flutter/material.dart';
import 'models/story_item.dart';

class StoryOverlay extends StatefulWidget {
  const StoryOverlay({
    super.key,
    required this.items,
    required this.initialIndex,
    required this.startPosition,
    required this.startSize,
  });

  final List<StoryItem> items;
  final int initialIndex;
  final Offset startPosition;
  final Size startSize;

  @override
  State<StoryOverlay> createState() => _StoryOverlayState();
}

class _StoryOverlayState extends State<StoryOverlay>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _expandController;
  late final Animation<double> _expand;
  late final Animation<double> _fade;

  double _drag = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _expand = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOutCubic,
    );
    _fade = Tween<double>(begin: 0.3, end: 1).animate(
      CurvedAnimation(parent: _expandController, curve: const Interval(0.3, 1)),
    );
    _expandController.forward();
  }

  Future<void> _close() async {
    await _expandController.reverse();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        _close();
      },

      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedBuilder(
          animation: _expandController,
          builder: (_, child) {
            final x = widget.startPosition.dx * (1 - _expand.value);
            final y = widget.startPosition.dy * (1 - _expand.value);
            final w =
                widget.startSize.width +
                (screen.width - widget.startSize.width) * _expand.value;
            final h =
                widget.startSize.height +
                (screen.height - widget.startSize.height) * _expand.value;

            return Positioned(
              left: x,
              top: y,
              width: w,
              height: h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100 * (1 - _expand.value)),
                child: Opacity(opacity: _fade.value, child: child),
              ),
            );
          },
          child: GestureDetector(
            onVerticalDragUpdate: (d) {
              _drag += d.delta.dy;
              if (_drag < 0) _drag = 0;
            },
            onVerticalDragEnd: (_) {
              if (_drag > 120) {
                _close();
              } else {
                _drag = 0;
              }
            },
            child: Transform.translate(
              offset: Offset(0, _drag),
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.items.length,
                itemBuilder: (_, index) {
                  final item = widget.items[index];

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final size = Size(
                        constraints.maxWidth,
                        constraints.maxHeight,
                      );

                      return Stack(
                        children: [
                          Positioned.fill(
                            child: Hero(
                              tag: 'ig-story-$index',
                              child: Image(
                                image: item.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          if (item.builder != null)
                            Positioned.fill(
                              child: item.builder!(context, size),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
