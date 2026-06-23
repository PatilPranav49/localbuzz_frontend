import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LocalBuzz',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Search businesses...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Chip(label: Text('All')),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Chip(label: Text('Cafe')),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Chip(label: Text('Restaurant')),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Chip(label: Text('Gym')),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Chip(label: Text('Shop')),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.campaign_outlined,
                      size: 80,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Feed API Integration Pending',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Business updates will appear here',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}