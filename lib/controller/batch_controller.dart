import 'package:albedo_app/model/batch_model.dart';
import 'package:get/get.dart';

class BatchesController extends GetxController {
  var batches = <Batch>[].obs;
  var selectedTab = 0.obs;
  var searchQuery = ''.obs;

  final statusMap = {0: 'active', 1: 'inactive'};

  @override
  void onInit() {
    super.onInit();
    loadDummyData();
  }

  void loadDummyData() {
    batches.value = [
      Batch(
          id: 'B001', name: 'Flutter Basics', code: 'FL101', status: 'active'),
      Batch(id: 'B002', name: 'Advanced Dart', code: 'DR201', status: 'active'),
      Batch(
          id: 'B003',
          name: 'Web Development',
          code: 'WD301',
          status: 'inactive'),
      Batch(
          id: 'B004', name: 'Mobile App Dev', code: 'MA401', status: 'active'),
      Batch(
          id: 'B005', name: 'UI/UX Design', code: 'UX501', status: 'inactive'),
    ];
  }

  List<Batch> get filteredBatches =>
      batches.where((b) => b.status == statusMap[selectedTab.value]).toList();

  void deleteBatch(String id) {
    batches.removeWhere((b) => b.id == id);
  }
}
