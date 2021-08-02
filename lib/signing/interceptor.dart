import 'dart:io';

abstract class CustomInterceptor {
  HttpResponse intercept(Chain chain);
}

abstract class Chain {
  HttpRequest request();

  HttpResponse proceed(HttpRequest request);
}
