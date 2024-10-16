//
//  TestView.swift
//  WordScramble
//
//  Created by Rodrigo Carballo on 10/15/24.
//

import SwiftUI

struct TestView: View {
    var body: some View {
                NavigationStack {
                    VStack {
                        NavigationLink {
                            Text("text")
                        } label: {
                            Text("Hello, world!")
                        }
                    }
                    .toolbar {
                        Text("Save")
                    }
                    .padding()
                }
            }
    }


#Preview {
    TestView()
}
