import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../helpers/navigation.dart';
import '../../helpers/utillls.dart';
import 'ContractorReposne.dart';
import 'askquote_screen.dart';
import 'menu_big_view.dart';

class ContractorPortfolioScreen extends ConsumerStatefulWidget {
  final String contractorName;
  final List<PortfolioList>? portfolioList;

  const ContractorPortfolioScreen({
    super.key,
    required this.contractorName,
    required this.portfolioList,
  });

  @override
  ConsumerState<ContractorPortfolioScreen> createState() =>
      _ContractorPortfolioScreenState();
}

class _ContractorPortfolioScreenState
    extends ConsumerState<ContractorPortfolioScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "${widget.contractorName} Portfolio",
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        // centerTitle: true,
      ),

      /// --- Body Section ---
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: widget.portfolioList!.first.imagepath != null && widget.portfolioList!.first.imagepath!.isNotEmpty?
                GridView.builder(
                  itemCount: widget.portfolioList!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    PortfolioList p = widget.portfolioList![index];

                    return InkWell(
                      onTap: () {
                        Navigation.sideNavigation(
                          context,
                          MenuViewScreen(menuimageList: p.imagepath,description: '${p.title} - ${p.description ??""}' ,),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              p.imagepath!.first.profileUrl ?? "",
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            p.location ?? "",
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1E2432),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ):
                Text("No Portfolio Found",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black87),),
      ),),
            // Bottom button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigation.sideNavigation(
                      context,
                      AskquoteScreen(
                        contractorId: widget.portfolioList!.first.userId.toString(),
                        contractorName: widget.contractorName.toString(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003B73),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "Ask for a quote",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )          ],
        ),
      ),
    );
  }
}
