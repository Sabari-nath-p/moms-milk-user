import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/utils.dart';
import 'package:mommilk_user/Screens/CreateBabyScreen/CreateBabyScreen.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';

class HBabyCard extends StatelessWidget {
  const HBabyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Homecontroller>(
      builder:
          (controller) =>
              (controller.myBabies.isEmpty)
                  ? Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.baby_changing_station,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Add your baby\'s profile to start tracking',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(
                                () => CreateBabyScreen(skip: false),
                                transition: Transition.rightToLeft,
                              );
                            },
                            child: const Text('Add Baby'),
                          ),
                        ],
                      ),
                    ),
                  )
                  : Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.baby_changing_station,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Baby Profile',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const Spacer(),
                              // TextButton(
                              //   onPressed: () async {
                              //     Get.to(
                              //       () => CreateBabyScreen(skip: false),
                              //       transition: Transition.rightToLeft,
                              //     );
                              //   },
                              //   child: const Text('Add Baby'),
                              // ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          DropdownButton(
                            value:
                                controller.selectedBady != null
                                    ? controller.selectedBady
                                    : null,
                            isExpanded: true,
                            hint: const Text('Select a baby'),
                            underline: Container(),
                            items:
                                controller.myBabies
                                    .map(
                                      (baby) => DropdownMenuItem(
                                        value: baby,

                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 16,
                                              backgroundColor:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                              child: Text(
                                                baby.name![0],
                                                style: TextStyle(
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.onPrimary,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(baby.name ?? "--:--"),
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
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectedBady = value;
                                controller.update();

                                controller.fetchBabyAnalytics(
                                  babyId: value.id!,
                                );
                                controller.update();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
    );
  }
}
