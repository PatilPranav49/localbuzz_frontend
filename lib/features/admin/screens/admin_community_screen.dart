import 'package:flutter/material.dart';

import '../models/pending_community_admin.dart';
import '../services/admin_service.dart';

class AdminCommunityScreen extends StatefulWidget {
  const AdminCommunityScreen({super.key});

  @override
  State<AdminCommunityScreen> createState() =>
      _AdminCommunityScreenState();
}

class _AdminCommunityScreenState
    extends State<AdminCommunityScreen> {

  final AdminService service = AdminService();

  late Future<List<PendingCommunityAdmin>> admins;

  @override
  void initState() {
    super.initState();
    loadAdmins();
  }

  void loadAdmins() {
    admins = service.getPendingCommunityAdmins();
  }

  Future<void> approve(int id) async {

    await service.approveCommunityAdmin(id);

    setState(() {
      loadAdmins();
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Community Admin Approved",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Community Admin Approval",
        ),
      ),

      body: FutureBuilder<List<PendingCommunityAdmin>>(

        future: admins,

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
                "No Pending Community Admins",
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
                loadAdmins();
              });
            },

            child: ListView.builder(

              itemCount: list.length,

              itemBuilder: (context, index) {

                final admin = list[index];

                return Card(

                  margin: const EdgeInsets.all(12),

                  child: Padding(

                    padding: const EdgeInsets.all(16),

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        Text(
                          admin.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          admin.email,
                        ),

                        const SizedBox(height: 20),

                        SizedBox(

                          width: double.infinity,

                          child: ElevatedButton.icon(

                            onPressed: () =>
                                approve(admin.id),

                            icon: const Icon(
                              Icons.check,
                            ),

                            label: const Text(
                              "Approve Community Admin",
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