//
//  NewRecording.swift
//  SafetyButton
//
//  Created by Anya Li on 4/16/24.
//

import SwiftUI

struct NewRecording: View {
    @State private var newScrum = DailyScrum.emptyScrum
    @Binding var scrums: [DailyScrum]
    @Binding var isRecording: Bool
    
    var body: some View {
        NavigationStack {
            DetailView(scrums: $scrums, scrum: $newScrum)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Dismiss") {
                            isRecording = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            scrums.append(newScrum)
                            isRecording = false
                        }
                    }
                }
        }
    }
}

struct NewRecording_Previews: PreviewProvider {
    static var previews: some View {
        NewRecording(scrums: .constant(DailyScrum.sampleData), isRecording: .constant(true))
    }
}
