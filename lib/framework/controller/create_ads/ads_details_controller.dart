import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/client_ads/contract/client_ads_repository.dart';
import 'package:odigov3/framework/repository/client_ads/model/client_ads_details_response_model.dart';
import 'package:odigov3/framework/repository/default_ads/contract/default_ads_repository.dart';
import 'package:odigov3/framework/repository/default_ads/model/default_ads_details_response_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';


final adsDetailsController = ChangeNotifierProvider(
      (ref) => getIt<DefaultDetailsController>(),
);

@injectable
class DefaultDetailsController extends ChangeNotifier {
  DefaultDetailsController(this.defaultAdsRepository, this.clientAdsRepository);

  DefaultAdsRepository defaultAdsRepository;
  ClientAdsRepository clientAdsRepository;

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    defaultAdsDetailState.success = null;
    defaultAdsDetailState.isLoading = false;
    clientAdsDetailState.success = null;
    clientAdsDetailState.isLoading = false;
    if (isNotify) {
      notifyListeners();
    }
  }

  /// ---------------------------- Api Integration ---------------------------------///

  ///-----------------  Default details Api------------------------------->
  var defaultAdsDetailState = UIState<DefaultAdsDetailsResponseModel>();

  Future<void> defaultAdsDetailApi(BuildContext context, String uuid) async {
    defaultAdsDetailState.isLoading = true;
    defaultAdsDetailState.success = null;
    notifyListeners();

    final result = await defaultAdsRepository.defaultAdsDetailsApi(defaultAdsUuid: uuid);

    result.when(
      success: (data) async {
        defaultAdsDetailState.success = data;
      },
      failure: (NetworkExceptions error) {
        //String errorMsg = NetworkExceptions.getErrorMessage(error);
        //       showCommonErrorDialog(context: context, message: errorMsg);
      },
    );

    defaultAdsDetailState.isLoading = false;
    notifyListeners();
  }

  ///-----------------  Client Ads Details API ------------------------------->
  var clientAdsDetailState = UIState<ClientAdsDetailsResponseModel>();

  Future<void> clientAdsDetailApi(BuildContext context, String uuid) async {
    clientAdsDetailState.isLoading = true;
    clientAdsDetailState.success = null;
    notifyListeners();

    final result = await clientAdsRepository.clientAdsDetailsApi(clientAdsUuid: uuid);

    result.when(
      success: (data) async {
        clientAdsDetailState.success = data;
      },
      failure: (NetworkExceptions error) {
        // String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      },
    );

    clientAdsDetailState.isLoading = false;
    notifyListeners();
  }


}

