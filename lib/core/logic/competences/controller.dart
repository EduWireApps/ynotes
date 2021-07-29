import 'package:flutter/material.dart';
import 'package:ynotes/core/apis/model.dart';

class CompetencesController extends ChangeNotifier {
  API? _api;

  CompetencesController(API? api) {
    _api = api;
  }
  set api(API? api) {
    _api = api;
  }

}
