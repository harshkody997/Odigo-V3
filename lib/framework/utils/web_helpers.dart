import 'dart:html' as html;

class WebHelper {
  static void setFavicon(String href) {
    final head = html.document.head;

    if (head == null) return;

    // Remove old icons
    head.querySelectorAll("link[rel~='icon']").forEach((element) => element.remove());

    // Add new one
    final link = html.LinkElement()
      ..rel = 'icon'
      ..href = href;

    head.append(link);
  }

  static void setLoadingFavicon() => setFavicon('icons/loading.png');

  static void setDefaultFavicon() => setFavicon('web/favicon.png');
}
