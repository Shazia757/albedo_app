import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SortType { newest, oldest, name }

class MentorController extends GetxController {
  final AuthController auth = Get.find();

  var searchQuery = ''.obs;
  var sortType = SortType.newest.obs;
  var mentors = <Mentor>[].obs;
  var selectedTab = 0.obs;
  var filteredMentors = <Mentor>[].obs;
  final tabs = ["Active", "Inactive"];
  var isSearching = false.obs;
  var isLoading = true.obs;
  var isDeleteButtonLoading = true.obs;
  var isDeactivateButtonLoading = true.obs;

  var experiences = <ExperienceModel>[].obs;

  // --------------------------
  // Counts for tabs
  // --------------------------

  int get activeCount => mentors.where((e) => e.status == "Active").length;

  int get inactiveCount => mentors.where((e) => e.status == "Inactive").length;

  List<Map<String, dynamic>> get tabData => [
        {"label": "Active", "count": activeCount},
        {"label": "Inactive", "count": inactiveCount},
      ];

  TextEditingController nameController = TextEditingController();
  TextEditingController empIdController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController timezoneController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController prefLangController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController accountHolderNameController = TextEditingController();
  TextEditingController upiIdController = TextEditingController();
  TextEditingController accountTypeController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController bankBranchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchMentors();
  }

  Future<void> fetchMentors() async {
    try {
      isLoading.value = true;

      final user = auth.activeUser;

      await Future.delayed(const Duration(seconds: 2));

      final allMentors = _getDummyMentors();

      List<Mentor> result;

      if (user?.role == "admin") {
        result = allMentors;
      } else if (user?.role == "coordinator") {
        result = allMentors.where((m) => m.coordinatorId == user!.id).toList();
      } else if (user?.role == "mentor") {
        // Mentor should usually see only themselves
        result = allMentors.where((m) => m.id == user!.id).toList();
      } else {
        result = [];
      }

      mentors.assignAll(result);
      applyFilters();
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<Mentor> _getDummyMentors() {
    return [
      Mentor(
        id: "MTR1001",
        name: "Maria",
        email: "maria@email.com",
        status: "Active",
        phone: "123456",
        joinedAt: DateTime.now(),
        coordinatorId: "COO1001",
      ),
      Mentor(
        id: "MTR1002",
        name: "Nick",
        email: "nick@email.com",
        status: "Inactive",
        phone: "+9876543210",
        joinedAt: DateTime.parse('2024-12-01 09:00:00'),
        coordinatorId: "COO1002",
      ),
    ];
  }

  void applyFilters() {
    List<Mentor> temp = mentors;

    switch (selectedTab.value) {
      case 0:
        temp = temp.where((t) => t.status == "Active").toList();
        break;

      case 1:
        temp = temp.where((t) => t.status == "Inactive").toList();
        break;
    }

    if (searchQuery.value.isNotEmpty) {
      temp = temp
          .where((t) =>
              t.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // Sort
    if (sortType.value == SortType.newest) {
      temp.sort((a, b) => b.joinedAt.compareTo(a.joinedAt));
    } else if (sortType.value == SortType.oldest) {
      temp.sort((a, b) => a.joinedAt.compareTo(b.joinedAt));
    } else if (sortType.value == SortType.name) {
      temp.sort((a, b) => a.name.compareTo(b.name));
    }

    filteredMentors.assignAll(temp);
  }

  void loadMentors(Mentor c) {
    nameController.text = c.name.toString();
    empIdController.text = c.id.toString();
    emailController.text = c.email.toString();
    phoneController.text = c.phone.toString();
    whatsappController.text = c.whatsapp.toString();
    timezoneController.text = c.timezone.toString();
    dobController.text = c.dob.toString();
    qualificationController.text = c.qualification.toString();
    placeController.text = c.place.toString();
    pincodeController.text = c.pincode.toString();
    addressController.text = c.address.toString();
    prefLangController.text = c.prefLanguage.toString();
    accountNumberController.text = c.accountNumber.toString();
    accountHolderNameController.text = c.accountHolder.toString();
    upiIdController.text = c.upiId.toString();
    accountTypeController.text = c.accountType.toString();
    bankNameController.text = c.bankName.toString();
    bankBranchController.text = c.bankBranch.toString();
  }

  void addExperience() {
    experiences.add(
      ExperienceModel(
        companyController: TextEditingController(),
        yearController: TextEditingController(),
        monthController: TextEditingController(),
      ),
    );
  }

  void handleDelete(BuildContext context, Mentor mentor) {
    final user = auth.activeUser;

    if (user?.role == "coordinator") {
      CustomWidgets().showDeleteDialog(
        context: context,
        text: "Do you want to request deletion of this mentor?",
        onConfirm: () => requestDelete(mentor.id!),
      );
    } else {
      CustomWidgets().showDeleteDialog(
        context: context,
        text: "Are you sure you want to delete this mentor permanently?",
        onConfirm: () => delete(mentor.id!),
      );
    }
  }

  void handleDeactivate(BuildContext context, Mentor mentor) {
    final user = auth.activeUser;

    if (user?.role == "coordinator") {
      CustomWidgets().showDeactivateDialog(
        context: context,
        text: "Do you want to request inactivation for this mentor?",
        onConfirm: () => requestDeactivate(mentor.id!),
      );
    } else {
      CustomWidgets().showDeactivateDialog(
        context: context,
        text: "Are you sure you want to deactivate this mentor permanently?",
        onConfirm: () => deactivate(mentor.id!),
      );
    }
  }

  deactivate(String id) {
    isDeleteButtonLoading.value = true;
    // Api().deleteProgram(id).then(
    //   (value) {
    //     if (value?.status == true) {
    //       isDeleteButtonLoading.value = false;
    //       Get.back();
    //       Get.back();
    //       Get.snackbar(
    //           "Success", value?.message ?? "Program deleted successfully.");
    //     } else {
    //       // CustomWidgets.showSnackBar(
    //       //     "Error", value?.message ?? 'Failed to delete program.');
    //     }
    //   },
    // );
  }

  void requestDeactivate(String mentorId) {
    print("Request sent to deactivate mentor: $mentorId");

    // TODO:
    // Call API → create approval request
    // Show snackbar
  }

  void requestDelete(String mentorId) {
    print("Request sent to delete mentor: $mentorId");

    // TODO:
    // Call API → create approval request
  }

  delete(String id) {
    isDeleteButtonLoading.value = true;
    // Api().deleteProgram(id).then(
    //   (value) {
    //     if (value?.status == true) {
    //       isDeleteButtonLoading.value = false;
    //       Get.back();
    //       Get.back();
    //       Get.snackbar(
    //           "Success", value?.message ?? "Program deleted successfully.");
    //     } else {
    //       // CustomWidgets.showSnackBar(
    //       //     "Error", value?.message ?? 'Failed to delete program.');
    //     }
    //   },
    // );
  }
}
