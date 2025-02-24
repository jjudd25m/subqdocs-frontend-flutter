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

    print("_ViewAttchmentImageState called");

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
    // #enddocregion webview_controller
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
            // Container(
            //   width: double.infinity,
            //   height: MediaQuery.of(context).size.height * 0.4,
            //   child: Zoom(
            //       backgroundColor: AppColors.backgroundWhite,
            //       maxZoomWidth: 1800,
            //       maxZoomHeight: 1800,
            //       centerOnScale: true,
            //       initTotalZoomOut: false,
            //       // zoomSensibility: 0.0,
            //       onTap: () {
            //         print("Widget clicked");
            //       },
            //       onPositionUpdate: (Offset position) {
            //         print(position);
            //       },
            //       onScaleUpdate: (double scale, double zoom) {
            //         print("zoom level is $scale  $zoom");
            //       },
            //       child: CachedNetworkImage(
            //         imageUrl: "https://photographylife.com/wp-content/uploads/2023/05/Nikon-Z8-Official-Samples-00002.jpg",
            //         width: double.infinity,
            //         height: MediaQuery.of(context).size.height * 0.4,
            //       )),
            // ),
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

// class SViewAttchmentImage extends StatelessWidget {
//   String imageUrl = "";
//
//   WebViewController controller = WebViewController()
//     ..setJavaScriptMode(JavaScriptMode.unrestricted)
//     ..setNavigationDelegate(
//       NavigationDelegate(
//         onProgress: (int progress) {
//           // Update loading bar.
//         },
//         onPageStarted: (String url) {},
//         onPageFinished: (String url) {},
//         onHttpError: (HttpResponseError error) {},
//         onWebResourceError: (WebResourceError error) {},
//         onNavigationRequest: (NavigationRequest request) {
//           if (request.url.startsWith('https://www.youtube.com/')) {
//             return NavigationDecision.prevent;
//           }
//           return NavigationDecision.navigate;
//         },
//       ),
//     )
//     ..loadRequest(Uri.parse('https://flutter.dev'));
//
//   ViewAttchmentImage({super.key, required this.imageUrl});
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       elevation: 16,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               height: 50,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: AppColors.backgroundPurple,
//                 borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       // "Right Cheek - 01/23/2025",
//                       "",
//                       style: AppFonts.medium(15, Colors.white),
//                     ),
//                     Spacer(),
//                     GestureDetector(
//                       onTap: () {
//                         Get.back();
//                       },
//                       child: SvgPicture.asset(
//                         ImagePath.logo_cross,
//                         width: 20,
//                         height: 20,
//                         colorFilter: ColorFilter.mode(AppColors.backgroundWhite, BlendMode.srcIn),
//                       ),
//                     ),
//                     SizedBox(width: 10)
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//                 width: double.infinity,
//                 height: MediaQuery.of(context).size.height * 0.7,
//                 child: imageUrl.isNotEmpty
//                     ? ClipRect(
//                         child: PhotoView(
//                         gaplessPlayback: true,
//                         imageProvider: NetworkImage(imageUrl),
//                       ))
//                     : WebViewWidget(controller: controller)),
//             // Container(
//             //   width: double.infinity,
//             //   height: MediaQuery.of(context).size.height * 0.4,
//             //   child: Zoom(
//             //       backgroundColor: AppColors.backgroundWhite,
//             //       maxZoomWidth: 1800,
//             //       maxZoomHeight: 1800,
//             //       centerOnScale: true,
//             //       initTotalZoomOut: false,
//             //       // zoomSensibility: 0.0,
//             //       onTap: () {
//             //         print("Widget clicked");
//             //       },
//             //       onPositionUpdate: (Offset position) {
//             //         print(position);
//             //       },
//             //       onScaleUpdate: (double scale, double zoom) {
//             //         print("zoom level is $scale  $zoom");
//             //       },
//             //       child: CachedNetworkImage(
//             //         imageUrl: "https://photographylife.com/wp-content/uploads/2023/05/Nikon-Z8-Official-Samples-00002.jpg",
//             //         width: double.infinity,
//             //         height: MediaQuery.of(context).size.height * 0.4,
//             //       )),
//             // ),
//             Container(
//               width: double.infinity,
//               color: AppColors.white,
//               child: Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       // "Acne Scar on right cheek.",
//                       "",
//                       style: AppFonts.medium(14, AppColors.textGrey),
//                     ),
//                     Spacer(),
//                     SvgPicture.asset(
//                       ImagePath.edit_outline,
//                       width: 40,
//                       height: 40,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 8,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// Positioned(
//   bottom: 0,
//   left: (MediaQuery.of(context).size.width / 2) - 100,
//   child: Center(
//     child: Container(
//       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//       decoration: BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.5))),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () {},
//             child: SvgPicture.asset(
//               ImagePath.plus,
//               width: 30,
//               height: 30,
//             ),
//           ),
//           SizedBox(width: 10),
//           Text(
//             "100%",
//             style: AppFonts.medium(15, AppColors.textGrey),
//           ),
//           SizedBox(width: 10),
//           GestureDetector(
//             onTap: () {},
//             child: SvgPicture.asset(
//               ImagePath.minus,
//               width: 30,
//               height: 30,
//             ),
//           ),
//           SizedBox(width: 10),
//           VerticalDivider(
//             color: Colors.black,
//             thickness: 2,
//           ),
//           SizedBox(width: 10),
//           GestureDetector(
//             onTap: () {},
//             child: SvgPicture.asset(
//               ImagePath.trash,
//               width: 30,
//               height: 30,
//             ),
//           )
//         ],
//       ),
//     ),
//   ),
// )
