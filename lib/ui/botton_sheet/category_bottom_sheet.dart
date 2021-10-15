import 'dart:io';

import 'package:critical_x_quiz/core/utils/Image_picker_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryBottomSheet {
  static showCategoryBottomSheet(BuildContext context,
      {Function addImage,
      Function submitButton,
      File image,
      TextEditingController categoryController}) {
    print("Bottom sheet  ok");
    return showModalBottomSheet(
        context: context,
        //backgroundColor: Colors.transparent,
        //isScrollControlled: true,
        //isDismissible: true,
        builder: (context) {
          return TestBottomSheetView(
            addImage: addImage,
            submitButton: submitButton,
            categoryController: categoryController,
            image: image,
          );
        });
  }
}

class TestBottomSheetView extends StatefulWidget {
  Function addImage;
  Function submitButton;
  File image;
  TextEditingController categoryController;

  TestBottomSheetView({
    this.submitButton,
    this.addImage,
    this.categoryController,
    this.image,
  });

  @override
  _TestBottomSheetViewState createState() => _TestBottomSheetViewState();
}

class _TestBottomSheetViewState extends State<TestBottomSheetView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    image = widget.image;
  }

  File image;
  File _image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'Add Category',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo),
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                // autofocus: true,
                textAlign: TextAlign.center,
                controller: widget.categoryController,
                validator: (s) {
                  return s.isEmpty ? "title cant be empty" : null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: InkWell(
                onTap: () {
                  FlutterImagePicker.imagePickerModalSheet(
                      context: context,
                      fromCamera: () async {
                        File temp = await FlutterImagePicker.getImageCamera(
                            context,
                            compress: true);
                        if (temp == null) return;

                        setState(() {
                          _image = temp;
                        });
                        widget?.addImage?.call(_image);
                      },
                      fromGallery: () async {
                        File temp = await FlutterImagePicker.getImageGallery(
                            context,
                            compress: true);
                        if (temp == null) return;

                        setState(() {
                          _image = temp;
                        });

                        widget?.addImage?.call(_image);
                      });
                },
                child: Center(
                  child: Text(
                    'Add Image',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo),
                  ),
                ),
              ),
            ),
            RaisedButton(
              child: const Text(
                'Submit',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  widget?.submitButton?.call();
                }
              },
              color: Colors.indigo,
            ),
            Expanded(
              child: Center(
                child: Container(
                  height: 150,
                  width: 150,
                  child: _image == null
                      ? Text('No image selected.')
                      : Image.file(_image),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
