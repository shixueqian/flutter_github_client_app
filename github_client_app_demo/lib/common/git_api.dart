import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:github_client_app_demo/common/global.dart';
import 'package:github_client_app_demo/models/index.dart';
import 'package:dio/adapter.dart';
import 'dart:developer';
import 'package:http_proxy/http_proxy.dart';

class Git {
  // 在网络请求过程中可能会需要使用当前的context信息，比如在请求失败时
  // 打开一个新路由，而打开新路由需要context信息。
  Git(this.context) {
    _options = Options(extra: {'context': context});
  }

  BuildContext context;
  late Options _options;

  static Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.github.com/',
      headers: {
        HttpHeaders.acceptHeader:
            "application/vnd.github.squirrel-girl-preview,"
                "application/vnd.github.symmetra-preview+json",
      },
    ),
  );

  static void init() {
    // 添加缓存插件
    dio.interceptors.add(Global.netCache);
    // 设置用户token（可能为null，代表未登录）
    dio.options.headers[HttpHeaders.authorizationHeader] = Global.profile.token;

    // Dio请求不走系统代码。传统抓包设置无效。所以需要特别设置
    // Git.addProxy(dio);
    Git.addProxy1();
  }

  static addProxy1() async {
    // 使用http_proxy插件来获取系统的代理，然后进行全局设置，进而能够正常抓包。
    // 但这功能是否对线上造成影响，未知,故只在调试时开启
    if (!Global.isRelease) {
      HttpProxy httpProxy = await HttpProxy.createHttpProxy();
      HttpOverrides.global = httpProxy;
    }
  }

  static addProxy(dio) {
    // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
    if (!Global.isRelease) {
      // DefaultHttpClientAdapter这个需要手动导入dio/adapter.dar;
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        //设置代理抓包，调试用
        client.findProxy = (uri) {
          return 'PROXY 10.14.4.141:8888';
        };
        // 代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
    }
  }


  // 登录接口，登录成功后返回用户信息
  Future<User> login(String login, String pwd) async {
    String basic = 'Basic ' + base64.encode(utf8.encode('$login:$pwd'));
    debugPrint("basic=$basic");
    var r = await dio.get(
      "/user",
      options: _options.copyWith(headers: {
        HttpHeaders.authorizationHeader: basic
      }, extra: {
        'noCache': true, //本接口禁用缓存
      }),
    );
    // log信息很长，直接使用print会在显示会不全。可以使用debugPrint和log来替代。注意log方法是dart:developer里面的
    // debugPrint("r=$r",wrapWidth: 1024);
    log(r.toString());

    // 登录成功后更新公共头（authorization），此后的所有请求都会带上用户身份信息
    dio.options.headers[HttpHeaders.authorizationHeader] = basic;
    // 清空所有缓存
    Global.netCache.cache.clear();
    // 更新profile中的token信息
    Global.profile.token = basic;
    return User.fromJson(r.data);
  }

  // 获取用户项目列表
  Future<List<Repo>> getRepos({
    required Map<String, dynamic> queryParameters,
    refresh = false,
  }) async {
    if (refresh) {
      // 列表下拉刷新，需要删除缓存（拦截器中会读取这些信息）
      _options.extra?.addAll({'refresh': true, 'list': true});
    }
    var r = await dio.get<List>('user/repos',
        queryParameters: queryParameters, options: _options);
    // debugPrint("getRepos=$r",wrapWidth: 1024);
    // log(r.toString());
    return r.data!.map((e) => Repo.fromJson(e)).toList();
  }
}
