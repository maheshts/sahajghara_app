import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sahajghara/controllers/contractor_controler.dart';
import 'package:sahajghara/helpers/navigation.dart';
import 'package:sahajghara/presentation/theme/app_constants.dart';
import 'package:sahajghara/screens/contractor/add_portfolio_screen.dart';
import 'package:sahajghara/screens/contractor/model/PortfolioData.dart';
import 'package:shimmer/shimmer.dart';

class PortfolioScreen extends ConsumerStatefulWidget {
  const PortfolioScreen({super.key});

  @override
  ConsumerState<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
 ref.read(contractorControllerProvider).getPortfolioList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final portfolioAsync = ref.watch(contractorControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title:  Text("My portfolio",style: nunitoItalic16,),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPortfolioScreen())).then((value) {
                  if (value == true) {
                    ref.read(contractorControllerProvider).getPortfolioList();
                  }
                });

              //    var result = Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPortfolioScreen()));
                //                    // result.then((value) {
                //                      if (result == true) {
                //                        ref.read(contractorControllerProvider).getPortfolioList();
                //                      }
                //                    })
              // var result = Navigator.push(context, route)

                   //
               // Navigation.sideNavigation(context, AddPortfolioScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child:  Text("Add portfolio",style: nunitoItalic14White,),
            ),
          )
        ],
      ),

      body: portfolioAsync.portfolioListStatus == PortfolioListStatus.loading
          ? _shimmerGrid()
          : portfolioAsync.portfolioListStatus == PortfolioListStatus.error
          ? const Center(child: Text("Error loading portfolio"))
          :


           Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              itemCount: portfolioAsync.portfolioList!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.60,
              ),
              itemBuilder: (context, index) {
                return _portfolioCard(portfolioAsync.portfolioList![index]);
              },
            ),
          )

    );
  }

  Widget _shimmerGrid() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (_, __) => _shimmerCard(),
      ),
    );
  }
  Widget _shimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          const SizedBox(height: 8),
          Container(height: 12, width: 100, color: Colors.white),
          const SizedBox(height: 6),
          Container(height: 10, width: 70, color: Colors.white),
        ],
      ),
    );
  }

  Widget _portfolioCard(PortfolioList item) {
    final imageUrl = item.imagepath?.isNotEmpty == true
        ? item.imagepath!.first.profileUrl
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: imageUrl != null
                ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.broken_image, size: 40),
            )
                : Container(
              color: Colors.grey.shade300,
              child: const Icon(Icons.image, size: 40),
            ),
          ),
        ),

        const SizedBox(height: 6),

        Text(
          item.title ?? "",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 2),

        Text(
          item.location ?? "",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
