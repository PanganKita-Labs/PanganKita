import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/business/presentation/business_copy.dart';
import 'package:pangankita/features/business/presentation/listing_preview_page.dart';
import 'package:pangankita/features/discovery/domain/listing.dart';
import 'package:pangankita/features/discovery/domain/listing_repository.dart';
import 'package:pangankita/features/discovery/presentation/discovery_format.dart';

/// Short merchant form for a local surplus listing.
class CreateListingPage extends StatefulWidget {
  /// Creates the form with the shared repository and fixed demo merchant.
  const new({
    required this.listings,
    required this.merchant,
    required this.now,
    required this.onSaved,
    super.key,
  });

  /// Shared listing state.
  final ListingRepository listings;

  /// Fixed local business identity.
  final ListingMerchant merchant;

  /// Replaceable clock for pickup validation.
  final DateTime Function() now;

  /// Reports a saved or published listing to the app shell.
  final VoidCallback onSaved;

  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {
  static const _descriptionLines = 3;

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _originalPrice = TextEditingController();
  final _surplusPrice = TextEditingController();
  final _quantity = TextEditingController();
  final _reason = TextEditingController();
  final _condition = TextEditingController();
  final _storage = TextEditingController();
  final _allergens = TextEditingController();
  ListingCategory _category = ListingCategory.bakery;
  DateTime? _pickupStart;
  DateTime? _pickupDeadline;
  String? _timeError;

  DateTime get _start =>
      _pickupStart ?? widget.now().add(const Duration(minutes: 15));

  DateTime get _deadline =>
      _pickupDeadline ?? widget.now().add(const Duration(hours: 2));

  @override
  void initState() {
    super.initState();
    final now = widget.now();
    _pickupStart = now.add(const Duration(minutes: 15));
    _pickupDeadline = now.add(const Duration(hours: 2));
  }

  @override
  void dispose() {
    for (final controller in [
      _name,
      _description,
      _originalPrice,
      _surplusPrice,
      _quantity,
      _reason,
      _condition,
      _storage,
      _allergens,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _positiveNumber(String? value) {
    final number = int.tryParse(value ?? '');
    return number == null || number <= 0 ? BusinessCopy.invalidNumber : null;
  }

  String? _surplusValidation(String? value) {
    final number = int.tryParse(value ?? '');
    final original = int.tryParse(_originalPrice.text);
    if (number == null || number < 0) return BusinessCopy.invalidNumber;
    if (original != null && number > original) return BusinessCopy.invalidPrice;
    return null;
  }

  Future<void> _pickDateTime({required bool deadline}) async {
    final initial = deadline ? _deadline : _start;
    final now = widget.now();
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 30)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null || !mounted) return;
    final selected = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      if (deadline) {
        _pickupDeadline = selected;
      } else {
        _pickupStart = selected;
      }
    });
  }

  void _preview() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    final draft = ListingDraft(
      merchant: widget.merchant,
      name: _name.text,
      category: _category,
      description: _description.text,
      imageAsset: BusinessCopy.imageAsset(_category),
      originalPriceRupiah: int.parse(_originalPrice.text),
      priceRupiah: int.parse(_surplusPrice.text),
      quantity: int.parse(_quantity.text),
      pickupStartsAt: _start,
      pickupDeadline: _deadline,
      surplusReason: _reason.text,
      condition: _condition.text,
      storage: _storage.text,
      allergens: _allergens.text,
    );
    if (!draft.isValidAt(widget.now())) {
      setState(() => _timeError = BusinessCopy.invalidTime);
      return;
    }
    setState(() => _timeError = null);
    Navigator.of(context)
        .push(
          MaterialPageRoute<void>(
            builder: (context) => ListingPreviewPage(
              draft: draft,
              listings: widget.listings,
              onSaved: widget.onSaved,
            ),
          ),
        )
        .ignore();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text(BusinessCopy.formTitle)),
    body: SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(PanganKitaSpacing.md),
          children: [
            Text(
              BusinessCopy.createHeading,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Text(BusinessCopy.createSubtitle),
            const SizedBox(height: PanganKitaSpacing.md),
            Text(
              BusinessCopy.foodDetails,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Text(BusinessCopy.demoNotice),
            const SizedBox(height: PanganKitaSpacing.md),
            _BusinessTextField(controller: _name, label: BusinessCopy.name),
            DropdownButtonFormField<ListingCategory>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: BusinessCopy.category,
              ),
              items: [
                for (final category in ListingCategory.values)
                  DropdownMenuItem(
                    value: category,
                    child: Text(BusinessCopy.categoryLabel(category)),
                  ),
              ],
              onChanged: (value) =>
                  setState(() => _category = value ?? _category),
            ),
            _ListingPhoto(category: _category),
            _BusinessTextField(
              controller: _description,
              label: BusinessCopy.description,
              maxLines: _descriptionLines,
            ),
            const SizedBox(height: PanganKitaSpacing.md),
            Text(
              BusinessCopy.offerDetails,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            _BusinessTextField(
              controller: _originalPrice,
              label: BusinessCopy.originalPrice,
              numeric: true,
              validator: _positiveNumber,
            ),
            _BusinessTextField(
              controller: _surplusPrice,
              label: BusinessCopy.surplusPrice,
              numeric: true,
              validator: _surplusValidation,
            ),
            _BusinessTextField(
              controller: _quantity,
              label: BusinessCopy.quantity,
              numeric: true,
              validator: _positiveNumber,
            ),
            ListTile(
              leading: const Icon(Symbols.schedule),
              title: const Text(BusinessCopy.pickupStart),
              subtitle: Text(formatPickupTime(_start)),
              trailing: const Icon(Symbols.edit_calendar),
              onTap: () => _pickDateTime(deadline: false),
            ),
            ListTile(
              leading: const Icon(Symbols.schedule),
              title: const Text(BusinessCopy.pickupDeadline),
              subtitle: Text(formatPickupTime(_deadline)),
              trailing: const Icon(Symbols.edit_calendar),
              onTap: () => _pickDateTime(deadline: true),
            ),
            if (_timeError case final message?)
              Text(
                message,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            const SizedBox(height: PanganKitaSpacing.md),
            Text(
              BusinessCopy.sellerDetails,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            _SellerFields(
              reason: _reason,
              condition: _condition,
              storage: _storage,
              allergens: _allergens,
              onPreview: _preview,
            ),
            SizedBox(height: MediaQuery.viewInsetsOf(context).bottom),
          ],
        ),
      ),
    ),
  );
}

class _ListingPhoto extends StatelessWidget {
  const new({required this.category});

  static const _imageHeight = 120.0;
  final ListingCategory category;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Stack(
        alignment: Alignment.bottomRight,
        children: [
          Image.asset(
            BusinessCopy.imageAsset(category),
            height: _imageHeight,
            fit: BoxFit.cover,
          ),
          const Padding(
            padding: EdgeInsets.all(PanganKitaSpacing.sm),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Symbols.photo_camera,
                color: PanganKitaColors.brandPrimary,
              ),
            ),
          ),
        ],
      ),
      const Text(BusinessCopy.photoNotice),
    ],
  );
}

class _SellerFields extends StatelessWidget {
  const new({
    required this.reason,
    required this.condition,
    required this.storage,
    required this.allergens,
    required this.onPreview,
  });

  final TextEditingController reason;
  final TextEditingController condition;
  final TextEditingController storage;
  final TextEditingController allergens;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _BusinessTextField(controller: reason, label: BusinessCopy.surplusReason),
      _BusinessTextField(controller: condition, label: BusinessCopy.condition),
      _BusinessTextField(
        controller: storage,
        label: BusinessCopy.storage,
        optional: true,
      ),
      _BusinessTextField(
        controller: allergens,
        label: BusinessCopy.allergens,
        optional: true,
      ),
      const SizedBox(height: PanganKitaSpacing.lg),
      ElevatedButton.icon(
        onPressed: onPreview,
        icon: const Icon(Symbols.publish),
        label: const Text(BusinessCopy.preview),
      ),
    ],
  );
}

class _BusinessTextField extends StatelessWidget {
  const new({
    required this.controller,
    required this.label,
    this.optional = false,
    this.numeric = false,
    this.maxLines = 1,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final bool optional;
  final bool numeric;
  final int maxLines;
  final FormFieldValidator<String>? validator;

  String? _validate(String? value) {
    if (optional) return null;
    if (value == null || value.trim().isEmpty) {
      return BusinessCopy.fieldRequired;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    decoration: InputDecoration(labelText: label),
    keyboardType: numeric ? TextInputType.number : TextInputType.text,
    maxLines: maxLines,
    inputFormatters: numeric ? [FilteringTextInputFormatter.digitsOnly] : null,
    validator: validator ?? _validate,
  );
}
