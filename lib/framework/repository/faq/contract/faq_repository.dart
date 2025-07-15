abstract class FaqRepository{

  /// Faq list
  Future faqListApi({required String request, required int pageNumber, int? dataSize});

  /// Update faq status
  Future updateFaqStatusApi({required String uuid, required bool isActive});

  /// Faq details
  Future faqDetailsApi(String uuid);

  ///Add Edit faq
  Future addEditFaqApi(String request, bool forAdd);
}