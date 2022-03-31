// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserStore on _UserStore, Store {
  final _$userVfaAtom = Atom(name: '_UserStore.userVfa');

  @override
  UserVfa get userVfa {
    _$userVfaAtom.reportRead();
    return super.userVfa;
  }

  @override
  set userVfa(UserVfa value) {
    _$userVfaAtom.reportWrite(value, super.userVfa, () {
      super.userVfa = value;
    });
  }

  final _$isLoggedInAtom = Atom(name: '_UserStore.isLoggedIn');

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  @override
  String toString() {
    return '''
userVfa: ${userVfa},
isLoggedIn: ${isLoggedIn}
    ''';
  }
}
