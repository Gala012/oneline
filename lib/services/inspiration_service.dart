import 'dart:math';
import 'package:get/get.dart';
class InspirationService extends GetxService {
  final _random = Random();
  final List<String> _inspirationPrompts = [
    'What made you smile today?',
    'What are you grateful for right now?',
    'What challenge did you overcome today?',
    'What small joy did you experience?',
    'What lesson did you learn today?',
    'What thought has been on your mind lately?',
    'What moment today felt meaningful?',
    'What do you hope for tomorrow?',
    'What feeling defines your day?',
    'What surprised you today?',
    'What would you tell your younger self?',
    'What brings you peace?',
    'What are you looking forward to?',
    'What made you proud today?',
    'What kindness did you witness?',
    'What beauty did you notice?',
    'What connection did you feel?',
    'What inspired you today?',
    'What do you want to remember?',
    'What changed your perspective?',
    'What simple pleasure brought you joy?',
    'What fear did you face?',
    'What strength did you discover?',
    'What clarity did you find?',
    'What wisdom would you share?',
    'What progress did you make?',
    'What love did you feel?',
    'What dream keeps you going?',
    'What truth resonates with you?',
    'What moment made you pause?',
  ];
  String getRandomInspiration() {
    return _inspirationPrompts[_random.nextInt(_inspirationPrompts.length)];
  }
}
