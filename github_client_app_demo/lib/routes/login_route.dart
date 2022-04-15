import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:github_client_app_demo/common/funs.dart';
import 'package:github_client_app_demo/common/global.dart';
import 'package:github_client_app_demo/generated/l10n.dart';
import 'package:github_client_app_demo/models/user.dart';
import 'package:github_client_app_demo/common/git_api.dart';
import 'package:dio/dio.dart';
import 'package:github_client_app_demo/states/profile_change_notifier.dart';
import 'package:provider/provider.dart';

class LoginRoute extends StatefulWidget {
  const LoginRoute({Key? key}) : super(key: key);

  @override
  State<LoginRoute> createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  // 用户框和密码框的controller
  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  // 是否显示密码明文
  bool pwdShow = false;
  final GlobalKey _formKey = GlobalKey<FormState>();
  bool _nameAutoFocus = true;

  @override
  void initState() {
    // 自动填充上次登录的用户名，填充后将焦点定位到密码输入框
    _unameController.text = Global.profile.lastLogin ?? "";
    if (_unameController.text.isNotEmpty) {
      _nameAutoFocus = false;
    }

    // 这里预置了账号和token，因为token太长了，懒得输入
    //_unameController.text = "xxx@163.com";
    //_pwdController.text = "123tokentoken123";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var gm = GmLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(gm.login),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autofocus: _nameAutoFocus,
                controller: _unameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  hintText: gm.userName,
                  labelText: gm.userName,
                ),
                // 校验用户名（不能为空）
                validator: (v) {
                  return v == null || v.trim().isNotEmpty
                      ? null
                      : gm.userNameRequired;
                },
              ),
              TextFormField(
                autofocus: !_nameAutoFocus,
                controller: _pwdController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  hintText: gm.password,
                  labelText: gm.password,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        pwdShow = !pwdShow;
                      });
                    },
                    icon:
                        Icon(pwdShow ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
                // 注意pwdShow的配合使用
                obscureText: !pwdShow,
                //校验密码（不能为空）
                validator: (v) {
                  return v == null || v.trim().isNotEmpty
                      ? null
                      : gm.passwordRequired;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ConstrainedBox(
                  // 设置登录按钮的高度
                  constraints: const BoxConstraints.expand(height: 55),
                  child: ElevatedButton(
                    onPressed: _onLogin,
                    child: Text(gm.login),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onLogin() async {
    // 验证表单字段是否合法
    if (!(_formKey.currentState as FormState).validate()) {
      return;
    }
    User? user;
    try {
      // 显示loading框
      showLoading(context);
      // 登录请求
      user =
          await Git(context).login(_unameController.text, _pwdController.text);
      // 设置user，listen为false代表更新后不需要触发更新。因为登录页返回后，首页会build。
      Provider.of<UserModel>(context, listen: false).user = user;
    } on DioError catch (e) {
      debugPrint("e=$e", wrapWidth: 1024);
      // 登录失败提示
      if (e.response?.statusCode == 401) {
        log(e.response.toString());
        showToast(GmLocalizations.of(context).userNameOrPasswordWrong);
      } else {
        showToast(e.toString());
      }
    } finally {
      // 隐藏loading框
      Navigator.of(context).pop();
    }
    // 登录成功则返回上一页(首页)
    if (user != null) {
      debugPrint("user=$user");
      Navigator.of(context).pop();
    }
  }
}
