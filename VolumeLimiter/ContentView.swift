//
//  ContentView.swift
//  VolumeLimiter
//
//  Created on 3/16/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("ReduceLoudSounds") var reduceLoudSounds: Bool = false
    @AppStorage("SelectedDecibelIndex") private var selectedDecibelsIndex = 0 // Syncs with UserDefaults
    private let decibelValues = [75, 80, 85, 90, 95, 100]
    
    var body: some View {
        VStack {
            Text("Coda Settings")
                .font(.largeTitle)
                .padding(.bottom, 20)

            // Toggle to reduce loud sounds
            Toggle(isOn: $reduceLoudSounds) {
                Text("Reduce Loud Sounds")
                    .font(.headline)
            }
            .toggleStyle(SwitchToggleStyle(tint: Color.blue))
            .padding()

            // Decibel slider
            Slider(value: Binding(get: {
                return Double(selectedDecibelsIndex)
            }, set: { newValue in
                selectedDecibelsIndex = Int(newValue)
            }), in: 0...5, step: 1)
                .padding()
            
            Text("\(decibelValues[selectedDecibelsIndex]) dB")
                .font(.headline)
                .padding(.top, 5)
            
            Spacer()
        }
        .padding()
        .frame(width: 400, height: 300)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
