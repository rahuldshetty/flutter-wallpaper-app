import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_wallpaper/services/wallpaper.dart';
import 'package:my_wallpaper/ui/wallpaper_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  late Future<List<Wallpaper>> futureWallpaper;

  @override
  void initState() {
    futureWallpaper = WallpaperService.fetchWallpapers();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Wallpaper Gallery')),
      body: FutureBuilder<List<Wallpaper>>(
        future: futureWallpaper,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError){
            return const Center(child: Text("Failed to load Wallpaper data"));
          } else {
            List<Wallpaper>? wallpapers = snapshot.data;
            return GridView.builder(
              itemCount: wallpapers?.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (1 / .4),
              ), 
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => WallpaperDetail(wallpapers[index]))  
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: wallpapers![index].thumbnailUrl,
                    placeholder: (context, url) => const Center(child:
                      SizedBox(
                      width: 80.0,
                      height: 80.0,
                      child: CircularProgressIndicator(),
                    )
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    fit: BoxFit.cover
                  ),
                );
              }
            );
          }
        },
      ),
    );
  }
}