import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_wallpaper/services/wallpaper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  late Future<List<Wallpaper>> futureWallpaper;

  @override
  void initState() {
    super.initState();
    futureWallpaper = WallpaperService.fetchWallpapers();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wallpaper App')),
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
                crossAxisCount: 2
              ), 
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){
                    
                  },
                  child: CachedNetworkImage(
                    imageUrl: wallpapers![index].thumbnailUrl,
                    placeholder: (context, url) => const CircularProgressIndicator(),
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