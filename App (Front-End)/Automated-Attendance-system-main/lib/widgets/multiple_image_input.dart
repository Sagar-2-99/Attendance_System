import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MultipleImageInput extends StatefulWidget {
  const MultipleImageInput({super.key, required this.onPickedImage});

  final void Function(List<XFile?>) onPickedImage;


  @override
  State<StatefulWidget> createState() {
    return _MultipleImageInputState();
  }
}

class _MultipleImageInputState extends State<MultipleImageInput> {

  List<XFile>? _selecteImages;
  String? msg;

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final List<XFile?> pickedImages = await imagePicker.pickMultiImage(maxWidth: 600);
    if(pickedImages.isEmpty) {
      return;
    }
    setState(() {
      // _selecteImages = pickedImages;
      msg = "${pickedImages.length} image selected";
    });
    widget.onPickedImage(pickedImages);
  }

  @override
  Widget build(BuildContext context) {

    Widget content = TextButton.icon(
        onPressed: _takePicture, 
        icon: const Icon(Icons.camera), 
        label: msg == null ? Text("Take Picture") : Text(msg!)
      );

    // if(_selectedImage != null) {
    //   content = GestureDetector(
    //     onTap: _takePicture,
    //     child: Image.file(
    //       _selectedImage!,
    //       fit : BoxFit.cover,
    //       height: double.infinity,
    //       width: double.infinity,
    //     ),
    //   );
    // }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
      ),
      height: 200,
      width: double.infinity,
      child: content,
    );
  }
}