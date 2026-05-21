import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DetailShimmer extends StatelessWidget {
  const DetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Banner image shimmer (SliverAppBar background)
          Text("Details",
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            color: Colors.red,
          ),

          const SizedBox(height: 16),

          // 🔹 "Photos" shimmer text
          _shimmerLine(width: 100, height: 16),

          const SizedBox(height: 8),
          Text("Details",
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
          // 🔹 Horizontal list of photos shimmer
          // SizedBox(
          //   height: 90,
          //   child: ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     itemCount: 4,
          //     itemBuilder: (_, __) => Container(
          //       margin: const EdgeInsets.symmetric(horizontal: 8),
          //       width: 120,
          //       height: 84,
          //       color: Colors.grey,
          //     ),
          //   ),
          // ),
          //
          // const SizedBox(height: 16),

          // 🔹 "Menus" shimmer text
          _shimmerLine(width: 100, height: 16),

          const SizedBox(height: 8),

          // 🔹 Horizontal list of menus shimmer
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (_, __) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 120,
                height: 84,
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 🔹 About section shimmer box
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 120,
          ),

          const SizedBox(height: 16),

          // 🔹 Features shimmer list
          _shimmerLine(width: 80, height: 16),
          const SizedBox(height: 8),
          ...List.generate(
            3,
                (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              child: _shimmerLine(width: 150, height: 14),
            ),
          ),

          const SizedBox(height: 16),

          // 🔹 Reviews shimmer
          _shimmerLine(width: 100, height: 16),
          const SizedBox(height: 8),
          ...List.generate(
            3,
                (index) => ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
              ),
              title: _shimmerLine(width: 120, height: 14),
              subtitle: _shimmerLine(width: 180, height: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerLine({double width = double.infinity, double height = 14}) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey,
    );
  }
}
