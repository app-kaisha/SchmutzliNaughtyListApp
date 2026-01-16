//
//  DetailView.swift
//  SchmutzliNaughtyListApp
//
//  Created by app-kaihatsusha on 15/01/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI
import AVFAudio
import SwiftData

struct DetailView: View {
    
    @State var child: Child
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var naughty = false
    @State private var smacksDeserved = 1
    @State private var notes = ""
    @State private var audioPlayer: AVAudioPlayer!
    @State private var animateBoy = true
    @State private var animateGirl = true
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("First Name:")
                .bold()
            TextField("first", text: $firstName)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
            Text("Last Name:")
                .bold()
            TextField("last", text: $lastName)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
            Toggle("Naughty?", isOn: $naughty)
                .bold()
                .onChange(of: naughty) {
                    // toggle on & smacks = 0, then 1 else running total
                    smacksDeserved = naughty == true && smacksDeserved == 0 ? 1 : smacksDeserved
                    smacksDeserved = naughty == false ? 0 : smacksDeserved
                }
            
            Stepper("Smacks Deserved:", value: $smacksDeserved, in: 0...5)
                .bold()
            Text("\(smacksDeserved)")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .center)
                .onChange(of: smacksDeserved) {
                    naughty = smacksDeserved == 0 ? false : true
                }
            
            Text("Notes:")
                .bold()
            TextField("notes", text: $notes, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
            
            Spacer()
            HStack {
                Spacer()
                Image("boy")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(animateBoy ? 1.0 : 0.9)
                    .onTapGesture {
                        if audioPlayer != nil && audioPlayer.isPlaying {
                            //audioPlayer.stop()
                            return
                        }
                        playSound(soundName: "smack")
                        animateBoy = false
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.3)) {
                            animateBoy = true
                        }
                    }
                    
                Image("girl")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(animateGirl ? 1.0 : 0.9)
                    .onTapGesture {
                        if audioPlayer != nil && audioPlayer.isPlaying {
                            //audioPlayer.stop()
                            return
                        }
                        playSound(soundName: "smack")
                        animateGirl = false
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.3)) {
                            animateGirl = true
                        }
                    }
                Spacer()
            }
            .frame(height: 250)
        }
        .navigationBarBackButtonHidden()
        .font(.title2)
        .padding()
        .onAppear {
            firstName = child.firstName
            lastName = child.lastName
            naughty = child.naughty
            smacksDeserved = child.smacks
            notes = child.notes
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    child.firstName = firstName
                    child.lastName = lastName
                    child.naughty = naughty
                    child.smacks = smacksDeserved
                    child.notes = notes
                    // save into swift data/overwrite existing
                    modelContext.insert(child)
                    
                    // just to push immediately to watch db get populated in dblite
                    guard let _ = try? modelContext.save() else {
                        print("😡 ERROR: Save on DetailView did not work!")
                        return
                    }
                    
                    dismiss()
                }
            }
        }
    }
    
    func playSound(soundName: String) {
        
        if audioPlayer != nil && audioPlayer.isPlaying {
            //audioPlayer.stop()
            return
        }
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 Could not read file named \(soundName)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 ERROR: \(error.localizedDescription) creating audioPlayer.")
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(child: Child())
            .modelContainer(for: Child.self, inMemory: true)
    }
}
