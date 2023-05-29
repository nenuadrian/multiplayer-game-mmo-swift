//
//  GameViewController.swift
//  UI
//
//  Created by Adrian Nenu on 28/05/2023.
//

import Cocoa
import MetalKit
import Common


// Our macOS specific view controller
class GameViewController: NSViewController {

    var renderer: Renderer!
    var mtkView: MTKView!
    let worldHandler: WorldServerHandler = WorldServerHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        worldHandler.with(port: 38102)

        guard let mtkView = self.view as? MTKView else {
            print("View attached to GameViewController is not an MTKView")
            return
        }

        // Select the device to render with.  We choose the default device
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            print("Metal is not supported on this device")
            return
        }

        mtkView.device = defaultDevice

        guard let newRenderer = Renderer(metalKitView: mtkView) else {
            print("Renderer cannot be initialized")
            return
        }

        renderer = newRenderer

        renderer.mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)

        mtkView.delegate = renderer
    }
    

}
