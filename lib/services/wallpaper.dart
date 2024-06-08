import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

const String imageWallpeperUrl = "";

class Wallpaper{
  final String category;
  final String namge;
  final String thumbnailUrl;
  final String imageUrl;

  Wallpaper({required this.category, required this.namge, required this.thumbnailUrl, required this.imageUrl});

  factory Wallpaper.fromJson(Map<String, dynamic> json){
    return Wallpaper(
      category: json['category'], 
      namge: json['namge'], 
      thumbnailUrl: json['thumbnailUrl'], 
      imageUrl: json['imageUrl']);
  }
}

class WallpaperService{
  static Future<List<Wallpaper>> fetchWallpapers() async {
    final response = await http.get(Uri.parse(imageWallpeperUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Wallpaper.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load wallpapers');
    }
  }
}
