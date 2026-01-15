//
//  DetailView.swift
//  SchmutzliNaughtyListApp
//
//  Created by app-kaihatsusha on 15/01/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    
    @State var child: Child
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var naughty = false
    @State private var smacksDeserved = 1
    @State private var notes = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("First Name:")
                .bold()
            TextField("first", text: $firstName)
                .textFieldStyle(.roundedBorder)
            Text("Last Name:")
                .bold()
            TextField("last", text: $lastName)
                .textFieldStyle(.roundedBorder)
            Text("Naughty?")
            Toggle("Naughty?", isOn: $naughty)
                .textFieldStyle(.roundedBorder)
                .bold()
            
            Stepper("Smacks Deserved:", value: $smacksDeserved, in: 0...5)
                .bold()
            Text("\(smacksDeserved)")
                .font(.largeTitle)
                .frame(maxWidth: .infinity)
            
            Text("Notes:")
                .bold()
            TextField("notes", text: $notes, axis: .vertical)
                .textFieldStyle(.roundedBorder)
            
            Spacer()
            HStack {
                Spacer()
                Image("boy")
                    .resizable()
                    .scaledToFit()
                Image("girl")
                    .resizable()
                    .scaledToFit()
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
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(child: Child())
    }
}
