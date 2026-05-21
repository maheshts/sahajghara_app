import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Dumyshimmer extends StatelessWidget {
  const Dumyshimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              //color: Colors.grey.shade50,
                margin: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics:     BouncingScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      // final item  = tripDataWatch.selectedTripList![index];

                      return Padding(
                        padding:     EdgeInsets.only(bottom: 12.0),
                        child: Container(
                          padding:     EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade50,
                                blurRadius: 4,
                                offset:     Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [

                                  SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '',

                                      ),
                                      Text(
                                        '',

                                      ),
                                      ElevatedButton.icon(
                                          onPressed: () {
                                            // Handle Update Status button click
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            padding:     EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4),
                                              side:     BorderSide(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          icon:     Icon(
                                            Icons.update,
                                            size: 20,
                                            color: Colors.black,
                                          ),
                                          label:     Text(
                                            "",
                                          )
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    })),
          )),
    );
    // return const Placeholder();
  }
}
