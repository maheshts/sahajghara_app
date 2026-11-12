import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sahajghara/presentation/theme/app_colors.dart';
import 'package:sahajghara/presentation/theme/app_theme.dart';

class CategoryBanner extends StatelessWidget {
  const CategoryBanner({super.key, required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: LayoutBuilder(
        builder: (context, constraints) => SizedBox(
          height: (constraints.maxWidth * 9 / 16).clamp(120.0, 240.0).toDouble(),
          child: CategoryImageCard(imageUrl: imageUrl),
        ),
      ),
    );
  }
}

class CategoryImageCard extends StatelessWidget {
  const CategoryImageCard({super.key, required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.surface(context, Colors.white),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDeep.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppTheme.outline(
            context,
            AppColors.primaryDeep.withOpacity(0.12),
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: CachedNetworkImage(
            imageUrl: imageUrl ?? '',
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.category_rounded,
              color: AppColors.primaryDeep.withOpacity(0.3),
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
