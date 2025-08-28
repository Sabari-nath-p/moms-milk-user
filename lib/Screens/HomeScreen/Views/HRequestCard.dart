import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:mommilk_user/Screens/RequestScreen/RequestScreen.dart';
import 'package:mommilk_user/Screens/SearchDonarScreen/SearchDonarScreen.dart';

class HRequestCard extends StatelessWidget {
  const HRequestCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.to(
                      () => RequestScreen(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Milk Request'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.to(
                      () => Searchdonarscreen(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  icon: const Icon(Icons.search),
                  label: const Text('Find Donors'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
