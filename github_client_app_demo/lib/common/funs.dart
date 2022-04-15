import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';

// 这是一个全局方法
Widget gmAvatar(
  String url, {
  double width = 30,
  required double height,
  BoxFit? fit,
  BorderRadius? borderRadius,
}) {
  var placeholder = Image.asset(
    "imgs/avatar-default.png",
    width: width,
    height: height,
  );
  return ClipRRect(
    borderRadius: borderRadius ?? BorderRadius.circular(2),
    // 这里使用了cached_network_image包，可以方便地处理占位图
    child: CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => placeholder,
      errorWidget: (context, url, error) => placeholder,
    ),
  );
}

void showToast(
  String text, {
  gravity = ToastGravity.CENTER,
  toastLength = Toast.LENGTH_SHORT,
}) {
  // 这里使用Fluttertoast包
  Fluttertoast.showToast(
    msg: text,
    toastLength: toastLength,
    gravity: gravity,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.grey[600],
    fontSize: 16,
  );
}

void showLoading(context, [String? text]) {
  text = text ?? "loading";
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (content) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          constraints: const BoxConstraints(minWidth: 180, minHeight: 120),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  text!,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
