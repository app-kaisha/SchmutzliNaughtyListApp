//
//  ListView.swift
//  SchmutzliNaughtyListApp
//
//  Created by app-kaihatsusha on 15/01/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI
import SwiftData


struct ListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var children: [Child]
    
    @State private var isSheetVisible = false
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(children) { child in
                    HStack{
                        NavigationLink {
                            DetailView(child: child)
                        } label: {
                            Image(child.naughty ? "naughty" : "nice")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                            Text("\(child.firstName) \(child.lastName)")
                                .font(.title2)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach({modelContext.delete(children[$0])})
                    // force save for simulator
                    guard let _ = try? modelContext.save() else {
                        print("😡 ERROR: Save after .onDelete on ToDoListView did not work!")
                        return
                    }
                }
                
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
            .sheet(isPresented: $isSheetVisible) {
                NavigationStack {
                    DetailView(child: Child())
                }
            }
        }
    }
    
}

#Preview {
    ListView()
        .modelContainer(Child.preview)
}
