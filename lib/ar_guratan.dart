import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class ArGuratan extends StatefulWidget {
  const ArGuratan({super.key});

  @override
  State<ArGuratan> createState() => _ArGuratanState();
}

class _ArGuratanState extends State<ArGuratan> {
  late ARKitController arkitController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guratan Sample')),
      body: ARKitSceneView(
        onARKitViewCreated: onARKitViewCreated,
      ),
    );
  }

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;

    final material = ARKitMaterial(
      lightingModelName: ARKitLightingModel.lambert,
      diffuse: ARKitMaterialProperty.image('lib/assets/guratan_camera.png'),
    );
    final sphere = ARKitPlane(
      materials: [material],
      width: 0.1,
      height: 0.1,
    );

    final node = ARKitNode(
      geometry: sphere,
      position: Vector3(0, 0, -0.5),
      eulerAngles: Vector3.zero(),
    );
    this.arkitController.add(node);
  }
}
