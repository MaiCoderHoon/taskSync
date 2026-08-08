import 'package:flutter/material.dart';
import 'package:tasksync/data/models/project_model.dart';
import 'package:tasksync/theme/theme.dart';

/// ─── AVATAR WIDGET ────────────────────────────────────────────────────────
/// Shows the person's initials with their unique color.
/// [bordered] adds a white ring — used in stacked groups.

class AvatarWidget extends StatelessWidget {
  final Person person;
  final double size;
  final bool bordered;

  const AvatarWidget({
    super.key,
    required this.person,
    this.size = 30,
    this.bordered = false,
  });

  String get _initials {
    final parts = person.name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.avatarFor(person.name);

    Widget circle = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bg,
        border: bordered
            ? Border.all(color: AppColors.avatarRing, width: 2.5)
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: TextStyle(
          fontFamily: 'DM Mono',
          fontSize: size * 0.36,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          height: 1,
        ),
      ),
    );

    return circle;
  }
}

/// ─── AVATAR STACK ─────────────────────────────────────────────────────────
/// Overlapping avatar group — at most [max] avatars shown.

class AvatarStack extends StatelessWidget {
  final List<Person> people;
  final double size;
  final int max;

  const AvatarStack({
    super.key,
    required this.people,
    this.size = 26,
    this.max = 3,
  });

  @override
  Widget build(BuildContext context) {
    final shown = people.take(max).toList();
    final overlap = size * 0.28;

    return SizedBox(
      width: size + (shown.length - 1) * (size - overlap),
      height: size,
      child: Stack(
        children: List.generate(shown.length, (i) {
          return Positioned(
            left: i * (size - overlap),
            child: AvatarWidget(person: shown[i], size: size, bordered: true),
          );
        }),
      ),
    );
  }
}
