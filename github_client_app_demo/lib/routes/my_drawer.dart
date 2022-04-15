import 'package:flutter/material.dart';
import 'package:github_client_app_demo/common/funs.dart';
import 'package:github_client_app_demo/generated/l10n.dart';
import 'package:github_client_app_demo/states/profile_change_notifier.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        // 移除顶部的间距
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),//构建抽屉菜单头部
            Expanded(child: _buildMenus()), //构建功能菜单
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel userModel, Widget? child) {
        return GestureDetector(
          onTap: () {
            if (!userModel.isLogin) Navigator.pushNamed(context, "login");
          },
          child: Container(
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  // 如果已登录，则显示用户头像；若未登录，则显示默认头像
                  child: ClipOval(
                    child: userModel.isLogin
                        ? gmAvatar(userModel.user!.avatar_url,
                            height: 80, width: 80)
                        : Image.asset("imgs/avatar-default.png"),
                  ),
                ),
                Text(
                  userModel.isLogin
                      ? userModel.user!.login
                      : GmLocalizations.of(context).login,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  // 构建菜单项
  Widget _buildMenus() {
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel userModel, Widget? child) {
        var gm = GmLocalizations.of(context);
        return ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: Text(gm.theme),
              onTap: () => Navigator.pushNamed(context, "themes"),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(gm.language),
              onTap: () => Navigator.pushNamed(context, "language"),
            ),
            if (userModel.isLogin)
              ListTile(
                leading: const Icon(Icons.power_settings_new),
                title: Text(gm.logout),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      //退出账号前先弹二次确认窗
                      return AlertDialog(
                        content: Text(gm.logoutTip),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(gm.cancel),
                          ),
                          TextButton(
                            onPressed: () {
                              //该赋值语句会触发MaterialApp rebuild
                              userModel.user = null;
                              Navigator.pop(context);
                            },
                            child: Text(gm.yes),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
