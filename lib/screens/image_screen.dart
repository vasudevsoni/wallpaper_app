import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';

class ExpandImage extends StatefulWidget {
  final String photographerName;
  final String photographerUrl;
  final String photographerId;
  final String altText;
  final String imgUrl;

  const ExpandImage({
    Key? key,
    required this.imgUrl,
    required this.photographerName,
    required this.photographerUrl,
    required this.photographerId,
    required this.altText,
  }) : super(key: key);

  @override
  State<ExpandImage> createState() => _ExpandImageState();
}

class _ExpandImageState extends State<ExpandImage> {
  bool isLoading = false;
  var filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Dismissible(
            direction: DismissDirection.down,
            onDismissed: (_) => Navigator.pop(context),
            key: const Key('key'),
            child: Hero(
              tag: widget.imgUrl,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  widget.imgUrl,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: const Color(0xffe3193a).withOpacity(0.3),
                        ),
                        child: const Center(
                          child: Icon(
                            Ionicons.close,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: _showImageDetails,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                        ),
                        child: const Center(
                          child: Icon(
                            Ionicons.information_circle_outline,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    _save();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: const Color(0xfff8bc11).withOpacity(0.3),
                        ),
                        child: Center(
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              : const Icon(
                                  Ionicons.download,
                                  color: Colors.white,
                                  size: 32,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xff0e0e0f).withOpacity(0.3),
                        ),
                        child: widget.altText == ''
                            ? Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'No image description',
                                  style: GoogleFonts.kanit(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              )
                            : Align(
                                alignment: Alignment.center,
                                child: Text(
                                  widget.altText.toString(),
                                  style: GoogleFonts.kanit(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _showImageDetails() async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          elevation: 10,
          backgroundColor: const Color(0xff0e0e0f),
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 20,
              ),
              child: Center(
                child: Text(
                  'Photographer details',
                  style: GoogleFonts.kanit(
                    color: const Color(0xfff8bc11),
                    fontSize: 17,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Ionicons.person_circle_outline,
                size: 35,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: GoogleFonts.kanit(
                      color: const Color(0xff606268),
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    widget.photographerName,
                    style: GoogleFonts.kanit(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              indent: 60,
              endIndent: 20,
              color: Colors.white,
            ),
            ListTile(
              leading: const Icon(
                Ionicons.id_card_outline,
                size: 35,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Id',
                    style: GoogleFonts.kanit(
                      color: const Color(0xff606268),
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    widget.photographerId,
                    style: GoogleFonts.kanit(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  _save() async {
    setState(() {
      isLoading = true;
    });
    if (Platform.isAndroid) {
      await _askPermission();
    }
    var response = await Dio().get(
      widget.imgUrl,
      options: Options(responseType: ResponseType.bytes),
    );
    ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image saved in gallery'),
      ),
    );
  }

  _askPermission() async {
    Map<Permission, PermissionStatus> permissions = await [
      Permission.photosAddOnly,
      Permission.storage,
    ].request();
  }
}
