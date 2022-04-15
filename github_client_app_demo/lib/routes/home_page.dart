import 'package:flutter/material.dart';
import 'package:github_client_app_demo/common/git_api.dart';
import 'package:github_client_app_demo/generated/l10n.dart';
import 'package:github_client_app_demo/models/repo.dart';
import 'package:github_client_app_demo/routes/my_drawer.dart';
import 'package:github_client_app_demo/routes/repo_item.dart';
import 'package:github_client_app_demo/states/profile_change_notifier.dart';
import 'package:provider/provider.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  // 表尾标记
  static const loadingTag = "##loading##";
  final _items = <Repo>[Repo()..name = loadingTag];

  // 是否还有数据
  bool hasMore = true;

  // 当前请求的是第几页
  int page = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GmLocalizations.of(context).title),
      ),
      body: _buildBody(), // 构建主页面
      drawer: const MyDrawer(), //抽屉菜单
    );
  }

  // 构建主页面
  Widget _buildBody() {
    UserModel userModel = Provider.of<UserModel>(context);

    //用户未登录，显示登录按钮
    if (!userModel.isLogin) {
      return Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, "login");
          },
          child: Text(GmLocalizations.of(context).login),
        ),
      );
    }
    debugPrint("_items.length=${_items.length}");

    //已登录，则显示项目列表
    return ListView.separated(
      itemBuilder: (context, index) {
        //如果到了表尾
        if (_items[index].name == loadingTag) {
          debugPrint("_items[index].name == loadingTag");

          if (hasMore) { //不足100条，继续获取数据
            //获取数据
            _retrieveData();
            //加载时显示loading
            return Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              width: 24,
              height: 24,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          } else {
            //已经加载了100条数据，不再获取数据。
            return Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: const Text(
                "没有更多了",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
        }
        //显示单词列表项
        return RepoItem(
          repo: _items[index],
        );
      },
      separatorBuilder: (context, index) => const Divider(
        height: .0,
      ),
      itemCount: _items.length,
    );
  }

  //请求数据
  Future<void> _retrieveData() async {
    var data = await Git(context).getRepos(
      queryParameters: {
        'page': page,
        'page_size': 20,
      },
    );
    // debugPrint("data=$data",wrapWidth: 1024);
    //如果返回的数据小于指定的条数，则表示没有更多数据，反之则否
    hasMore = data.isNotEmpty && data.length % 20 == 0;
    //把请求到的新数据添加到items中
    setState(() {
      _items.insertAll(_items.length - 1, data);
      page++;
    });
  }
}
