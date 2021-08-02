import 'dart:io';

import 'package:dio/dio.dart';

abstract class CustomInterceptor extends Interceptor {
  HttpResponse intercept(Chain chain);
}

abstract class Chain {
  HttpRequest request();

  HttpResponse proceed(HttpRequest request);
}
