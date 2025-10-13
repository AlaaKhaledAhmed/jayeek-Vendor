import 'package:flutter/material.dart';

import '../../../../core/constants/app_string.dart';
import '../../../../core/widgets/app_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(text: AppMessage.profile,),
    );
  }
}
