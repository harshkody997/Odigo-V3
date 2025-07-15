'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "351d1d87c439b14604421cdf186c79b0",
"version.json": "0fbca92d051908a2526fd4a6b158f5eb",
"index.html": "20503e2d9e9688453cab0e6907b7c79c",
"/": "20503e2d9e9688453cab0e6907b7c79c",
"firebase-messaging-sw.js": "04f4d10a2b19bd3e227457d8ebc4b09c",
"main.dart.js": "2eb169897b0ddab812c06ffef2e037b4",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"favicon.png": "9999ff5afd219d7aef94c3c66fb6c13b",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/loading.png": "2b38b3e7d064d6493c6d7063033bed92",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "aa4ceb553de17f1e39376d0caa7a03d9",
"assets/AssetManifest.json": "662d2bb863fbce14c2253f85d02c1e90",
"assets/NOTICES": "860edbda61a935fc655b754ee1646c82",
"assets/FontManifest.json": "bc57d51cf158600726eccace9dcdd95b",
"assets/AssetManifest.bin.json": "5a2e295413e892b12f748d709ef0800d",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "0428480280386a6921f6ab25edfc6354",
"assets/packages/flutter_inappwebview_web/assets/web/web_support.js": "509ae636cfdd93e49b5a6eaf0f06d79f",
"assets/packages/flex_color_picker/assets/opacity.png": "49c4f3bcb1b25364bb4c255edcaaf5b2",
"assets/packages/flutter_dropzone_web/assets/flutter_dropzone.js": "dddc5c70148f56609c3fb6b29929388e",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.css": "5a8d0222407e388155d7d1395a75d5b9",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.html": "16911fcc170c8af1c5457940bd0bf055",
"assets/packages/html_editor_enhanced/assets/plugins/summernote-at-mention/summernote-at-mention.js": "8d1a7c753cf1a4cd0058e31fa1e5376e",
"assets/packages/html_editor_enhanced/assets/summernote-lite-dark.css": "3f3cb618d1d51e3e6d0d4cce469b991b",
"assets/packages/html_editor_enhanced/assets/summernote.html": "8ce8915ee5696d3c568e94911eb0d9bf",
"assets/packages/html_editor_enhanced/assets/jquery.min.js": "b61aa6e2d68d21b3546b5b418bf0e9c3",
"assets/packages/html_editor_enhanced/assets/summernote-no-plugins.html": "89ca56cd85a91f1dc39f5413204e24d0",
"assets/packages/html_editor_enhanced/assets/font/summernote.ttf": "82fa597f29de41cd41a7c402bcf09ba5",
"assets/packages/html_editor_enhanced/assets/font/summernote.eot": "f4a47ce92c02ef70fc848508f4cec94a",
"assets/packages/html_editor_enhanced/assets/summernote-lite.min.css": "570da368f96dc6433b8a1006c425ca7d",
"assets/packages/html_editor_enhanced/assets/summernote-lite.min.js": "4fe75f9b35f43da141d60d6a697db1c1",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "73254ec6a1f6b2af72f2e4285bfba3c2",
"assets/fonts/MaterialIcons-Regular.otf": "5adebad0b249c9fd776e6e657ca3a1b9",
"assets/assets/anim/anim_store.json": "142b5764cd7d2fe4e04b6839ff0684d3",
"assets/assets/anim/anim_error_403.json": "892e48270e732b2cfe9d26259e93afaa",
"assets/assets/anim/anim_ads_show_time.json": "a9e433a1d2467f2910cea5d63cf08568",
"assets/assets/anim/anim_cms.json": "1f7ef64b6080b24455ab566c92c508c0",
"assets/assets/anim/anim_client.json": "bbe9b8f332f96879094972eb37b81587",
"assets/assets/anim/anim_error_404.json": "3b9d7012593f2c8fc039f00b267604d8",
"assets/assets/anim/anim_roles_and_permissions.json": "dbf3178dd950f18af1b68dc9ed67026c",
"assets/assets/anim/anim_destination.json": "d7de00d20d388210bb9a8f02c509d3b2",
"assets/assets/anim/anim_master.json": "3634236ea4365ef70637f0c8296aee1d",
"assets/assets/anim/anim_ads_sequence.json": "33a635f14f356210572757b09eb99f58",
"assets/assets/anim/anim_company.json": "68c97ea3c5fa35f19bb81ff958bdbbf5",
"assets/assets/anim/anim_success.json": "ce55673d1f95ce2285b08a6f60637b5f",
"assets/assets/anim/anim_change_password_success.json": "86beaa669e4de6ed1e1c5605099de736",
"assets/assets/anim/anim_contact_us.json": "8b0ed60e7836077c8702357efa1ed133",
"assets/assets/anim/anim_change_email_success.json": "fee91bb8a7acd6eb6519bc069962d15c",
"assets/assets/anim/anim_ads.json": "a9e433a1d2467f2910cea5d63cf08568",
"assets/assets/anim/anim_user_management.json": "d0a79a910e39436e433dd3c4924664d1",
"assets/assets/anim/anim_purchase.json": "8a995272d77e0f7edaa79b5cc4033ab7",
"assets/assets/anim/anim_error_json.json": "62673bd95d4829365821e365bfb07b84",
"assets/assets/anim/anim_loader_blue.json": "dd0ca94daa536d5d504f26ade4d5b2bc",
"assets/assets/anim/anim_walllet.json": "89c19edeaaa78e99a976c7207cda2013",
"assets/assets/anim/anim_ticket.json": "7a4a659c4db36c48b9c4d8f7861d3b82",
"assets/assets/anim/anim_dashboard.json": "b65a3fb4606eb3424126fd414a30fd3f",
"assets/assets/anim/anim_device.json": "87c70edf03ea99913f624e1092639804",
"assets/assets/anim/anim_faq.json": "ea8e8b6fc9f271fb33f73c96a596678b",
"assets/assets/anim/anim_sucess.json": "fe9ff59cae0ea56adfb7762140220e7d",
"assets/assets/images/3x/ic_odigo.png": "d87b9820d612964b14cfb6d2b2530744",
"assets/assets/images/3x/ic_login_background.png": "b2f2c2b192571421a3cb58047fc0c80f",
"assets/assets/images/3x/ic_access_denied.jpg": "2f98a8ccaa5f06154c0982d72eaa0fef",
"assets/assets/images/ic_odigo.png": "16809eb6cfb9a7f04b05b906a5d24a81",
"assets/assets/images/ic_login_background.png": "4bf2a524086c511f419c1dee6aa0d7a9",
"assets/assets/images/ic_access_denied.jpg": "2f98a8ccaa5f06154c0982d72eaa0fef",
"assets/assets/images/2x/ic_odigo.png": "d87b9820d612964b14cfb6d2b2530744",
"assets/assets/images/2x/ic_login_background.png": "3397fda33db41b32008b7b219620b5b8",
"assets/assets/images/2x/ic_access_denied.jpg": "2f98a8ccaa5f06154c0982d72eaa0fef",
"assets/assets/svgs/svg_arrow_down_debit.svg": "89eb3f65902b1a67e203fd5387342d0f",
"assets/assets/svgs/svg_filter.svg": "f8e29d07320976ce751337947167794a",
"assets/assets/svgs/svg_cms_aboutUs.svg": "38bd56b6faadb0d50d5d5d592cdb9d26",
"assets/assets/svgs/svg_password_unhide.svg": "5cd067c0123eddd501619c5c93719525",
"assets/assets/svgs/svg_hide_password.svg": "26674e92898293dce4974ae0ba62e772",
"assets/assets/svgs/svg_ad_drawer.svg": "2a2641b402b24e513f9c38d4c308a806",
"assets/assets/svgs/svg_black_right_arrow.svg": "512541e129a35fe9334d1d5038a04be1",
"assets/assets/svgs/svg_switch_selected.svg": "758df4b7ea6770d38941e194cd794484",
"assets/assets/svgs/svg_login_background.svg": "7ef5c08a42cf72319e8c352373fcf1e8",
"assets/assets/svgs/svg_call_about.svg": "2f6ca3edf17f0c7e56aaba630cf92bc1",
"assets/assets/svgs/svg_cross_rounded.svg": "5c6e7ffdf533e69d6ebaacb89aec464d",
"assets/assets/svgs/svg_device.svg": "20bd0f8111e6586cc51fb8f644d1a33d",
"assets/assets/svgs/svg_stock_manage.svg": "3ce2d8fe682a6a900835436b7b99ddda",
"assets/assets/svgs/svg_delete.svg": "835c7130d97acf5713a1dc279a8d78b8",
"assets/assets/svgs/svg_right_forgot_arrow.svg": "2485246266bc96bd58cee574aae2fcb7",
"assets/assets/svgs/svg_map.svg": "6251ae3fae580015004d9eb7650bbccb",
"assets/assets/svgs/svg_location_center.svg": "82f0c686f3ba866666e84746ccd9a379",
"assets/assets/svgs/svg_edit2.svg": "a8cc5b64266dae703520b335c6658784",
"assets/assets/svgs/svg_edit_pen.svg": "b5a4a5d54a0f0e12380751bd18ca1ff9",
"assets/assets/svgs/svg_file.svg": "291bbd8a39af89dd48cd64df67449e18",
"assets/assets/svgs/svg_mobile.svg": "903cad82192c0c7ad1e36c5b6ee0cbfb",
"assets/assets/svgs/svg_phone_with_background.svg": "2db6638c9f71320c4cf8e500056cfc48",
"assets/assets/svgs/svg_back_button.svg": "dbb67ba99822be2243c3375303211cf6",
"assets/assets/svgs/svg_cross_icon.svg": "049031c3d5bff76773eb7d4309b1f339",
"assets/assets/svgs/svg_in.svg": "99e5618bd822339129b5814e2c571ce2",
"assets/assets/svgs/svg_image_placeholder.svg": "fda7dd960c498882c032898961583555",
"assets/assets/svgs/svg_master_total_destination.svg": "3c36d4b4ce88985a3fc6501eb1d5b0d4",
"assets/assets/svgs/svg_back_button_without_bg.svg": "773378d9c5036ec9c50e3ed8e023a858",
"assets/assets/svgs/svg_notification_web.svg": "30ab322d78ce68f7d21c7f94aa431fcf",
"assets/assets/svgs/svg_dasher.svg": "46edab5ebea5a3e645dadce9fc6f4933",
"assets/assets/svgs/svg_hourglass.svg": "d74febd0aea3638b3624cb9351c8a782",
"assets/assets/svgs/svg_drop_down.svg": "5afc3d25024912edc7c430d8fc6f541a",
"assets/assets/svgs/svg_white_pencil.svg": "173281e706740bf3a5837d3abe692e5e",
"assets/assets/svgs/en.svg": "0853c4d42c837f07b6178c182847e5ce",
"assets/assets/svgs/svg_like.svg": "5bebb798a56c308b5c4507aedd7789f0",
"assets/assets/svgs/svg_upload_image.svg": "b6156940582a727502b2d0112e018a7e",
"assets/assets/svgs/svg_right_arrow_icon_cupertino.svg": "d1611faa5027216c42f6ca63b6380e60",
"assets/assets/svgs/svg_grey_dot.svg": "ebb6fb5a752e3c7a14a22547a1d47e94",
"assets/assets/svgs/svg_toast_failure.svg": "52ca422748480701872809644603ff16",
"assets/assets/svgs/svg_upload.svg": "9e1207ba61facebab2632a239a260f2a",
"assets/assets/svgs/svg_voice_mic.svg": "50b0f7e95c6ec8e6e1d18ff31e485297",
"assets/assets/svgs/svg_dasher_robo.svg": "51933592daa31406b9da501ca9e90fe1",
"assets/assets/svgs/svg_vert_dots.svg": "42e3affa7bcba1b070557781fcd36cd3",
"assets/assets/svgs/svg_radio_unselected.svg": "39258198862dfc78d0f67e4e16ea2053",
"assets/assets/svgs/svg_admin_name.svg": "fc742ccc536c4de649e0e0f9f75abb9a",
"assets/assets/svgs/svg_filter_rounded.svg": "7803b20d7f7617a79acd5124a7a22b2b",
"assets/assets/svgs/svg_toast_success.svg": "4d5c58060daa32f4b7035792495e72d2",
"assets/assets/svgs/svg_right_arrow_with_black_background.svg": "98bcefbabe8e362e0b85b98ee55c6624",
"assets/assets/svgs/svg_selected_file.svg": "905679333122a62564589c7e251be6d8",
"assets/assets/svgs/svg_filler.svg": "952a5cf14926a9c2b5e8dfea46d418b5",
"assets/assets/svgs/svg_calendar.svg": "fc0e9c76a05d4f5ce8c34705e41cabdb",
"assets/assets/svgs/svg_dislike.svg": "e2e400b99cd19af303c2bf1374c9e871",
"assets/assets/svgs/svg_cms_empty_state.svg": "f5df624acdbebcfa974e2f7e92f4730f",
"assets/assets/svgs/svg_download_sample.svg": "ce4b54703edec5fdc8b307bce7ffc128",
"assets/assets/svgs/svg_reload.svg": "d77bb0d48c2a796a0b222823818714d8",
"assets/assets/svgs/svg_left_triangle.svg": "51b8e34af4e682a68f6cb99af68878d8",
"assets/assets/svgs/svg_agency_registered.svg": "faf129b35f225de76ca9efce2d91a1ef",
"assets/assets/svgs/svg_settings_circular.svg": "70c603406759430aa5c4adc8d9487899",
"assets/assets/svgs/svg_info.svg": "7fddab580460fecd5e40d9a1fa446c6b",
"assets/assets/svgs/svg_store.svg": "a2e08ca19887f7a4cbfbd70ebbc016d5",
"assets/assets/svgs/svg_roles_permission.svg": "6128625ec1fcfe6996fa592803e4c78c",
"assets/assets/svgs/svg_client.svg": "e36bbf5279a964d0db2ec558d61880f3",
"assets/assets/svgs/svg_edit_status.svg": "e99b5fb02eb0da44890ab54bae942c2b",
"assets/assets/svgs/svg_done_all.svg": "94651b49b3df9b0b3d1a34ae63d02d39",
"assets/assets/svgs/svg_dashboard.svg": "d2e26e711a19942151e2d07bf8c2a2af",
"assets/assets/svgs/svg_add.svg": "0759eee0d5840c138ce447dfb9bc7b55",
"assets/assets/svgs/svg_master_filter.svg": "01c8df31766ed83b8a756b05362f5584",
"assets/assets/svgs/svg_more_info.svg": "33d85199bd41539212643e970826e962",
"assets/assets/svgs/svg_plus.svg": "983adeb7633b2d77dd660e559d0e5eac",
"assets/assets/svgs/svg_hidePassword.svg": "e7748c4ed4db38f234e74a994a49659a",
"assets/assets/svgs/svg_expand_history.svg": "f895800c9684b7f398bc267aec79e292",
"assets/assets/svgs/svg_forward_arrow.svg": "7de048290cb35a9b9e8c7489e496eb10",
"assets/assets/svgs/svg_filters.svg": "ff6bd977fe312e21cf774be3aa084d20",
"assets/assets/svgs/svg_email.svg": "667a533178030710e2c4621b46798627",
"assets/assets/svgs/svg_placeholder.svg": "34bcdc129e1d60f2b8eccd0510b4cc00",
"assets/assets/svgs/svg_notification_appbar.svg": "91024f1fc8783dc750fdd0198ce7503c",
"assets/assets/svgs/svg_caution.svg": "a392fb53f41fa263084fbc76da906972",
"assets/assets/svgs/svg_notification.svg": "6efb8e3837a2241e7ef7ff619d803664",
"assets/assets/svgs/svg_check.svg": "80ea32ce3690574a743160a150538adb",
"assets/assets/svgs/svg_close_notification_tile.svg": "dcd8d0f4769620850a4ee93587797251",
"assets/assets/svgs/ar.svg": "d9f3ca47a675608a9218b8344fc783a5",
"assets/assets/svgs/svg_dialog_close_button.svg": "6b1e67b53e52f1ba125c0c9595f4a43f",
"assets/assets/svgs/svg_destination_placeholder.svg": "184d7700ae2335f33e23243a24ac2d52",
"assets/assets/svgs/svg_cross_icon_bg.svg": "1853c49f1f43c4451d8fe39e38303d26",
"assets/assets/svgs/svg_check_circle_rounded_selected.svg": "6207ad29e5f91d7f1a7567f4efc9acbf",
"assets/assets/svgs/svg_password.svg": "2fc3353b87a9d461e1972e82a15e0216",
"assets/assets/svgs/svg_rounded_cross.svg": "af43b126a6ff700820c0b6e9440bbd14",
"assets/assets/svgs/svg_file_upload.svg": "b7e2aaeefb79d309c75b4166017d141b",
"assets/assets/svgs/svg_odigo_icon.svg": "518fc07b7e7fbff42ebc993621ad98fa",
"assets/assets/svgs/svg_notification_circular.svg": "893a55db7c5a6580c40645cf47e61051",
"assets/assets/svgs/svg_rounded_robot.svg": "712b06d33f95373f7a9db0f6a98a98d6",
"assets/assets/svgs/svg_client_registered.svg": "f81dba0344ebeac674016e996a40ed0b",
"assets/assets/svgs/svg_cart.svg": "b4c6e2a005876618eeaf91baa1b997b7",
"assets/assets/svgs/svg_heart_selected.svg": "ae77fb4aa7c9f22a53db04f4e3567994",
"assets/assets/svgs/svg_mobile_number.svg": "052ff8895a9151cbcd6279903a3d3c46",
"assets/assets/svgs/svg_profile_rounded.svg": "1c00273f0d947f81b7e05a7cb783826f",
"assets/assets/svgs/svg_dashboard_logo.svg": "be78c9e785a42b636f9d186c0b5bf338",
"assets/assets/svgs/svg_rounded_term_and_condition.svg": "b642fefca80435b7d324aa7e13174c24",
"assets/assets/svgs/svg_calender_with_border.svg": "b52a5e83730f3832df0c89c9ac460237",
"assets/assets/svgs/svg_master_store_registered.svg": "8cec0656986e37eed7dce3af5d321667",
"assets/assets/svgs/svg_import.svg": "8696be1e6ac6816a78ccd51515905df5",
"assets/assets/svgs/svg_filled_checkbox.svg": "63808c0b991e94a64b5f36d58daa0512",
"assets/assets/svgs/svg_crown.svg": "5127f6cbcc15f79020fe3be3df5bafe2",
"assets/assets/svgs/svg_gst.svg": "f3c308e3ebbe9e36226530f1e6da9ffb",
"assets/assets/svgs/svg_about_drawer.svg": "717021e25c1ba4a62c8b48c62ec151cd",
"assets/assets/svgs/svg_faq_drawer.svg": "fe89bbeb9ae1b16dd3725049e1e9803a",
"assets/assets/svgs/svg_sidebar.svg": "ff38afb34b5ec104adf3a6f3a829fbe5",
"assets/assets/svgs/svg_bell_circular.svg": "783706eb382baf0fb4c7820360400bee",
"assets/assets/svgs/svg_setting.svg": "29b314975e2f9f4c46852cd37ab33115",
"assets/assets/svgs/svg_setting_drawer.svg": "aba96c394c70a5ab0b6c883c55bc3802",
"assets/assets/svgs/svg_search_web.svg": "9c7558e20d8173f1b947d9a6d1a68e9e",
"assets/assets/svgs/svg_kody_robots_logo.svg": "af2c646f7b68e30d4973e15a4752d64a",
"assets/assets/svgs/svg_forward_button.svg": "8927d0c3145d24452f80f86de9250667",
"assets/assets/svgs/svg_close.svg": "6b1e67b53e52f1ba125c0c9595f4a43f",
"assets/assets/svgs/svg_robot_registered.svg": "0e240ce1019626be3b1ac7de36469976",
"assets/assets/svgs/svg_backArrow.svg": "6a47e909222326bc6d4f1975524824cd",
"assets/assets/svgs/svg_edit.svg": "db8aad5b9fb04e8bcbe29c0c60a2e4e0",
"assets/assets/svgs/svg_showPassword.svg": "1cec1702b232ed6f9e2c24bb96304fe2",
"assets/assets/svgs/svg_no_data.svg": "dd838a1ce6b1f06b2f745ffcf7747217",
"assets/assets/svgs/svg_close_rounded.svg": "b3058e9e5696021ba0e8bf671879975a",
"assets/assets/svgs/svg_premium.svg": "e9e602c21883c60d87be792647efa923",
"assets/assets/svgs/svg_empty_checkbox.svg": "dd91618af070f53e85157a4af254a33f",
"assets/assets/svgs/svg_heart_unselected.svg": "ff4fff5b0cf5675ead0f7a4f83cac804",
"assets/assets/svgs/svg_cash.svg": "9272b0ad6379826a1cec6a2f42ce0cda",
"assets/assets/svgs/svg_red.svg": "02d8656670056657353cd2222120060a",
"assets/assets/svgs/svg_radio_selected.svg": "471ea116204608b607ae6b8651d131e3",
"assets/assets/svgs/svg_password_hide.svg": "9c93dadbbce920b3d0e1b11e9b2af989",
"assets/assets/svgs/svg_switch_unselected.svg": "653bf106bf97ec04fc419615b33383a3",
"assets/assets/svgs/svg_right_arrow.svg": "512541e129a35fe9334d1d5038a04be1",
"assets/assets/svgs/svg_odigo_frame.svg": "440cf95aa57f1b37feac2dfec0814a27",
"assets/assets/svgs/svg_edit_chage_password.svg": "faa6eba1771209152616143f5fe855ce",
"assets/assets/svgs/svg_copy.svg": "3fa22d60637f110497ef1282804c074d",
"assets/assets/svgs/svg_notification_delete.svg": "ca19d1e4cc28222a4c1f537f71b9bb57",
"assets/assets/svgs/svg_notification_close.svg": "7245a59075041085e738e75991cb1f8a",
"assets/assets/svgs/svg_logout_transparent.svg": "616710c7f0690e46bde7d7dc17739571",
"assets/assets/svgs/svg_ticket_management.svg": "2edd277e7211b7898ae42c75783b8433",
"assets/assets/svgs/svg_edit_with_bg.svg": "bb774998d9306603e8728618043dc39c",
"assets/assets/svgs/svg_show_password.svg": "1f63c610e0c106f81c8ecbf33218e217",
"assets/assets/svgs/svg_operator_name.svg": "42d2831571e09aaf122e968388511050",
"assets/assets/svgs/svg_destination.svg": "69c91c98ce88c8ebcc9178a7b0f2d340",
"assets/assets/svgs/svg_rounded_privacy_policy.svg": "ded718a647e28610b532a682f269e29e",
"assets/assets/svgs/svg_notification_list.svg": "db85637fa536daa68f965589d30a12de",
"assets/assets/svgs/svg_close_rounded_dialog.svg": "5d9d70a04d42fb90e6e407e8f6473f2c",
"assets/assets/svgs/svg_agency.svg": "66c43a36a7d0d3400a7420734971ddcd",
"assets/assets/svgs/svg_foreground_notification_icon.svg": "1c79df2f2bf4b93cb5c968cd22aab055",
"assets/assets/svgs/svg_notification_dashbaord.svg": "893a55db7c5a6580c40645cf47e61051",
"assets/assets/svgs/svg_person.svg": "e8b6b056df17e4c8c492fb542ecb0e8d",
"assets/assets/svgs/svg_check_circle_rounded.svg": "f3e707b48fad87dffd7a2796c0374536",
"assets/assets/svgs/svg_update_image.svg": "a63c586efefe0b6ae77cc1e33cb9428a",
"assets/assets/svgs/svg_select_image.svg": "b1ca6b813d966b2782d7ad311366d68f",
"assets/assets/svgs/svg_user_manage.svg": "781918b96ec3cdab43497f2f57974721",
"assets/assets/svgs/svg_profile.svg": "57e892a774dd6dbada4dd1138a01fe41",
"assets/assets/svgs/svg_file_resent.svg": "291bbd8a39af89dd48cd64df67449e18",
"assets/assets/svgs/svg_rounded_destination.svg": "77fef66f0e5d1f24e2ebcec54f5433e5",
"assets/assets/svgs/svg_date.svg": "839546c3f5501ccd06ab498f435c5169",
"assets/assets/svgs/svg_info2.svg": "1524303198ec8b059c4cb8b796048075",
"assets/assets/svgs/svg_three_vertical_dots.svg": "988beb652912aa7b71f97949b43baecb",
"assets/assets/svgs/svg_left_arrow.svg": "54370558e5c3bb46f871cd61d9860ad3",
"assets/assets/svgs/svg_comment.svg": "d131cf5567dfc0d228224273b3ce2e55",
"assets/assets/svgs/svg_calender.svg": "ea707d31bb4e9a9a502c3c7152db9841",
"assets/assets/svgs/svg_search.svg": "e912d41e4cf45ed2add5f702b83cac28",
"assets/assets/svgs/svg_clear_search.svg": "43ed62bc49dcf121c7f597fc77fdde16",
"assets/assets/svgs/svg_change_password_dialog.svg": "813c714b7c4d9fab8d53fbe409dca642",
"assets/assets/svgs/svg_dasher_front_view.svg": "24783442e05d5be3e2e9f3ee6413549c",
"assets/assets/svgs/svg_odigo.svg": "cba7915ee9a7c37cb542aba9fd6f276d",
"assets/assets/svgs/svg_clock.svg": "52a5ccdb2b32ec7b802d4395facff961",
"assets/assets/svgs/svg_package_master.svg": "2fa395d7ea495f54e832622f6749b14e",
"assets/assets/svgs/svg_plus_blue.svg": "ee0a960708f4c58c2fbbd16213511df8",
"assets/assets/svgs/svg_cloud_sync_blue.svg": "b9134c362ca5aa86116d7b3d0f96d222",
"assets/assets/svgs/svg_edit_company.svg": "6a54e436fc86cda1ac079e2dbb67aaa8",
"assets/assets/svgs/svg_general_support.svg": "d2e1ca3f371bd44efefae02765aa1465",
"assets/assets/svgs/svg_filled_right_arrow.svg": "64443e73a90f7f38a84f9ee23630d771",
"assets/assets/svgs/svg_down_arrow.svg": "d374d8c5e9799f62fac5eb5669b07ce7",
"assets/assets/svgs/svg_view_details.svg": "c4cfbd8f70eba8dd93a58712ab6ed550",
"assets/assets/svgs/svg_email_with_background.svg": "0a7846d8ef3f43212095eaceef596bdf",
"assets/assets/svgs/svg_drawer.svg": "403f7acaf25219f9d2888c4e3053ac0c",
"assets/assets/svgs/svg_close_import.svg": "e607820fa561d997ef87256abbf21e41",
"assets/assets/svgs/svg_person_placeholder.svg": "143ef9890d1d3382dbbb470db8845050",
"assets/assets/svgs/svg_robot_list.svg": "20bd0f8111e6586cc51fb8f644d1a33d",
"assets/assets/svgs/svg_arrangeable_icon.svg": "036caf48e220ecaae4af32dbcce0b114",
"assets/assets/svgs/svg_users.svg": "55ce3b47474f7d93ece441a4ef35b9aa",
"assets/assets/svgs/svg_green_right_arrow.svg": "4456b786c45511db72c1b4d89b44bbce",
"assets/assets/svgs/svg_call.svg": "25ce3961ea0418ccf57e050adf441e1d",
"assets/assets/svgs/svg_rounded_user.svg": "27f130aaf65d4aaffc7bcb7a98463af7",
"assets/assets/svgs/svg_minus.svg": "e476811ac41484523963d5fbba67d6a0",
"assets/assets/svgs/svg_import_file.svg": "2b5c83743de196f164ba5f8468dd5d0d",
"assets/assets/svgs/svg_arrow_up_credit.svg": "e6bdf140c5b30b674a2e87f2ed0b2074",
"assets/assets/svgs/svg_white_right_arrow.svg": "e719986dc5a08527d9ce8fdb617d4544",
"assets/assets/svgs/svg_logout.svg": "28b790ff1b19be236d80e91d1a9f4e89",
"assets/assets/svgs/svg_email_id.svg": "5f32c9b5eaeaed8757b02f6558e40545",
"assets/assets/svgs/svg_location_icon.svg": "b965ee96ef565b4479ac98bf387b52cb",
"assets/assets/svgs/svg_kody.svg": "9b8cc755444d80a619aff2daebbbc61a",
"assets/assets/svgs/svg_cms.svg": "3bd497b83caca1ed7e6061a6b312fb0b",
"assets/assets/svgs/svg_edit_profile.svg": "f7c337b66e49de90e88bec75a001fcc5",
"assets/assets/svgs/svg_no_permission.svg": "59b7280655a6857a0568945c5c8de8f7",
"assets/assets/svgs/svg_premium_2.svg": "13e329d6bb0e16153fd0c833b4688cc4",
"assets/assets/svgs/svg_contactUs.svg": "4a88e77fbf29292fe7c8a3f86ede1d0d",
"assets/assets/svgs/svg_dasher_latter.svg": "11a6ba05a7dbaa2d9500204c580a6cef",
"assets/assets/svgs/svg_ticket.svg": "8243f3167696a421a909b17c4df6e7ce",
"assets/assets/svgs/svg_logout_square.svg": "b779fecafc170bc497264f3b8df25440",
"assets/assets/svgs/svg_user1.svg": "79efcfd96f5b4f2994cb57cf1dcc1f79",
"assets/assets/svgs/svg_export.svg": "f10cf9d4e44108388c395485e0d75c1f",
"assets/assets/svgs/svg_green.svg": "a454d40eee24ac825313cbf0411514f9",
"assets/assets/svgs/svg_right_triangle.svg": "c11762a3a88e89c64ac3502e8c833f00",
"assets/assets/svgs/svg_arrow_up.svg": "a6ff8bd7fb13e4e18f367465571db01c",
"assets/assets/svgs/svg_master.svg": "8df7bc631ad58f606138f00b0876563a",
"assets/assets/lang/en.json": "551ff09561fa83c8820cc62b6408281f",
"assets/assets/lang/ar.json": "d0f85e5a6fa99df77f93c441264756f1",
"assets/assets/fonts/Outfit/Outfit-Bold.ttf": "e28d1b405645dfd47f4ccbd97507413c",
"assets/assets/fonts/Outfit/Outfit-Regular.ttf": "9f444021dd670d995f9341982c396a1d",
"assets/assets/fonts/Outfit/Outfit-Black.ttf": "d032ccd62028487a6c8d70a07bda684b",
"assets/assets/fonts/Outfit/Outfit-Thin.ttf": "8f281fc8ba39d6f355190c14b6532b44",
"assets/assets/fonts/Outfit/Outfit-SemiBold.ttf": "f4bde7633a5db986d322f4a10c97c0de",
"assets/assets/fonts/Outfit/Outfit-ExtraLight.ttf": "f257db4579a91feb1c1f0e80daae48ae",
"assets/assets/fonts/Outfit/Outfit-ExtraBold.ttf": "d649fd9b3a7e7c6d809b53eede996d18",
"assets/assets/fonts/Outfit/Outfit-Medium.ttf": "3c88ad79f2a55beb1ffa8f68d03321e3",
"assets/assets/fonts/Outfit/Outfit-Light.ttf": "905f109c79bd9683fc22eaffe4808ffe",
"assets/assets/fonts/Instrument%2520Sans/InstrumentSans-Italic.ttf": "d7f4946eb5d840e0eaf050be742ddeae",
"assets/assets/fonts/Instrument%2520Sans/InstrumentSans-MediumItalic.ttf": "aac79db6ae8591b8bff8106107f1a03b",
"assets/assets/fonts/Instrument%2520Sans/InstrumentSans-BoldItalic.ttf": "4ef845af1f159e3d704b3ae7f20be06b",
"assets/assets/fonts/Instrument%2520Sans/InstrumentSans-SemiBoldItalic.ttf": "13369dca12b5d4ad773ad7384238280e",
"assets/assets/fonts/Instrument%2520Sans/InstrumentSans-Regular.ttf": "68a19bd7907d66271109b354c18a5c65",
"assets/assets/fonts/Instrument%2520Sans/InstrumentSans-SemiBold.ttf": "2aaca9d19ffd4cccb93898b107e9238b",
"assets/assets/fonts/Instrument%2520Sans/InstrumentSans-Medium.ttf": "64a5a738f077da9f6897c78ea4181b29",
"assets/assets/fonts/Instrument%2520Sans/InstrumentSans-Bold.ttf": "8881a442a3f4cf88b092463d49a377e4",
"assets/assets/fonts/Roboto/Roboto-Medium.ttf": "68ea4734cf86bd544650aee05137d7bb",
"assets/assets/fonts/Roboto/Roboto-Light.ttf": "881e150ab929e26d1f812c4342c15a7c",
"assets/assets/fonts/Roboto/Roboto-Regular.ttf": "8a36205bd9b83e03af0591a004bc97f4",
"assets/assets/fonts/Roboto/Roboto-Bold.ttf": "b8e42971dec8d49207a8c8e2b919a6ac",
"assets/assets/fonts/Roboto/Roboto-Thin.ttf": "66209ae01f484e46679622dd607fcbc5",
"assets/assets/fonts/Roboto/Roboto-Black.ttf": "d6a6f8878adb0d8e69f9fa2e0b622924",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "9fe690d47b904d72c7d020bd303adf16",
"canvaskit/canvaskit.js.symbols": "27361387bc24144b46a745f1afe92b50",
"canvaskit/skwasm.wasm": "1c93738510f202d9ff44d36a4760126b",
"canvaskit/chromium/canvaskit.js.symbols": "f7c5e5502d577306fb6d530b1864ff86",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "c054c2c892172308ca5a0bd1d7a7754b",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.wasm": "a37f2b0af4995714de856e21e882325c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
