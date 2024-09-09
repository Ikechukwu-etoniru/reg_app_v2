import 'dart:io';

import 'package:elevate_reg_app_2/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerBox extends StatefulWidget {
  final Function getPath;
  final Function getFile;
  const ImagePickerBox({required this.getPath, required this.getFile, super.key});

  @override
  State<ImagePickerBox> createState() => _ImagePickerBoxState();
}

class _ImagePickerBoxState extends State<ImagePickerBox> {
  File? pickedImage;

  void _getPath() {
    widget.getPath(pickedImage!.path);
    widget.getFile(pickedImage);
  }

  final ImagePicker _picker = ImagePicker();

  void _selectImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Center(
              child: Text(
                'Select Source',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final nav = Navigator.of(context);
                        final selectedImage = await _picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 70,
                          maxHeight: 250,
                          maxWidth: 250,
                        );
                        if (selectedImage == null) {
                          nav.pop();
                        }
                        nav.pop();
                        setState(() {
                          pickedImage = File(selectedImage!.path);
                          _getPath();
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 90,
                            width: 90,
                            margin: const EdgeInsets.only(
                              top: 10,
                              bottom: 5,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: MyColors.tfGreen,
                            ),
                            child: SvgPicture.asset(
                              'images/gallery.svg',
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text('Gallery')
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        final selectedImage = await _picker.pickImage(
                          source: ImageSource.camera,
                          imageQuality: 70,
                          maxHeight: 250,
                          maxWidth: 250,
                        );
                        if (selectedImage == null) {
                        } else {
                          setState(() {
                            Navigator.of(context).pop();
                            pickedImage = File(selectedImage.path);
                            _getPath();
                          });
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 90,
                            width: 90,
                            margin: const EdgeInsets.only(
                              top: 10,
                              bottom: 5,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: MyColors.tfGreen,
                            ),
                            child: SvgPicture.asset(
                              'images/camera.svg',
                            ),
                          ),
                          const Text('Camera')
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: MyColors.primayGreen,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (pickedImage == null)
          Stack(
            children: [
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey[100],
                child: const Icon(
                  Icons.person,
                  size: 43,
                  color: Colors.grey,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: _selectImageDialog,
                  child: SvgPicture.asset(
                    'images/edit_icon.svg',
                    height: 30,
                    width: 30,
                  ),
                ),
              )
            ],
          ),
        if (pickedImage != null)
          Stack(
            children: [
              CircleAvatar(
                radius: 55,
                backgroundImage: FileImage(pickedImage!),
              ),
              Positioned(
                bottom: 0,
                right: -5,
                child: InkWell(
                  onTap: _selectImageDialog,
                  child: SvgPicture.asset(
                    'images/edit_icon.svg',
                    height: 30,
                    width: 30,
                  ),
                ),
              )
            ],
          ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
