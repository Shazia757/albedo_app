class Urls {
  static String base = 'https://api.albedoedu.com/api/v1';

  //------------------ Accounts ---------------------------//

  static String impersonate = '$base/accounts/admin-impersonate/';
  static String appAuthenticate(String userId) =>
      '$base/accounts/app-authenticate/$userId/';

  static String changePassword = '$base/accounts/change-password/';

  static String changePasswordByProfile(String profileType, String profileId) =>
      '$base/accounts/change-password/$profileType/$profileId/';

  static String changeUsername(String profileType, String profileId) =>
      '$base/accounts/change-username/$profileType/$profileId/';

  static String dbBackup = '$base/accounts/db-backup/';
  static String dbLoadData = '$base/accounts/db-load-data/';

  static String forgotPasswordConfirm =
      '$base/accounts/forgot-password/confirm/';
  static String forgotPasswordRequest =
      '$base/accounts/forgot-password/request/';
  static String forgotPasswordValidate =
      '$base/accounts/forgot-password/validate/';

  static String googleLogin = '$base/accounts/google-login/';
  static String login = '$base/accounts/mobile-login/';
  static String logout = '$base/accounts/mobile-logout/';

  static String passwordReset = '$base/accounts/password-reset/';
  static String register = '$base/accounts/register/';
  static String resetPasswordConfirm = '$base/accounts/reset-password-confirm/';

  static String ssoValidate = '$base/accounts/sso-validate/';
  static String refreshToken = '$base/accounts/token/refresh/';

  static String userDetails = '$base/accounts/user/details/';
  static String userUpdate = '$base/accounts/user/update/';

  static String users = '$base/accounts/users/';
  static String userById(String id) => '$base/accounts/users/$id/';

  static String setUserPermission(String id) =>
      '$base/accounts/users/$id/set-permission/';

  //------------------ Assistant ---------------------------//

  static String assignMentor(String id) => '$base/assistant/assign-mentor/$id/';

  static String assistantPayments = '$base/assistant/assistant-payments/';

  static String assistantPaymentById(String id) =>
      '$base/assistant/assistant-payments/$id/';

  static String assistantsList = '$base/assistant/assistants-list/';

  static String assistants = '$base/assistant/assistants/';

  static String assistantById(String id) => '$base/assistant/assistants/$id/';

  static String assistantExperiences(String id) =>
      '$base/assistant/assistants/$id/experiences/';

  static String assistantExperienceById(String id, String experienceId) =>
      '$base/assistant/assistants/$id/experiences/$experienceId/';

  static String assistantResign(String id) =>
      '$base/assistant/assistants/$id/resign/';

  static String uploadAssistantIdCard(String id) =>
      '$base/assistant/assistants/$id/upload-id-card/';

  static String myMentors = '$base/assistant/my-mentors/';
  static String myStudents = '$base/assistant/my-students/';
  static String myStudentsDetails = '$base/assistant/my-students/details/';
  static String myTeachers = '$base/assistant/my-teachers/';
  static String assistantUserCount = '$base/assistant/user-count/';

  //------------------ Bank ---------------------------//

  static String banks = '$base/bank/banks/';
  static String branches = '$base/bank/branches/';
  static String ifsc = '$base/bank/ifsc/';
  static String syncIfsc = '$base/bank/sync-ifsc/';

  //------------------ Chat ---------------------------//

  static String chatGroups = '$base/chat/groups/';

  static String groupMembers(String chatId) =>
      '$base/chat/groups/$chatId/members/';

  static String groupMessages(String chatId) =>
      '$base/chat/groups/$chatId/messages/';

  static String sendGroupMessage(String chatId) =>
      '$base/chat/groups/$chatId/messages/send/';

  static String updateGroupMessage(String chatId, String messageId) =>
      '$base/chat/groups/$chatId/messages/$messageId/';

  static String deleteGroupMessage(String chatId, String messageId) =>
      '$base/chat/groups/$chatId/messages/$messageId/delete/';

  static String muteGroup(String chatId) => '$base/chat/groups/$chatId/mute/';

  static String readGroup(String chatId) => '$base/chat/groups/$chatId/read/';

  //------------------ Custom Admin ---------------------------//

  static String advisorReports = '$base/custom_admin/advisor-reports/';

  static String assessmentQuestions =
      '$base/custom_admin/assessment-questions/';

  static String assessmentQuestionById(String id) =>
      '$base/custom_admin/assessment-questions/$id/';

  static String assessmentReportTypes =
      '$base/custom_admin/assessment-report-type/';

  static String assessmentReportTypeById(String id) =>
      '$base/custom_admin/assessment-report-type/$id/';

  static String groupedPermissions =
      '$base/custom_admin/assign-permissions/grouped/';

  static String assignedStudents(String mentorId) =>
      '$base/custom_admin/assigned-students/$mentorId/';

  static String assignedStudentById(String mentorId, String studentId) =>
      '$base/custom_admin/assigned-students/$mentorId/$studentId/';

  static String assistantMentorReports(String assistantId) =>
      '$base/custom_admin/assistant-mentor-reports/$assistantId/';

  static String assistantMonthlyReport =
      '$base/custom_admin/assistant-monthly-report/';

  static String assistantReports = '$base/custom_admin/assistant-reports/';

  static String assistantStarReport(String assistantId) =>
      '$base/custom_admin/assistant-star-of-month-report/$assistantId/';

  static String assistantMentors(String assistantId) =>
      '$base/custom_admin/assistant/$assistantId/mentors/';

  static String banners = '$base/custom_admin/banners/';
  static String bannerById(String id) => '$base/custom_admin/banners/$id/';

  static String categories = '$base/custom_admin/categories/';
  static String categoryById(String id) => '$base/custom_admin/categories/$id/';

  static String combinedReport = '$base/custom_admin/combined-report/';

  static String completionDeadlineSettings =
      '$base/custom_admin/completion-deadline-settings/';

  static String completionDeadlineSettingById(String id) =>
      '$base/custom_admin/completion-deadline-settings/$id/';

  static String coupons = '$base/custom_admin/coupons/';
  static String couponById(String id) => '$base/custom_admin/coupons/$id/';

  static String courses = '$base/custom_admin/courses/';
  static String courseById(String id) => '$base/custom_admin/courses/$id/';

  static String deadlineOverrides = '$base/custom_admin/deadline-overrides/';

  static String clearAllDeadlineOverrides =
      '$base/custom_admin/deadline-overrides/clear-all/';

  static String deadlineOverrideById(String id) =>
      '$base/custom_admin/deadline-overrides/$id/';

  static String defaultBanners = '$base/custom_admin/default-banners/';

  static String defaultBannerById(String id) =>
      '$base/custom_admin/default-banners/$id/';

  static String expenseRatio = '$base/custom_admin/expense-ratio/';

  static String fcmToken = '$base/custom_admin/fcm-token/';

  static String globalRatingValues = '$base/custom_admin/global-rating-values/';

  static String globalRatingValueById(String id) =>
      '$base/custom_admin/global-rating-values/$id/';

  static String globalSearch = '$base/custom_admin/global-search/';

  static String hiringAds = '$base/custom_admin/hiring-ads/';

  static String hiringAdById(String id) => '$base/custom_admin/hiring-ads/$id/';

  static String hiringReport = '$base/custom_admin/hiring-report/';

  static String latestMentorMetrics(String mentorId) =>
      '$base/custom_admin/latest-mentor-metrics/$mentorId/';

  static String materials = '$base/custom_admin/materials/';

  static String materialById(String id) => '$base/custom_admin/materials/$id/';

  static String meetSessions = '$base/custom_admin/meet-sessions/';

  static String categorizedMeetSessions =
      '$base/custom_admin/meet-sessions/categorized/';

  static String meetSessionById(String id) =>
      '$base/custom_admin/meet-sessions/$id/';

  static String mentorCurrentMonthMetrics(String mentorId) =>
      '$base/custom_admin/mentor-current-month-metrics/$mentorId/';

  static String mentorMonthlyReport =
      '$base/custom_admin/mentor-monthly-report/';

  static String mentorReports = '$base/custom_admin/mentor-reports/';

  static String myDeadlineOverrides =
      '$base/custom_admin/my-deadline-overrides/';

  static String myNotifications = '$base/custom_admin/my-notifications/';

  static String notifications = '$base/custom_admin/notifications/';

  static String categorizedNotifications =
      '$base/custom_admin/notifications/categorized/';

  static String checkNewNotifications =
      '$base/custom_admin/notifications/check-new/';

  static String checkNotifications = '$base/custom_admin/notifications/check/';

  static String markAllNotificationsRead =
      '$base/custom_admin/notifications/mark-read/';

  static String markNotificationRead(String notificationId) =>
      '$base/custom_admin/notifications/mark-read/$notificationId/';

  static String notificationById(String id) =>
      '$base/custom_admin/notifications/$id/';

  static String packageNames = '$base/custom_admin/package-names/';

  static String packageNameById(String id) =>
      '$base/custom_admin/package-names/$id/';

  static String packageRecommendations =
      '$base/custom_admin/package-recommendations/';

  static String packageRecommendationById(String id) =>
      '$base/custom_admin/package-recommendations/$id/';

  static String packageReports = '$base/custom_admin/package-reports/';

  static String packagesWithStudentSessionRequests =
      '$base/custom_admin/packages-with-student-session-requests/';

  static String packagesWithTeacherSessionRequests =
      '$base/custom_admin/packages-with-teacher-session-requests/';

  static String privacyPolicies = '$base/custom_admin/privacy-policies/';

  static String privacyPolicyById(String id) =>
      '$base/custom_admin/privacy-policies/$id/';

  static String privacyPolicyByUserType(String userType) =>
      '$base/custom_admin/privacy-policy/users/$userType/';

  static String pushStatus = '$base/custom_admin/push-status/';

  static String recommendationReport =
      '$base/custom_admin/recommendation-report/';

  static String referralSources = '$base/custom_admin/referral-sources/';

  static String referralSourceById(String id) =>
      '$base/custom_admin/referral-sources/$id/';

  static String refundDisbursements =
      '$base/custom_admin/refund-disbursements/';

  static String refundDisbursementById(String id) =>
      '$base/custom_admin/refund-disbursements/$id/';

  static String refundPolicies = '$base/custom_admin/refund-policies/';

  static String refundPolicyById(String id) =>
      '$base/custom_admin/refund-policies/$id/';

  static String refundPolicyByUserType(String userType) =>
      '$base/custom_admin/refund-policy/users/$userType/';

  static String refundRequests = '$base/custom_admin/refund-requests/';

  static String refundRequestById(String id) =>
      '$base/custom_admin/refund-requests/$id/';

  static String refundRequestDisbursements(String refundRequestId) =>
      '$base/custom_admin/refund-requests/$refundRequestId/disbursements/';

  static String registrationFee = '$base/custom_admin/registration-fee/';

  static String rescheduleRequests = '$base/custom_admin/reschedule-requests/';

  static String rescheduleRequestsDetails =
      '$base/custom_admin/reschedule-requests/details/';

  static String rescheduleRequestById(String id) =>
      '$base/custom_admin/reschedule-requests/$id/';

  static String salaryInvoiceTaxSettings =
      '$base/custom_admin/salary-invoice-tax-settings/';

  static String saleSummary = '$base/custom_admin/sale-summary/';

  static String standards = '$base/custom_admin/standards/';

  static String standardById(String id) => '$base/custom_admin/standards/$id/';

  static String starFactor = '$base/custom_admin/star-factor/';

  static String starOfMonthReport = '$base/custom_admin/star-of-month-report/';

  static String starOfMonth = '$base/custom_admin/star-of-month/';

  static String starOfMonthByMentor(String mentorId) =>
      '$base/custom_admin/star-of-month/$mentorId/';

  static String studentAdvisorAssignments =
      '$base/custom_admin/student-advisor-assignments/';

  static String studentAdvisorAssignmentById(String id) =>
      '$base/custom_admin/student-advisor-assignments/$id/';

  static String studentMentorAssignments =
      '$base/custom_admin/student-mentor-assignments/';

  static String studentMentorAssignmentHistory(String studentId) =>
      '$base/custom_admin/student-mentor-assignments/history/$studentId/';

  static String studentMentorAssignmentById(String id) =>
      '$base/custom_admin/student-mentor-assignments/$id/';

  static String studentMentor(String studentId) =>
      '$base/custom_admin/student-mentor/$studentId/';

  static String studentRescheduleRequests =
      '$base/custom_admin/student-reschedule-requests/';

  static String summary = '$base/custom_admin/summary/';

  static String supportCategories = '$base/custom_admin/support-categories/';

  static String supportCategoryById(String id) =>
      '$base/custom_admin/support-categories/$id/';

  //------------------ Support Macros ---------------------------//

  static String supportMacros = '$base/custom_admin/support-macros/';

  static String supportMacroById(String id) =>
      '$base/custom_admin/support-macros/$id/';

  //------------------ Support Ticket Replies ---------------------------//

  static String supportTicketReplies(String ticketId) =>
      '$base/custom_admin/support-ticket-replies/$ticketId/';

  static String supportTicketReplyById(String ticketId, String id) =>
      '$base/custom_admin/support-ticket-replies/$ticketId/$id/';

  //------------------ Support Tickets ---------------------------//

  static String supportTickets = '$base/custom_admin/support-tickets/';

  static String supportTicketById(String id) =>
      '$base/custom_admin/support-tickets/$id/';

  //------------------ Syllabuses ---------------------------//

  static String syllabuses = '$base/custom_admin/syllabuses/';

  static String syllabusById(String id) => '$base/custom_admin/syllabuses/$id/';

  //------------------ Teacher Reports ---------------------------//

  static String teacherReports = '$base/custom_admin/teacher-reports/';

  static String teacherRescheduleRequests =
      '$base/custom_admin/teacher-reschedule-requests/';

  //------------------ Terms ---------------------------//

  static String terms = '$base/custom_admin/terms/';

  static String termsByUserType(String userType) =>
      '$base/custom_admin/terms/users/$userType/';

  static String termById(String id) => '$base/custom_admin/terms/$id/';

  //------------------ Test Push ---------------------------//

  static String testPush = '$base/custom_admin/test-push/';

  static String testType = '$base/custom_admin/test-type/';

  //------------------ Users ---------------------------//

  static String customAdminUserCount = '$base/custom_admin/user-count/';

  static String userMeetSessions = '$base/custom_admin/user-meet-sessions/';

  static String categorizedUserMeetSessions =
      '$base/custom_admin/user-meet-sessions/categorized/';

  //------------------ User Notifications ---------------------------//

  static String userNotifications = '$base/custom_admin/user-notifications/';

  //------------------ Verification Requests ---------------------------//

  static String usersWithVerificationRequests =
      '$base/custom_admin/users-with-verification-requests/';

  static String verificationRequests =
      '$base/custom_admin/verification-requests/';

  static String verificationRequestById(String id) =>
      '$base/custom_admin/verification-requests/$id/';

  //------------------ Coupon ---------------------------//

  static String verifyCoupon = '$base/custom_admin/verify-coupon/';

  //------------------ Mentor Feedback ---------------------------//

  static String mentorFeedback = '$base/mentor/mentor-feedback/';

  static String mentorFeedbackById(String id) =>
      '$base/mentor/mentor-feedback/$id/';

  //------------------ Mentor Payments ---------------------------//

  static String mentorPayments = '$base/mentor/mentor-payments/';

  static String mentorPaymentById(String id) =>
      '$base/mentor/mentor-payments/$id/';

  //------------------ Mentor To Student/Teacher Feedback ---------------------------//

  static String mentorToStudentFeedback =
      '$base/mentor/mentor-to-student-feedback/';

  static String mentorToTeacherFeedback =
      '$base/mentor/mentor-to-teacher-feedback/';

  //------------------ Mentors ---------------------------//

  static String mentorsList = '$base/mentor/mentors-list/';

  static String mentorsWithFeedbacks = '$base/mentor/mentors-with-feedbacks/';

  static String mentors = '$base/mentor/mentors/';

  static String mentorsBulkCreate = '$base/mentor/mentors/bulk-create/';

  static String mentorById(String id) => '$base/mentor/mentors/$id/';

  static String mentorExperiences(String id) =>
      '$base/mentor/mentors/$id/experiences/';

  static String mentorExperienceById(String id, String experienceId) =>
      '$base/mentor/mentors/$id/experiences/$experienceId/';

  static String mentorPaymentDetails(String id) =>
      '$base/mentor/mentors/$id/payment-details/';

  static String mentorResign(String id) => '$base/mentor/mentors/$id/resign/';

  static String mentorUploadIdCard(String id) =>
      '$base/mentor/mentors/$id/upload-id-card/';

  //------------------ Mentor Self APIs ---------------------------//

  static String mentorMyClassSchedules = '$base/mentor/my-class-schedules/';

  static String mentorMyStudentsRefunds = '$base/mentor/my-students-refunds/';

  static String mentorMyStudents = '$base/mentor/my-students/';

  static String mentorMyTeachers = '$base/mentor/my-teachers/';

  static String mentorRescheduleRequestsDetails =
      '$base/mentor/reschedule-requests/details/';

  static String unassignedMentors = '$base/mentor/unassigned-mentors/';

  static String mentorUserCount = '$base/mentor/user-count/';

  static String mentorFeedbackByMentorId(String mentorId) =>
      '$base/mentor/$mentorId/feedback/';

  //------------------ Other Users ---------------------------//

  static String advisorPayments = '$base/other_users/advisor-payments/';

  static String advisorStudents = '$base/other_users/advisor-students/';

  static String advisorStudentsCount =
      '$base/other_users/advisor-students/count/';

  static String advisorsList = '$base/other_users/advisors-list/';

  static String advisors = '$base/other_users/advisors/';

  static String advisorById(String id) => '$base/other_users/advisors/$id/';

  static String advisorUploadIdCard(String id) =>
      '$base/other_users/advisors/$id/upload-id-card/';

  static String otherPayments = '$base/other_users/other-payments/';

  static String otherPaymentById(String id) =>
      '$base/other_users/other-payments/$id/';

  static String otherUserPermissions =
      '$base/other_users/other-user-permissions/';

  static String otherUserPermissionById(String id) =>
      '$base/other_users/other-user-permissions/$id/';

  static String otherUsersList = '$base/other_users/other-users-list/';

  static String otherUsers = '$base/other_users/other-users/';

  static String editUserById(String id) =>
      '$base/other_users/other-users/$id/';

  static String positionChoices = '$base/other_users/position-choices/';

  static String viewPermissions = '$base/other_users/view-permissions/';

  //------------------ Student Assessment Reports ---------------------------//

  static String assessmentReports = '$base/student/assessment-reports/';

  static String assessmentReportById(String id) =>
      '$base/student/assessment-reports/$id/';

  static String assessmentVoiceNoteById(String id) =>
      '$base/student/assessment-voicenote/$id/';

  //------------------ Batch Class Sessions ---------------------------//

  static String batchClassSessions = '$base/student/batch-class-sessions/';

  static String batchClassSessionById(String id) =>
      '$base/student/batch-class-sessions/$id/';

  static String authorizeBatchClassJoin(String id) =>
      '$base/student/batch-class-sessions/$id/authorize-join/';

  //------------------ Batch Packages ---------------------------//

  static String batchPackages = '$base/student/batch-packages/';

  static String batchPackageById(String id) =>
      '$base/student/batch-packages/$id/';

  static String regenerateBatchPackageMeetLink(String id) =>
      '$base/student/batch-packages/$id/regenerate-meet-link/';

  //------------------ Batch Recommendations ---------------------------//

  static String batchRecommendations = '$base/student/batch-recommendations/';

  static String batchRecommendationById(String id) =>
      '$base/student/batch-recommendations/$id/';

  //------------------ Batch Schedules ---------------------------//

  static String batchSchedules = '$base/student/batch-schedules/';

  static String batchSchedulesCount = '$base/student/batch-schedules/count/';

  static String batchSchedulesStatus = '$base/student/batch-schedules/status/';

  static String batchScheduleById(String id) =>
      '$base/student/batch-schedules/$id/';

  //------------------ Batches ---------------------------//

  static String batchesList = '$base/student/batches-list/';

  static String batches = '$base/student/batches/';

  static String batchById(String id) => '$base/student/batches/$id/';

  static String batchAssignments(String batchId) =>
      '$base/student/batches/$batchId/assignments/';

  static String batchPackagesByBatch(String batchId) =>
      '$base/student/batches/$batchId/packages/';

  static String batchPayments(String batchId) =>
      '$base/student/batches/$batchId/payments/';

  static String batchTeacherSalarySchedules(String batchId) =>
      '$base/student/batches/$batchId/schedules/teacher-salary/';

  //------------------ Certificates ---------------------------//

  static String certificates = '$base/student/certificates/';

  static String certificateById(String id) => '$base/student/certificates/$id/';

  //------------------ Class Schedules ---------------------------//

  static String classSchedules = '$base/student/class-schedules/';

  static String classSchedulesCount = '$base/student/class-schedules/count/';

  static String classSchedulesStatus = '$base/student/class-schedules/status/';

  static String classScheduleById(String id) =>
      '$base/student/class-schedules/$id/';

  //------------------ Class Sessions ---------------------------//

  static String classSessions = '$base/student/class-sessions/';

  static String classSessionById(String id) =>
      '$base/student/class-sessions/$id/';

  static String authorizeClassSessionJoin(String id) =>
      '$base/student/class-sessions/$id/authorize-join/';

  //------------------ Student Misc ---------------------------//

  static String meetParticipants = '$base/student/meet-participants/';

  static String myClassSchedules = '$base/student/my-class-schedules/';

  static String myClassSchedulesCount =
      '$base/student/my-class-schedules/count/';

  static String myMentor = '$base/student/my-mentor/';

  static String myPackages = '$base/student/my-packages/';

  static String myPayments = '$base/student/my-payments/';

  static String myRecommendations = '$base/student/my-recommendations/';

  static String studentMyTeachers = '$base/student/my-teachers/';

  static String nextClass = '$base/student/next-class/';

  static String packageSchedules = '$base/student/package-schedules/';

  //------------------ Packages ---------------------------//

  static String packagesList = '$base/student/packages-list/';

  static String packages = '$base/student/packages/';

  static String createCalendarEvents =
      '$base/student/packages/create-calendar-events/';

  static String packageById(String id) => '$base/student/packages/$id/';

  static String regeneratePackageMeetLink(String id) =>
      '$base/student/packages/$id/regenerate-meet-link/';

  static String createRemainingSessions(String packageId) =>
      '$base/student/packages/$packageId/create-remaining-sessions/';

  static String packagePaymentDetails(String packageId) =>
      '$base/student/packages/$packageId/payment_details/';

  //------------------ Payments ---------------------------//

  static String paymentById(String id) => '$base/student/payments/$id/';

  //------------------ Additional Student APIs ---------------------------//

  static String recalculatePayments(String studentId) =>
      '$base/student/recalculate-payments/$studentId/';

  static String reportsBatchRecommendations =
      '$base/student/reports/batch-recommendations/';

  static String scheduleFileById(String fileId) =>
      '$base/student/schedule-files/$fileId/';

  static String scheduleVoiceNoteById(String voiceNoteId) =>
      '$base/student/schedule-voice-notes/$voiceNoteId/';

  static String studentAssessmentReport(String id) =>
      '$base/student/student-assessment-reports/$id/';

  static String studentBatchAssignments =
      '$base/student/student-batch-assignments/';

  static String studentBatchAssignmentById(String id) =>
      '$base/student/student-batch-assignments/$id/';

  static String studentBatchInterests =
      '$base/student/student-batch-interests/';

  static String studentBatchPayments = '$base/student/student-batch-payments/';

  static String studentBatchPaymentById(String id) =>
      '$base/student/student-batch-payments/$id/';

  static String studentBatchRecommendations =
      '$base/student/student-batch-recommendations/';

  static String studentCourseProfile = '$base/student/student-course-profile/';

  static String studentCourseProfileById(String id) =>
      '$base/student/student-course-profile/$id/';

  static String studentExpenseRatio = '$base/student/student-expense-ratio/';

  static String studentPackageInterest =
      '$base/student/student-package-interest/';

  static String studentsList = '$base/student/students-list/';

  static String studentsWithBatches = '$base/student/students-with-batches/';

  static String studentsWithRefunds = '$base/student/students-with-refunds/';

  static String studentsWithReschedules =
      '$base/student/students-with-reschedules/';

  static String students = '$base/student/students/';

  static String studentsBulkCreate = '$base/student/students/bulk-create/';

  static String studentsDetails = '$base/student/students/details/';

  static String studentsDetailsActive =
      '$base/student/students/details/active/';

  static String studentsPaidStudents = '$base/student/students/paid_students/';

  static String studentsPayments = '$base/student/students/payments/';

  static String studentById(String id) => '$base/student/students/$id/';

  static String studentGenerateIdCard(String id) =>
      '$base/student/students/$id/generate-id-card/';

  static String studentUploadIdCard(String id) =>
      '$base/student/students/$id/upload-id-card/';

  static String studentActivityStatus(String studentId) =>
      '$base/student/students/$studentId/activity-status/';

  static String studentBatchPaymentsByStudent(String studentId) =>
      '$base/student/students/$studentId/batch-payments/';

  static String studentCertificates(String studentId) =>
      '$base/student/students/$studentId/certificates/';

  static String studentMaterials(String studentId) =>
      '$base/student/students/$studentId/materials/';

  static String studentPackages(String studentId) =>
      '$base/student/students/$studentId/packages/';

  static String studentPayments(String studentId) =>
      '$base/student/students/$studentId/payments/';

  static String unassignedStudents = '$base/student/unassigned-students/';

  //------------------ Teacher ---------------------------//

  static String hiringInterests = '$base/teacher/hiring-interests/';

  static String hiringInterestById(String id) =>
      '$base/teacher/hiring-interests/$id/';

  static String teacherMyClassSchedules = '$base/teacher/my-class-schedules/';

  static String teacherMyClassSchedulesCount =
      '$base/teacher/my-class-schedules/count/';

  static String teacherMyPayments = '$base/teacher/my-payments/';

  static String teacherMyStudentsMentors = '$base/teacher/my-students-mentors/';

  static String teacherMyStudents = '$base/teacher/my-students/';

  static String teacherMyStudentById(String teacherId) =>
      '$base/teacher/my-students/$teacherId/';

  static String paidTeachers = '$base/teacher/paid_teachers/';

  static String teacherBatchPackages = '$base/teacher/teacher-batch-packages/';

  static String teacherBatchPayments = '$base/teacher/teacher-batch-payments/';

  static String teacherBatchPaymentById(String id) =>
      '$base/teacher/teacher-batch-payments/$id/';

  static String teacherBonusPayments = '$base/teacher/teacher-bonus-payments/';

  static String teacherBonusPaymentById(String id) =>
      '$base/teacher/teacher-bonus-payments/$id/';

  static String teacherExpenseRatio = '$base/teacher/teacher-expense-ratio/';

  static String teacherFeedbackUpdate(String id) =>
      '$base/teacher/teacher-feedback-update/$id/';

  static String teacherWalletRecalculate(String teacherId) =>
      '$base/teacher/teachers/$teacherId/wallet-recalculate/';

  static String teacherPackageSalary(String teacherId, String packageId) =>
      '$base/teacher/$teacherId/package/$packageId/salary/';

  //------------------ Wallet ---------------------------//

  static String applyFixedCoupon = '$base/wallet/apply-fixed-coupon/';

  static String applyPercentageCoupon = '$base/wallet/apply-percentage-coupon/';

  static String walletCreditByPackage = '$base/wallet/credit/by-package/';

  static String walletCreditClassPayments =
      '$base/wallet/credit/class-payments/';

  static String walletCreditManage = '$base/wallet/credit/manage/';

  static String walletCreditRepay = '$base/wallet/credit/repay/';

  static String walletCreditStatistics = '$base/wallet/credit/statistics/';

  static String walletCreditTransactions = '$base/wallet/credit/transactions/';

  static String walletDeposit = '$base/wallet/deposit/';

  static String walletPayment = '$base/wallet/payment/';

  static String walletStudentTransactions =
      '$base/wallet/student-transactions/';

  static String teacherSalaryAdjustment =
      '$base/wallet/teacher-salary-adjustment/';

  static String teacherTransactionsGroupedByMonth =
      '$base/wallet/teacher-transactions-grouped-by-month/';

  static String teacherTransactions = '$base/wallet/teacher-transactions/';

  static String walletTransactions = '$base/wallet/transactions/';

  static String allWalletTransactions = '$base/wallet/transactions/all/';

  static String walletTransactionById(String id) =>
      '$base/wallet/transactions/$id/';

  static String userDepositsForCoupon =
      '$base/wallet/user-deposits-for-coupon/';

  static String userWallet = '$base/wallet/user-wallet/';

  static String walletCoupons = '$base/wallet/wallet-coupons/';

  static String walletCouponById(String id) =>
      '$base/wallet/wallet-coupons/$id/';

  static String walletRefundRequests = '$base/wallet/wallet-refund-requests/';

  static String walletRefundRequestById(String id) =>
      '$base/wallet/wallet-refund-requests/$id/';
}
