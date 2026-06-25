import 'package:flutter/material.dart';

import '../models/owner_business.dart';
import '../services/owner_service.dart';
import 'create_business_screen.dart';
import 'create_update_screen.dart';

class OwnerBusinessScreen extends StatefulWidget {
  const OwnerBusinessScreen({super.key});

  @override
  State<OwnerBusinessScreen> createState() =>
      _OwnerBusinessScreenState();
}

class _OwnerBusinessScreenState
    extends State<OwnerBusinessScreen> {

  final OwnerService _service = OwnerService();

  late Future<List<OwnerBusiness>> businesses;

  @override
  void initState() {
    super.initState();
    loadBusinesses();
  }

  void loadBusinesses() {
    businesses = _service.getMyBusinesses();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Businesses"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateBusinessScreen(),
            ),
          );

          setState(() {
            loadBusinesses();
          });
        },
        icon: const Icon(Icons.add),
        label: const Text("Business"),
      ),
      body: FutureBuilder<List<OwnerBusiness>>(
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
            return Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [

                  const Text(
                    "No Business Found",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                      "Tap the + button below to create your first business.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
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
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 24,
                              child: Icon(Icons.store),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                business.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            const Icon(Icons.category,
                                size: 18,
                                color: Colors.blue),
                            const SizedBox(width: 10),
                            Text(
                              business.category,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Icon(
                              business.status == "APPROVED"
                                  ? Icons.check_circle
                                  : Icons.pending,
                              color: business.status == "APPROVED"
                                  ? Colors.green
                                  : Colors.orange,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              business.status,
                              style: TextStyle(
                                color: business.status == "APPROVED"
                                    ? Colors.green
                                    : Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const Divider(height: 30),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on,
                                size: 18,
                                color: Colors.red),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(business.address),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            const Icon(Icons.phone,
                                size: 18,
                                color: Colors.green),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                business.phone.isEmpty
                                    ? "Not Available"
                                    : business.phone,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            const Icon(Icons.language,
                                size: 18,
                                color: Colors.blue),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                business.website.isEmpty
                                    ? "Not Available"
                                    : business.website,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        if (business.status == "APPROVED")
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.campaign),
                              label: const Text("Create Update"),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CreateUpdateScreen(
                                      businessId: business.id,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        else
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "Waiting for Admin Approval",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
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