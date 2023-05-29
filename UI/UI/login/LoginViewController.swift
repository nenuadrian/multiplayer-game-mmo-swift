//
//  LoginViewController.swift
//  UI
//
//  Created by Adrian Nenu on 29/05/2023.
//

import Foundation
import Cocoa
import MetalKit
import Common

class LoginViewController: NSViewController {
    
    var renderer: Renderer!
    var mtkView: MTKView!
    let loginHandler = LoginServerHandler()
    let worldHandler: WorldServerHandler = WorldServerHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginHandler.with(port: 38101)
        worldHandler.with(port: 38102)
    }
    @IBAction func printHello(sender: AnyObject) {
        Common.Logger.initiate()
 
        let nextViewController = self.storyboard?.instantiateController(withIdentifier: "gameView") as! GameViewController
        
        guard let windowController = self.view.window?.windowController else {
                   return
               }
               
       // Replace  the content view controller with the next view controller
       windowController.contentViewController = nextViewController


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
