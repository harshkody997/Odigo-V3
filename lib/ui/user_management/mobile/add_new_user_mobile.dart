import 'package:flutter/material.dart';

class AddNewUserMobile extends StatefulWidget {
  final String? userUuid;

  const AddNewUserMobile({this.userUuid, super.key});

  @override
  State<AddNewUserMobile> createState() => _AddNewUserMobileState();
}

class _AddNewUserMobileState extends State<AddNewUserMobile> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}
