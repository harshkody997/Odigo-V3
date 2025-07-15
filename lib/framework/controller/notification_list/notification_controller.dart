import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/notification/contract/notification_repository.dart';
import 'package:odigov3/framework/repository/notification/model/notification_list_request_model.dart';
import 'package:odigov3/framework/repository/notification/model/notification_list_response_model.dart';
import 'package:odigov3/framework/repository/notification/model/notification_unread_count_reponse_model.dart';
import 'package:odigov3/framework/repository/notification/model/notification_unread_count_request_model.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/app_enums.dart';



final notificationController = ChangeNotifierProvider(
      (ref) => getIt<NotificationController>(),
);

@injectable
class NotificationController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    limitedList.clear();
    notificationList.clear();
    notificationScreenState.isLoading = false;
    notificationListState.success = null;
    deleteNotificationState.success = null;
    deleteNotificationListState.success = null;
    notificationUnReadCountState.success = null;
    readAllNotificationState.success = null;
    pageNoNotificationList=1;

    if (isNotify) {

      notifyListeners();
    }
  }

ScrollController notificationListController =ScrollController();
  /// list for paginatipon
  List<NotificationData> notificationList = [];


  // --------------------------------Api Integration -------------------------------//

  var notificationScreenState = UIState();

  NotificationRepository notificationRepository;

  NotificationController(this.notificationRepository);

  var notificationUnReadCountState = UIState<NotificationUnReadCountResponseModel>();
  var deleteNotificationListState = UIState<CommonResponseModel>();
  var deleteNotificationState = UIState<CommonResponseModel>();
  var readAllNotificationState = UIState<CommonResponseModel>();
  var notificationListState = UIState<NotificationListResponseModel>();

  int pageNoNotificationList = 1;

  // void increasePageNumber() {
  //   pageNoNotificationList += 1;
  //   notifyListeners();
  // }

  void resetPagination() {
    pageNoNotificationList = 1;
    notificationListState.success = null;
    notifyListeners();
  }
  List<NotificationData> limitedList=[];


  /// Notification List API
  Future<void> notificationListAPI(BuildContext context,bool? pagination) async {

    if((notificationListState.success?.hasNextPage ?? false) && (pagination??false)){
      pageNoNotificationList = pageNoNotificationList + 1;
    }

    if (pageNoNotificationList == 1) {
      notificationListState.isLoading = true;
      notificationList.clear();
    } else {
      notificationListState.isLoadMore = true;
    }
    notificationListState.success = null;
    notifyListeners();

    //
    // if(!showLoading){
    //   increasePageNumber();
    //   notificationListState.isLoading = false;
    //   notificationListState.success = null;
    // }else{
    //   if ((pageNoNotificationList != 1) && (notificationListState.success?.hasNextPage ?? false)) {
    //     notificationListState.isLoadMore = true;
    //   } else {
    //     pageNoNotificationList = 1;
    //     notificationList.clear();
    //     if (showLoading) {
    //       notificationListState.isLoading = true;
    //     }
    //     notificationListState.success = null;
    //   }
    // }



    NotificationListRequestModel requestModel = NotificationListRequestModel(
        fromDate: null,
        toDate: null,
        currentDate: null
    );

    final result = await notificationRepository
        .notificationListAPI(notificationListRequestModelToJson(requestModel),pageNoNotificationList);

    result.when(success: (data) async {
      notificationListState.success = data;

      if (notificationListState.success?.data?.isNotEmpty ?? false) {
        notificationList.addAll(notificationListState.success?.data ?? []);
        if(notificationList.isNotEmpty)
        {
          limitedList = notificationList.take(5).toList();

        }
      }
    }, failure: (NetworkExceptions error) {

    });
    notificationListState.isLoading = false;
    notificationListState.isLoadMore = false;
    notifyListeners();
  }

  /// Notification count
  Future<void> notificationUnReadCountAPI(BuildContext context) async {
    notificationUnReadCountState.isLoading = true;
    notificationUnReadCountState.success = null;
    notifyListeners();

    NotificationUnReadCountRequestModel requestModel = NotificationUnReadCountRequestModel(
      isRead:false,
    );
    final result = await notificationRepository.notificationUnreadCountAPI(notificationUnReadCountRequestModelToJson(requestModel));

    result.when(success: (data) async {
      notificationUnReadCountState.success = data;
    }, failure: (NetworkExceptions error) {
    });

    notificationUnReadCountState.isLoading = false;
    notifyListeners();
  }

  /// Delete all Notification
  Future<void> deleteNotificationListAPI(BuildContext context) async {
    deleteNotificationListState.isLoading = true;
    deleteNotificationListState.success = null;
    notifyListeners();

    final result = await notificationRepository.deleteNotificationList();

    result.when(success: (data) async {
      deleteNotificationListState.success = data;
    }, failure: (NetworkExceptions error) {
    });

    deleteNotificationListState.isLoading = false;
    notifyListeners();
  }

  /// Delete one  Notification
  Future<void> deleteNotificationAPI(
      BuildContext context, String notificationId) async {
    deleteNotificationState.isLoading = true;
    deleteNotificationState.success = null;
    notifyListeners();

    final result =
    await notificationRepository.deleteNotification(notificationId);

    result.when(success: (data) async {
      deleteNotificationState.success = data;
      if (deleteNotificationState.success?.status == ApiEndPoints.apiStatus_200) {
      }
      notifyListeners();
    }, failure: (NetworkExceptions error) {
    });

    deleteNotificationState.isLoading = false;
    notifyListeners();
  }

  /// Read all notification
  Future<void> readAllNotificationAPI(BuildContext context) async {
    readAllNotificationState.isLoading = true;
    readAllNotificationState.success = null;
    notifyListeners();

    final result = await notificationRepository.readAllNotification();

    result.when(success: (data) async {
      readAllNotificationState.success = data;
      if(readAllNotificationState.success?.status == ApiEndPoints.apiStatus_200){
        notificationUnReadCountState.success?.data =0;
      }
    }, failure: (NetworkExceptions error) {

    });

    readAllNotificationState.isLoading = false;
    notifyListeners();
  }


  /// Set notification redirection
  setNotificationRedirection(WidgetRef ref,{bool? isFromHome,String? moduleName,String? uuid,String? entityType, String? entityUuid, String? subEntityUuid ,String? subEntityType, String? destinationUuid}){
    if(moduleName == 'ADS'){
      ref.read(navigationStackController).push( NavigationStackItem.adsDetails(adsType: AdsType.Client.name, uuid: entityUuid??''));
    }
    else if(moduleName == 'Ticket'){
      ref.read(navigationStackController).pushAndRemoveAll( NavigationStackItem.ticketList());
    }else{
      if(isFromHome??false){
        ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.dashboard());
        ref.read(navigationStackController).push(const NavigationStackItem.notificationList());
      }

    }

  }





}

