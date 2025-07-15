import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/general_support/contract/general_support_repository.dart';
import 'package:odigov3/framework/repository/general_support/model/contact_us_list_response.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';

final generalSupportController = ChangeNotifierProvider(
      (ref) => getIt<GeneralSupport>(),
);

@injectable
class GeneralSupport extends ChangeNotifier {
  GeneralSupport(this.generalSupportRepository);
  final GeneralSupportRepository generalSupportRepository;


  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    contactUsListState.isLoading = true;
    contactUsListState.success = null;
    contactUsList.clear();
    if (isNotify) {
      notifyListeners();
    }
  }

  ///detail dialog key
  GlobalKey contactDetailDialogKey = GlobalKey();




  void notify(){
    notifyListeners();
  }

  /// ----------------------------------------------- Api Integration ----------------------------------------------------///

  ///-----------------Contact Us List Api------------------------------->
  var contactUsListState = UIState<ContactUsListResponseModel>();
  List<ContactDetail?> contactUsList =[];

  Future<void> contactUsListApi(BuildContext context, {bool isForPagination = false, int? pageSize}) async {
    int pageNo = 1;
    bool apiCall = true;
    if(!isForPagination){
      pageNo = 1;
      contactUsList.clear();
      contactUsListState.isLoading = true;
      contactUsListState.success = null;
    }
    else if(contactUsListState.success?.hasNextPage ?? false){
      pageNo = (contactUsListState.success?.pageNumber ?? 0) + 1;
      contactUsListState.isLoadMore = true;
      contactUsListState.success = null;
    }
    else{
      apiCall = false;
    }
    notifyListeners();

    if(apiCall) {

      final result = await generalSupportRepository.contactUsListApi(pageNumber: pageNo, dataSize: pageSize ?? AppConstants.pageSize);

      result.when(success: (data) async {
        contactUsListState.success = data;
        contactUsList.addAll(contactUsListState.success?.data ?? []);
      }, failure: (NetworkExceptions error) {
      });

      contactUsListState.isLoading = false;
      contactUsListState.isLoadMore = false;
      notifyListeners();
    }
  }



}

