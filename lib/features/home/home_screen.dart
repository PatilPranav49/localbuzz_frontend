import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../auth/models/nearby_business.dart';
import '../auth/services/business_service.dart';
import '../auth/services/nearby_business_service.dart';
import '../feed/feed_screen.dart';
import '../profile/profile_screen.dart';

import '../auth/models/feed_item.dart';
import '../auth/services/feed_service.dart';
import 'package:geolocator/geolocator.dart';
import '../business/business_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final NearbyBusinessService
  nearbyBusinessService =
  NearbyBusinessService();


  List<NearbyBusiness>
  nearbyBusinesses = [];

  bool isNearbyLoading = false;

  final TextEditingController searchController =
  TextEditingController();

  String selectedRadius = '2 KM';
  String selectedCategory = 'CAFE';
  String selectedType = 'ALL';
  String searchQuery = '';
  final FeedService feedService = FeedService();

  List<FeedItem> updates = [];
  double? currentLat;
  double? currentLng;
  @override
  void initState() {
    super.initState();
    initializeFeed();
  }

  Future<void> initializeFeed() async {

    Position position =
    await Geolocator.getCurrentPosition();

    currentLat = position.latitude;
    currentLng = position.longitude;

    loadFilteredFeed();
  }
  bool isLoading = true;
  Future<void> loadFeed() async {
    print('LOAD FEED CALLED');
    try {
      final result =
      await feedService.getFeed();

      setState(() {
        updates = result;
        isLoading = false;
      });
    } catch (e) {
      print('ERROR: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void openFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        String tempRadius = selectedRadius;
        String tempType = selectedType;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),



                    const SizedBox(height: 20),

                    const Text(
                      'Update Type',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Wrap(
                      spacing: 8,
                      children: [
                        'ALL',
                        'OFFER',
                        'EVENT',
                        'ANNOUNCEMENT',
                        'PRODUCT',
                        'SERVICE',
                      ].map((type) {
                        return ChoiceChip(
                          label: Text(type),
                          selected:
                          tempType == type,
                          onSelected: (_) {
                            setModalState(() {
                              tempType = type;
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {

                          setState(() {
                            selectedRadius = tempRadius;
                            selectedType = tempType;
                          });

                          Navigator.pop(context);



                          loadFilteredFeed();
                        },
                        child:
                        const Text('Apply'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('LocalBuzz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Row(
              children: [
        Expanded(
        child: TextField(
          controller: searchController,
          onChanged: (value) {
            searchQuery = value.trim();
            loadFilteredFeed();
          },
          onSubmitted: (_) {
            loadFilteredFeed();
          },
          decoration: InputDecoration(
            hintText: 'Search nearby offers...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: openFilters,
                  icon: const Icon(
                    Icons.filter_alt_outlined,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  'CAFE',
                  'GYM',
                  'RESTAURANT',
                  'SALON',
                ].map((category) {
                  return Padding(
                    padding:
                    const EdgeInsets.only(
                      right: 8,
                    ),
                    child: ChoiceChip(
                      label: Text(category),
                      selected:
                      selectedCategory ==
                          category,
                          onSelected: (_) {

                          setState(() {
                          selectedCategory = category;
                          });

                          loadFilteredFeed();

                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            const Align(
              alignment:
              Alignment.centerLeft,
              child: Text(
                '🔥 Offers & Updates Near You',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: isLoading
                  ? const Center(
                child:
                CircularProgressIndicator(),
              )
                  : updates.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 60,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'No updates found nearby',
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount:
                updates.length,
                itemBuilder:
                    (context, index) {
                      final FeedItem item =
                      updates[index];

                  return Card(
                    margin:
                    const EdgeInsets.only(
                      bottom: 16,
                    ),
                    child: Padding(
                      padding:
                      const EdgeInsets.all(
                        16,
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          Container(
                            height: 160,
                            width:
                            double.infinity,
                            decoration:
                            BoxDecoration(
                              color: Colors
                                  .grey
                                  .shade300,
                              borderRadius:
                              BorderRadius.circular(
                                12,
                              ),
                            ),
                            child:
                            const Icon(
                              Icons.store,
                              size: 60,
                            ),
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          Text(
                            item.businessName,
                            style:
                            const TextStyle(
                              fontSize:
                              18,
                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          Chip(
                            label: Text(
                              item.category??'',
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          Text(
                            item.title,
                            style:
                            const TextStyle(
                              fontSize:
                              16,
                              fontWeight:
                              FontWeight
                                  .w600,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            item.description,
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          Row(
                            children: [
                              const Icon(
                                Icons
                                    .location_on_outlined,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                item.address??'',
                              ),
                              const Spacer(),
                              Text(
                                item.updateType,
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          Row(
                            children: [
                              Expanded(
                                child:
                                ElevatedButton(
                                  onPressed: () {

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            BusinessDetailsScreen(
                                              businessId:
                                              item.businessId??0,
                                            ),
                                      ),
                                    );

                                  },
                                  child:
                                  const Text(
                                    'View Business',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width:
                                10,
                              ),
                              Expanded(
                                child:
                                OutlinedButton(
                                  onPressed: () {
                                    openDirections(
                                      item.businessId ?? 0,
                                    );
                                  },
                                  child:
                                  const Text(
                                    'Directions',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ));
  }


  Future<void> loadFilteredFeed() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    try {

      String url =
          '${FeedService.baseUrl}/feed'
          '?category=$selectedCategory'
          '&lat=$currentLat'
          '&lng=$currentLng';

      if (selectedType != 'ALL') {
        url += '&type=$selectedType';
      }

      if (searchQuery.isNotEmpty) {
        url += '&search=$searchQuery';
      }
      print('URL: $url');
      final result =
      await feedService.getFilteredFeed(
        url,
      );

      setState(() {
        updates = result;
        isLoading = false;
      });

    }catch (e) {

      print('BUSINESS ERROR: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> openDirections(
      int businessId) async {

    final business =
    await BusinessService()
        .getBusiness(businessId);

    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${business.latitude},${business.longitude}',
    );

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }



}