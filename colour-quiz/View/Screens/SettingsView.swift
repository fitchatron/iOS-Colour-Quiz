//
//  SettingsView.swift
//  colour-quiz
//
//  Created by James Fitch on 24/7/2022.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            List {
                Text("iCloud Toggle")
                Text("Reset High Score")
                Text("Difficulty Toggle")
                Text("Tricky Colours")
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
        }
    }
}
