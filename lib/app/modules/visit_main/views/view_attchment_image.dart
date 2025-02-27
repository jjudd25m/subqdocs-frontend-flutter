import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:photo_view/photo_view.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/utils/imagepath.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zoom_widget/zoom_widget.dart';

import '../../../core/common/logger.dart';

class ViewAttchmentImage extends StatefulWidget {
  String imageUrl = "";
  String attchmentUrl = "";

  late final WebViewController controller;

  ViewAttchmentImage({super.key, required this.imageUrl, required this.attchmentUrl});

  @override
  State<ViewAttchmentImage> createState() => _ViewAttchmentImageState();
}

class _ViewAttchmentImageState extends State<ViewAttchmentImage> {
  void initState() {
    super.initState();

    customPrint("_ViewAttchmentImageState called");

    // #docregion webview_controller
    widget.controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://flutter.dev'));
    widget.controller.loadRequest(Uri.https(widget.attchmentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.backgroundPurple,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      // "Right Cheek - 01/23/2025",
                      "",
                      style: AppFonts.medium(15, Colors.white),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: SvgPicture.asset(
                        ImagePath.logo_cross,
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(AppColors.backgroundWhite, BlendMode.srcIn),
                      ),
                    ),
                    SizedBox(width: 10)
                  ],
                ),
              ),
            ),
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.7,
                child: widget.imageUrl.isNotEmpty
                    ? ClipRect(
                        child: PhotoView(
                        gaplessPlayback: true,
                        imageProvider: NetworkImage(widget.imageUrl),
                      ))
                    : WebViewWidget(controller: widget.controller)),
            Container(
              width: double.infinity,
              color: AppColors.white,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      // "Acne Scar on right cheek.",
                      "",
                      style: AppFonts.medium(14, AppColors.textGrey),
                    ),
                    Spacer(),
                    SvgPicture.asset(
                      ImagePath.edit_outline,
                      width: 40,
                      height: 40,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8,
            )
          ],
        ),
      ),
    );
  }
}
