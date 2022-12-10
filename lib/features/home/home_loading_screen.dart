import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeLoadingScreen extends StatelessWidget {
  const HomeLoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      // child: ListView.builder(physics: const NeverScrollableScrollPhysics(),itemCount: 6,itemBuilder: (context,index){
      //   return Card(
      //     elevation: 1.0,
      //     child: Row(
      //       children: [
      //
      //       ],
      //     ),
      //   );
      // }),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            for (int i = 0; i < 10; i++)
              Card(
                elevation: 1.0,
                child: Container(
                  height: 100.0,
                )
              )
          ],
        ),
      ),
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
    );
  }
}
