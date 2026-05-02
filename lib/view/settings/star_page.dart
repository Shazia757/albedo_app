import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StarOfMonthPage extends StatelessWidget {
  final controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,

      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _buildMainSettingsCard(context),
      ),
    );
  }

  Widget _buildMainSettingsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), // Soft rounded corners
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text("Global Rating Values",
              style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: 5),
          Text(
              "Add, edit, or remove values as needed. Minimum 5 values required.",
              style: TextStyle(
                  fontSize: 14, color: Theme.of(context).colorScheme.outline)),

          Divider(color: Theme.of(context).colorScheme.outline, height: 30),

          // The Dynamic List (Reactive)
          Obx(() => ListView.separated(
                shrinkWrap:
                    true, // Important for ListView inside SingleChildScrollView
                physics:
                    NeverScrollableScrollPhysics(), // Scroll managed by parent
                itemCount: controller.ratingValues.length,
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return _buildInputRow(context, index);
                },
              )),

          Divider(color: Theme.of(context).colorScheme.outline, height: 30),

          // Bottom Action Buttons (Rows like the image)
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  label: "+ Add Field",
                  onPressed: () => controller.addField(),
                  color: Theme.of(context)
                      .colorScheme
                      .primary, // Specific Blue Color
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _buildActionButton(
                  label: "Save",
                  onPressed: controller.saveSettings,
                  color: Theme.of(context)
                      .colorScheme
                      .secondary, // Specific Purple Color
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow(BuildContext context, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label (MV1, MV2...)
        SizedBox(
          width: 50,
          child: Text(
            controller.ratingValues[index].label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.end,
          ),
        ),
        SizedBox(width: 15),
        // Custom Styled Input Field
        Expanded(
          child: _buildCustomTextField(
            context: context,
            controller: controller.textControllers[index],
            hintText: "Enter value...",
          ),
        ),
        // Custom Styled Remove Button
        SizedBox(width: 10),
        GestureDetector(
          onTap: () => controller.removeField(index),
          child: Icon(Icons.remove_circle_outline,
              color: Colors.redAccent, size: 28),
        ),
      ],
    );
  }

  // A custom widget to match the input fields in the screenshot
  Widget _buildCustomTextField(
      {required BuildContext context,
      required TextEditingController controller,
      required String hintText}) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        // color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(8), // Subtle rounded corners
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        // Recreating the subtle internal padding of the image
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center, // Center text like the screenshot
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: 10, vertical: 0), // Flat vertical padding
          border: InputBorder.none, // Removes the standard Material line/border
          hintText: hintText,
          hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.outline,
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  // Generic full-width button (Add/Save) to match the screenshots
  Widget _buildActionButton(
      {required String label,
      required VoidCallback onPressed,
      required Color color}) {
    return MaterialButton(
      onPressed: onPressed,
      elevation: 0,
      highlightElevation: 2,
      height: 50,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
