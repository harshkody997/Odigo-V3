import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/network.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/ticket_management/contract/ticket_repository.dart';
import 'package:odigov3/framework/repository/ticket_management/model/response/created_ticket_response_model.dart';
import 'package:odigov3/framework/repository/ticket_management/model/response/ticket_list_response_model.dart';

@LazySingleton(as: TicketRepository, env: Env.environments)
class TicketApiRepository implements TicketRepository{
  final DioClient apiClient;
  TicketApiRepository(this.apiClient);

  @override
  Future ticketListApi({required String request, required int pageNumber, int? dataSize}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.ticketList(pageNumber, dataSize??10 ), request);
      TicketListResponseModel responseModel = ticketListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future updateTicketStatusApi({required String request, required uuid}) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.ticketStatus(uuid), request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future createTicketApi({required String request}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.createTicket, request);
      CreatedTicketResponseModel responseModel = createdTicketResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }


}
