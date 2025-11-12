import 'package:flutter/material.dart';
import '../../models/app_model.dart';
import '../../app_launcher.dart';

/// Smooth, reliable Recents:
/// - Swipe LEFT/RIGHT: browse cards (PageView)
/// - Swipe UP: remove that app (Dismissible up only)
/// - Drag DOWN (background): close recents screen
/// - Clear All: instant (setState)
class RecentAppsOverlay extends StatefulWidget {
  final AnimationController controller;
  final AppModel model;
  final void Function(dynamic app) onSelect;

  const RecentAppsOverlay({
    super.key,
    required this.controller,
    required this.model,
    required this.onSelect,
  });

  @override
  State<RecentAppsOverlay> createState() => _RecentAppsOverlayState();
}

class _RecentAppsOverlayState extends State<RecentAppsOverlay> {
  late final PageController _page = PageController(viewportFraction: 0.78);

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardWidth = size.width * 0.72;
    final cardHeight = size.height * 0.76;

    return IgnorePointer(
      ignoring: widget.controller.value == 0,
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (_, __) {
          return Opacity(
            opacity: widget.controller.value,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              // Drag DOWN on background → close recents screen
              onVerticalDragUpdate: (d) {
                if (d.delta.dy > 8) widget.controller.reverse();
              },
              child: Container(
                width: size.width,
                height: size.height,
                color: Colors.black54,
                child: SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      // Header + Clear all
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              'Recent Apps',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                widget.model.recent.clear();
                              });
                            },
                            child: const Text(
                              'Clear All',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Cards
                      Expanded(
                        child: widget.model.recent.isEmpty
                            ? const Center(
                                child: Text(
                                  'No recent apps',
                                  style: TextStyle(
                                      color: Colors.white60, fontSize: 16),
                                ),
                              )
                            : ScrollConfiguration(behavior: const _SmoothScroll(),
                                child: PageView.builder(
                                  controller: _page,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: widget.model.recent.length,
                                  itemBuilder: (context, i) {
                                    // newest at the right end (like Android)
                                    final idx =
                                        widget.model.recent.length - 1 - i;
                                    final app = widget.model.recent[idx];

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: _RecentCard(
                                        app: app,
                                        width: cardWidth,
                                        height: cardHeight,
                                        onOpen: () => widget.onSelect(app),
                                        onClose: () {
                                          setState(() {
                                            widget.model.recent.removeAt(idx);
                                          });
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// One recent card: PageView handles LEFT/RIGHT; Dismissible handles UP only.
class _RecentCard extends StatelessWidget {
  final dynamic app;
  final double width;
  final double height;
  final VoidCallback onOpen;
  final VoidCallback onClose;

  const _RecentCard({
    super.key,
    required this.app,
    required this.width,
    required this.height,
    required this.onOpen,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('recent_${app.hashCode}'),
      direction: DismissDirection.up, // only swipe UP to close this card
      onDismissed: (_) => onClose(),
      child: RepaintBoundary(
        child: InkWell(
          onTap: onOpen,
          borderRadius: BorderRadius.circular(24),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF1F2636), Color(0xFF2C3856)],
              ),
              // lighter shadow to avoid GPU overdraw jank
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.45),
                  blurRadius: 16,
                  spreadRadius: -2,
                  offset: const Offset(0, 12),
                ),
              ],
              border: Border.all(color: Colors.white10, width: 1),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row
                Row(
                  children: [
                    const Icon(Icons.apps, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      app is DesktopApp? app.name
                          : (app is AppIcon ? app.name : 'Unknown'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: onClose,
                      icon: const Icon(Icons.close, color: Colors.white70),
                    ),
                  ],
                ),
                const Spacer(),
                const Text(
                  'Preview unavailable',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Smoother scrolling on Linux/desktop without extra rebuild cost.
class _SmoothScroll extends ScrollBehavior {
  const _SmoothScroll();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics();
}