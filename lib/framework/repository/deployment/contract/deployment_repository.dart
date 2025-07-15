
import 'package:odigov3/framework/provider/network/network.dart';

abstract class DeploymentRepository {

    ///Deployment list api
    Future deploymentListApi(int page,String request);

    ///Add deployment
    Future addNewDeploymentApi(FormData formData);



}

