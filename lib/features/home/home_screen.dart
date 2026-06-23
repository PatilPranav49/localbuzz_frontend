import 'package:flutter/material.dart';
import '../feed/feed_screen.dart';
import '../profile/profile_screen.dart';
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
  final List<Map<String, String>> updates = [
    {
      'business': 'Star Cafe',
      'category': 'CAFE',
      'title': 'Buy 1 Get 1 Free',
      'description': 'Valid till Sunday',
      'distance': '0.8 KM',
      'time': '2h ago',
    },
    {
      'business': 'Fitness Hub',
      'category': 'GYM',
      'title': '20% Off Membership',
      'description': 'Limited period offer',
      'distance': '1.2 KM',
      'time': '5h ago',
    },
    {
      'business': 'Book World',
      'category': 'OTHER',
      'title': 'Weekend Sale',
      'description': 'Flat 15% Off',
      'distance': '1.8 KM',
      'time': '1 day ago',
    },
  ];

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
                        'OFFERS',
                        'EVENTS',
                        'ANNOUNCEMENTS',
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
                            selectedRadius =
                                tempRadius;
                            selectedType =
                                tempType;
                          });

                          Navigator.pop(context);
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
                          selectedCategory =
                              category;
                        });
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
              child: updates.isEmpty
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
                  final item =
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
                            item['business']!,
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
                              item['category']!,
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          Text(
                            item['title']!,
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
                            item[
                            'description']!,
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
                                item[
                                'distance']!,
                              ),
                              const Spacer(),
                              Text(
                                item[
                                'time']!,
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
}