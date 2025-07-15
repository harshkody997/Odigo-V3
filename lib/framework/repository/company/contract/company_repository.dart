
import 'package:odigov3/framework/provider/network/network.dart';

abstract class CompanyRepository{

  ///get company detail of
  Future getCompanyDetail();

  ///Add Edit company
  Future editCompanyApi(String request);

  ///upload company image
  Future uploadCompanyImage(FormData formData, String companyUuid);


}