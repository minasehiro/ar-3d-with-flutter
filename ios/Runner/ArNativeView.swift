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
        condig.planeDetection = [.horizontal, .vertical]
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
    
    func view() -> UIView {
        return _view
    }
    
    func createNativeView() {
        _view.addSubview(arView)
        
        arView.translatesAutoresizingMaskIntoConstraints = false,
        arView.leftAnchor.constraint(equalTo: _view.leftAnchor, constant: 20).isActive = true
        arView.rightAnchor.constraint(equalTo: _view.rightAnchor, constant: -20).isActive = true
        arView.topAnchor.constraint(equalTo: _view.topAnchor).isActive = true
        arView.bottomAnchor.constraint(equalTo: _view.bottomAnchor).isActive = true
        
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/japan-shooting-locations.appspot.com/o/sneaker_airforce.usdz?alt=media&token=bf70a752-5636-4d5b-b8c5-0fe408a13d46"
        )
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destination = documents.appendingPathComponent(url!.lastPathComponent)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let downloadTask = session.downloadTask(with: request, conmpletionHandler: { (location URL?,
                                                                                      response: URLResponse?,
                                                                                      error: Error?) -> Void in
            
            let fileManeger = FileManager.default
            
            if fileManeger.fileExists(atPath: destination.path) {
                try! fileManeger.removeItem(atPath: destination.path)
            }
            try! fileManeger.moveItem(atPath: location!.path, toPath: destination.path)
            
            DispatchQueue.main.async {
                self.cancellable = Entity.loadAsync(contentsOf: destination)
                    .sink(receiveCompletion: { loadCompletion in
                        if case let .failure(error) = loadCompletion {
                            print("Unable to load a model due to error \(error)")
                        }
                        self.cancellable?.cancel()
                    }, receiveValue: { modelEntity in
                        let parentEntity = modelEntity()
                        parentEntity.addChild(modelEntity)
                        
                        let anchor AnchorEntity(plane: .horizontal)
                        anchor.name = "MyAnchor"
                        anchor.addChild(parentEntity)
                        self.arView.scene.addAnchor(anchor)
                        modelEntity.generateCollisionChapes(recursive: true)
                        self.arView.installGestures([.translation, .rotation, .scale], for: parentEntity)
                    })
            }
            
        })
        downloadTask.resume()
    }
}
