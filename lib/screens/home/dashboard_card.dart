import 'package:flutter/material.dart';

import '../../helpers/navigation.dart';
import '../profile/vendor/vendor_enquirys.dart';
import 'HomePageResponse.dart';

class DashboardCard extends StatelessWidget {
  final VendorSummery item;

  const DashboardCard({required this.item});

  Color _getColorByStatus(int? status) {
    switch (status) {
      case 2:
        return Colors.orange;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.teal;
      case 5:
        return Colors.green;
      case 6:
        return Colors.deepPurple;
      case 7:
        return Colors.amber;
      case 8:
        return Colors.indigo;
      case 9:
        return Colors.grey;
      default:
        return Colors.black54;
    }
  }

  IconData _getIconByStatus(int status) {
    switch (status) {
      case 2:
        return Icons.edit_note;
      case 3:
        return Icons.hourglass_top;
      case 4:
        return Icons.verified;
      case 5:
        return Icons.check_circle;
      case 6:
        return Icons.payment;
      case 7:
        return Icons.account_balance_wallet;
      case 8:
        return Icons.currency_rupee;
      case 9:
        return Icons.lock;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColorByStatus(item.status);

    return InkWell(
      onTap: () {
        Navigation.sideNavigation(context, VendorEnquirys(itemStatus: item.status!,));

      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.85),
              color.withOpacity(0.65),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 👈 important
          children: [

            /// Top Row (Icon + Count)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  _getIconByStatus(item.status!),
                  color: Colors.white,
                  size: 22, // smaller
                ),
                SizedBox(width: 20,),
                Text(
                  item.count.toString(),
                  style: const TextStyle(
                    fontSize: 28, // smaller
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            /// Status Text
            Text(
              item.level!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
