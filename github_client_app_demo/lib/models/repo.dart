import 'package:json_annotation/json_annotation.dart';
import "user.dart";
part 'repo.g.dart';

@JsonSerializable()
class Repo {
  Repo();

  late num id;
  late String name;
  late String full_name;
  late User owner;
  Repo? parent;
  late bool private;
  String? html_url;
  String? description;
  late bool fork;
  String? homepage;
  String? language;
  num? forks_count;
  late num stargazers_count;
  late num watchers_count;
  late num size;
  String? default_branch;
  num? open_issues_count;
  List? topics;
  bool? has_issues;
  bool? has_projects;
  bool? has_wiki;
  bool? has_pages;
  bool? has_downloads;
  String? pushed_at;
  String? created_at;
  String? updated_at;
  Map<String,dynamic>? permissions;
  num? subscribers_count;
  Map<String,dynamic>? license;
  
  factory Repo.fromJson(Map<String,dynamic> json) => _$RepoFromJson(json);
  Map<String, dynamic> toJson() => _$RepoToJson(this);
}
