import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/store/contract/store_repository.dart';
import 'package:odigov3/framework/repository/store/model/store_language_detail_api.dart';
import 'package:odigov3/framework/utils/ui_state.dart';

final storeDetailController = ChangeNotifierProvider((ref) => getIt<StoreDetailController>());

@injectable
class StoreDetailController extends ChangeNotifier {
  StoreDetailController(this.storeRepository);
  final StoreRepository storeRepository;

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    storeLanguageDetailState.isLoading = true;
    storeLanguageDetailState.success = null;
    if (isNotify) {
      notifyListeners();
    }
  }

  ScrollController destinationScrollController = ScrollController();

  /// ---------------------------- Api Integration ---------------------------------///

  ///-----------------Store Language Details Api------------------------------->
  var storeLanguageDetailState = UIState<StoreLanguageDetailResponseModel>();

  Future<void> storeLanguageDetailApi(BuildContext context, String storeUuid) async {
    storeLanguageDetailState.isLoading = true;
    storeLanguageDetailState.success = null;
    notifyListeners();

    final result = await storeRepository.storeLanguageDetailApi(storeUuid: storeUuid);

    result.when(
      success: (data) async {
        storeLanguageDetailState.success = data;
      },
      failure: (NetworkExceptions error) {
        //String errorMsg = NetworkExceptions.getErrorMessage(error);
        //       showCommonErrorDialog(context: context, message: errorMsg);
      },
    );

    storeLanguageDetailState.isLoading = false;
    notifyListeners();
  }
}
