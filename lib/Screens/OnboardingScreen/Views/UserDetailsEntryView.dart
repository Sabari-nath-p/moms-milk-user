import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Screens/OnboardingScreen/Controller/OnboardingController.dart';

class UserDetailsStep extends StatelessWidget {
  UserDetailsStep({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Onboardingcontroller>(
      builder: (controller) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Personal Information',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Text(
                'Please provide your basic information to create your profile.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black.withOpacity(.8),
                ),
              ),

              SizedBox(height: 32),

              // Name Field
              TextField(
                controller: controller.nameController,
                textInputAction: TextInputAction.next,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Full Name *',
                  hintText: 'Enter your full name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              Obx(
                () =>
                    controller.nameError.value.isNotEmpty
                        ? Padding(
                          padding: EdgeInsets.only(top: 6, left: 4),
                          child: Text(
                            controller.nameError.value,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        )
                        : SizedBox.shrink(),
              ),

              SizedBox(height: 20),

              // Phone Number with Country Code
              Row(
                children: [
                  // Country Code Dropdown
                  SizedBox(
                    width: 120,
                    child: DropdownButtonFormField<String>(
                      value:
                          controller.selectedCountryCode.isEmpty
                              ? null
                              : controller.selectedCountryCode,
                      decoration: InputDecoration(
                        labelText: 'Code',
                        prefixIcon: Icon(Icons.flag_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[400]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      items:
                          controller.countryCodes.map((country) {
                            return DropdownMenuItem<String>(
                              value: country['code'],
                              child: Text(
                                '${country['code']} ${country['country']}',
                                style: TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.selectedCountryCode = value;
                        }
                      },
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                    ),
                  ),

                  SizedBox(width: 16),

                  // Phone Number
                  Expanded(
                    child: TextField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(fontSize: 16),
                      maxLength: 11,
                      buildCounter:
                          (
                            context, {
                            required currentLength,
                            required isFocused,
                            required maxLength,
                          }) => null,
                      decoration: InputDecoration(
                        labelText: 'Phone Number *',
                        hintText: 'Enter phone number',
                        prefixIcon: Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[400]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      //onChanged: (value) => controller.phone.value = value,
                    ),
                  ),
                ],
              ),

              Obx(
                () =>
                    controller.phoneError.value.isNotEmpty
                        ? Padding(
                          padding: EdgeInsets.only(top: 6, left: 4),
                          child: Text(
                            controller.phoneError.value,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        )
                        : SizedBox.shrink(),
              ),

              SizedBox(height: 20),

              // Zip Code
              TextField(
                controller: controller.zipCodeController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                style: TextStyle(fontSize: 16),
                maxLength: 6,
                buildCounter:
                    (
                      context, {
                      required currentLength,
                      required isFocused,
                      required maxLength,
                    }) => null,
                decoration: InputDecoration(
                  labelText: 'Zip Code *',
                  hintText: 'Enter your zip code',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                //  onChanged: (value) => controller.zipCode.value = value,
              ),
              Obx(
                () =>
                    controller.zipError.value.isNotEmpty
                        ? Padding(
                          padding: EdgeInsets.only(top: 6, left: 4),
                          child: Text(
                            controller.zipError.value,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        )
                        : SizedBox.shrink(),
              ),

              if (false) SizedBox(height: 32),

              // Facebook Link
              if (false)
                TextField(
                  controller: controller.facebookLinkController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: 'Facebook Profile link',
                    hintText: 'Enter your facebook profile link',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),

              if (false) SizedBox(height: 20),

              // Instagram Link
              if (false)
                TextField(
                  controller: controller.instagramLinkController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: 'Instagram Profile Link',
                    hintText: 'Enter your Instagram profile link',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),

              SizedBox(height: 32),

              // Info Card
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your information is secure and will only be used to connect you with other verified users.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
