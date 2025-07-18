import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../data/models/plan_model.dart';
import '../../../../core/theme/theme.dart';

// Displays a single plan item in the plan list with swipe-to-action functionality
class PlanListItem extends StatefulWidget {
  final PlanModel plan;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const PlanListItem({
    super.key,
    required this.plan,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  _PlanListItemState createState() => _PlanListItemState();
}

class _PlanListItemState extends State<PlanListItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  double _dragOffset = 0.0;
  bool _isSwiping = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isSwiping) return;
    setState(() {
      _dragOffset += details.delta.dx;
      // Limit swipe distance to 30% of screen width
      final maxOffset = MediaQuery.of(context).size.width * 0.3;
      _dragOffset = _dragOffset.clamp(-maxOffset, maxOffset);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isSwiping) return;
    _isSwiping = false;
    // Determine swipe direction based on velocity
    final velocity = details.primaryVelocity ?? 0.0;
    final isLeftToRight = velocity > 500 || _dragOffset > 50;
    final isRightToLeft = velocity < -500 || _dragOffset < -50;

    // Animate back to original position
    _controller.reset();
    _animation = Tween<Offset>(
      begin: Offset(_dragOffset, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Cubic(0.2, 0.0, 0.0, 1.0),
    ));

    _controller.forward().then((_) {
      setState(() {
        _dragOffset = 0.0;
      });
      // Trigger action after bounce-back
      if (isLeftToRight) {
        widget.onEdit();
      } else if (isRightToLeft) {
        Get.dialog<bool>(
          AlertDialog(
            title: Text('Confirm Delete', style: AdminTheme.textStyles['title']),
            content: Text(
              'Are you sure you want to delete "${widget.plan.title}"?',
              style: AdminTheme.textStyles['body'],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text(
                  'Cancel',
                  style: AdminTheme.textStyles['body']!.copyWith(color: AdminTheme.colors['textSecondary']),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: Text(
                  'Delete',
                  style: AdminTheme.textStyles['body']!.copyWith(color: AdminTheme.colors['deleteIcon'] ?? Colors.red),
                ),
              ),
            ],
          ),
        ).then((confirm) {
          if (confirm == true) {
            widget.onDelete();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (_) => _isSwiping = true,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final offset = _isSwiping ? Offset(_dragOffset, 0) : _animation.value;
          return Transform.translate(
            offset: offset,
            child: child,
          );
        },
        child: Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          child: ListTile(
            title: Text(
              widget.plan.title,
              style: AdminTheme.textStyles['body']!.copyWith(
                color: AdminTheme.colors['textPrimary'],
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              widget.plan.details['description'] ?? '',
              style: AdminTheme.textStyles['body']!.copyWith(color: AdminTheme.colors['textSecondary']),
            ),
          ),
        ),
      ),
    );
  }
}