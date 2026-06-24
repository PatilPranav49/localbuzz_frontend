import 'package:flutter/material.dart';
import '../feed/feed_screen.dart';
import '../profile/profile_screen.dart';

import '../auth/models/feed_item.dart';
import '../auth/services/feed_service.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final TextEditingController searchController =
  TextEditingController();

  String selectedRadius = '2 KM';
  String selectedCategory = 'CAFE';
  String selectedType = 'ALL';
  int currentIndex = 0;
  final FeedService feedService = FeedService();

  List<FeedItem> updates = [];
  @override
  void initState() {
    super.initState();
    loadFeed();
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
                      'Radius',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Wrap(
                      spacing: 8,
                      children: [
                        '1 KM',
                        '2 KM',
                        '5 KM',
                      ].map((radius) {
                        return ChoiceChip(
                          label: Text(radius),
                          selected:
                          tempRadius == radius,
                          onSelected: (_) {
                            setModalState(() {
                              tempRadius = radius;
                            });
                          },
                        );
                      }).toList(),
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
                    decoration: InputDecoration(
                      hintText:
                      'Search nearby offers...',
                      prefixIcon:
                      const Icon(Icons.search),
                      border:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(
                          12,
                        ),
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
                              item.category,
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
                                item.address,
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
                                  onPressed:
                                      () {},
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
                                  onPressed:
                                      () {},
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
      ),bottomNavigationBar: NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.feed_outlined),
          selectedIcon: Icon(Icons.feed),
          label: 'Feed',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    ),
    );
  }


  Future<void> loadFilteredFeed() async {

    setState(() {
      isLoading = true;
    });

    try {

      String url =
          '${FeedService.baseUrl}/feed'
          '?category=$selectedCategory';

      if (selectedType != 'ALL') {
        url += '&type=$selectedType';
      }

      final result =
      await feedService.getFilteredFeed(
        url,
      );

      setState(() {
        updates = result;
        isLoading = false;
      });

    } catch (e) {

      setState(() {
        isLoading = false;
      });
    }
  }

}