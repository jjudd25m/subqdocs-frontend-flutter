import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/utils/imagepath.dart';

import '../../../core/common/logger.dart';

class ViewAttachmentImage extends StatefulWidget {
  String imageUrl = "";
  String attachmentUrl = "";

  // late final WebViewController controller;

  ViewAttachmentImage({super.key, required this.imageUrl, required this.attachmentUrl});

  @override
  State<ViewAttachmentImage> createState() => _ViewAttachmentImageState();
}

class _ViewAttachmentImageState extends State<ViewAttachmentImage> {
  void initState() {
    super.initState();

    customPrint("_ViewAttchmentImageState called");
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 16,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              width: double.infinity,
              decoration: const BoxDecoration(color: AppColors.backgroundPurple, borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
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
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5), child: SvgPicture.asset(ImagePath.logo_cross, width: 25, height: 25, colorFilter: const ColorFilter.mode(AppColors.backgroundWhite, BlendMode.srcIn))),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
            SizedBox(width: double.infinity, height: MediaQuery.of(context).size.height * 0.7, child: widget.imageUrl.isNotEmpty ? ClipRect(child: PhotoView(gaplessPlayback: true, imageProvider: NetworkImage(widget.imageUrl))) : const SizedBox(width: 10)),
            // WebViewWidget(controller: widget.controller))
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
                    const Spacer(),
                    SvgPicture.asset(ImagePath.edit_outline, width: 40, height: 40),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
//
// import 'dart:typed_data';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class ViewAttachmentImage extends StatefulWidget {
//   final String imageUrl;
//   final String attachmentUrl;
//   final Dio dioInstance;
//
//   const ViewAttachmentImage({super.key, required this.imageUrl, required this.attachmentUrl, required this.dioInstance});
//
//   @override
//   State<ViewAttachmentImage> createState() => _ViewAttachmentImageState();
// }
//
// class _ViewAttachmentImageState extends State<ViewAttachmentImage> {
//   late final CacheManager _cacheManager;
//   CancelToken? _cancelToken;
//   ImageProvider? _imageProvider;
//   bool _isLoading = true;
//   bool _hasError = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // _cacheManager = CacheManager(Config('custom_cache_key', stalePeriod: const Duration(days: 30), maxNrOfCacheObjects: 100));
//
//     _cacheManager = CacheManager(
//       Config(
//         'customCacheKey',
//         stalePeriod: const Duration(days: 30),
//         maxNrOfCacheObjects: 100, // Reduce if you don't need many cached files
//         // repo: JsonCacheInfoRepository(databaseName: 'custom_cache_db'), // Optional
//       ),
//     );
//
//     _loadImage();
//   }
//
//   Future<void> _loadImage() async {
//     if (!mounted) return;
//
//     setState(() {
//       _isLoading = true;
//       _hasError = false;
//     });
//
//     _cancelToken = CancelToken();
//
//     try {
//       // Try to get from cache first
//       final file = await _cacheManager.getSingleFile(widget.imageUrl);
//       if (mounted) {
//         setState(() {
//           _imageProvider = FileImage(file);
//           _isLoading = false;
//         });
//       }
//
//       // Refresh in background
//       final response = await widget.dioInstance.get<Uint8List>(widget.imageUrl, options: Options(responseType: ResponseType.bytes), cancelToken: _cancelToken);
//
//       if (response.statusCode == 200 && response.data != null && mounted) {
//         await _cacheManager.putFile(widget.imageUrl, response.data!);
//         if (mounted) {
//           setState(() {
//             _imageProvider = MemoryImage(response.data!);
//             _isLoading = false;
//           });
//         }
//       }
//     } catch (e) {
//       debugPrint('Image loading error: $e');
//       if (mounted) {
//         setState(() {
//           _hasError = true;
//           _isLoading = false;
//           // Fallback to network image provider
//           _imageProvider = CachedNetworkImageProvider(widget.imageUrl);
//         });
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _cancelToken?.cancel('Widget disposed');
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 16,
//       child: Container(
//         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Header (unchanged from your original code)
//             Container(
//               height: 50,
//               width: double.infinity,
//               decoration: const BoxDecoration(color: AppColors.backgroundPurple, borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
//               child: Padding(padding: const EdgeInsets.all(10), child: Row(children: [Text("", style: AppFonts.medium(15, Colors.white)), const Spacer(), IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context))])),
//             ),
//
//             // Image content
//             Container(width: double.infinity, height: MediaQuery.of(context).size.height * 0.7, child: _buildImageContent()),
//
//             // Footer (unchanged from your original code)
//             Container(padding: const EdgeInsets.all(10), color: AppColors.white, child: Row(children: [Text("", style: AppFonts.medium(14, AppColors.textGrey)), const Spacer(), IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () {})])),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImageContent() {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     if (_hasError || _imageProvider == null) {
//       return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.error, color: Colors.red, size: 48), const SizedBox(height: 16), Text('Failed to load image', style: AppFonts.medium(16, Colors.red)), TextButton(onPressed: _loadImage, child: const Text('Retry'))]));
//     }
//
//     return PhotoView(
//       gaplessPlayback: true,
//       imageProvider: _imageProvider!,
//       loadingBuilder: (context, event) => Center(child: CircularProgressIndicator(value: event?.cumulativeBytesLoaded?.toDouble() ?? 0)),
//       errorBuilder: (context, error, stackTrace) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.error, color: Colors.red, size: 48), const SizedBox(height: 16), Text('Image display error', style: AppFonts.medium(16, Colors.red)), TextButton(onPressed: _loadImage, child: const Text('Retry'))])),
//     );
//   }
// }
