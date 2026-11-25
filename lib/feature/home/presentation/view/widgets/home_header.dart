import '../../../../../shared/widgets/shared_widgets.dart';

class HomeHeader extends StatelessWidget {
  final String? locationLabel;
  final VoidCallback onLocationTap;
  final VoidCallback onBellTap;

  const HomeHeader({
    super.key,
    required this.locationLabel,
    required this.onLocationTap,
    required this.onBellTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onLocationTap,
            child: Row(
              children: [
                const GlassIcon(icon: Icons.location_on_rounded),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      MainText(
                        l10n.deliver_to,
                        fontSize: 11.5,
                        color: Colors.white.withValues(alpha: 0.78),
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: MainText(
                              locationLabel ?? l10n.select_location,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onBellTap,
          child: const GlassIcon(icon: Icons.notifications_none_rounded),
        ),
      ],
    );
  }
}

class GlassIcon extends StatelessWidget {
  final IconData icon;
  final double size;

  const GlassIcon({super.key, required this.icon, this.size = 42});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Icon(icon, color: Colors.white, size: size * 0.5),
    );
  }
}
