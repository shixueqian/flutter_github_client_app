// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class GmLocalizations {
  GmLocalizations();

  static GmLocalizations? _current;

  static GmLocalizations get current {
    assert(_current != null,
        'No instance of GmLocalizations was loaded. Try to initialize the GmLocalizations delegate before accessing GmLocalizations.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<GmLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = GmLocalizations();
      GmLocalizations._current = instance;

      return instance;
    });
  }

  static GmLocalizations of(BuildContext context) {
    final instance = GmLocalizations.maybeOf(context);
    assert(instance != null,
        'No instance of GmLocalizations present in the widget tree. Did you add GmLocalizations.delegate in localizationsDelegates?');
    return instance!;
  }

  static GmLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<GmLocalizations>(context, GmLocalizations);
  }

  /// `Auto`
  String get auto {
    return Intl.message(
      'Auto',
      name: 'auto',
      desc: '',
      args: [],
    );
  }

  /// `cancel`
  String get cancel {
    return Intl.message(
      'cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Github`
  String get home {
    return Intl.message(
      'Github',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `logout`
  String get logout {
    return Intl.message(
      'logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to quit your current account?`
  String get logoutTip {
    return Intl.message(
      'Are you sure you want to quit your current account?',
      name: 'logoutTip',
      desc: '',
      args: [],
    );
  }

  /// `No description yet !`
  String get noDescription {
    return Intl.message(
      'No description yet !',
      name: 'noDescription',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Password required!`
  String get passwordRequired {
    return Intl.message(
      'Password required!',
      name: 'passwordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get setting {
    return Intl.message(
      'Setting',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Flutter APP`
  String get title {
    return Intl.message(
      'Flutter APP',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `User Name`
  String get userName {
    return Intl.message(
      'User Name',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `User name or password is not correct!`
  String get userNameOrPasswordWrong {
    return Intl.message(
      'User name or password is not correct!',
      name: 'userNameOrPasswordWrong',
      desc: '',
      args: [],
    );
  }

  /// `User name required!`
  String get userNameRequired {
    return Intl.message(
      'User name required!',
      name: 'userNameRequired',
      desc: '',
      args: [],
    );
  }

  /// `yes`
  String get yes {
    return Intl.message(
      'yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<GmLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<GmLocalizations> load(Locale locale) => GmLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
