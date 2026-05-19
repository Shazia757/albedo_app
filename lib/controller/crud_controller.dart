import 'package:get/get.dart';

class CrudController extends GetxController {
 RxnString editingId = RxnString();
  RxBool isSaving = false.obs;

 Future<void> save<T>({
    required String id,
    required String value,
    required Future<bool> Function(String id, String value) apiCall,
  }) async {
    isSaving.value = true;

    try {
      final success = await apiCall(id, value);

      if (success) {
        editingId.value = null;
        Get.snackbar("Success", "Updated successfully");
      } else {
        Get.snackbar("Error", "Update failed");
      }
    } finally {
      isSaving.value = false;
    }
  }

  void startEdit(String id) {
    editingId.value = id;
  }

  void cancelEdit() {
    editingId.value = null;
  }
}