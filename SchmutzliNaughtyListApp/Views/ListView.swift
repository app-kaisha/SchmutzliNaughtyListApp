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
                
            }
            .listStyle(.plain)
            .navigationTitle("Schmutzli's List")
        }
    }
}

#Preview {
    ListView()
        .modelContainer(Child.preview)
}
