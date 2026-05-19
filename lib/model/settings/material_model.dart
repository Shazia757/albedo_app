class Materials {
  final String? id;
  final String? title;
  final String? description;
  final String? materialType;
  final List<dynamic>? categories;
  final List<dynamic>? courses;
  final List<dynamic>? packages;
  final List<dynamic>? standards;
  final List<dynamic>? syllabi;
  final List<String>? batches;
  final String? contentType;
  final String? driveLink;
  final String? youtubeLink;
  final String? uploadedFile;
  final String? contentUrl;
  final DateTime? dateAdded;
  final int? creator;
  final bool? isDeleted;
  final List<String>? categoryNames;
  final List<String>? courseNames;
  final List<String>? packageNames;
  final List<String>? standardNames;
  final List<String>? syllabusNames;
  final List<String>? batchNames;

  Materials({
    this.id,
    this.title,
    this.description,
    this.materialType,
    this.categories,
    this.courses,
    this.packages,
    this.standards,
    this.syllabi,
    this.batches,
    this.contentType,
    this.driveLink,
    this.youtubeLink,
    this.uploadedFile,
    this.contentUrl,
    this.dateAdded,
    this.creator,
    this.isDeleted,
    this.categoryNames,
    this.courseNames,
    this.packageNames,
    this.standardNames,
    this.syllabusNames,
    this.batchNames,
  });

  factory Materials.fromJson(Map<String, dynamic> json) {
    return Materials(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      materialType: json['material_type'],
      categories: json['categories'] ?? [],
      courses: json['courses'] ?? [],
      packages: json['packages'] ?? [],
      standards: json['standards'] ?? [],
      syllabi: json['syllabi'] ?? [],
      batches: json['batches'] != null
          ? List<String>.from(json['batches'])
          : [],
      contentType: json['content_type'],
      driveLink: json['drive_link'],
      youtubeLink: json['youtube_link'],
      uploadedFile: json['uploaded_file'],
      contentUrl: json['content_url'],
      dateAdded: json['date_added'] != null
          ? DateTime.parse(json['date_added'])
          : null,
      creator: json['creator'],
      isDeleted: json['is_deleted'],
      categoryNames: json['category_names'] != null
          ? List<String>.from(json['category_names'])
          : [],
      courseNames: json['course_names'] != null
          ? List<String>.from(json['course_names'])
          : [],
      packageNames: json['package_names'] != null
          ? List<String>.from(json['package_names'])
          : [],
      standardNames: json['standard_names'] != null
          ? List<String>.from(json['standard_names'])
          : [],
      syllabusNames: json['syllabus_names'] != null
          ? List<String>.from(json['syllabus_names'])
          : [],
      batchNames: json['batch_names'] != null
          ? List<String>.from(json['batch_names'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'material_type': materialType,
      'categories': categories,
      'courses': courses,
      'packages': packages,
      'standards': standards,
      'syllabi': syllabi,
      'batches': batches,
      'content_type': contentType,
      'drive_link': driveLink,
      'youtube_link': youtubeLink,
      'uploaded_file': uploadedFile,
      'content_url': contentUrl,
      'date_added': dateAdded?.toIso8601String(),
      'creator': creator,
      'is_deleted': isDeleted,
      'category_names': categoryNames,
      'course_names': courseNames,
      'package_names': packageNames,
      'standard_names': standardNames,
      'syllabus_names': syllabusNames,
      'batch_names': batchNames,
    };
  }

  static List<Materials> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => Materials.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}