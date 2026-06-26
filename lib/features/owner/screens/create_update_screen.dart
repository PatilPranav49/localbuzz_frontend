import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/buzz_widgets.dart';
import '../services/owner_service.dart';
import '../../ai/services/ai_service.dart';
class CreateUpdateScreen extends StatefulWidget {
  final int businessId;

  const CreateUpdateScreen({super.key, required this.businessId});

  @override
  State<CreateUpdateScreen> createState() => _CreateUpdateScreenState();
}

class _CreateUpdateScreenState extends State<CreateUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final OwnerService service = OwnerService();
  final AIService _aiService = AIService();
  bool loading = false;
  String updateType = 'OFFER';

  static const _types = [
    ('OFFER', 'Offer', Icons.local_offer_rounded),
    ('NOTICE', 'Notice', Icons.info_rounded),
    ('EVENT', 'Event', Icons.event_rounded),
  ];

  Future<void> submitUpdate() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    try {
      await service.createUpdate(
        businessId: widget.businessId,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        type: updateType,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Update posted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> generatePost() async {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter keywords/title first')),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final response = await _aiService.generatePromotionalPost(
        keywords: titleController.text.trim(),
      );

      descriptionController.text = response;
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post an update'),
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
                'Got something to share?',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Let nearby folks know what\'s up.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 22),

              Text('TYPE', style: theme.textTheme.labelMedium),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _types.map((t) {
                  return BuzzChoiceChip(
                    label: t.$2,
                    icon: t.$3,
                    selected: updateType == t.$1,
                    onTap: () => setState(() => updateType = t.$1),
                  );
                }).toList(),
              ),
              const SizedBox(height: 22),

              Text('TITLE', style: theme.textTheme.labelMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'e.g. 20% off all lattes today',
                ),
                validator: (v) =>
                v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: loading ? null : generatePost,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text("Generate with AI"),
                ),
              ),

              const SizedBox(height: 14),
              Text('DESCRIPTION', style: theme.textTheme.labelMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Add the details people need…',
                ),
                validator: (v) =>
                v == null || v.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 28),
              BuzzGradientButton(
                label: 'POST UPDATE',
                icon: Icons.send_rounded,
                loading: loading,
                onPressed: loading ? null : submitUpdate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}