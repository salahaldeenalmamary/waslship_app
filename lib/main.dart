
import 'package:waslship/src/app.dart';
import 'src/imports/imports.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: '.env');
  
  await AppConfig.init();

  runApp(
    const LocalizationWrapper(
      child: ProviderScope(
        child: App(),
      ),
    ),
  );
}