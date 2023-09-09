//
//  ArNativeView.swift
//  Runner
//
//  Created by minasehiro on 2023/08/26.
//

import Flutter
import UIKit
import RealityKit
import ARKit
import Combine

class ArNativeView: NSObject, FlutterPlatformView {
    private var cancellable: AnyCancellable? = nil
    
    private var _view: UIView
    var arView: ARView = {
        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        arView.session.run(config)
        return arView
    }()
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        super.init()
        
        createNativeView()
    }
    
    func view() -> UIView{
        return _view
    }
    
    func createNativeView(){
        _view.addSubview(arView)

        arView.translatesAutoresizingMaskIntoConstraints = false
        arView.leftAnchor.constraint(equalTo: _view.leftAnchor, constant: 20).isActive = true
        arView.rightAnchor.constraint(equalTo: _view.rightAnchor, constant: -20).isActive = true
        arView.topAnchor.constraint(equalTo: _view.topAnchor).isActive = true
        arView.bottomAnchor.constraint(equalTo: _view.bottomAnchor).isActive = true

        // 飛行機: biplane.usdz
        // スニーカー: sneaker.usdz
        // ぐらたん: guratan_ver1.usdz
        
        self.cancellable = Entity.loadAsync(named: "guratan_ver1.usdz")
            .sink(receiveCompletion: { loadCompletion in
                if case let .failure(error) = loadCompletion {
                    print("Unable to load a model due to error \(error)")
                }
                self.cancellable?.cancel()
            }, receiveValue: { modelEntity in
                let parentEntity = ModelEntity()
                parentEntity.addChild(modelEntity)
                
                let anchor = AnchorEntity(plane:.horizontal)
                anchor.name = "MyAnchor"
                anchor.addChild(parentEntity)
                self.arView.scene.addAnchor(anchor)
                modelEntity.generateCollisionShapes(recursive: true)
                self.arView.installGestures([.translation, .rotation, .scale], for: parentEntity)
            })
    }
}
