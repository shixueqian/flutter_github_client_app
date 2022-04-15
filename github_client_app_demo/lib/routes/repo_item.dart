import 'package:flutter/material.dart';
import 'package:github_client_app_demo/common/funs.dart';
import 'package:github_client_app_demo/common/icons.dart';
import 'package:github_client_app_demo/generated/l10n.dart';
import 'package:github_client_app_demo/models/repo.dart';

class RepoItem extends StatefulWidget {
  const RepoItem({Key? key, required this.repo}) : super(key: key);

  final Repo repo;

  @override
  State<RepoItem> createState() => _RepoItemState();
}

class _RepoItemState extends State<RepoItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      // Material这个widget本身没有实际效果，但是可以设置阴影，形状，阴影，颜色，文字格式等
      child: Material(
        color: Colors.white,
        // BorderDirectional跟Border功能一致，不过BorderDirectional能适配阿拉伯布局
        shape: BorderDirectional(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: .5),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                dense: true,
                //项目owner头像
                leading: gmAvatar(
                  widget.repo.owner.avatar_url,
                  height: 24,
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Text(
                  widget.repo.owner.login,
                  textScaleFactor: .9,
                ),
                trailing: Text(widget.repo.language ?? '--'),
              ),
              // 构建项目标题和简介
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.repo.fork
                          ? widget.repo.full_name
                          : widget.repo.name,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontStyle: widget.repo.fork
                              ? FontStyle.italic
                              : FontStyle.normal),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 12),
                      child: widget.repo.description == null
                          ? Text(
                              GmLocalizations.of(context).noDescription,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[700],
                              ),
                            )
                          : Text(
                              widget.repo.description ?? "",
                              style: TextStyle(
                                height: 1.15,
                                color: Colors.blueGrey[700],
                                fontSize: 13,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              // 构建卡片底部信息
              _buildBottom(),
            ],
          ),
        ),
      ),
    );
  }
  // 构建卡片底部信息
  Widget _buildBottom() {
    const paddingWidth = 10;
    return IconTheme(
      data: const IconThemeData(
        color: Colors.grey,
        size: 15,
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.grey, fontSize: 12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Builder(
            builder: (context) {
              var children = <Widget>[
                const Icon(Icons.star),
                Text(" " +
                    widget.repo.stargazers_count
                        .toString()
                        .padRight(paddingWidth)),
                const Icon(Icons.info_outline),
                Text(" " +
                    widget.repo.open_issues_count
                        .toString()
                        .padRight(paddingWidth)),
                //我们的自定义图标
                const Icon(MyIcons.fork),
                Text(widget.repo.forks_count.toString().padRight(paddingWidth)),
              ];

              // children里面可以直接用 if else ，需要注意
              if (widget.repo.fork) {
                // padRight对字符串进行右填充(就是左对齐)
                children.add(Text("Forked".padRight(paddingWidth)));
              }
              if (widget.repo.private == true) {
                children.addAll([
                  const Icon(Icons.lock),
                  Text(" private".padRight(paddingWidth)),
                ]);
              }
              return Row(
                children: children,
              );
            },
          ),
        ),
      ),
    );
  }
}
