import 'package:flutter/material.dart';
import '../../core/utils/default_business_image.dart';
import '../auth/models/business_profile.dart';
import '../auth/services/business_service.dart';
import 'package:url_launcher/url_launcher.dart';
class BusinessDetailsScreen extends StatefulWidget {

  final int businessId;

  const BusinessDetailsScreen({
    super.key,
    required this.businessId,
  });

  @override
  State<BusinessDetailsScreen> createState() =>
      _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState
    extends State<BusinessDetailsScreen> {

  final BusinessService businessService =
  BusinessService();

  BusinessProfile? business;

  bool isLoading = true;
  Future<void> openDirections() async {

    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${business!.latitude},${business!.longitude}',
    );

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }
  @override
  void initState() {
    super.initState();
    loadBusiness();
  }

  Future<void> loadBusiness() async {

    try {

      final result =
      await businessService.getBusiness(
        widget.businessId,
      );

      setState(() {
        business = result;
        isLoading = false;
      });

    } catch (e, stackTrace) {



      setState(() {
        isLoading = false;
      });

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Business Details',
        ),
      ),
      body: isLoading
          ? const Center(
        child:
        CircularProgressIndicator(),
      )
          : business == null
          ? const Center(
        child: Text(
          'Failed to load business',
        ),
      )
          : Padding(
        padding:
        const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                getBusinessImage(business!.category),
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),
            Text(
              business!.name,
              style:
              const TextStyle(
                fontSize: 24,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Chip(
              label: Text(
                business!.category,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Text(
              business!.address,
            ),

            const SizedBox(
              height: 12,
            ),

            Text(
              business!.description,
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: openDirections,
                icon: const Icon(Icons.directions),
                label: const Text('Get Directions'),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Recent Updates',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount:
                business!.recentUpdates.length,
                itemBuilder: (context, index) {

                  final update =
                  business!.recentUpdates[index];

                  return Card(
                    child: ListTile(
                      title: Text(update.title),
                      subtitle: Text(
                        update.description,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}