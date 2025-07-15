import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:odigov3/ui/client/web/upload_document_web.dart';

class UploadDocument extends ConsumerStatefulWidget{
  final String? clientUuid;
  final String? documentUuid;
  const UploadDocument({Key? key,this.clientUuid, this.documentUuid}) : super(key: key);

  @override
  ConsumerState<UploadDocument> createState() => _UploadDocumentState();
}

class _UploadDocumentState extends ConsumerState<UploadDocument> with WidgetsBindingObserver, ZoomAwareMixin  {
  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return UploadDocumentWeb(clientUuid: widget.clientUuid,documentUuid: widget.documentUuid,);
      },
      desktop: (BuildContext context) {
        return UploadDocumentWeb(clientUuid: widget.clientUuid,documentUuid: widget.documentUuid,);
      },
      tablet: (BuildContext context) {
        return UploadDocumentWeb(clientUuid: widget.clientUuid,documentUuid: widget.documentUuid,);
      },
    );
  }
}

