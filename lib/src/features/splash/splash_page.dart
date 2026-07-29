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
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isNavigated = false;
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
    _checkAuthAndNavigate();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for minimum splash duration
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted || _isNavigated) return;

    // Read current auth state
    final authState = ref.read(authNotifierProvider);

    // Check if still initializing
    if (authState.status == AuthStatus.initial) {
     ref.listenManual(
        authNotifierProvider,
        (prev, next) {
          if (next.status != AuthStatus.initial) {
        
            if (mounted && !_isNavigated) {
              _navigateBasedOnAuth(next);
            }
          }
        },
      );
    } else {
      // Already initialized, navigate immediately
      _navigateBasedOnAuth(authState);
    }
  }

  void _navigateBasedOnAuth(AuthState authState) {
    if (!mounted || _isNavigated) return;
    _isNavigated = true;

    if (authState.status == AuthStatus.authenticated) {
      context.router.replace(const AppShellRoute());
    } else {
      context.router.replace(const LoginRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
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
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withOpacity(0.3),
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

              // App Name
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