//
//  VolumeLimiterApp.swift
//  VolumeLimiter
//
//  Created on 3/16/24.
//

import SwiftUI

@main
struct VolumeLimiterApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    var reduceLoudSoundsToggle: NSMenuItem!
    var decibelSliderItem: NSMenuItem!

    @State private var selectedDecibelsIndex = 0
    private let decibelValues = [75, 80, 85, 90, 95, 100] // Decibel values for each slider step

    func applicationDidFinishLaunching(_ notification: Notification) {
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = self.statusBarItem.button {
            button.image = NSImage(systemSymbolName: "speaker.wave.2.fill", accessibilityDescription: "Volume Limiter")
            button.action = #selector(statusBarButtonClicked(_:))
        }
        
        let statusBarMenu = NSMenu(title: "Volume Limiter Menu")
        
        // Add Reduce Loud Sounds toggle button
        let toggleView = Toggle(isOn: Binding(get: {
            // Get the current state
            return UserDefaults.standard.bool(forKey: "ReduceLoudSounds")
        }, set: { newValue in
            // Save the new state
            UserDefaults.standard.set(newValue, forKey: "ReduceLoudSounds")
        })) {
            Text("Reduce Loud Sounds")
                .fontWeight(.semibold)
                .foregroundColor(Color(NSColor.controlTextColor).opacity(0.95))
        }
        .toggleStyle(SwitchToggleStyle(tint: Color(NSColor.controlAccentColor)))

        // Create NSHostingView to embed SwiftUI view in NSMenuItem
        let toggleHostingView = NSHostingView(rootView: toggleView)
        toggleHostingView.frame = NSRect(x: 0, y: 0, width: 200, height: 40)

        reduceLoudSoundsToggle = NSMenuItem()
        reduceLoudSoundsToggle.view = toggleHostingView
        statusBarMenu.addItem(reduceLoudSoundsToggle)
        
        statusBarMenu.addItem(NSMenuItem.separator())
        
        // Decibel slider and title
        let sliderView = Slider(value: Binding(get: {
            return Double(self.selectedDecibelsIndex)
        }, set: { newValue in
            self.selectedDecibelsIndex = Int(newValue)
        }), in: 0...5, step: 1)
            .padding(.horizontal, 20)
        
        let decibelText = Text("\(decibelValues[self.selectedDecibelsIndex]) decibels")
            .fontWeight(.semibold)
            .padding(.top, 5)
        
        let sliderHostingView = NSHostingView(rootView: VStack {
            sliderView
            decibelText
        })
        sliderHostingView.frame = NSRect(x: 0, y: 0, width: 200, height: 60)
        
        decibelSliderItem = NSMenuItem()
        decibelSliderItem.view = sliderHostingView
        statusBarMenu.addItem(decibelSliderItem)
        
        statusBarMenu.addItem(NSMenuItem.separator())
        statusBarMenu.addItem(NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: "s"))
        statusBarMenu.addItem(NSMenuItem.separator())
        statusBarMenu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusBarItem.menu = statusBarMenu
    }

    @objc func statusBarButtonClicked(_ sender: Any?) {
        // TODO: Handle status bar button click
    }

    @objc func openSettings() {
        // TODO: Add functionality for the settings
    }
}

