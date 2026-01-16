//
//  ListView.swift
//  SchmutzliNaughtyListApp
//
//  Created by app-kaihatsusha on 15/01/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI
import SwiftData
import AVFAudio

struct ListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var children: [Child]
    
    @State private var audioPlayer: AVAudioPlayer!
    @State private var isSheetVisible = false
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(children) { child in
                    NavigationLink {
                        DetailView(child: child)
                    } label: {
                        HStack{
                            Image(child.naughty ? "naughty" : "nice")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                            Text("\(child.firstName) \(child.lastName)")
                                .font(.title2)
                        }
                    }
                    .swipeActions {
                        Button("Delete", role: .destructive) {
                            modelContext.delete(child)
                            
                            // force save for simulator
                            guard let _ = try? modelContext.save() else {
                                print("😡 ERROR: Save after .onDelete on ToDoListView did not work!")
                                return
                            }
                        }
                    }
                }
//                .onDelete { indexSet in
//                    indexSet.forEach({modelContext.delete(children[$0])})
//                    // force save for simulator
//                    guard let _ = try? modelContext.save() else {
//                        print("😡 ERROR: Save after .onDelete on ToDoListView did not work!")
//                        return
//                    }
//                }
            }
            .listStyle(.plain)
            .navigationTitle("Schmutzli's List")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isSheetVisible.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title)
                    }
                    
                }
            }
        }
        .onAppear {
            playSound(soundName: "riff")
        }
        .sheet(isPresented: $isSheetVisible) {
            NavigationStack {
                DetailView(child: Child())
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
    ListView()
        .modelContainer(Child.preview)
}
