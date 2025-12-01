import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Screens/CreateBabyScreen/CreateBabyScreen.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class HBabyCard extends StatelessWidget {
  const HBabyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Homecontroller>(
      builder: (controller) {
        final gradientBox = (Widget child) => ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12), // Optional, remove if not needed
    border: Border.all(
  color: Color(0xffFFE4E6),
  width: 1.5,
),

    boxShadow: const [
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
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Icon(
                    Icons.baby_changing_station,
                    color: Colors.pink,
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      'Add your baby\'s profile to start tracking',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  SizedBox(width: 12),
                  // ✅ GRADIENT ADD BABY BUTTON
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.roundButtonGradient,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 2),
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
                      child: const Text(
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.baby_changing_station,
                      color:   Colors.pink,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Baby Profile',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                  ],
                ),

                const SizedBox(height: 16),

                // ▼▼ Dropdown ▼▼
                DropdownButton(
                  value: controller.selectedBady,
                  isExpanded: true,
                  hint: const Text('Select a baby'),
                  underline: Container(),
                  items: controller.myBabies.map((baby) {
                    return DropdownMenuItem(
                      value: baby,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            child: Text(
                              baby.name![0],
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(baby.name ?? "--"),
                              Text(
                                baby.deliveryDate != null
                                    ? controller.calculateAge(
                                        DateTime.parse(baby.deliveryDate!),
                                      )
                                    : 'Unknown age',
                                style:
                                    Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectedBady = value;
                    controller.update();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
