import 'package:flutter/material.dart';
import 'package:github_client_app_demo/routes/home_page.dart';
import 'package:github_client_app_demo/routes/language_route.dart';
import 'package:github_client_app_demo/routes/login_route.dart';
import 'package:github_client_app_demo/routes/theme_change_route.dart';
import 'package:github_client_app_demo/states/profile_change_notifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'common/global.dart';
import 'generated/l10n.dart';

void main() {
  // 注意这里的init方法不能有异常，不然执行会有问题
  Global.init().then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ThemeModel()),
        ChangeNotifierProvider.value(value: UserModel()),
        ChangeNotifierProvider.value(value: LocalModel()),
      ],
      child: Consumer2<ThemeModel, LocalModel>(
        builder: (BuildContext context, themeModel, localeModel, child) {
          return MaterialApp(
            // primaryColor是primarySwatch的一种[500]，设置primarySwatch会更好，覆盖的范围更大
            theme: ThemeData(primarySwatch: themeModel.theme),
            // 跟title差不多，但是onGenerateTitle可以做本地化
            onGenerateTitle: (context) {
              // GmLocalizations是通过Intl插件工具生成的，本来默认类名是S，在pubspec.yaml底下改成了这个
              return GmLocalizations.of(context).title;
            },
            home: const HomeRoute(),
            // 设置语言
            locale: localeModel.getLocale(),
            // 设置支持的语言，使用Intl插件工具后，直接使用就好
            supportedLocales: GmLocalizations.delegate.supportedLocales,
            // 设置本地化代理
            localizationsDelegates: const [
              GmLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            // 对语言做特殊处理
            localeResolutionCallback: (_locale, supportedLocales) {
              if (localeModel.getLocale() != null) {
                // 如果已经选定语言，则不跟随系统
                return localeModel.getLocale();
              } else {
                // localeModel没有设置，则优先选择当前系统语言，若不支持，则默认英文
                Locale locale;
                if (supportedLocales.contains(_locale)) {
                  locale = _locale!;
                } else {
                  // 如果系统语言不是中文简体或美国英语，则默认使用美国英语
                  locale = const Locale('en', 'US');
                }
                return locale;
              }
            },
            // 注册路由表
            routes: <String, WidgetBuilder>{
              "login": (context) => const LoginRoute(),
              "language": (context) => const LanguageRoute(),
              "themes": (context) => const ThemeChangeRoute(),
            },
          );
        },
      ),
    );
  }
}
