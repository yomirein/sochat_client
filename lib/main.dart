import 'package:flutter/material.dart';
import 'package:sochat_client/modules/keys/key_service.dart';
import 'package:sochat_client/so_ui/chatscreen/chat_screen.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';
import 'package:sochat_client/so_ui/loginscreen/login_screen.dart';
import 'package:sochat_client/so_ui/themes/colors.dart';
import 'package:sochat_client/so_ui/themes/dark/dark_theme.dart';
import 'package:sochat_client/so_ui/themes/light/light_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() {
  runApp(const ProviderScope(child: SoChat()));
}

class SoChat extends ConsumerWidget {
  const SoChat({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = DarkTheme.extensions
        .whereType<AppColors>()
        .first;
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        extensions: DarkTheme.extensions,
        useMaterial3: false,
        fontFamily: 'Inter',

        primaryColor: colors.primary,
        primaryColorDark: colors.primary,
        primaryColorLight: colors.primary,

        hoverColor: colors.contrastColor.withOpacity(0.05),
        splashFactory: NoSplash.splashFactory,
        highlightColor: colors.contrastColor.withOpacity(0.10),

        colorScheme: ColorScheme.light(
          primary: colors.primary,
        ),

        textTheme: TextTheme(
            titleLarge: TextStyle(
                fontSize: 18,
                color: colors.textPrimary,
                fontWeight: FontWeight.w500,
            ),

            bodyLarge: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: colors.textPrimary,
            ),

            labelLarge: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: colors.textSecondary,
            ),

            titleMedium: TextStyle(
                fontSize: 15,
                color: colors.textPrimary,
                fontWeight: FontWeight.w500,
            ),

            bodyMedium: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: colors.textPrimary,
            ),

            labelMedium: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: colors.textSecondary,
            ),

            titleSmall: TextStyle(
                fontSize: 12,
                color: colors.textPrimary,
                fontWeight: FontWeight.w500,

            ),

            bodySmall: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: colors.textPrimary,
            ),

            labelSmall: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: colors.textSecondary,
              letterSpacing: 0.1,
            )
        ),



        iconTheme: IconThemeData(
          color: colors.textPrimary,
          size: 24,
        ),
        
        appBarTheme: AppBarTheme(
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        scaffoldBackgroundColor: colors.background,



        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: colors.foreground,
            shadowColor: Colors.transparent,
            alignment: Alignment.center,
            padding: EdgeInsets.zero,
          ),
        ),

        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      title: 'SoChat design test',
      home: const SoDesignPage(title: 'SoChat Test app'),
      themeMode: null,
    );
  }
}

class SoDesignPage extends ConsumerStatefulWidget {
  const SoDesignPage({super.key, required this.title});
  final String title;

  @override
  ConsumerState<SoDesignPage> createState() => _SoDesignPageState();
}

class _SoDesignPageState extends ConsumerState<SoDesignPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            TextButton(onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
                child: Text("Login")),
            TextButton(onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatScreen()));
            }, child: Text("Chat")),
            TextButton(onPressed: () {}, child: Text("Settings")),
          ],
        ),
      ),
    );
  }
}
