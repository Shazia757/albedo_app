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
          teacherName: '',
          id: 'B001',
          batchName: 'Flutter Basics',
          batchID: 'FL101',
          status: 'active'),
      Batch(
          teacherName: '',
          id: 'B002',
          batchName: 'Advanced Dart',
          batchID: 'DR201',
          status: 'active'),
      Batch(
          teacherName: '',
          id: 'B003',
          batchName: 'Web Development',
          batchID: 'WD301',
          status: 'inactive'),
      Batch(
          teacherName: '',
          id: 'B004',
          batchName: 'Mobile App Dev',
          batchID: 'MA401',
          status: 'active'),
      Batch(
          teacherName: '',
          id: 'B005',
          batchName: 'UI/UX Design',
          batchID: 'UX501',
          status: 'inactive'),
    ];
  }

  List<Batch> get filteredBatches =>
      batches.where((b) => b.status == statusMap[selectedTab.value]).toList();

  void deleteBatch(String id) {
    batches.removeWhere((b) => b.id == id);
  }
}
