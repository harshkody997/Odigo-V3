import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:injectable/injectable.dart';
import 'package:odigov3/framework/dependency_injection/inject.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/provider/network/network_exceptions.dart';
import 'package:odigov3/framework/repository/auth/contract/auth_repository.dart';
import 'package:odigov3/framework/repository/cms/contract/cms_repository.dart';
import 'package:odigov3/framework/repository/cms/model/add_cms_response_model.dart';
import 'package:odigov3/framework/repository/cms/model/add_edit_cms_request_model.dart';
import 'package:odigov3/framework/repository/cms/model/cms_response_model.dart';
import 'package:odigov3/framework/repository/cms/model/get_cms_type_response_model.dart';
import 'package:odigov3/framework/repository/common_response/common_response_model.dart';
import 'package:odigov3/framework/repository/master/country/model/get_language_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/framework/utils/ui_state.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';


final cmsController = ChangeNotifierProvider(
      (ref) => getIt<CmsController>(),
);

@injectable
class CmsController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    if (isNotify) {

      languageList.clear();
      languageListState.success=null;
      cmsTypeState.success =null;
      addCmsState.success =null;
      editCmsState.success =null;
      closeAllTiles();

      notifyListeners();
    }
  }

  TextEditingController languageController = TextEditingController();
  void closeAllTiles() {
    expandedTileKey = null;
    notifyListeners();
  }
  // final List<String> tabList = PlatFormType.values.map((type) => type.label).toList();
  //
  //
  // final List<Map<String, String>> cmsTypeList = CmsType.values.map((type) {
  //   return {
  //     'key': type.key,
  //     'label': type.label,
  //   };
  // }).toList();
  List<String> getTabList(BuildContext context) {
    return PlatFormType.values.map((type) => type.label(context)).toList();
  }

  List<Map<String, String>> getCmsTypeList(BuildContext context) {
    return CmsType.values.map((type) {
      return {
        'key': type.key,
        'label': type.label(context),
      };
    }).toList();
  }

  int selectedTabIndex=0;
  void updateSelectedTabIndex(int index)
  {
    selectedTabIndex = index;
    notifyListeners();
  }
  LanguageModel? selectedLanguageData;

  Timer? debounceTimer;

  Future<void> setCmsDataForLanguage(String newValue) async {

    final cmsValues = cmsTypeState.success?.data?.cmsValues ?? [];

    CmsValue? matchedCms;
    try {
      matchedCms = cmsValues.firstWhere(
            (cms) => cms.languageUuid == selectedLanguageData?.uuid,
      );
    } catch (e) {
      matchedCms = null;
    }

    if (matchedCms != null && matchedCms.toString().trim() !='<br>') {
      matchedCms.fieldValue = newValue;
      notifyListeners();
    }
  }

  updateLanguageData(LanguageModel? langData)
  async {
    selectedLanguageData =langData;
    if((cmsTypeState.success?.data?.cmsValues??[]).isNotEmpty)
      {

            for (var cmsData in  cmsTypeState.success?.data?.cmsValues??[]) {
              if (cmsData.controller != null) {
                var fieldData = cmsTypeState.success?.data?.cmsValues?.firstWhere((element)=>element.languageUuid==selectedLanguageData?.uuid);
                try {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    await Future.delayed(Duration(milliseconds: 150));
                    await cmsData.controller.setText(fieldData?.fieldValue??'');
                  });

                } catch (e) {
                  print('Error------: $e');
                }
              } else {
                print('Controller is null for ${cmsData.languageName}');
              }
            }
            notifyListeners();

      }



      }


      getLanguageFromSession()
      {

        GetLanguageListResponseModel responseModel = getLanguageListResponseModelFromJson(Session.languageModel);

        if((responseModel.data??[]).isNotEmpty)
         {

           languageList.addAll(responseModel.data??[]);
           updateLanguageData(languageList.firstWhere((languageList) => languageList.code == Session.getAppLanguage()));

           selectedLanguageData =languageList.firstWhere((languageList) => languageList.code == Session.getAppLanguage());

         }

      }


  AuthRepository loginRepository;
  CmsRepository cmsRepository;

  CmsController(this.loginRepository,this.cmsRepository);


  UIState<GetLanguageListResponseModel> languageListState = UIState<GetLanguageListResponseModel>();
  List<LanguageModel> languageList = [];

  Future<void> getLanguageListAPI(BuildContext context, WidgetRef ref) async {
    languageListState.isLoading = true;
    languageListState.success = null;
    languageList.clear();
    notifyListeners();

    final result = await loginRepository.getLanguageListAPI();

    result.when(
      success: (data) async {
        notifyListeners();
        languageListState.isLoading = false;
        languageListState.success = data;

        if (languageListState.success?.status == ApiEndPoints.apiStatus_200) {
          if (languageListState.success?.data?.isNotEmpty ?? false) {
            languageList.addAll(languageListState.success?.data ?? []);
            notifyListeners();
             updateLanguageData(languageList.firstWhere((languageList) => languageList.code == Session.getAppLanguage()));

            /// Store Language Model Into Session
            Session.languageModel = getLanguageListResponseModelToJson(data);
          }
        }
      },
      failure: (NetworkExceptions error) {
        languageListState.isLoading = false;
      },
    );
    languageListState.isLoading = false;
    notifyListeners();
  }

  HtmlEditorController htmlController = HtmlEditorController();

  ///Set CMS Page
  setCmsPage(value){
    if(value=='ABOUT_US'){
      cmsPage=LocaleKeys.keyAboutUs.localized;
    }else if(value=='PRIVACY_POLICY'){
      cmsPage=LocaleKeys.keyPrivacyPolicy.localized;
    }else if(value=='TERMS_AND_CONDITION'){
      cmsPage=LocaleKeys.keyTermsConditions.localized;
    }else {
      cmsPage=LocaleKeys.keyRefund.localized;
    }
    notifyListeners();
  }




  String? cmsType;
  String? expandedTileKey;
  updateCmsType(String? val)
  {
    expandedTileKey =val;
    notifyListeners();

  }



  var cmsTypeState = UIState<GetCmsTypeResponseModel>();

  Future<void> cmsListApi(BuildContext context) async {
    cmsTypeState.isLoading = true;
    cmsTypeState.success = null;
    notifyListeners();


    final result = await cmsRepository.cmsTypeApi(expandedTileKey??'',selectedTabIndex==0? 'DESTINATION':'CLIENT');
    result.when(
      success: (data) async {
        cmsTypeState.success = data;
        if (cmsTypeState.success?.data != null) {
          print('ifff----${selectedLanguageData?.code}');
          cmsTypeState.success?.data?.isEdit =true;
          for (var cmsData in cmsTypeState.success?.data?.cmsValues ?? []) {
            cmsData.controller = HtmlEditorController();
            if (cmsData.controller != null) {
              try {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await Future.delayed(Duration(milliseconds: 200));
                  await cmsData.controller.setText(cmsData.fieldValue ?? '');
                });

              } catch (e) {
                print('Error in lang------: $e');
              }
            } else {
              print('Controller is null for ${cmsData.languageName}');
            }
          }
          notifyListeners();
        }
        else {

          List<CmsValue> cmsValues = languageList.map((lang) {
            return CmsValue(
              languageUuid: lang.uuid ?? '',
              languageName: lang.name ?? '',
              uuid: '',
              fieldValue: '',
              controller: HtmlEditorController(),
            );
          }).toList();
          cmsTypeState.success = GetCmsTypeResponseModel(data: Data(cmsValues: cmsValues,isEdit: false));
        //  updateLanguageData(languageList.firstWhere((languageList) => languageList.code == Session.getAppLanguage()));
          updateLanguageData(languageList.firstWhere((languageList) => languageList.code == selectedLanguageData?.code));

          notifyListeners();
        }
      },

      failure: (NetworkExceptions error) {
        cmsTypeState.isLoading = false;
        notifyListeners();
      },
    );

    cmsTypeState.isLoading = false;
    notifyListeners();
  }

  var addCmsState = UIState<AddCmsResponseModel>();

  Future<void> addCmsApi(BuildContext context) async {
    addCmsState.isLoading = true;
    addCmsState.success = null;
    notifyListeners();
    final cmsList = cmsTypeState.success?.data?.cmsValues ?? [];

    final cmsValues = cmsList.map((cms) {
      return AddCmsValues(
        languageUuid: cms.languageUuid,
        fieldValue: cms.fieldValue ?? '',
      );
    }).toList();

    AddEditCmsRequestModel addEditCmsRequestModel = AddEditCmsRequestModel(platformType: selectedTabIndex==0? 'DESTINATION':'CLIENT',
        cmsType: expandedTileKey??'',cmsValues: cmsValues);
    String request = addEditCmsRequestModelToJson(addEditCmsRequestModel);


    final result = await cmsRepository.addCmsApi(request);
    result.when(
      success: (data) async {
        addCmsState.success = data;
        if(addCmsState.success?.status==ApiEndPoints.apiStatus_200)
          {
           // context.showSnackBar(addCmsState.success?.message??'');
            showToast(context: context,isSuccess:true,message:addCmsState.success?.message??'',showAtBottom: true);

          }
        notifyListeners();

      },
      failure: (NetworkExceptions error) {

      },
    );

    addCmsState.isLoading = false;
    notifyListeners();
  }

  bool isMeaningfulHtml(String html) {
    final cleaned = html.replaceAll(RegExp(r'<[^>]*>'), '').trim();
    return cleaned.isNotEmpty;
  }
  var editCmsState = UIState<CommonResponseModel>();

  Future<void> editCmsApi(BuildContext context,String? uuid) async {
    editCmsState.isLoading = true;
    editCmsState.success = null;
    notifyListeners();
    final cmsList = cmsTypeState.success?.data?.cmsValues ?? [];

    final cmsValues = cmsList.map((cms) {
      return AddCmsValues(
        languageUuid: cms.languageUuid,
        fieldValue: cms.fieldValue ?? '',
      );
    }).toList();

    AddEditCmsRequestModel addEditCmsRequestModel = AddEditCmsRequestModel(platformType: selectedTabIndex==0? 'DESTINATION':'CLIENT',
        cmsType: expandedTileKey??'',
        cmsValues: cmsValues,
        uuid: uuid);
    String request = addEditCmsRequestModelToJson(addEditCmsRequestModel);


    final result = await cmsRepository.updateCmsApi(request);
    result.when(
      success: (data) async {
        editCmsState.success = data;
        if(editCmsState.success?.status==ApiEndPoints.apiStatus_200)
          {
            //context.showSnackBar(editCmsState.success?.message??'');
            showToast(context: context,isSuccess:true,message:editCmsState.success?.message??'',showAtBottom: true);

          }
        notifyListeners();
      },
      failure: (NetworkExceptions error) {
        editCmsState.isLoading = false;
        notifyListeners();
      },
    );

    editCmsState.isLoading = false;
    notifyListeners();
  }

  var cmsState = UIState<CmsResponseModel>();

  /// CMS API
  Future<UIState<CmsResponseModel>> cmsAPI(BuildContext context, {required String cmsType}) async {
    cmsState.isLoading = true;
    cmsState.success = null;
    notifyListeners();

    final result = await cmsRepository.cmsApi(cmsType,'DESTINATION');

    result.when(success: (data) async {
      cmsState.success = data;
      cmsState.isLoading = false;
      if (cmsState.success?.status == ApiEndPoints.apiStatus_200) {}
      notifyListeners();
    }, failure: (NetworkExceptions error) {

    });

    cmsState.isLoading = false;
    notifyListeners();
    return cmsState;
  }

}
