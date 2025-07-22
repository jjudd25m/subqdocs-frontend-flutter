import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class UrlProvider {
  // static String baseUrl = WebUri(dotenv.get("DEV_URL", fallback: "")).toString();
  static String baseUrl = WebUri(dotenv.get("NGROK_URL", fallback: "")).toString();

// static String baseUrl = WebUri(dotenv.get("STAGE_URL", fallback: "")).toString();
// static String baseUrl = WebUri(dotenv.get("PROD_URL", fallback: "")).toString();

// static String imageUrl = WebUri(dotenv.get("IMAGE_URL", fallback: "")).toString();
}
