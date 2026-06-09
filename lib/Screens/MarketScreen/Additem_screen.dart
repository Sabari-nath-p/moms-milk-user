import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:mommilk_user/Screens/MarketScreen/Service/add_marketcontroller.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  CONSTANTS
// ─────────────────────────────────────────────────────────────────────────────

const Color _kRed = Color(0xFFE8453C);
const Color _kRedLight = Color(0xFFFFE5E3);
const Color _kRedBorder = Color(0xFFF0D6D6);
const Color _kGreen = Color(0xFF22C55E);
const Color _kBg = Color(0xFFFAFAFA);
const Color _kHint = Color(0xFFBBBBBB);
const Color _kLabel = Color(0xFF1A1A1A);
const Color _kSubLabel = Color(0xFF6B7280);
const Color _kBorder = Color(0xFFE8E8E8);

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final AddMarketplaceController controller = Get.put(
    AddMarketplaceController(),
  );

  int _step = 0;

  final _materialsInputCtrl = TextEditingController();
  final _colorsInputCtrl = TextEditingController();
  final _boxInputCtrl = TextEditingController();
  final _pincodeCtrl = TextEditingController();

  final List<String> _categories = [
    'CRADLES',
    'TOYS',
    'CLOTHING',
    'STROLLERS',
    'CAR_SEATS',
    'FEEDING',
    'BATH',
    'SAFETY',
    'BOOKS',
    'EDUCATIONAL',
    'OTHER',
  ];
  final List<String> _conditions = ['NEW', 'LIKE_NEW', 'GOOD', 'FAIR', 'POOR'];

  @override
  void dispose() {
    _materialsInputCtrl.dispose();
    _colorsInputCtrl.dispose();
    _boxInputCtrl.dispose();
    _pincodeCtrl.dispose();
    super.dispose();
  }

  // ── helpers ───────────────────────────────────────────────────────────────

  String _catLabel(String c) => c
      .split('_')
      .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
      .join(' ');

  String _condLabel(String c) {
    switch (c) {
      case 'LIKE_NEW':
        return 'Like New';
      case 'NEW':
        return 'New';
      default:
        return c[0] + c.substring(1).toLowerCase();
    }
  }

  Color _condDot(String c) {
    switch (c) {
      case 'NEW':
      case 'LIKE_NEW':
        return _kGreen;
      case 'GOOD':
        return const Color(0xFFF59E0B);
      case 'FAIR':
        return const Color(0xFFF97316);
      case 'POOR':
        return const Color(0xFFDC2626);
      default:
        return _kSubLabel;
    }
  }

  Future<void> _pickImages() async {
    final picked = await ImagePicker().pickMultiImage(imageQuality: 80);
    if (picked.isNotEmpty) {
      final files = picked.map((e) => File(e.path)).toList();
      controller.setSelectedImages([...controller.selectedImages, ...files]);
    }
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: controller.purchasedOn ?? DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(
          ctx,
        ).copyWith(colorScheme: const ColorScheme.light(primary: _kRed)),
        child: child!,
      ),
    );
    if (d != null) controller.setPurchasedOn(d);
  }

  bool _validateStep() {
    switch (_step) {
      case 0:
        if (controller.selectedImages.isEmpty) {
          Get.snackbar(
            'Error',
            'Please add at least one photo',
            backgroundColor: _kRed,
            colorText: Colors.white,
          );
          return false;
        }
        return true;
      case 1:
        if (controller.titleController.text.trim().isEmpty) {
          Get.snackbar(
            'Error',
            'Enter item name',
            backgroundColor: _kRed,
            colorText: Colors.white,
          );
          return false;
        }
        if (controller.priceController.text.trim().isEmpty) {
          Get.snackbar(
            'Error',
            'Enter price',
            backgroundColor: _kRed,
            colorText: Colors.white,
          );
          return false;
        }
        return true;
      case 2:
        if (_pincodeCtrl.text.trim().isEmpty) {
          Get.snackbar(
            'Error',
            'Enter pin code',
            backgroundColor: _kRed,
            colorText: Colors.white,
          );
          return false;
        }
        if (controller.placeController.text.trim().isEmpty) {
          Get.snackbar(
            'Error',
            'Enter place',
            backgroundColor: _kRed,
            colorText: Colors.white,
          );
          return false;
        }
        if (controller.descriptionController.text.trim().isEmpty) {
          Get.snackbar(
            'Error',
            'Enter description',
            backgroundColor: _kRed,
            colorText: Colors.white,
          );
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  void _next() {
    if (!_validateStep()) return;
    if (_step < 3) {
      setState(() => _step++);
    } else {
      _submit();
    }
  }

  void _submit() async {
    controller.zipcodeController.text = _pincodeCtrl.text.trim();
    controller.createListing();
  }

  static const _stepLabels = ['Photos', 'Details', 'Info', 'Review'];
  static const _stepNext = [
    'Next: Item Details',
    'Next: More Info',
    'Next: Review',
    'Post Item',
  ];

  // ══════════════════════════════════════════════════════════════════════════
  //  BUILD
  // ══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddMarketplaceController>(
      builder: (ctrl) => Scaffold(
        backgroundColor: _kBg,
        appBar: _appBar(),
        body: Column(
          children: [
            _stepIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                child: _stepBody(ctrl),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _bottomBar(ctrl),
      ),
    );
  }

  // ── APP BAR ───────────────────────────────────────────────────────────────

  PreferredSizeWidget _appBar() => AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    leading: IconButton(
      onPressed: () => _step > 0 ? setState(() => _step--) : Get.back(),
      icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
    ),
    title: const Text(
      'List an Item',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w700,
        fontSize: 17,
      ),
    ),
  );

  // ── STEP INDICATOR — FIX 1: full width, edge to edge ─────────────────────

  // ── Step indicator: circle — line — circle — line — circle — line — circle
  // Each circle is NOT wrapped in Expanded; only the 3 lines between are Expanded.
  // This makes circles stay same size and lines fill ALL remaining space equally,
  // so "Review" lands exactly at the right edge.
  Widget _stepIndicator() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _stepNode(0),
          Expanded(child: _linePad(0 < _step)),
          _stepNode(1),
          Expanded(child: _linePad(1 < _step)),
          _stepNode(2),
          Expanded(child: _linePad(2 < _step)),
          _stepNode(3),
        ],
      ),
    );
  }

  Widget _stepNode(int i) {
    final done = i < _step;
    final current = i == _step;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _stepCircle(i + 1, done: done, current: current),
        const SizedBox(height: 4),
        Text(
          _stepLabels[i],
          style: TextStyle(
            fontSize: 10,
            fontWeight: current || done ? FontWeight.w600 : FontWeight.w400,
            color: current || done ? _kRed : _kSubLabel,
          ),
        ),
      ],
    );
  }

  // vertically centres the dashed line with the circle midpoint (circle=28px → 14px from top)
  Widget _linePad(bool active) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 20),
    child: _dashedLine(active),
  );

  Widget _stepCircle(int n, {required bool done, required bool current}) {
    if (done) {
      return Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(color: _kRed, shape: BoxShape.circle),
        child: const Icon(Icons.check, color: Colors.white, size: 14),
      );
    }
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: current ? _kRed : const Color(0xFFFFE5E3),
        shape: BoxShape.circle,
        border: Border.all(
          color: current ? _kRed : const Color(0xFFDDDDDD),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          '$n',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: current ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _dashedLine(bool active) => LayoutBuilder(
    builder: (_, bc) {
      const dashW = 4.0, gap = 3.0;
      final count = (bc.maxWidth / (dashW + gap)).floor();
      return Row(
        children: List.generate(
          count,
          (_) => Container(
            width: dashW,
            height: 1.5,
            margin: const EdgeInsets.only(right: gap),
            color: active ? _kRed : const Color(0xFFDDDDDD),
          ),
        ),
      );
    },
  );

  // ── STEP BODY ─────────────────────────────────────────────────────────────

  Widget _stepBody(AddMarketplaceController ctrl) {
    switch (_step) {
      case 0:
        return _photosStep(ctrl);
      case 1:
        return _detailsStep(ctrl);
      case 2:
        return _infoStep(ctrl);
      case 3:
        return _reviewStep(ctrl);
      default:
        return const SizedBox();
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  STEP 0 — PHOTOS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _photosStep(AddMarketplaceController ctrl) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Add photos of your item',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: _kLabel,
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        'Good photos sell faster!',
        style: TextStyle(fontSize: 13, color: _kSubLabel),
      ),
      const SizedBox(height: 16),

      GestureDetector(
        onTap: _pickImages,
        child: Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF5F5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _kRedBorder, width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _kRedLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.add_a_photo_outlined,
                  color: _kRed,
                  size: 26,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tap to add photos',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _kLabel,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Upload up to 8 photos',
                style: TextStyle(fontSize: 12, color: _kSubLabel),
              ),
            ],
          ),
        ),
      ),

      const SizedBox(height: 16),

      if (ctrl.selectedImages.isNotEmpty)
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            ctrl.selectedImages.length,
            (i) => _thumb(ctrl, i),
          ),
        ),

      const SizedBox(height: 20),
      _tipsCard(),
    ],
  );

  Widget _thumb(AddMarketplaceController ctrl, int i) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 80,
            height: 80,
            child: Image.file(ctrl.selectedImages[i], fit: BoxFit.cover),
          ),
        ),
        if (i == 0)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 3),
              decoration: const BoxDecoration(
                color: _kRed,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
              ),
              child: const Text(
                'Primary',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              final imgs = List<File>.from(ctrl.selectedImages)..removeAt(i);
              ctrl.setSelectedImages(imgs);
            },
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 11),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tipsCard() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF5F5),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.lightbulb_outline, color: _kRed, size: 16),
            const SizedBox(width: 6),
            const Text(
              'Tips for good photos',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _kLabel,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (final t in [
          'Use natural light',
          'Show all angles',
          'Include any flaws',
        ])
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                const Icon(Icons.check, color: _kRed, size: 14),
                const SizedBox(width: 6),
                Text(
                  t,
                  style: const TextStyle(fontSize: 12, color: _kSubLabel),
                ),
              ],
            ),
          ),
      ],
    ),
  );

  // ══════════════════════════════════════════════════════════════════════════
  //  STEP 1 — BASIC DETAILS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _detailsStep(AddMarketplaceController ctrl) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Basic Details',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: _kLabel,
        ),
      ),
      const SizedBox(height: 20),

      _fieldLabel('Item Name *'),
      _inputField(
        controller: ctrl.titleController,
        hint: 'e.g. Wooden Baby Cradle - Barely Used',
        maxLength: 60,
        showCounter: true,
      ),
      const SizedBox(height: 16),

      _fieldLabel('Category *'),
      _dropdownField<String>(
        value: ctrl.selectedCategory,
        items: _categories,
        leadingIcon: Icons.category_outlined,
        iconColor: _kRed,
        label: _catLabel,
        onChanged: (v) {
          ctrl.selectedCategory = v!;
          ctrl.update();
        },
      ),
      const SizedBox(height: 16),

      _fieldLabel('Condition *'),
      _dropdownField<String>(
        value: ctrl.selectedCondition,
        items: _conditions,
        leadingDot: true,
        dotColor: _condDot(ctrl.selectedCondition),
        label: _condLabel,
        onChanged: (v) {
          ctrl.selectedCondition = v!;
          ctrl.update();
        },
      ),
      const SizedBox(height: 16),

      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel('Price *'),
                _inputField(
                  controller: ctrl.priceController,
                  hint: '₹ 1,500',
                  prefix: '₹ ',
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel('Original Price'),
                _inputField(
                  controller: ctrl.originalPriceController,
                  hint: '₹ 2,999',
                  prefix: '₹ ',
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ],
      ),

      if (ctrl.savings != null && ctrl.discountPercent != null)
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: Row(
            children: [
              const Icon(Icons.local_offer_outlined, color: _kGreen, size: 14),
              const SizedBox(width: 6),
              Text(
                'You save ₹${ctrl.savings} (${ctrl.discountPercent}% off) for buyers',
                style: const TextStyle(
                  fontSize: 11,
                  color: _kGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

      const SizedBox(height: 16),

      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel('Purchased On'),
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _kBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          color: _kRed,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          ctrl.purchasedOn != null
                              ? DateFormat(
                                  'dd MMM yyyy',
                                ).format(ctrl.purchasedOn!)
                              : '15 Jan 2024',
                          style: TextStyle(
                            fontSize: 13,
                            color: ctrl.purchasedOn != null ? _kLabel : _kHint,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: _kSubLabel,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel('Brand'),
                _inputField(
                  controller: ctrl.brandController,
                  hint: 'Fisher-Price',
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );

  // ══════════════════════════════════════════════════════════════════════════
  //  STEP 2 — MORE INFORMATION
  // ══════════════════════════════════════════════════════════════════════════

  Widget _infoStep(AddMarketplaceController ctrl) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'More Information',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: _kLabel,
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        'Add more details to help buyers know your item better.',
        style: TextStyle(fontSize: 13, color: _kSubLabel),
      ),
      const SizedBox(height: 20),

      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel('Pin Code *'),
                _inputField(
                  controller: _pincodeCtrl,
                  hint: '600001',
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(
                    Icons.location_on_outlined,
                    color: _kSubLabel,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel('Place *'),
                _inputField(
                  controller: ctrl.placeController,
                  hint: 'Chennai, Tamil Nadu',
                  suffixIcon: const Icon(
                    Icons.my_location_outlined,
                    color: _kSubLabel,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),

      _fieldLabel('Description *'),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _kBorder),
        ),
        child: TextField(
          controller: ctrl.descriptionController,
          maxLines: 5,
          maxLength: 500,
          style: const TextStyle(fontSize: 14, color: _kLabel),
          decoration: const InputDecoration(
            hintText: 'Tell us more about the item',
            hintStyle: TextStyle(color: _kHint, fontSize: 14),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(12),
            counterStyle: TextStyle(fontSize: 11, color: _kSubLabel),
          ),
        ),
      ),
      const SizedBox(height: 16),

      _fieldLabel('Materials'),
      // FIX 4: tag input with correct alignment
      _tagInputField(
        tags: ctrl.materials,
        inputCtrl: _materialsInputCtrl,
        hint: '+ Add',
        onAdd: () {
          ctrl.addMaterial(_materialsInputCtrl.text.trim());
          _materialsInputCtrl.clear();
        },
        onRemove: ctrl.removeMaterial,
      ),
      const SizedBox(height: 16),

      _fieldLabel('Colors'),
      _tagInputField(
        tags: ctrl.colors,
        inputCtrl: _colorsInputCtrl,
        hint: '+ Add',
        onAdd: () {
          ctrl.addColor(_colorsInputCtrl.text.trim());
          _colorsInputCtrl.clear();
        },
        onRemove: ctrl.removeColor,
      ),
      const SizedBox(height: 16),

      _fieldLabel('Dimensions'),
      _inputField(
        controller: ctrl.dimensionsController,
        hint: '60cm x 40cm x 35cm',
        prefixIcon: const Icon(
          Icons.straighten_outlined,
          color: _kSubLabel,
          size: 18,
        ),
      ),
      const SizedBox(height: 16),

      _fieldLabel('Box Contains'),
      _tagInputField(
        tags: ctrl.boxContains,
        inputCtrl: _boxInputCtrl,
        hint: '+ Add',
        onAdd: () {
          ctrl.addBoxItem(_boxInputCtrl.text.trim());
          _boxInputCtrl.clear();
        },
        onRemove: ctrl.removeBoxItem,
      ),

      const SizedBox(height: 20),
      _tipsInfoCard(),
    ],
  );

  Widget _tipsInfoCard() => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF5F5),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.lightbulb_outline, color: _kRed, size: 16),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tips',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _kLabel,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'More details build trust and help you sell faster!',
                style: TextStyle(fontSize: 12, color: _kSubLabel),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  // ══════════════════════════════════════════════════════════════════════════
  //  STEP 3 — REVIEW
  // ══════════════════════════════════════════════════════════════════════════

  Widget _reviewStep(AddMarketplaceController ctrl) {
    final price = int.tryParse(ctrl.priceController.text.trim()) ?? 0;
    final origPrice = int.tryParse(ctrl.originalPriceController.text.trim());
    final disc = ctrl.discountPercent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Review Your Listing',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _kLabel,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Please review all details before posting your item.',
          style: TextStyle(fontSize: 13, color: _kSubLabel),
        ),
        const SizedBox(height: 16),

        // Preview card
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _kBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // image — no edit icon (removed)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: ctrl.selectedImages.isNotEmpty
                          ? Image.file(
                              ctrl.selectedImages[0],
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: const Color(0xFFF5F5F5),
                              child: const Icon(
                                Icons.image_outlined,
                                color: _kSubLabel,
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        decoration: const BoxDecoration(
                          color: _kRed,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Primary',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ctrl.titleController.text.trim().isNotEmpty
                          ? ctrl.titleController.text.trim()
                          : 'Item Title',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _kLabel,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '₹$price',
                          style: const TextStyle(
                            color: _kRed,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (origPrice != null)
                          Text(
                            '₹$origPrice',
                            style: const TextStyle(
                              color: _kSubLabel,
                              fontSize: 13,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: _kSubLabel,
                            ),
                          ),
                      ],
                    ),
                    if (disc != null) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '$disc% OFF',
                          style: const TextStyle(
                            color: _kGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // FIX 2: detail table — Expanded on value side so it's always right-aligned
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _kBorder),
          ),
          child: Column(
            children: [
              _reviewRow(
                Icons.sell_outlined,
                _kRed,
                'Category',
                _catLabel(ctrl.selectedCategory),
              ),
              _reviewDivider(),
              _reviewRow(
                Icons.circle,
                _condDot(ctrl.selectedCondition),
                'Condition',
                _condLabel(ctrl.selectedCondition),
              ),
              _reviewDivider(),
              _reviewRow(
                Icons.branding_watermark_outlined,
                _kSubLabel,
                'Brand',
                ctrl.brandController.text.isNotEmpty
                    ? ctrl.brandController.text
                    : '—',
              ),
              _reviewDivider(),
              _reviewRow(
                Icons.calendar_today_outlined,
                _kSubLabel,
                'Purchased On',
                ctrl.purchasedOn != null
                    ? DateFormat('dd MMM yyyy').format(ctrl.purchasedOn!)
                    : '—',
              ),
              _reviewDivider(),
              _reviewRow(
                Icons.location_on_outlined,
                _kSubLabel,
                'Location',
                '${ctrl.placeController.text} (${_pincodeCtrl.text})',
              ),
              _reviewDivider(),
              _reviewRow(
                Icons.attach_money_outlined,
                _kSubLabel,
                'Price',
                disc != null
                    ? '₹$price (${disc}% off)\nOriginal: ₹${ctrl.originalPriceController.text}'
                    : '₹$price',
              ),
              if (ctrl.boxContains.isNotEmpty) ...[
                _reviewDivider(),
                _reviewRowTags(
                  Icons.inventory_2_outlined,
                  'Box Contains',
                  ctrl.boxContains,
                ),
              ],
              if (ctrl.dimensionsController.text.isNotEmpty) ...[
                _reviewDivider(),
                _reviewRow(
                  Icons.straighten_outlined,
                  _kSubLabel,
                  'Dimensions',
                  ctrl.dimensionsController.text,
                ),
              ],
              if (ctrl.materials.isNotEmpty) ...[
                _reviewDivider(),
                _reviewRow(
                  Icons.texture_outlined,
                  _kSubLabel,
                  'Materials',
                  ctrl.materials.join(', '),
                ),
              ],
              if (ctrl.colors.isNotEmpty) ...[
                _reviewDivider(),
                _reviewRowColors('Colors', ctrl.colors),
              ],
              if (ctrl.descriptionController.text.isNotEmpty) ...[
                _reviewDivider(),
                _reviewRow(
                  Icons.description_outlined,
                  _kSubLabel,
                  'Description',
                  ctrl.descriptionController.text.length > 80
                      ? '${ctrl.descriptionController.text.substring(0, 80)}...'
                      : ctrl.descriptionController.text,
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFFBF3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF22C55E),
                    width: 1.2,
                  ),
                ),
                child: const Icon(
                  Icons.verified_user_outlined,
                  color: Color(0xFF22C55E),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your listing looks good!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _kLabel,
                      ),
                    ),
                    Text(
                      'Buyers will see all details clearly.',
                      style: TextStyle(fontSize: 12, color: _kSubLabel),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ── Review helper widgets ─────────────────────────────────────────────────

  // FIX 2: use Expanded instead of Flexible+Spacer so value is always right-aligned
  Widget _reviewRow(
    IconData icon,
    Color iconColor,
    String label,
    String value,
  ) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    child: Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 10),
        // Label takes only what it needs
        Text(label, style: const TextStyle(fontSize: 13, color: _kSubLabel)),
        const SizedBox(width: 8),
        // Value fills the rest and aligns right
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _kLabel,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _reviewRowTags(
    IconData icon,
    String label,
    List<String> tags,
  ) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: _kSubLabel),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(fontSize: 13, color: _kSubLabel)),
        const SizedBox(width: 8),
        Expanded(
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            alignment: WrapAlignment.end,
            children: [
              ...tags
                  .take(3)
                  .map(
                    (t) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        t,
                        style: const TextStyle(fontSize: 11, color: _kLabel),
                      ),
                    ),
                  ),
              if (tags.length > 3)
                Text(
                  '+${tags.length - 3} more',
                  style: const TextStyle(fontSize: 11, color: _kSubLabel),
                ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _reviewRowColors(String label, List<String> colors) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    child: Row(
      children: [
        const Icon(Icons.color_lens_outlined, size: 16, color: _kSubLabel),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(fontSize: 13, color: _kSubLabel)),
        const Spacer(),
        Row(
          children: colors
              .take(4)
              .map(
                (c) => Container(
                  margin: const EdgeInsets.only(left: 4),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _parseColor(c),
                    shape: BoxShape.circle,
                    border: Border.all(color: _kBorder),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    ),
  );

  Color _parseColor(String name) {
    switch (name.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'pink':
        return Colors.pink;
      case 'white':
        return Colors.grey.shade200;
      case 'black':
        return Colors.black;
      case 'yellow':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget _reviewDivider() => Divider(height: 1, color: _kBorder, indent: 40);

  // ── BOTTOM BAR — FIX 2: "Edit Details" button removed ────────────────────

  Widget _bottomBar(AddMarketplaceController ctrl) => Container(
    padding: EdgeInsets.fromLTRB(
      16,
      12,
      16,
      12 + MediaQuery.of(context).padding.bottom,
    ),
    color: Colors.white,
    child: SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: ctrl.isLoading ? null : _next,
        style: ElevatedButton.styleFrom(
          backgroundColor: _kRed,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: ctrl.isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _stepNext[_step],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_ios, size: 13),
                ],
              ),
      ),
    ),
  );

  // ── SHARED FIELD WIDGETS ──────────────────────────────────────────────────

  Widget _fieldLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: _kLabel,
      ),
    ),
  );

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    String? prefix,
    bool showCounter = false,
    int? maxLength,
    TextInputType? keyboardType,
    bool usePrefix = true,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) => TextField(
    controller: controller,
    keyboardType: keyboardType,
    maxLength: maxLength,
    style: const TextStyle(fontSize: 14, color: _kLabel),
    onChanged: (_) => setState(() {}),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _kHint, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      prefixText: (usePrefix && prefix != null) ? prefix : null,
      prefixStyle: const TextStyle(fontSize: 14, color: _kLabel),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      counterText: showCounter ? null : '',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _kBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _kBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _kRed, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    ),
  );

  Widget _dropdownField<T>({
    required T value,
    required List<T> items,
    required String Function(T) label,
    required void Function(T?) onChanged,
    IconData? leadingIcon,
    Color? iconColor,
    bool leadingDot = false,
    Color dotColor = _kGreen,
  }) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: _kBorder),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        value: value,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down, color: _kSubLabel),
        style: const TextStyle(fontSize: 14, color: _kLabel),
        items: items
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: Row(
                  children: [
                    if (leadingIcon != null) ...[
                      Icon(
                        leadingIcon,
                        color: iconColor ?? _kSubLabel,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (leadingDot && item == value) ...[
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: dotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(label(item)),
                  ],
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    ),
  );

  // FIX 4: tag input — "+ Add" input is now always at the end of the Wrap,
  // aligned left with the tags naturally, not floating awkwardly
  Widget _tagInputField({
    required List<String> tags,
    required TextEditingController inputCtrl,
    required String hint,
    required VoidCallback onAdd,
    required void Function(String) onRemove,
  }) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: _kBorder),
    ),
    child: Wrap(
      spacing: 6,
      runSpacing: 6,
      crossAxisAlignment:
          WrapCrossAlignment.center, // ← centres tags + input vertically
      children: [
        // existing tags
        ...tags.map(
          (t) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(t, style: const TextStyle(fontSize: 13, color: _kLabel)),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => onRemove(t),
                  child: const Icon(Icons.close, size: 13, color: _kSubLabel),
                ),
              ],
            ),
          ),
        ),
        // inline "+ Add" input — fixed width, same height as tags
        IntrinsicWidth(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 60, maxWidth: 100),
            child: TextField(
              controller: inputCtrl,
              style: const TextStyle(
                fontSize: 13,
                color: _kRed,
                fontWeight: FontWeight.w600,
              ),
              onSubmitted: (_) => onAdd(),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: _kRed,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
                isDense: true,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
