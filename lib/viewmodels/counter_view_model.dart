import 'package:get/get.dart';
import 'base_view_model.dart';

class CounterController extends BaseController {
  final _counter = 0.obs;

  int get counter => _counter.value;

  void increment() {
    _counter.value++;
  }

  void decrement() {
    _counter.value--;
  }

  void reset() {
    _counter.value = 0;
  }
}