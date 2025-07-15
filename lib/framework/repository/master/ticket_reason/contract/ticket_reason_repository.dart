abstract class TicketReasonRepository {

  Future getTicketReasonListApi(int pageNo,int pageSize,String request);

  Future addTicketReasonApi(String request);

  Future editTicketReasonApi(String request);

  Future changeTicketReasonStatusApi(String uuid,bool status);

  Future ticketReasonDetailsApi(String uuid);

}