import 'package:flutter/material.dart';

import '../../../../core/constants/app_string.dart';
import '../../../../core/widgets/app_bar.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBarWidget(text: AppMessage.orders));
  }
}
