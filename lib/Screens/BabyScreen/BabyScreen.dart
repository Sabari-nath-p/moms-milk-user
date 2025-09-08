import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:mommilk_user/Models/BabyModel.dart';
import 'package:mommilk_user/Screens/BabyScreen/BabyDetailScreen.dart';
import 'package:mommilk_user/Screens/CreateBabyScreen/Controller/BabyCreateController.dart';
import 'package:mommilk_user/Screens/CreateBabyScreen/CreateBabyScreen.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';

class BabyScreen extends StatelessWidget {
  const BabyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Homecontroller>(
      builder:
          (controller) => Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver:
                      (controller.myBabies.isEmpty)
                          ? SliverFillRemaining(
                            child: _buildEmptyState(context),
                          )
                          : SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final baby = controller.myBabies[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildBabyCard(context, baby),
                              );
                            }, childCount: controller.myBabies.length),
                          ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Get.to(() => CreateBabyScreen(skip: false));
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Baby'),
            ),
          ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.child_care,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Babies Added Yet',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first baby profile to start tracking',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Get.to(() => CreateBabyScreen(skip: false));
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Your First Baby'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBabyCard(BuildContext context, BabyModel baby) {
    Homecontroller controller = Get.put(Homecontroller());
    final isSelected = controller.selectedBady!.id == baby.id;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            (isSelected ? Theme.of(context).colorScheme.primary : Colors.pink)
                .withOpacity(0.05),
            (isSelected ? Theme.of(context).colorScheme.primary : Colors.pink)
                .withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: (isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.pink)
              .withOpacity(isSelected ? 0.5 : 0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Get.to(
              () => BabyDetailsScreen(baby: baby),
              transition: Transition.rightToLeft,
            );
            // controller.selectedBady = baby;
            // controller.update();
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.pink)
                            .withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.child_care,
                        color:
                            isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.pink,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                baby.name ?? "My Baby",
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'ACTIVE',
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            getFormattedAge(baby),
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  PopupMenuButton<String>(
  onSelected: (value) {
    switch (value) {
      case 'view':
        Get.to(
          () => BabyDetailsScreen(baby: baby),
          transition: Transition.rightToLeft,
        );
        break;
      case 'edit':
        // TODO: integrate edit flow if needed
        break;
      case 'delete':
        _showDeleteConfirmation(context, baby);
        break;
    }
  },
  itemBuilder: (context) => [
    const PopupMenuItem(
      value: 'view',
      child: Row(
        children: [
          Icon(Icons.visibility, size: 18),
          SizedBox(width: 8),
          Text('View Details'),
        ],
      ),
    ),
    const PopupMenuItem(
      value: 'edit',
      child: Row(
        children: [
          Icon(Icons.edit, size: 18),
          SizedBox(width: 8),
          Text('Edit'),
        ],
      ),
    ),
    const PopupMenuItem(
      value: 'delete',
      child: Row(
        children: [
          Icon(Icons.delete, size: 18, color: Colors.red),
          SizedBox(width: 8),
          Text('Delete', style: TextStyle(color: Colors.red)),
        ],
      ),
    ),
  ],
),

                    
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Born',
                        _formatDate(DateTime.parse(baby.deliveryDate!)),
                        Icons.cake,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Weight',
                        baby.weight != null ? '${baby.weight} kg' : 'Not set',
                        Icons.monitor_weight,
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
                // if (baby.notes.isNotEmpty) ...[
                //   const SizedBox(height: 16),
                //   Container(
                //     width: double.infinity,
                //     padding: const EdgeInsets.all(12),
                //     decoration: BoxDecoration(
                //       color: Theme.of(
                //         context,
                //       ).colorScheme.surface.withOpacity(0.5),
                //       borderRadius: BorderRadius.circular(8),
                //       border: Border.all(
                //         color: Theme.of(context).dividerColor.withOpacity(0.2),
                //       ),
                //     ),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           'Notes',
                //           style: Theme.of(context).textTheme.labelMedium
                //               ?.copyWith(fontWeight: FontWeight.w600),
                //         ),
                //         const SizedBox(height: 4),
                //         Text(
                //           baby.,
                //           style: Theme.of(context).textTheme.bodySmall,
                //         ),
                //       ],
                //     ),
                //   ),
                // ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(
                context,
              ).textTheme.labelSmall?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  // void _showAddBabyDialog(BuildContext context, HomeController controller) {
  //   final nameController = TextEditingController();
  //   final notesController = TextEditingController();
  //   DateTime selectedDate = DateTime.now();
  //   String selectedGender = 'Boy';
  //   double? weight;

  //   showDialog(
  //     context: context,
  //     builder:
  //         (context) => StatefulBuilder(
  //           builder:
  //               (context, setState) => AlertDialog(
  //                 title: const Text('Add Baby Profile'),
  //                 content: SingleChildScrollView(
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       TextField(
  //                         controller: nameController,
  //                         decoration: const InputDecoration(
  //                           labelText: 'Baby Name',
  //                           border: OutlineInputBorder(),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 16),
  //                       DropdownButtonFormField<String>(
  //                         value: selectedGender,
  //                         decoration: const InputDecoration(
  //                           labelText: 'Gender',
  //                           border: OutlineInputBorder(),
  //                         ),
  //                         items:
  //                             ['Boy', 'Girl', 'Other'].map((gender) {
  //                               return DropdownMenuItem(
  //                                 value: gender,
  //                                 child: Text(gender),
  //                               );
  //                             }).toList(),
  //                         onChanged: (value) {
  //                           setState(() => selectedGender = value!);
  //                         },
  //                       ),
  //                       const SizedBox(height: 16),
  //                       ListTile(
  //                         title: const Text('Birth Date'),
  //                         subtitle: Text(_formatDate(selectedDate)),
  //                         leading: const Icon(Icons.calendar_today),
  //                         onTap: () async {
  //                           final date = await showDatePicker(
  //                             context: context,
  //                             initialDate: selectedDate,
  //                             firstDate: DateTime(2020),
  //                             lastDate: DateTime.now(),
  //                           );
  //                           if (date != null) {
  //                             setState(() => selectedDate = date);
  //                           }
  //                         },
  //                       ),
  //                       const SizedBox(height: 16),
  //                       TextField(
  //                         decoration: const InputDecoration(
  //                           labelText: 'Current Weight (kg)',
  //                           border: OutlineInputBorder(),
  //                         ),
  //                         keyboardType: TextInputType.number,
  //                         onChanged: (value) {
  //                           weight = double.tryParse(value);
  //                         },
  //                       ),
  //                       const SizedBox(height: 16),
  //                       TextField(
  //                         controller: notesController,
  //                         decoration: const InputDecoration(
  //                           labelText: 'Notes (optional)',
  //                           border: OutlineInputBorder(),
  //                         ),
  //                         maxLines: 3,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 actions: [
  //                   TextButton(
  //                     onPressed: () => Navigator.pop(context),
  //                     child: const Text('Cancel'),
  //                   ),
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       if (nameController.text.trim().isNotEmpty) {
  //                         final baby = BabyProfile(
  //                           id:
  //                               DateTime.now().millisecondsSinceEpoch
  //                                   .toString(),
  //                           name: nameController.text.trim(),
  //                           birthDate: selectedDate,
  //                           gender: selectedGender,
  //                           currentWeight: weight,
  //                           notes: notesController.text.trim(),
  //                         );
  //                         controller.addBabyProfile(baby);
  //                         Navigator.pop(context);
  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                           SnackBar(
  //                             content: Text('${baby.name} added successfully!'),
  //                           ),
  //                         );
  //                       }
  //                     },
  //                     child: const Text('Add'),
  //                   ),
  //                 ],
  //               ),
  //         ),
  //   );
  // }

  // void _showEditBabyDialog(
  //   BuildContext context,
  //   BabyProfile baby,
  //   HomeController controller,
  // ) {
  //   final nameController = TextEditingController(text: baby.name);
  //   final notesController = TextEditingController(text: baby.notes);
  //   DateTime selectedDate = baby.birthDate;
  //   String selectedGender = baby.gender;
  //   double? weight = baby.currentWeight;

  //   showDialog(
  //     context: context,
  //     builder:
  //         (context) => StatefulBuilder(
  //           builder:
  //               (context, setState) => AlertDialog(
  //                 title: const Text('Edit Baby Profile'),
  //                 content: SingleChildScrollView(
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       TextField(
  //                         controller: nameController,
  //                         decoration: const InputDecoration(
  //                           labelText: 'Baby Name',
  //                           border: OutlineInputBorder(),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 16),
  //                       DropdownButtonFormField<String>(
  //                         value: selectedGender,
  //                         decoration: const InputDecoration(
  //                           labelText: 'Gender',
  //                           border: OutlineInputBorder(),
  //                         ),
  //                         items:
  //                             ['Boy', 'Girl', 'Other'].map((gender) {
  //                               return DropdownMenuItem(
  //                                 value: gender,
  //                                 child: Text(gender),
  //                               );
  //                             }).toList(),
  //                         onChanged: (value) {
  //                           setState(() => selectedGender = value!);
  //                         },
  //                       ),
  //                       const SizedBox(height: 16),
  //                       ListTile(
  //                         title: const Text('Birth Date'),
  //                         subtitle: Text(_formatDate(selectedDate)),
  //                         leading: const Icon(Icons.calendar_today),
  //                         onTap: () async {
  //                           final date = await showDatePicker(
  //                             context: context,
  //                             initialDate: selectedDate,
  //                             firstDate: DateTime(2020),
  //                             lastDate: DateTime.now(),
  //                           );
  //                           if (date != null) {
  //                             setState(() => selectedDate = date);
  //                           }
  //                         },
  //                       ),
  //                       const SizedBox(height: 16),
  //                       TextField(
  //                         decoration: const InputDecoration(
  //                           labelText: 'Current Weight (kg)',
  //                           border: OutlineInputBorder(),
  //                         ),
  //                         keyboardType: TextInputType.number,
  //                         controller: TextEditingController(
  //                           text: weight?.toString() ?? '',
  //                         ),
  //                         onChanged: (value) {
  //                           weight = double.tryParse(value);
  //                         },
  //                       ),
  //                       const SizedBox(height: 16),
  //                       TextField(
  //                         controller: notesController,
  //                         decoration: const InputDecoration(
  //                           labelText: 'Notes (optional)',
  //                           border: OutlineInputBorder(),
  //                         ),
  //                         maxLines: 3,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 actions: [
  //                   TextButton(
  //                     onPressed: () => Navigator.pop(context),
  //                     child: const Text('Cancel'),
  //                   ),
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       if (nameController.text.trim().isNotEmpty) {
  //                         final updatedBaby = BabyProfile(
  //                           id: baby.id,
  //                           name: nameController.text.trim(),
  //                           birthDate: selectedDate,
  //                           gender: selectedGender,
  //                           currentWeight: weight,
  //                           notes: notesController.text.trim(),
  //                         );
  //                         controller.updateBabyProfile(updatedBaby);
  //                         Navigator.pop(context);
  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                           SnackBar(
  //                             content: Text(
  //                               '${updatedBaby.name} updated successfully!',
  //                             ),
  //                           ),
  //                         );
  //                       }
  //                     },
  //                     child: const Text('Update'),
  //                   ),
  //                 ],
  //               ),
  //         ),
  //   );
  // }

  void _showDeleteConfirmation(BuildContext context, BabyModel baby) {
  final createBabyController = Get.put(CreateBabyController()); // ensure controller available

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Baby Profile'),
      content: Text(
        'Are you sure you want to delete ${baby.name}\'s profile? This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // close dialog first
            createBabyController.deleteBaby(baby.id!);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
}

String getFormattedAge(BabyModel baby) {
  int ageInDays =
      DateTime.now().difference(DateTime.parse(baby.deliveryDate!)).inDays;
  int ageInWeeks = (ageInDays / 7).floor();
  int ageInMonths = ageInDays ~/ 30;
  if (ageInDays < 7) {
    return '$ageInDays day${ageInDays == 1 ? '' : 's'} old';
  } else if (ageInWeeks < 8) {
    return '$ageInWeeks week${ageInWeeks == 1 ? '' : 's'} old';
  } else {
    return '$ageInMonths month${ageInMonths == 1 ? '' : 's'} old';
  }
}
