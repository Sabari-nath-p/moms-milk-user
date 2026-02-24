import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/BabyModel.dart';
import 'package:mommilk_user/Screens/CreateBabyScreen/Controller/BabyCreateController.dart';
import 'package:mommilk_user/Screens/CreateBabyScreen/CreateBabyScreen.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class HBabyCard extends StatelessWidget {
  HBabyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Homecontroller>(
      builder: (controller) {
        /// 🔥 Fix 1: Ensure selected baby is NOT null
        if (controller.myBabies.isNotEmpty && controller.selectedBady == null) {
          controller.selectedBady = controller.myBabies.first;
        }

        final gradientBox =
            (Widget child) => ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color(0xffFFE4E6),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: child,
              ),
            );

        // ========= WHEN NO BABIES ==========
        if (controller.myBabies.isEmpty) {
          return gradientBox(
            Padding(
              padding: EdgeInsets.all(24),
              child: Row(
                children: [
                  Icon(Icons.baby_changing_station, color: Colors.pink),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Add your baby\'s profile to start tracking',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.roundButtonGradient,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        Get.to(
                          () => CreateBabyScreen(skip: false),
                          transition: Transition.rightToLeft,
                        );
                      },
                      child: Text(
                        'Add Baby',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // ========= WHEN BABIES EXIST ==========
        return gradientBox(
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    //   Icon(Icons.baby_changing_station, color: Colors.pink),
                    SizedBox(width: 8),
                    Text(
                      'Baby Profile',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.roundButtonGradient,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: () {
                          Get.to(
                            () => CreateBabyScreen(skip: false),
                            transition: Transition.rightToLeft,
                          );
                        },
                        child: Text(
                          'Add Baby',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // ▼▼ Dropdown ▼▼
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.pink.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButton<BabyModel>(
                          value: controller.selectedBady,
                          isExpanded: true,
                          underline: SizedBox(),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.pink,
                          ),
                          items:
                              controller.myBabies.map((baby) {
                                return DropdownMenuItem<BabyModel>(
                                  value: baby,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Colors.pink,
                                        child: Text(
                                          baby.name![0],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(baby.name ?? "--"),
                                          Text(
                                            baby.deliveryDate != null
                                                ? controller.calculateAge(
                                                  DateTime.parse(
                                                    baby.deliveryDate!,
                                                  ),
                                                )
                                                : 'Unknown age',
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),

                          onChanged: (value) {
                            controller.selectedBady = value!;
                            controller.update();
                          },
                        ),
                      ),

                      // More Menu
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_horiz, color: Colors.pink),
                        onSelected: (value) {
                          if (value == 'delete') {
                            _showDeleteConfirmation(
                              context,
                              controller.selectedBady!,
                            );
                          }
                        },
                        itemBuilder:
                            (context) => [
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, BabyModel baby) {
    final createBabyController = Get.put(CreateBabyController());

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Baby Profile'),
            content: Text(
              'Are you sure you want to delete ${baby.name}? This cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  createBabyController.deleteBaby(baby.id!);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text('Delete'),
              ),
            ],
          ),
    );
  }
}
