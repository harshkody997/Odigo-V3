import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/master/contract/master_repository.dart';
import 'package:odigov3/framework/repository/master/country/contract/country_repository.dart';
import 'package:odigov3/framework/repository/master/country/model/country_timezone_response_model.dart';
import 'package:odigov3/framework/repository/master/country/model/get_language_list_response_model.dart';
import 'package:odigov3/framework/repository/master/country/model/country_list_response_model.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';

final countryListController = ChangeNotifierProvider((ref) => getIt<CountryListController>());

@injectable
class CountryListController extends ChangeNotifier {
  MasterRepository masterRepository;
  CountryRepository countryRepository;

  CountryListController(this.masterRepository,this.countryRepository);

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    searchCtr.clear();
    countryList.clear();
    languageListState.isLoading = false;
    languageListState.success = null;
    countryListState.isLoading = false;
    countryListState.success = null;
    countryListState.isLoadMore = false;
    countryTimezoneListState.success = null;
    countryTimezoneListState.isLoading = false;
    countryTimeZoneList.clear();
    pageNo = 1;
    totalCount = null;
    if (isNotify) {
      notifyListeners();
    }
  }

  clearList(){
    pageNo = 1;
    countryList.clear();
    countryListState.isLoading = false;
    countryListState.success = null;
    countryListState.isLoadMore = false;
    totalCount = null;
    notifyListeners();
  }

  List<CountryModel> countryList = [];
  List<String> countryTimeZoneList = [];
  TextEditingController searchCtr = TextEditingController();
  Timer? debounce;
  int pageNo = 1;
  int? totalCount;

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  UIState<GetLanguageListResponseModel> languageListState = UIState<GetLanguageListResponseModel>();
  List<LanguageModel> languageList = [];

  Future getLanguageListAPI(BuildContext context, WidgetRef ref) async {
    languageListState.isLoading = true;
    languageListState.success = null;
    languageList.clear();
    notifyListeners();

    final result = await masterRepository.getLanguageListAPI();

    result.when(
      success: (data) async {
        notifyListeners();
        languageListState.isLoading = false;
        languageListState.success = data;

        if (languageListState.success?.status == ApiEndPoints.apiStatus_200) {
          if (languageListState.success?.data?.isNotEmpty ?? false) {
            /// Store Language Model Into Session
            Session.languageModel = getLanguageListResponseModelToJson(data);
          }
        }
      },
      failure: (NetworkExceptions error) {
        languageListState.isLoading = false;
        String errorMsg = NetworkExceptions.getErrorMessage(error);
      },
    );
    languageListState.isLoading = false;
    notifyListeners();
  }

  UIState<CountryListResponseModel> countryListState = UIState<CountryListResponseModel>();

  Future<UIState<CountryListResponseModel>> getCountryListAPI(BuildContext context,{bool pagination = false,int? pageSize,bool? activeRecords,String? searchKeyword}) async {
    if((countryListState.success?.hasNextPage ?? false) && pagination){
      pageNo = pageNo + 1;
    }

    if (pageNo == 1) {
      countryListState.isLoading = true;
      countryList.clear();
    } else {
      countryListState.isLoadMore = true;
    }
    countryListState.success = null;

    notifyListeners();

    Map<String, dynamic> request = {
      'searchKeyword':searchKeyword,
      'activeRecords':activeRecords
    };

    final result = await countryRepository.getCountryListAPI(pageNo, pageSize ?? AppConstants.pageSize,jsonEncode(request));

    result.when(
      success: (data) async {
        countryListState.success = data;
        countryList.addAll(countryListState.success?.data ?? []);
        totalCount = countryListState.success?.totalCount;
        countryListState.isLoading = false;
        countryListState.isLoadMore = false;
        notifyListeners();
      },
      failure: (NetworkExceptions error) {
        countryListState.isLoading = false;
        countryListState.isLoadMore = false;
      },
    );
    countryListState.isLoading = false;
    countryListState.isLoadMore = false;
    notifyListeners();
    return countryListState;
  }

  /// country timezone list api
  UIState<CountryTimeZoneResponseModel> countryTimezoneListState = UIState<CountryTimeZoneResponseModel>();
  Future<UIState<CountryTimeZoneResponseModel>> getCountryTimezoneListAPI(BuildContext context) async {
    countryTimezoneListState.isLoading = true;
    countryTimezoneListState.success = null;
    countryTimeZoneList.clear();
    notifyListeners();

    final result = await countryRepository.getCountryTimeZoneAPI();

    result.when(
      success: (data) async {
        notifyListeners();
        countryTimezoneListState.isLoading = false;
        countryTimezoneListState.success = data;
        countryTimeZoneList.addAll(countryTimezoneListState.success?.data??[]);
      },
      failure: (NetworkExceptions error) {
        countryTimezoneListState.isLoading = false;
      },
    );
    countryTimezoneListState.isLoading = false;
    notifyListeners();
    return countryTimezoneListState;
  }
}
