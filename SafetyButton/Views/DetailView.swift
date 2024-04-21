//
//  DetailView.swift
//  SafetyButton
//
//  Created by Anya Li on 4/16/24.
//

import SwiftUI

struct DetailView: View {
    @Binding var scrums: [DailyScrum]
    @Binding var scrum: DailyScrum
    @State private var editingScrum = DailyScrum.emptyScrum

    @State private var isPresentingEditView = false
    @State var chatUser: ChatUser?
    var body: some View {
        List {
            Section(header: Text("Event")) {
                Picker(selection: $scrum.event, label: Text("Event")) {
                    Text("Car Ride").tag("Car Ride")
                    Text("Meeting Someone New").tag("Meeting Someone New")
                    Text("Unsafe Conversation").tag("Unsafe Conversation")
                    Text("Other").tag("Other")
                }
//                Text(String($scrum.event))

//                .pickerStyle(.segmented)
                TextField("Event", text: $scrum.event)
            }

            Section(header: Text("Record")) {
                NavigationLink(destination: Transcribe(scrums: $scrums, scrum: $scrum, vm: .init(chatUser: chatUser))) {
                    Label("Start Recording", systemImage: "mic")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }
//                HStack {
//                    Label("Length", systemImage: "clock")
//                    Spacer()
//                    Text("\(scrum.lengthInMinutes) minutes")
//                }
//                .accessibilityElement(children: .combine)
//                HStack {
//                    Label("Theme", systemImage: "paintpalette")
//                    Spacer()
//                    Text(scrum.theme.name)
//                        .padding(4)
//                        .foregroundColor(scrum.theme.accentColor)
//                        .background(scrum.theme.mainColor)
//                        .cornerRadius(4)
//                }
//                .accessibilityElement(children: .combine)
//            }
//            Section(header: Text("Attendees")) {
//                ForEach(scrum.attendees) { attendee in
//                    Label(attendee.name, systemImage: "person")
//                }
            }
            Section(header: Text("Transcript")) {
                if scrum.history.isEmpty {
                    Label("No transcripts yet", systemImage: "pencil")
                }
                ForEach(scrum.history) { history in
                    NavigationLink(destination: HistoryView(history: history)) {
                        HStack {
                            Image(systemName: "pencil")
                            Text(history.date, style: .date)
                        }
                    }
                }
//            }
//        }
//        .navigationTitle(scrum.title)
//        .toolbar {
//            Button("Edit") {
//                isPresentingEditView = true
//                editingScrum = scrum
//            }
//        }
//        .sheet(isPresented: $isPresentingEditView) {
//            NavigationStack {
//                DetailEditView(scrum: $editingScrum)
//                    .navigationTitle(scrum.title)
//                    .toolbar {
//                        ToolbarItem(placement: .cancellationAction) {
//                            Button("Cancel") {
//                                isPresentingEditView = false
//                            }
//                        }
//                        ToolbarItem(placement: .confirmationAction) {
//                            Button("Done") {
//                                isPresentingEditView = false
//                                scrum = editingScrum
//                            }
//                        }
//                    }
            }
        }
//        func printText(){
//            print($scrum.event)
//        }

//        Text("")
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DetailView(scrums: .constant(DailyScrum.sampleData), scrum: .constant(DailyScrum.sampleData[0]))
        }
    }
}
