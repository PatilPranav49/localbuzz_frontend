import 'package:flutter/material.dart';

import '../services/owner_service.dart';

class CreateBusinessScreen extends StatefulWidget {
  const CreateBusinessScreen({super.key});

  @override
  State<CreateBusinessScreen> createState() =>
      _CreateBusinessScreenState();
}

class _CreateBusinessScreenState
    extends State<CreateBusinessScreen> {

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final websiteController = TextEditingController();
  final coverImageController = TextEditingController();

  final OwnerService service = OwnerService();

  String category = "CAFE";

  bool loading = false;

  Future<void> saveBusiness() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    });

    try {

      await service.createBusiness(
        name: nameController.text,
        description: descriptionController.text,
        address: addressController.text,
        latitude: 19.2183,
        longitude: 72.9781,
        phone: phoneController.text,
        website: websiteController.text,
        coverImageUrl: coverImageController.text,
        category: category,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Business Created Successfully"),
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );

    } finally {

      if (mounted) {
        setState(() {
          loading = false;
        });
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
    coverImageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Create Business"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: ListView(

            children: [

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Business Name",
                ),
                validator: (value) =>
                value!.isEmpty ? "Required" : null,
              ),

              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
              ),

              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: "Address",
                ),
                validator: (value) =>
                value!.isEmpty ? "Required" : null,
              ),

              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone",
                ),
              ),

              TextFormField(
                controller: websiteController,
                decoration: const InputDecoration(
                  labelText: "Website",
                ),
              ),

              TextFormField(
                controller: coverImageController,
                decoration: const InputDecoration(
                  labelText: "Cover Image URL",
                ),
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(
                  labelText: "Category",
                ),
                items: const [
                  DropdownMenuItem(
                    value: "CAFE",
                    child: Text("Cafe"),
                  ),
                  DropdownMenuItem(
                    value: "RESTAURANT",
                    child: Text("Restaurant"),
                  ),
                  DropdownMenuItem(
                    value: "SHOP",
                    child: Text("Shop"),
                  ),
                  DropdownMenuItem(
                    value: "SERVICE",
                    child: Text("Service"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    category = value!;
                  });
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed:
                  loading ? null : saveBusiness,
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text("Create Business"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}