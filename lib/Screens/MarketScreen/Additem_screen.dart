import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:mommilk_user/Screens/MarketScreen/Service/add_marketcontroller.dart';

const Color _kRed = Color(0xFFE8453C);
const Color _kRedLight = Color(0xFFFFE5E3);
const Color _kRedBorder = Color(0xFFF0D6D6);
const Color _kGreen = Color(0xFF22C55E);
const Color _kBg = Color(0xFFFAFAFA);
const Color _kHint = Color(0xFFBBBBBB);
const Color _kLabel = Color(0xFF1A1A1A);
const Color _kSubLabel = Color(0xFF6B7280);
const Color _kBorder = Color(0xFFE8E8E8);

const int _kMaxPhotos = 8;

class AddItemScreen extends StatefulWidget {
  AddItemScreen({super.key});

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

  final _materialsFocus = FocusNode();
  final _colorsFocus = FocusNode();
  final _boxFocus = FocusNode();

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
  void initState() {
    super.initState();
    _materialsFocus.addListener(() {
      if (!_materialsFocus.hasFocus &&
          _materialsInputCtrl.text.trim().isNotEmpty) {
        controller.addMaterial(_materialsInputCtrl.text.trim());
        _materialsInputCtrl.clear();
      }
    });
    _colorsFocus.addListener(() {
      if (!_colorsFocus.hasFocus && _colorsInputCtrl.text.trim().isNotEmpty) {
        controller.addColor(_colorsInputCtrl.text.trim());
        _colorsInputCtrl.clear();
      }
    });
    _boxFocus.addListener(() {
      if (!_boxFocus.hasFocus && _boxInputCtrl.text.trim().isNotEmpty) {
        controller.addBoxItem(_boxInputCtrl.text.trim());
        _boxInputCtrl.clear();
      }
    });
  }

  @override
  void dispose() {
    _materialsInputCtrl.dispose();
    _colorsInputCtrl.dispose();
    _boxInputCtrl.dispose();
    _pincodeCtrl.dispose();
    _materialsFocus.dispose();
    _colorsFocus.dispose();
    _boxFocus.dispose();
    super.dispose();
  }

  String _catLabel(String c) {
    // Human-readable label, then translated
    final label = c
        .split('_')
        .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join(' ');
    return label.tr;
  }

  String _condLabel(String c) {
    switch (c) {
      case 'LIKE_NEW':
        return 'Like New'.tr;
      case 'NEW':
        return 'New'.tr;
      case 'GOOD':
        return 'Good'.tr;
      case 'FAIR':
        return 'Fair'.tr;
      case 'POOR':
        return 'Poor'.tr;
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
        return Color(0xFFF59E0B);
      case 'FAIR':
        return Color(0xFFF97316);
      case 'POOR':
        return Color(0xFFDC2626);
      default:
        return _kSubLabel;
    }
  }

  // ── Photo picker: show bottom sheet → Camera or Gallery ──────────────────
  // This is called when user taps the main "Tap to add photos" box OR the "+ Add more" button.
  // Design matches screenshot 4: single tap box → bottom sheet → pick source.
  void _showPhotoSourceSheet() {
    if (controller.selectedImages.length >= _kMaxPhotos) {
      Get.snackbar(
        'Limit Reached',
        'You can only add up to $_kMaxPhotos photos.',
        backgroundColor: _kRed,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final remaining = _kMaxPhotos - controller.selectedImages.length;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Text(
                  'Add Photo'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _kLabel,
                  ),
                ),
                SizedBox(height: 16),
                // Camera option
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _kRedLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: _kRed,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    'Take a Photo'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: _kLabel,
                    ),
                  ),
                  subtitle: Text(
                    'Open camera and click a photo'.tr,
                    style: TextStyle(fontSize: 12, color: _kSubLabel),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: _kSubLabel,
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickFromCamera();
                  },
                ),
                Divider(height: 1),
                // Gallery option
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _kRedLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.photo_library_outlined,
                      color: _kRed,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    'Choose from Gallery'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: _kLabel,
                    ),
                  ),
                  subtitle: Text(
                    'Select up to $remaining photo${remaining == 1 ? '' : 's'}',
                    style: TextStyle(fontSize: 12, color: _kSubLabel),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: _kSubLabel,
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickFromGallery();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickFromCamera() async {
    if (controller.selectedImages.length >= _kMaxPhotos) return;
    final picked = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (picked == null) return;
    final file = File(picked.path);
    controller.setSelectedImages([...controller.selectedImages, file]);
    await controller.uploadImages([file]);
  }

  Future<void> _pickFromGallery() async {
    final currentCount = controller.selectedImages.length;
    if (currentCount >= _kMaxPhotos) return;
    final remaining = _kMaxPhotos - currentCount;
    final picked = await ImagePicker().pickMultiImage(imageQuality: 80);
    if (picked.isEmpty) return;

    final allowed = picked.take(remaining).toList();
    if (picked.length > remaining) {
      Get.snackbar(
        'Too Many Photos',
        'Only $remaining more photo${remaining == 1 ? '' : 's'} allowed. First $remaining selected.',
        backgroundColor: _kRed,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    }
    final files = allowed.map((e) => File(e.path)).toList();
    controller.setSelectedImages([...controller.selectedImages, ...files]);
    await controller.uploadImages(files);
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

  bool _hasRealText(String value) =>
      RegExp(r'[a-zA-Z0-9\u0900-\u097F]').hasMatch(value);

  bool _validateStep() {
    switch (_step) {
      case 0:
        if (controller.selectedImages.isEmpty) {
          _snack('Please add at least one photo');
          return false;
        }
        return true;

      case 1:
        final title = controller.titleController.text.trim();
        final price = controller.priceController.text.trim();
        if (title.isEmpty) {
          _snack('Enter item name');
          return false;
        }
        if (!_hasRealText(title)) {
          _snack('Item name must contain valid characters');
          return false;
        }
        if (price.isEmpty) {
          _snack('Enter price');
          return false;
        }
        final priceInt = int.tryParse(price);
        if (priceInt == null || priceInt <= 0) {
          _snack('Enter a valid price');
          return false;
        }
        final origText = controller.originalPriceController.text.trim();
        if (origText.isNotEmpty) {
          final origInt = int.tryParse(origText);
          if (origInt == null || origInt <= 0) {
            _snack('Enter a valid original price');
            return false;
          }
          if (origInt <= priceInt) {
            _snack('Original price must be higher than selling price');
            return false;
          }
        }
        return true;

      case 2:
        if (_materialsInputCtrl.text.trim().isNotEmpty) {
          controller.addMaterial(_materialsInputCtrl.text.trim());
          _materialsInputCtrl.clear();
        }
        if (_colorsInputCtrl.text.trim().isNotEmpty) {
          controller.addColor(_colorsInputCtrl.text.trim());
          _colorsInputCtrl.clear();
        }
        if (_boxInputCtrl.text.trim().isNotEmpty) {
          controller.addBoxItem(_boxInputCtrl.text.trim());
          _boxInputCtrl.clear();
        }
        final pincode = _pincodeCtrl.text.trim();
        final place = controller.placeController.text.trim();
        final desc = controller.descriptionController.text.trim();
        if (pincode.isEmpty) {
          _snack('Enter pin code');
          return false;
        }
        if (!RegExp(r'^\d{5,10}$').hasMatch(pincode)) {
          _snack('Pin code must be 5–10 digits');
          return false;
        }
        if (place.isEmpty) {
          _snack('Enter place');
          return false;
        }
        if (!_hasRealText(place)) {
          _snack('Place must contain valid characters');
          return false;
        }
        if (desc.isEmpty) {
          _snack('Enter description');
          return false;
        }
        if (desc.length < 10) {
          _snack('Description must be at least 10 characters');
          return false;
        }
        if (!_hasRealText(desc)) {
          _snack('Description must contain real text');
          return false;
        }
        return true;

      default:
        return true;
    }
  }

  void _snack(String msg) => Get.snackbar(
    'Error',
    msg,
    backgroundColor: _kRed,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
  );

  void _next() {
    if (!_validateStep()) return;
    if (_step < 3) {
      setState(() => _step++);
    } else {
      _submit();
    }
  }

  void _submit() {
    controller.zipcodeController.text = _pincodeCtrl.text.trim();
    controller.createListing();
  }

  static List<String> get _stepLabels => [
    'Photos'.tr,
    'Details'.tr,
    'Info'.tr,
    'Review'.tr,
  ];
  static List<String> get _stepNext => [
    'Next: Item Details'.tr,
    'Next: More Info'.tr,
    'Next: Review'.tr,
    'Post Item'.tr,
  ];

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

  PreferredSizeWidget _appBar() => AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    leading: IconButton(
      onPressed: () => _step > 0 ? setState(() => _step--) : Get.back(),
      icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
    ),
    title: Text(
      'List an Item'.tr,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w700,
        fontSize: 17,
      ),
    ),
  );

  Widget _stepIndicator() => Container(
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

  Widget _stepNode(int i) {
    final done = i < _step;
    final current = i == _step;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _stepCircle(i + 1, done: done, current: current),
        SizedBox(height: 4),
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

  Widget _linePad(bool active) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 20),
    child: _dashedLine(active),
  );

  Widget _stepCircle(int n, {required bool done, required bool current}) {
    if (done) {
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(color: _kRed, shape: BoxShape.circle),
        child: Icon(Icons.check, color: Colors.white, size: 14),
      );
    }
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: current ? _kRed : Color(0xFFFFE5E3),
        shape: BoxShape.circle,
        border: Border.all(
          color: current ? _kRed : Color(0xFFDDDDDD),
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
            color: active ? _kRed : Color(0xFFDDDDDD),
          ),
        ),
      );
    },
  );

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
        return SizedBox();
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  STEP 0 — PHOTOS
  //  Design: single "Tap to add photos" box (like screenshot 4)
  //  Tapping opens a bottom sheet with Camera / Gallery options
  //  After photos added: thumbnails appear below with "+ Add more" button
  // ══════════════════════════════════════════════════════════════════════════

  Widget _photosStep(AddMarketplaceController ctrl) {
    final limitReached = ctrl.selectedImages.length >= _kMaxPhotos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add photos of your item'.tr,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _kLabel,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Good photos sell faster! (${ctrl.selectedImages.length}/$_kMaxPhotos)',
          style: TextStyle(fontSize: 13, color: _kSubLabel),
        ),
        SizedBox(height: 16),

        // ALWAYS show the tap box — even after photos are added
        // Tapping always opens Camera/Gallery sheet
        GestureDetector(
          onTap: limitReached ? null : _showPhotoSourceSheet,
          child: Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: limitReached ? Color(0xFFF5F5F5) : Color(0xFFFFF5F5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: limitReached ? Color(0xFFDDDDDD) : _kRedBorder,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: limitReached ? Color(0xFFEEEEEE) : _kRedLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.add_a_photo_outlined,
                    color: limitReached ? Colors.grey : _kRed,
                    size: 26,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  limitReached
                      ? 'Maximum $_kMaxPhotos photos reached'
                      : 'Tap to add photos'.tr,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: limitReached ? Colors.grey : _kLabel,
                  ),
                ),
                if (!limitReached) ...[
                  SizedBox(height: 4),
                  Text(
                    'Upload up to 8 photos'.tr,
                    style: TextStyle(fontSize: 12, color: _kSubLabel),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Thumbnails grid below the tap box
        if (ctrl.selectedImages.isNotEmpty) ...[
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              ctrl.selectedImages.length,
              (i) => _thumb(ctrl, i),
            ),
          ),
        ],

        SizedBox(height: 20),
        _tipsCard(),
      ],
    );
  }

  void _viewPhotoFullScreen(BuildContext context, File file) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(child: Image.file(file, fit: BoxFit.contain)),
            ),
            Positioned(
              top: 40,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _thumb(AddMarketplaceController ctrl, int i) => Stack(
    children: [
      GestureDetector(
        onTap: () => _viewPhotoFullScreen(context, ctrl.selectedImages[i]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 80,
            height: 80,
            child: Image.file(ctrl.selectedImages[i], fit: BoxFit.cover),
          ),
        ),
      ),
      if (i == 0)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
              color: _kRed,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            ),
            child: Text(
              'Primary'.tr,
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
            decoration: BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.close, color: Colors.white, size: 11),
          ),
        ),
      ),
    ],
  );

  Widget _tipsCard() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Color(0xFFFFF5F5),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.lightbulb_outline, color: _kRed, size: 16),
            SizedBox(width: 6),
            Text(
              'Tips for good photos'.tr,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _kLabel,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        for (final t in [
          'Use natural light'.tr,
          'Show all angles'.tr,
          'Include any flaws'.tr,
        ])
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Icon(Icons.check, color: _kRed, size: 14),
                SizedBox(width: 6),
                Text(t, style: TextStyle(fontSize: 12, color: _kSubLabel)),
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
      Text(
        'Basic Details'.tr,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: _kLabel,
        ),
      ),
      SizedBox(height: 20),

      _fieldLabel('Item Name *'.tr),
      _inputField(
        controller: ctrl.titleController,
        hint: 'e.g. Wooden Baby Cradle - Barely Used',
        maxLength: 60,
        showCounter: true,
      ),
      SizedBox(height: 16),

      _fieldLabel('Category *'.tr),
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
      SizedBox(height: 16),

      _fieldLabel('Condition *'.tr),
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
      SizedBox(height: 16),

      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel('Price *'.tr),
                _inputField(
                  controller: ctrl.priceController,
                  hint: '1500',
                  prefix: '₹ ',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel('Original Price'.tr),
                _inputField(
                  controller: ctrl.originalPriceController,
                  hint: '2999',
                  prefix: '₹ ',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
            color: Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFFBBF7D0)),
          ),
          child: Row(
            children: [
              Icon(Icons.local_offer_outlined, color: _kGreen, size: 14),
              SizedBox(width: 6),
              Text(
                '${'Buyers save'.tr} ₹${ctrl.savings} (${ctrl.discountPercent}% ${'off'.tr})',
                style: TextStyle(
                  fontSize: 11,
                  color: _kGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

      SizedBox(height: 16),

      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel('Purchased On'.tr),
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
                        Icon(
                          Icons.calendar_month_outlined,
                          color: _kRed,
                          size: 16,
                        ),
                        SizedBox(width: 8),
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
                        Spacer(),
                        Icon(
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
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel('Brand'.tr),
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
      Text(
        'More Information'.tr,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: _kLabel,
        ),
      ),
      SizedBox(height: 4),
      Text(
        'Add more details to help buyers know your item better.'.tr,
        style: TextStyle(fontSize: 13, color: _kSubLabel),
      ),
      SizedBox(height: 20),

      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel('Pin Code *'.tr),
                _inputField(
                  controller: _pincodeCtrl,
                  hint: '600001',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  prefixIcon: Icon(
                    Icons.location_on_outlined,
                    color: _kSubLabel,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel('Place *'.tr),
                _inputField(
                  controller: ctrl.placeController,
                  hint: 'e.g. Alappuzha, Kerala',
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: 16),

      _fieldLabel('Description *'.tr),
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
          style: TextStyle(fontSize: 14, color: _kLabel),
          decoration: InputDecoration(
            hintText: 'Tell us more about the item (min 10 characters)'.tr,
            hintStyle: TextStyle(color: _kHint, fontSize: 14),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(12),
            counterStyle: TextStyle(fontSize: 11, color: _kSubLabel),
          ),
        ),
      ),
      SizedBox(height: 16),

      _fieldLabel('Materials'.tr),
      _tagInputField(
        tags: ctrl.materials,
        inputCtrl: _materialsInputCtrl,
        focusNode: _materialsFocus,
        hint: '+ Add'.tr,
        onAdd: () {
          controller.addMaterial(_materialsInputCtrl.text.trim());
          _materialsInputCtrl.clear();
        },
        onRemove: ctrl.removeMaterial,
      ),
      SizedBox(height: 16),

      _fieldLabel('Colors'.tr),
      _tagInputField(
        tags: ctrl.colors,
        inputCtrl: _colorsInputCtrl,
        focusNode: _colorsFocus,
        hint: '+ Add'.tr,
        onAdd: () {
          controller.addColor(_colorsInputCtrl.text.trim());
          _colorsInputCtrl.clear();
        },
        onRemove: ctrl.removeColor,
      ),
      SizedBox(height: 16),

      _fieldLabel('Dimensions'.tr),
      _inputField(
        controller: ctrl.dimensionsController,
        hint: '60cm x 40cm x 35cm',
        prefixIcon: Icon(
          Icons.straighten_outlined,
          color: _kSubLabel,
          size: 18,
        ),
      ),
      SizedBox(height: 16),

      _fieldLabel('Box Contains'.tr),
      _tagInputField(
        tags: ctrl.boxContains,
        inputCtrl: _boxInputCtrl,
        focusNode: _boxFocus,
        hint: '+ Add'.tr,
        onAdd: () {
          controller.addBoxItem(_boxInputCtrl.text.trim());
          _boxInputCtrl.clear();
        },
        onRemove: ctrl.removeBoxItem,
      ),
      SizedBox(height: 20),

      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFFFF5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lightbulb_outline, color: _kRed, size: 16),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tips'.tr,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _kLabel,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'More details build trust and help you sell faster!'.tr,
                    style: TextStyle(fontSize: 12, color: _kSubLabel),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
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
        Text(
          'Review Your Listing'.tr,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _kLabel,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Please review all details before posting your item.'.tr,
          style: TextStyle(fontSize: 13, color: _kSubLabel),
        ),
        SizedBox(height: 16),

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
                              color: Color(0xFFF5F5F5),
                              child: Icon(
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
                        decoration: BoxDecoration(
                          color: _kRed,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Primary'.tr,
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
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ctrl.titleController.text.trim().isNotEmpty
                          ? ctrl.titleController.text.trim()
                          : 'Item Title'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _kLabel,
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '₹$price',
                          style: TextStyle(
                            color: _kRed,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 6),
                        if (origPrice != null)
                          Text(
                            '₹$origPrice',
                            style: TextStyle(
                              color: _kSubLabel,
                              fontSize: 13,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: _kSubLabel,
                            ),
                          ),
                      ],
                    ),
                    if (disc != null) ...[
                      SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '$disc% OFF',
                          style: TextStyle(
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

        SizedBox(height: 16),

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
                'Category'.tr,
                _catLabel(ctrl.selectedCategory),
              ),
              _reviewDivider(),
              _reviewRow(
                Icons.circle,
                _condDot(ctrl.selectedCondition),
                'Condition'.tr,
                _condLabel(ctrl.selectedCondition),
              ),
              _reviewDivider(),
              _reviewRow(
                Icons.branding_watermark_outlined,
                _kSubLabel,
                'Brand'.tr,
                ctrl.brandController.text.isNotEmpty
                    ? ctrl.brandController.text
                    : '—',
              ),
              _reviewDivider(),
              _reviewRow(
                Icons.calendar_today_outlined,
                _kSubLabel,
                'Purchased On'.tr,
                ctrl.purchasedOn != null
                    ? DateFormat('dd MMM yyyy').format(ctrl.purchasedOn!)
                    : '—',
              ),
              _reviewDivider(),
              _reviewRow(
                Icons.location_on_outlined,
                _kSubLabel,
                'Location'.tr,
                '${ctrl.placeController.text} (${_pincodeCtrl.text})',
              ),
              _reviewDivider(),
              _reviewRow(
                Icons.attach_money_outlined,
                _kSubLabel,
                'Price'.tr,
                disc != null
                    ? '₹$price (${disc}% off)\nOriginal: ₹${ctrl.originalPriceController.text}'
                    : '₹$price',
              ),
              if (ctrl.materials.isNotEmpty) ...[
                _reviewDivider(),
                _reviewRow(
                  Icons.texture_outlined,
                  _kSubLabel,
                  'Materials'.tr,
                  ctrl.materials.join(', '),
                ),
              ],
              if (ctrl.colors.isNotEmpty) ...[
                _reviewDivider(),
                _reviewRowColors('Colors'.tr, ctrl.colors),
              ],
              if (ctrl.descriptionController.text.isNotEmpty) ...[
                _reviewDivider(),
                _reviewRow(
                  Icons.description_outlined,
                  _kSubLabel,
                  'Description'.tr,
                  ctrl.descriptionController.text.length > 80
                      ? '${ctrl.descriptionController.text.substring(0, 80)}...'
                      : ctrl.descriptionController.text,
                ),
              ],
            ],
          ),
        ),

        SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFBBF7D0)),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Color(0xFFEFFBF3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFF22C55E), width: 1.2),
                ),
                child: Icon(
                  Icons.verified_user_outlined,
                  color: Color(0xFF22C55E),
                  size: 18,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your listing looks good!'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _kLabel,
                      ),
                    ),
                    Text(
                      'Buyers will see all details clearly.'.tr,
                      style: TextStyle(fontSize: 12, color: _kSubLabel),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

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
        SizedBox(width: 10),
        Text(label, style: TextStyle(fontSize: 13, color: _kSubLabel)),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _kLabel,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _reviewRowColors(String label, List<String> colors) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    child: Row(
      children: [
        Icon(Icons.color_lens_outlined, size: 16, color: _kSubLabel),
        SizedBox(width: 10),
        Text(label, style: TextStyle(fontSize: 13, color: _kSubLabel)),
        Spacer(),
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
            ? SizedBox(
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
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_ios, size: 13),
                ],
              ),
      ),
    ),
  );

  Widget _fieldLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: TextStyle(
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
    List<TextInputFormatter>? inputFormatters,
  }) => TextField(
    controller: controller,
    keyboardType: keyboardType,
    maxLength: maxLength,
    inputFormatters: inputFormatters,
    style: TextStyle(fontSize: 14, color: _kLabel),
    onChanged: (_) => setState(() {}),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: _kHint, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      prefixText: (usePrefix && prefix != null) ? prefix : null,
      prefixStyle: TextStyle(fontSize: 14, color: _kLabel),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      counterText: showCounter ? null : '',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: _kBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: _kBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: _kRed, width: 1.5),
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
        icon: Icon(Icons.keyboard_arrow_down, color: _kSubLabel),
        style: TextStyle(fontSize: 14, color: _kLabel),
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
                      SizedBox(width: 8),
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
                      SizedBox(width: 8),
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

  Widget _tagInputField({
    required List<String> tags,
    required TextEditingController inputCtrl,
    required FocusNode focusNode,
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
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...tags.map(
          (t) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(t, style: TextStyle(fontSize: 13, color: _kLabel)),
                SizedBox(width: 4),
                GestureDetector(
                  onTap: () => onRemove(t),
                  child: Icon(Icons.close, size: 13, color: _kSubLabel),
                ),
              ],
            ),
          ),
        ),
        IntrinsicWidth(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 60, maxWidth: 100),
            child: TextField(
              controller: inputCtrl,
              focusNode: focusNode,
              style: TextStyle(
                fontSize: 13,
                color: _kRed,
                fontWeight: FontWeight.w600,
              ),
              onSubmitted: (_) => onAdd(),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
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
