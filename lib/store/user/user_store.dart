import 'package:mobx/mobx.dart';
import 'package:start/model/user/uservfa.dart';

part 'user_store.g.dart';


class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  _UserStore();

  @observable
  UserVfa userVfa = UserVfa();

  @observable
  bool isLoggedIn = false;

}
