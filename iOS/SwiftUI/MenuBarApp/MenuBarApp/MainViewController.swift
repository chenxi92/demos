//
//  MainViewController.swift
//  MenuBarApp
//
//  Created by peak on 2022/9/21.
//

import SwiftUI

class MainViewController: NSWindowController {
    
    var onWindowClose: (() -> Void)?
    
    static func create() -> MainViewController {
        let window = NSWindow()
        window.center()
        
        window.styleMask = [.titled, .closable, .miniaturizable, .resizable]
        window.title = "This is a test main title"
        
        let vc = MainViewController(window: window)
        vc.contentViewController = NSHostingController(rootView: ContentView())
        return vc
    }
    
    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        
        NSApp.activate(ignoringOtherApps: true)
        
        window?.makeKeyAndOrderFront(self)
        window?.delegate = self
    }
}

extension MainViewController: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        onWindowClose?()
    }
}
