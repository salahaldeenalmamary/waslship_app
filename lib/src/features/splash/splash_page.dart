import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waslship/src/app/routing/app_router.gr.dart';

import '../../app/providers/auth/auth_providers.dart';
import '../../app/providers/auth/auth_state.dart';

@RoutePage()
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  bool _canNavigate = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.forward();

    _startSplashTimer();
  }

  Future<void> _startSplashTimer() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    _canNavigate = true;

    _tryNavigate(ref.read(authNotifierProvider));
  }

  void _tryNavigate(AuthState state) {
    if (!_canNavigate || _navigated || !mounted) return;

    if (state.status == AuthStatus.initial) {
      return;
    }

    _navigated = true;

    if (state.status == AuthStatus.authenticated) {
      context.router.replace(const AppShellRoute());
    } else {
      context.router.replace(const LoginRoute());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(
      authNotifierProvider,
      (_, next) {
        _tryNavigate(next);
      },
    );

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withOpacity(.3),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.local_shipping_rounded,
                  size: 50,
                  color: colors.onPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'وصل شيب',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.primary,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '|',
                      style: textTheme.headlineMedium?.copyWith(
                        color: const Color(0xFFC5A059),
                      ),
                    ),
                  ),
                  Text(
                    'WaslShip',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFC5A059),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'بوابة الأعمال الإلكترونية',
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}