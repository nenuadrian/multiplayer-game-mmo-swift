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
    let loginHandler = LoginServerHandler()
    let worldHandler: WorldServerHandler = WorldServerHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginHandler.with(port: 38101)
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
    
    @IBAction func printHello(sender: AnyObject) {
        Common.Logger.initiate()

        
        loginHandler.login(username: "test", password: "1234")
        loginHandler.serverList()
        loginHandler.joinServer(server: 1)

        
        worldHandler.characterList()
        worldHandler.enterWorld(char: 1)

        worldHandler.startMoving()
        worldHandler.moveTo()

        worldHandler.stopMoving()
        
    }
}
