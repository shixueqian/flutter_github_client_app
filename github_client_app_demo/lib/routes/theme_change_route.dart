import 'package:flutter/material.dart';
import 'package:github_client_app_demo/common/global.dart';
import 'package:github_client_app_demo/generated/l10n.dart';
import 'package:github_client_app_demo/states/profile_change_notifier.dart';
import 'package:provider/provider.dart';

class ThemeChangeRoute extends StatelessWidget {
  const ThemeChangeRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GmLocalizations.of(context).theme),
      ),
      //显示主题色块
      body: ListView(
        children: Global.themes.map((e){
          return GestureDetector(
            onTap: (){
              //主题更新后，MaterialApp会重新build
              Provider.of<ThemeModel>(context,listen: false).theme = e;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 16),
              child: Container(color: e,height: 40,),
            ),
          );
        }).toList(),
      ),
    );
  }
}

