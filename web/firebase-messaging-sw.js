self.addEventListener("notificationclick", function (event) {
  const data = event.notification.data.FCM_MSG.data;
  console.log('Data',data);

  event.waitUntil(
    clients.matchAll({
        type: "window",
      }).then(function (clientList) {

        if (clients.openWindow) {
            if(data.url){

        /*        if (data.module === "Vendor") {
                       return clients.openWindow(`${data.url}/vendor`);
                }else if (data.module === "Agency") {
                       return clients.openWindow(`${data.url}/agency`);
                }else if (data.module === "Store") {
                       return clients.openWindow(`${data.url}/vendor/vendorDetails?vendorUuid=${data.entityUuid}`);
                 }
                 else if (data.module === "ADS") {
                        if(data.entityType === "VENDOR"){

                            return  clients.openWindow(`${data.url}/vendor/vendorDetails/vendorStoreDetails?vendorUuid=${data.entityUuid}&storeUuid=${data.subEntityUuid}&tabIndex=1`);

                        }else if(data.entityType === "AGENCY"){
                           if(data.entityUuid && data.subEntityUuid && data.subEntityType === "CLIENT"){
                             return clients.openWindow(`${data.url}/agency/agencyDetails/clientsDetails?agencyUuid=${data.entityUuid}&tabIndex=1&clientUuid=${data.subEntityUuid}&subTabIndex=1`);
                             }else if (data.entityUuid){
                             return clients.openWindow(`${data.url}/agency/agencyDetails?agencyUuid=${data.entityUuid}&tabIndex=2`);
                             }else{
                                return clients.openWindow(`${data.url}/dashBoard/notification`);
                                }
                        }else{
                            return clients.openWindow(`${data.url}/dashBoard/notification`);
                               }

                 }
                 else if (data.module === "Package") {

                      if(data.entityType === "VENDOR"){
                         return  clients.openWindow(`${data.url}/vendor/vendorDetails/vendorStoreDetails?vendorUuid=${data.entityUuid}&storeUuid=${data.subEntityUuid}&tabIndex=0`);
                          }else if(data.entityType === "AGENCY"){
                            if(data.entityUuid && data.subEntityUuid && data.subEntityType === "CLIENT"){

                                  return clients.openWindow(`${data.url}/agency/agencyDetails/clientsDetails?agencyUuid=${data.entityUuid}&tabIndex=1&clientUuid=${data.subEntityUuid}&subTabIndex=0`);

                                }else if (data.entityUuid){

                                  return clients.openWindow(`${data.url}/agency/agencyDetails?agencyUuid=${data.entityUuid}&tabIndex=0`);

                                  }else{
                                      return clients.openWindow(`${data.url}/dashBoard/notification`);
                                       }
                      }

                   }else if (data.module === "Ticket") {

                          return clients.openWindow(`${data.url}/ticketManagement?ticketUuid=${data.moduleUuid}`);

                   }*/
                     if (data.module === "Purchase") {
                               return clients.openWindow(`${data.url}/purchaseDetails?purchaseUuid=${data.moduleUuid}`);
                             }
                              else if (data.module === "Ticket") {
                               return clients.openWindow(`${data.url}/ticketList`);
                             }
                              else if (data.module === "ADS") {
                               return clients.openWindow(`${data.url}/adsDetails?uuid=${data.moduleUuid}`);
                             }
                   else{

                        return clients.openWindow(`${data.url}/dashBoard/notification`);
                    }
            }

        }
      })
  );
});

importScripts("https://www.gstatic.com/firebasejs/8.0.2/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.0.2/firebase-messaging.js");


var  firebaseConfig = {
       apiKey: "AIzaSyDggKmq4QvKzvnC6X0bz965wEmhqBhBps8",
       authDomain: "odigo-v3.firebaseapp.com",
       projectId: "odigo-v3",
       storageBucket: "odigo-v3.firebasestorage.app",
       messagingSenderId: "778431670895",
       appId: "1:778431670895:web:3050f7b190e01ef393bb9a",
       measurementId: "G-P5BC7B0MEJ"
     };
firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();


