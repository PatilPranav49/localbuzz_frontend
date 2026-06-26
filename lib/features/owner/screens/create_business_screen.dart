import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/buzz_widgets.dart';
import '../services/owner_service.dart';
import '../../ai/services/ai_service.dart';
class CreateBusinessScreen extends StatefulWidget {
  const CreateBusinessScreen({super.key});

  @override
  State<CreateBusinessScreen> createState() => _CreateBusinessScreenState();
}

class _CreateBusinessScreenState extends State<CreateBusinessScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final servicesController = TextEditingController(); // NEW
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();

  final phoneController = TextEditingController();
  final websiteController = TextEditingController();
  String selectedImage = 'assets/images/default_cafe.png';

  final OwnerService service = OwnerService();
  String category = "CAFE";
  bool loading = false;
  final AIService _aiService = AIService();
  static const _categories = [
    ('CAFE', 'Cafe', Icons.local_cafe_rounded),
    ('BAKERY', 'Bakery', Icons.bakery_dining_rounded),
    ('RESTAURANT', 'Restaurant', Icons.restaurant_rounded),
    ('SALON', 'Salon', Icons.content_cut_rounded),
    ('MEDICAL', 'Medical', Icons.local_hospital_rounded),
    ('JEWELLERY', 'Jewellery', Icons.diamond_rounded),
    ('OTHER', 'Other', Icons.store_rounded),
  ];

  Future<void> saveBusiness() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    try {
      await service.createBusiness(
        name: nameController.text,
        description: descriptionController.text,
        address: addressController.text,
        latitude: 19.2183,
        longitude: 72.9781,
        phone: phoneController.text,
        website: websiteController.text,
        coverImageUrl: selectedImage,
        category: category,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Business created successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }
  Future<void> generateDescription() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the business name first')),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final response = await _aiService.generateBusinessDescription(
        businessName: nameController.text.trim(),
        category: category,
        services: servicesController.text.trim(),
      );

      descriptionController.text = response;
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }
  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    phoneController.dispose();
    websiteController.dispose();
    servicesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('New business'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text(
                'Tell us about your spot.',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'It\'ll be reviewed before going live.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              _label('CATEGORY', theme),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((c) {
                  return BuzzChoiceChip(
                    label: c.$2,
                    icon: c.$3,
                    selected: category == c.$1,
                    onTap: () {
                      setState(() {
                        category = c.$1;

                        switch (category) {
                          case 'CAFE':
                            selectedImage = 'assets/images/default_cafe.png';
                            break;

                          case 'RESTAURANT':
                            selectedImage = 'assets/images/default_restaurant.png';
                            break;

                          case 'SHOP':
                            selectedImage = 'assets/images/default_shop.png';
                            break;

                          case 'SERVICE':
                            selectedImage = 'assets/images/default_service.png';
                            break;
                          case 'BAKERY':
                            selectedImage = 'assets/images/default_bakery.png';
                            break;
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 22),

              _label('NAME', theme),
              const SizedBox(height: 8),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'e.g. The Daily Grind',
                  prefixIcon: Icon(Icons.storefront_rounded),
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 14),

              _label('SERVICES', theme),

              const SizedBox(height: 8),

              TextFormField(
                controller: servicesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'e.g. Coffee, Cakes, Sandwiches',
                  prefixIcon: Icon(Icons.room_service_rounded),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: loading ? null : generateDescription,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text("Generate with AI"),
                ),
              ),

              const SizedBox(height: 14),
              _label('DESCRIPTION', theme),
              const SizedBox(height: 8),
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'A short description for visitors…',
                ),
              ),




              const SizedBox(height: 14),

              _label('ADDRESS', theme),
              const SizedBox(height: 8),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                  hintText: 'Street, area, city',
                  prefixIcon: Icon(Icons.location_on_rounded),
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 14),
              _label('CONTACT', theme),
              const SizedBox(height: 8),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: 'Phone',
                  prefixIcon: Icon(Icons.phone_rounded),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: websiteController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  hintText: 'Website',
                  prefixIcon: Icon(Icons.public_rounded),
                ),
              ),
              _label('BUSINESS IMAGE', theme),
              const SizedBox(height: 8),

              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  selectedImage,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 12),

              ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.local_cafe),
                              title: const Text("Cafe"),
                              onTap: () {
                                setState(() => selectedImage = "assets/images/default_cafe.png");
                                Navigator.pop(context);
                              },
                            ),

                            ListTile(
                              leading: const Icon(Icons.bakery_dining),
                              title: const Text("Bakery"),
                              onTap: () {
                                setState(() => selectedImage = "assets/images/default_shop.png");
                                Navigator.pop(context);
                              },
                            ),

                            ListTile(
                              leading: const Icon(Icons.restaurant),
                              title: const Text("Restaurant"),
                              onTap: () {
                                setState(() => selectedImage = "assets/images/default_restaurant.png");
                                Navigator.pop(context);
                              },
                            ),

                            ListTile(
                              leading: const Icon(Icons.content_cut),
                              title: const Text("Salon"),
                              onTap: () {
                                setState(() => selectedImage = "assets/images/default_service.png");
                                Navigator.pop(context);
                              },
                            ),

                            ListTile(
                              leading: const Icon(Icons.local_hospital),
                              title: const Text("Medical"),
                              onTap: () {
                                setState(() => selectedImage = "assets/images/default_service.png");
                                Navigator.pop(context);
                              },
                            ),

                            ListTile(
                              leading: const Icon(Icons.diamond),
                              title: const Text("Jewellery"),
                              onTap: () {
                                setState(() => selectedImage = "assets/images/default_shop.png");
                                Navigator.pop(context);
                              },
                            ),

                            ListTile(
                              leading: const Icon(Icons.store),
                              title: const Text("Other"),
                              onTap: () {
                                setState(() => selectedImage = "assets/images/default_shop.png");
                                Navigator.pop(context);
                              },
                            ),

                          ],
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.image),
                label: const Text("Choose Image"),
              ),

              const SizedBox(height: 28),
              BuzzGradientButton(
                label: 'CREATE BUSINESS',
                icon: Icons.check_rounded,
                loading: loading,
                onPressed: loading ? null : saveBusiness,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text, ThemeData theme) {
    return Text(text, style: theme.textTheme.labelMedium);
  }
}