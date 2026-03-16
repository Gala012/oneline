import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'one_line_library_logic.dart';

class OneLineLibraryView extends GetView<OneLineLibraryLogic> {
  const OneLineLibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => controller.aekqbznc.value
              ? const CircularProgressIndicator(color: Colors.black)
              : buildError(),
        ),
      ),
    );
  }

  Widget buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              controller.dyab();
            },
            icon: const Icon(
              Icons.restart_alt,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
