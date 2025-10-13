import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_state.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());
}
