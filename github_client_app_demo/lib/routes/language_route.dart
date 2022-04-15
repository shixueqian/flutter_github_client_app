import 'package:flutter/material.dart';
import 'package:github_client_app_demo/generated/l10n.dart';
import 'package:github_client_app_demo/states/profile_change_notifier.dart';
import 'package:provider/provider.dart';

class LanguageRoute extends StatelessWidget {
  const LanguageRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).primaryColor;
    // 直接使用Provider.of和使用Comsumer差不多的效果
    var localeModel = Provider.of<LocalModel>(context);
    var gm = GmLocalizations.of(context);
    // 这里在build里面编写方法是因为方便使用上下文的参数
    Widget _buildLanguageItem(String language, locale) {
      return ListTile(
        title: Text(
          language,
          // 对APP当前语言进行高亮显示
          style: TextStyle(
            color: localeModel.locale == locale ? color : null,
          ),
        ),
        trailing: Icon(localeModel.locale == locale ? Icons.done : null),
        onTap: () {
          // 此行代码会通知MaterialApp重新build
          localeModel.locale = locale;
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(gm.language),
      ),
      body: ListView(
        children: [
          _buildLanguageItem("中文简体", "zh_CN"),
          _buildLanguageItem("English", "en_US"),
          _buildLanguageItem(gm.auto, null),
        ],
      ),
    );
  }
}
