//
//  AppDelegate.swift
//  MenuBarApp
//
//  Created by peak on 2022/9/21.
//

import SwiftUI

class AppDelegate: NSObject, ObservableObject, NSApplicationDelegate {
    
    @Published var statusItem: NSStatusItem?
    @Published var popover = NSPopover()
    
    private var mainVC: MainViewController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
    }
    
    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let menuButton = statusItem?.button {
            menuButton.image = NSImage(systemSymbolName: "dollarsign.circle.fill", accessibilityDescription: nil)
            menuButton.action = #selector(menuButtonOnClick(sender:))
        }
        
//        popover.animates = true
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: PopoverView())
        popover.contentViewController?.view.window?.makeKey()
    }
    
    func showMainWindow() {
        if mainVC == nil {
            mainVC = MainViewController.create()
            mainVC?.onWindowClose = { [weak self] in
                self?.mainVC = nil
            }
        }
        mainVC?.showWindow(self)
    }
    
    @objc private func menuButtonOnClick(sender: AnyObject) {
        if popover.isShown {
            popover.performClose(sender)
        } else if let menuButton = statusItem?.button {
            popover.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: .minY)
        }
    }
}
