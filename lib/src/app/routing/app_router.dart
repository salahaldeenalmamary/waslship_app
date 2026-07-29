import 'package:auto_route/auto_route.dart';
import 'package:waslship/src/app/routing/global_navigator.dart';

import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter() : super(navigatorKey: rootNavigatorKey);

  @override
  List<AutoRoute> get routes => [
      AutoRoute(
      page: SplashRoute.page,
      path: '/',
      initial: true,
    ),
    // ── Elite Feature ──────────────────────────────────────────────
    // Login is a standalone push before entering the shell
    AutoRoute(page: LoginRoute.page,),
    AutoRoute(page: RegisterRoute.page),
    AutoRoute(page: ForgotPasswordRoute.page),
    AutoRoute(page: OtpRoute.page),
    AutoRoute(page: ResetPasswordRoute.page),

    // Shell with 4 bottom-nav tabs
    AutoRoute(
      page: AppShellRoute.page,
      children: [
        AutoRoute(page: DashboardRoute.page, initial: true),
        AutoRoute(page: ShipmentsRoute.page),
        AutoRoute(page: WalletRoute.page),
        AutoRoute(page: SettingsRoute.page),
      ],
    ),

    // Secondary screens pushed on top of the shell
    AutoRoute(page: TrackRoute.page),
    AutoRoute(page: NotificationsRoute.page),
    AutoRoute(page: TopUpRoute.page),
    AutoRoute(page: TopUpSuccessRoute.page),
    AutoRoute(page: BankTransferRoute.page),
    AutoRoute(page: AddressesRoute.page),
    AutoRoute(page: AddLocationRoute.page),
  ];
}
