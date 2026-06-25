import 'package:flutter/material.dart';

import '../models/pending_business.dart';
import '../services/admin_service.dart';

class AdminBusinessScreen extends StatefulWidget {
  const AdminBusinessScreen({super.key});

  @override
  State<AdminBusinessScreen> createState() =>
      _AdminBusinessScreenState();
}

class _AdminBusinessScreenState
    extends State<AdminBusinessScreen> {

  final AdminService service = AdminService();

  late Future<List<PendingBusiness>> businesses;

  @override
  void initState() {
    super.initState();
    loadBusinesses();
  }

  void loadBusinesses() {
    businesses = service.getPendingBusinesses();
  }

  Future<void> approve(int id) async {

    await service.approveBusiness(id);

    setState(() {
      loadBusinesses();
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Business Approved"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Business Approval"),
      ),

      body: FutureBuilder<List<PendingBusiness>>(

        future: businesses,

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {

            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final list = snapshot.data ?? [];

          if (list.isEmpty) {

            return const Center(
              child: Text(
                "No Pending Businesses",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return RefreshIndicator(

            onRefresh: () async {
              setState(() {
                loadBusinesses();
              });
            },

            child: ListView.builder(

              itemCount: list.length,

              itemBuilder: (context, index) {

                final business = list[index];

                return Card(

                  margin: const EdgeInsets.all(12),

                  child: Padding(

                    padding: const EdgeInsets.all(16),

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        Text(
                          business.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                            "Category : ${business.category}"),

                        Text(
                            "Address : ${business.address}"),

                        Text(
                            "Status : ${business.status}"),

                        const SizedBox(height: 20),

                        SizedBox(

                          width: double.infinity,

                          child: ElevatedButton.icon(

                            onPressed: () =>
                                approve(business.id),

                            icon: const Icon(
                                Icons.check),

                            label: const Text(
                                "Approve Business"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}