import 'package:flutter/material.dart';
import 'package:github_client_app_demo/common/global.dart';
import 'package:github_client_app_demo/models/index.dart';

class ProfileChangeNotifier extends ChangeNotifier {
  Profile get _profile => Global.profile;

  // 这里重写了notifyListeners方法，并且后面的Model都集成了本类
  // 主要目的是在其他Model类调用了notifyListeners()后能保存Profile变更
  @override
  void notifyListeners() {
    // 保存Profile变更
    Global.saveProfile();
    // 通知依赖的Widget更新
    super.notifyListeners();
  }
}

class UserModel extends ProfileChangeNotifier {
  User? get user => _profile.user;

  // APP是否登录(如果有用户信息，则证明登录过)
  bool get isLogin => user != null;

  //用户信息发生变化，更新用户信息并通知依赖它的子孙Widgets更新
  set user(User? user) {
    if (user?.login != _profile.user?.login) {
      _profile.lastLogin = _profile.user?.login;
      _profile.user = user;
      notifyListeners();
    }
  }
}

class ThemeModel extends ProfileChangeNotifier {
  // 注意这里将color和value进行了转换 set:color->value get:value->color
  // 获取当前主题，如果为设置主题，则默认使用蓝色主题
  MaterialColor get theme {
    return Global.themes.firstWhere(
      (e) {
        return e.value == (_profile.theme ?? 0);
      },
      orElse: () => Colors.blue,
    );
  }

  // 主题改变后，通知其依赖项，新主题会立即生效
  set theme(MaterialColor color) {
    if (color != theme) {
      _profile.theme = color[500]?.value as num;
      notifyListeners();
    }
  }
}

class LocalModel extends ProfileChangeNotifier {
  // 获取当前用户的APP语言配置Locale类，如果为null，则语言跟随系统语言
  Locale? getLocale() {
    if (_profile.locale == null) return null;
    // 字符串传Locale
    var t = _profile.locale!.split('_');
    return Locale(t[0], t[1]);
  }

  // 获取当前Locale的字符串表示
  String? get locale => _profile.locale;

  // 用户改变APP语言后，通知依赖项更新，新语言会立即生效
  set locale(String? locale) {
    if (locale != _profile.locale) {
      _profile.locale = locale;
      notifyListeners();
    }
  }
}
