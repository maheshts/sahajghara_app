import 'package:flutter/material.dart';

class VendorDashboard extends StatefulWidget {
  const VendorDashboard({super.key});

  @override
  State<VendorDashboard> createState() => _VendorDashboardState();
}

class _VendorDashboardState extends State<VendorDashboard> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: NavigationBar(
      //   selectedIndex: currentIndex,
      //   onDestinationSelected: (index) {
      //     setState(() => currentIndex = index);
      //   },
      //   destinations: const [
      //     NavigationDestination(icon: Icon(Icons.dashboard), label: "Home"),
      //     NavigationDestination(icon: Icon(Icons.list_alt), label: "Orders"),
      //     NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: "Chat"),
      //     NavigationDestination(icon: Icon(Icons.person_outline), label: "Profile"),
      //   ],
      // ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// 🔥 Gradient Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff2563EB), Color(0xff1E40AF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Vendor Dashboard",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Icon(Icons.notifications_none, color: Colors.white),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Welcome back, Mahesh 👋",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Here’s your business summary",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 📊 Summary Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: const [
                    Expanded(
                      child: SummaryCard(
                        title: "Pending",
                        value: "14",
                        icon: Icons.hourglass_empty,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: SummaryCard(
                        title: "Accepted",
                        value: "9",
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: SummaryCard(
                        title: "Rejected",
                        value: "2",
                        icon: Icons.cancel,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// 💰 Earnings Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total Earnings"),
                            SizedBox(height: 6),
                            Text(
                              "₹ 1,25,000",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.trending_up, size: 32)
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// 🧾 Recent Orders
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Recent Quotations",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    QuotationTile(
                      company: "ABC Construction",
                      product: "25 Cement Bags",
                      amount: "₹ 6,250",
                      status: "Pending",
                    ),
                    QuotationTile(
                      company: "XYZ Builders",
                      product: "50 Steel Rods",
                      amount: "₹ 21,000",
                      status: "Accepted",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(title),
          ],
        ),
      ),
    );
  }
}

class QuotationTile extends StatelessWidget {
  final String company;
  final String product;
  final String amount;
  final String status;

  const QuotationTile({
    super.key,
    required this.company,
    required this.product,
    required this.amount,
    required this.status,
  });

  Color getStatusColor() {
    switch (status) {
      case "Accepted":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(company,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(product),
            const SizedBox(height: 6),
            Text(amount,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Chip(
                label: Text(status),
                backgroundColor: getStatusColor().withOpacity(0.15),
                labelStyle: TextStyle(color: getStatusColor()),
              ),
            )
          ],
        ),
      ),
    );
  }
}