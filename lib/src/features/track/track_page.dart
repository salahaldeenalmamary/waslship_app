import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../widgets/elite_top_bar.dart';

/// Elite track page — animated vertical timeline.
/// Mirrors the Track screen from waslship-elite.
@RoutePage()
class TrackPage extends StatefulWidget {
  const TrackPage({super.key});

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage>
    with SingleTickerProviderStateMixin {
  int _activeStep = 2;
  late AnimationController _animController;
  late Animation<double> _progressAnim;

  static const _steps = [
    _TrackStep(
      title: 'تم الاستلام',
      location: 'الرياض، مستودع السلي',
      time: '٢٤ أكتوبر، ٠٨:٠٠ ص',
      icon: Icons.inventory_2_outlined,
    ),
    _TrackStep(
      title: 'في مركز الفرز',
      location: 'الرياض، المركز الرئيسي',
      time: '٢٤ أكتوبر، ١١:٣٠ ص',
      icon: Icons.navigation_rounded,
    ),
    _TrackStep(
      title: 'قيد التوصيل',
      location: 'الرياض، في الطريق إليك',
      time: '٢٥ أكتوبر، ٠٩:١٥ ص',
      icon: Icons.local_shipping_rounded,
    ),
    _TrackStep(
      title: 'تم التسليم',
      location: 'الرياض، حي النرجس',
      time: 'متوقع اليوم',
      icon: Icons.check_circle_outline_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _progressAnim =
        Tween<double>(begin: 0, end: _activeStep / (_steps.length - 1)).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
        );
    _animController.forward();
  }

  void _setStep(int step) {
    final target = step / (_steps.length - 1);
    _progressAnim = Tween<double>(begin: _progressAnim.value, end: target)
        .animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
        );
    _animController.forward(from: 0);
    setState(() => _activeStep = step);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: EliteTopBar(title: 'تتبع الشحنة', showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            // ── Shipment ID Card ───────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colors.outlineVariant.withValues(alpha: 0.35),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'رقم الشحنة',
                    style: textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '#BL-44821',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.blue.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_shipping_rounded,
                          size: 16,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'قيد التوصيل',
                          style: textTheme.titleSmall?.copyWith(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Timeline ───────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colors.outlineVariant.withValues(alpha: 0.35),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'خريطة تتبع الشحنة',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedBuilder(
                    animation: _animController,
                    builder: (context, _) => _Timeline(
                      steps: _steps,
                      activeStep: _activeStep,
                      progress: _progressAnim.value,
                      onStepTap: _setStep,
                      colors: colors,
                      textTheme: textTheme,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackStep {
  const _TrackStep({
    required this.title,
    required this.location,
    required this.time,
    required this.icon,
  });

  final String title;
  final String location;
  final String time;
  final IconData icon;
}

class _Timeline extends StatelessWidget {
  const _Timeline({
    required this.steps,
    required this.activeStep,
    required this.progress,
    required this.onStepTap,
    required this.colors,
    required this.textTheme,
  });

  final List<_TrackStep> steps;
  final int activeStep;
  final double progress;
  final ValueChanged<int> onStepTap;
  final ColorScheme colors;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Vertical line background
        Positioned(
          right: 23,
          top: 24,
          bottom: 24,
          child: Container(
            width: 4,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        // Animated fill
        Positioned(
          right: 23,
          top: 24,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            width: 4,
            height:
                progress *
                ((steps.length - 1) * 72.0), // approx height per step
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        // Steps
        Column(
          children: List.generate(steps.length, (i) {
            final step = steps[i];
            final isCompleted = i <= activeStep;
            final isActive = i == activeStep;

            return GestureDetector(
              onTap: () => onStepTap(i),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isCompleted ? 1.0 : 0.4,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon circle
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        width: isActive ? 50 : 46,
                        height: isActive ? 50 : 46,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? colors.primary
                              : isCompleted
                              ? colors.primaryContainer
                              : colors.surfaceContainerHighest,
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: colors.primary.withValues(
                                      alpha: 0.35,
                                    ),
                                    blurRadius: 16,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(
                          step.icon,
                          size: isActive ? 22 : 18,
                          color: isActive
                              ? colors.onPrimary
                              : isCompleted
                              ? colors.primary
                              : colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step.title,
                                style: textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isActive
                                      ? colors.primary
                                      : colors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 13,
                                    color: colors.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 3),
                                  Expanded(
                                    child: Text(
                                      step.location,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colors.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                step.time,
                                style: textTheme.labelSmall?.copyWith(
                                  color: colors.outline,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                                textDirection: TextDirection.ltr,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
