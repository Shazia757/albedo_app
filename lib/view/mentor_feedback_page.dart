import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/feedback_controller.dart';
import 'package:albedo_app/controller/request_controller.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class MentorFeedbackPage extends StatelessWidget {
  MentorFeedbackPage({super.key});

  final c = FeedbackController();

  final List<Map<String, dynamic>> feedbacks = List.generate(12, (i) {
    return {
      "studentName": "Student $i",
      "studentId": "STU00$i",
      "studentImage": "https://i.pravatar.cc/150?img=${i + 1}",
      "mentorName": "Mentor ${i % 5}",
      "mentorId": "MEN00${i % 5}",
      "mentorImage": "https://i.pravatar.cc/150?img=${i + 20}",
      "rating": (i % 5) + 1,
      "description": [
        "Great mentor, explains concepts clearly and is very supportive.",
        "Good guidance, but response time could be improved.",
        "Excellent teaching style, really helped me understand difficult topics.",
        "Average experience, expected more detailed explanations.",
        "Very helpful and friendly mentor. Highly recommended!",
        "Mentor was knowledgeable but sessions felt rushed.",
        "Loved the way doubts were handled. Very patient.",
        "Decent experience overall, but could be more interactive.",
        "Outstanding support throughout the course!",
        "Helpful, but sometimes unclear explanations.",
        "Very professional and approachable mentor.",
        "Not satisfied with the mentoring sessions."
      ][i],
    };
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomAppBar(),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 12),
                  child: Text(
                    'Mentor Feedbacks',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: CustomWidgets().premiumSearch(
                    context,
                    hint: "Search feedbacks...",
                    onChanged: (v) => c.searchQuery.value = v,
                  ),
                ),

                /// 🔹 LIST

                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 1200
                          ? 3
                          : constraints.maxWidth > 800
                              ? 2
                              : 1;

                      return MasonryGridView.count(
                        padding: const EdgeInsets.all(12),
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        itemCount: feedbacks.length,
                        itemBuilder: (context, index) {
                          final r = feedbacks[index];
                          return FeedbackCard(data: r);
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FeedbackCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const FeedbackCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final int rating = data["rating"] ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.outline.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 TOP → STUDENT + RATING
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 44,
                  height: 44,
                  color: cs.primaryContainer.withOpacity(0.4),
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["studentName"],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data["studentId"],
                      style: TextStyle(
                        fontSize: 11,
                        color: cs.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              /// ⭐ RATING
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    size: 18,
                    color: Colors.amber,
                  );
                }),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// 📝 FEEDBACK TEXT
          Text(
            data["description"] ?? "No feedback provided",
            style: TextStyle(
              fontSize: 13,
              color: cs.onSurface.withOpacity(0.8),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 12),

          /// 🔻 DIVIDER
          Divider(
            height: 16,
            thickness: 0.8,
            color: cs.outline.withOpacity(0.12),
          ),

          /// 🔹 MENTOR SECTION (UPGRADED)
          Row(
            children: [
              /// AVATAR
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(data["mentorImage"]),
              ),

              const SizedBox(width: 8),

              /// NAME + ID
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["mentorName"],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      data["mentorId"],
                      style: TextStyle(
                        fontSize: 11,
                        color: cs.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              /// LABEL
              Text(
                "Mentor",
                style: TextStyle(
                  fontSize: 11,
                  color: cs.onSurface.withOpacity(0.5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
