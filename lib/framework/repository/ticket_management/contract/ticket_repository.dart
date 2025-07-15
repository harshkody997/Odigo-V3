abstract class TicketRepository {

  ///ticket list Api
  Future ticketListApi({required String request,required int pageNumber, int dataSize});

  ///Update status Api
  Future updateTicketStatusApi({required String uuid,required String request});

  ///Create ticket Api
  Future createTicketApi({required String request});




}

