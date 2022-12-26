import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AttachmentMenuBottomSheet extends StatelessWidget {
  const AttachmentMenuBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 350,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              getAttachmentItem(() {}, Icons.camera, Colors.red, "Camera"),
              getAttachmentItem(() {}, CupertinoIcons.doc,
                  Colors.deepPurpleAccent, "Document"),
              getAttachmentItem(() {}, Icons.photo, Colors.blue, "Gallery"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              getAttachmentItem(
                  () {}, Icons.headphones_rounded, Colors.orange, "Audio"),
              getAttachmentItem(
                  () {}, Icons.location_on, Colors.green, "Location"),
              getAttachmentItem(
                  () {}, Icons.person, Colors.blueAccent, "Contact"),
            ],
          ),
        ],
      ),
    );
  }

  Widget getAttachmentItem(Function onTap, IconData iconData,
      Color containerColor, String attachmentType) {
    return Builder(builder: (context) {
      return Column(
        children: [
          Container(
              padding: const EdgeInsets.all(20.0),
              margin: const EdgeInsets.only(bottom: 8.0),
              decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(15.0)),
              child: Column(
                children: [
                  Icon(
                    iconData,
                    size: 30.0,
                    color: Colors.white,
                  )
                ],
              )),
          Text(
            attachmentType,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w400),
          )
        ],
      );
    });
  }
}

// https://stackoverflow.com/questions/52088889/can-someone-explain-to-me-what-the-builder-class-does-in-flutter
