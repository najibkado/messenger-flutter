import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

//Cropping image
cropImage(File imageFile) async {
  File croppedImage = await ImageCropper.cropImage(
    sourcePath: imageFile.path,
    //aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    aspectRatioPresets: Platform.isAndroid
        ? [
            CropAspectRatioPreset.square,
            //CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            //CropAspectRatioPreset.ratio4x3,
            //CropAspectRatioPreset.ratio16x9
          ]
        : [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            //CropAspectRatioPreset.ratio3x2,
            //CropAspectRatioPreset.ratio4x3,
            //CropAspectRatioPreset.ratio5x3,
            //CropAspectRatioPreset.ratio5x4,
            //CropAspectRatioPreset.ratio7x5,
            //CropAspectRatioPreset.ratio16x9
          ],
    androidUiSettings: AndroidUiSettings(
        //minimumAspectRatio: 300.0,
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.black,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false),

    cropStyle: CropStyle.rectangle,
    // maxHeight: 100,
    //maxWidth: 100
  );
  return croppedImage;
}

//Gets image to upload
getImage(BuildContext context, ImageSource source) async {
  // Closes the bottom sheet
  Navigator.pop(context);
  File image = await ImagePicker.pickImage(source: source);
  if (image != null) {
    image = await cropImage(image);
    return image;
  }
}

//Picking from gallery or camera
openImagePickerModal(BuildContext context) async {
  final flatButtonColor = Theme.of(context).primaryColor;
  //print('Image Picker Modal Called');
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150.0,
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text(
                'Pick an image',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: flatButtonColor,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: IconButton(
                        onPressed: () async {
                          /* Navigator.pop(context);
                         File image = await ImagePicker.pickImage(source: ImageSource.camera);
                        if(image != null){
                         image = await cropImage(image);
                        return image;
                          }*/

                          return getImage(context, ImageSource.camera);
                        },
                        icon: Icon(Icons.camera_alt),
                        color: Colors.white),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: IconButton(
                        onPressed: () async {
                          return getImage(context, ImageSource.gallery);
                          /*Navigator.pop(context);
                         File image = await ImagePicker.pickImage(source: ImageSource.gallery);
                        if(image != null){
                         image = await cropImage(image);
                        return image;
                          }*/
                        },
                        icon: Icon(Icons.image),
                        color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        );
      });
}
