import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_wallpaper/services/wallpaper.dart';
import 'package:http/http.dart' as http;

const platform = MethodChannel('com.example.my_wallpaper/setWallpaper');

class WallpaperDetail extends StatelessWidget {
  final Wallpaper wallpaper;

  const WallpaperDetail(this.wallpaper, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar:
            AppBar(title: Text("${wallpaper.namge} (${wallpaper.category})")),
        body: SingleChildScrollView (child:Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: CachedNetworkImage(
                  imageUrl: wallpaper.imageUrl,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
              TextButton(
                  onPressed: () => setAsWallpaper(wallpaper.imageUrl), child: const Text("Set As Wallpaper"))
            ],
        ))));
  }

  Future<void> setAsWallpaper(String imageUrl) async {
    try {
      // download image
      final response = await http.get(Uri.parse(imageUrl));
      if(response.statusCode == 200){
         // Convert response body to Uint8List
        Uint8List bytes = response.bodyBytes;

        await platform.invokeMethod('setWallpaper', bytes);
      } else {
        throw Exception('Downloading image failed!');
      }
    } on PlatformException catch (e) {
      print("Failed to set wallpaper: '${e.message}'");
    }
  }
}
