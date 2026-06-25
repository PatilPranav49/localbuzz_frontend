import 'package:flutter/material.dart';

import '../services/owner_service.dart';

class CreateUpdateScreen extends StatefulWidget {
  final int businessId;

  const CreateUpdateScreen({
    super.key,
    required this.businessId,
  });

  @override
  State<CreateUpdateScreen> createState() =>
      _CreateUpdateScreenState();
}

class _CreateUpdateScreenState
    extends State<CreateUpdateScreen> {

  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final OwnerService service = OwnerService();

  bool loading = false;

  String updateType = "OFFER";

  Future<void> submitUpdate() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {

      await service.createUpdate(
        businessId: widget.businessId,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        type: updateType,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Update Created Successfully"),
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      if (!mounted) return;

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
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Update"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: ListView(
            children: [

              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                ),
                validator: (value) =>
                value == null || value.isEmpty
                    ? "Required"
                    : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
                validator: (value) =>
                value == null || value.isEmpty
                    ? "Required"
                    : null,
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: updateType,
                decoration: const InputDecoration(
                  labelText: "Update Type",
                ),
                items: const [
                  DropdownMenuItem(
                    value: "OFFER",
                    child: Text("Offer"),
                  ),
                  DropdownMenuItem(
                    value: "NOTICE",
                    child: Text("Notice"),
                  ),
                  DropdownMenuItem(
                    value: "EVENT",
                    child: Text("Event"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    updateType = value!;
                  });
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: loading ? null : submitUpdate,
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text("Create Update"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}