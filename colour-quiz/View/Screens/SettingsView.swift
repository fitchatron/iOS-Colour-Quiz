//
//  SettingsView.swift
//  colour-quiz
//
//  Created by James Fitch on 24/7/2022.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @State var isShowingAlert = false
    
    var body: some View {
        VStack {
            Form {
                Toggle("Save to iCloud", isOn: $userDefaultsManager.iCloudEnabled)
                    .disabled(true)
                
                HStack {
                    Text("High Score: \(userDefaultsManager.highScore)")
                    
                    Spacer()
                    
                    Button {
                        isShowingAlert.toggle()
                    } label: {
                        Text("Reset High Score")
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.red)
                }
          
                Picker("Default Difficulty", selection: $userDefaultsManager.defaultDifficulty) {
                    ForEach(GameDifficulty.allCases) { type in
                        Text(type.name).tag(type)
                            .tint(.red)
                            .foregroundColor(.green)
                    }
                }
                .pickerStyle(.automatic)
                
                
                Toggle("Tricky Colours", isOn: $userDefaultsManager.similarColours)
            }
            .navigationTitle("Settings")
            .alert("Reset High Score", isPresented: $isShowingAlert, actions: {
                Button("Yes", role: .destructive) { handleResetHighScore() }
                Button("No", role: .cancel) { }
            }, message: {
                Text("Are you sure you want to erase your achievements 🏆?")
            })
        }
        
    }
    
    func handleResetHighScore() { userDefaultsManager.highScore = 0 }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView().environmentObject(UserDefaultsManager())
        }
    }
}
