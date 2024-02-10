import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:growgreen/game/game/world/components/land/overlays/system_selector_menu/model/ssm_child_model.dart';
import 'package:growgreen/game/game/world/components/land/overlays/system_selector_menu/model/ssm_parent_model.dart';

part 'system_selector_menu_event.dart';
part 'system_selector_menu_state.dart';

class SystemSelectorMenuBloc extends Bloc<SystemSelectorMenuEvent, SystemSelectorMenuState> {
  SystemSelectorMenuBloc() : super(SystemSelectorMenuInitial()) {
    on<SystemSelectorMenuEvent>((event, emit) {});
  }
}
