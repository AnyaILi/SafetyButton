//
//  DetailEditView.swift
//  SafetyButton
//
//  Created by Anya Li on 4/16/24.
//

import SwiftUI


struct DetailEditView: View {
    @Binding var scrum: DailyScrum
    @State private var newEmergency = ""
    @State private var newCarName = ""
    @State private var newMeeting = ""
    @State private var newConversation = ""
    @State private var newOther = ""

    var body: some View {
        ZStack{
            Color(hex: "FFEBEB")
                .ignoresSafeArea()
            VStack{
                Text("Settings")
                    .font(.system(size: 40, weight: .bold))
                //                .padding(.top, 75.0)
                Form {
                    Section(header: Text("Emergency Contacts (email)")) {
                        ForEach(scrum.emergency) { emergency in
                            Text(emergency.number)
                        }
                        .onDelete { indices in
                            scrum.emergency.remove(atOffsets: indices)
                        }
                        HStack {
                            TextField("New Contact", text: $newEmergency)
                            Button(action: {
                                withAnimation {
                                    let emergency = DailyScrum.Emergency(number: newEmergency)
                                    scrum.emergency.append(emergency)
                                    newEmergency = ""
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .accessibilityLabel("Add Contact")
                            }
                            .disabled(newEmergency.isEmpty)
                        }
//                        TextField("Title", text: $scrum.title)
//                        HStack {
//                            Slider(value: $scrum.lengthInMinutesAsDouble, in: 5...30, step: 1) {
//                                Text("Length")
//                            }
//                            .accessibilityValue("\(scrum.lengthInMinutes) minutes")
//                            Spacer()
//                            Text("\(scrum.lengthInMinutes) minutes")
//                                .accessibilityHidden(true)
//                        }
                    }
                    Text("Enter trigger words for each scenario")
                    Section(header: Text("Car Rides")) {
                        ForEach(scrum.car) { car in
                            Text(car.wordCar)
                        }
                        .onDelete { indices in
                            scrum.car.remove(atOffsets: indices)
                        }
                        HStack {
                            TextField("New Word", text: $newCarName)
                            Button(action: {
                                withAnimation {
                                    let car = DailyScrum.Car(wordCar: newCarName)
                                    scrum.car.append(car)
                                    newCarName = ""
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .accessibilityLabel("Add word")
                            }
                            .disabled(newCarName.isEmpty)
                        }
                    }
                    Section(header: Text("Meeting New People")) {
                        ForEach(scrum.meeting) { meeting in
                            Text(meeting.wordMeeting)
                        }
                        .onDelete { indices in
                            scrum.meeting.remove(atOffsets: indices)
                        }
                        HStack {
                            TextField("New Word", text: $newMeeting)
                            Button(action: {
                                withAnimation {
                                    let meeting = DailyScrum.Meeting(wordMeeting: newMeeting)
                                    scrum.meeting.append(meeting)
                                    newMeeting = ""
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .accessibilityLabel("Add word")
                            }
                            .disabled(newMeeting.isEmpty)
                        }
                    }
                    Section(header: Text("Unsafe Conversation")) {
                        ForEach(scrum.conversation) { conversation in
                            Text(conversation.wordConversation)
                        }
                        .onDelete { indices in
                            scrum.conversation.remove(atOffsets: indices)
                        }
                        HStack {
                            TextField("New Word", text: $newConversation)
                            Button(action: {
                                withAnimation {
                                    let conversation = DailyScrum.Conversation(wordConversation: newConversation)
                                    scrum.conversation.append(conversation)
                                    newConversation = ""
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .accessibilityLabel("Add word")
                            }
                            .disabled(newConversation.isEmpty)
                        }
                    }
                    Section(header: Text("Other")) {
                        ForEach(scrum.other) { other in
                            Text(other.wordOther)
                        }
                        .onDelete { indices in
                            scrum.other.remove(atOffsets: indices)
                        }
                        HStack {
                            TextField("New Word", text: $newOther)
                            Button(action: {
                                withAnimation {
                                    let other = DailyScrum.Other(wordOther: newOther)
                                    scrum.other.append(other)
                                    newOther = ""
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .accessibilityLabel("Add word")
                            }
                            .disabled(newOther.isEmpty)
                        }
                    }
                }
            }
        }
    }
}

struct DetailEditView_Previews: PreviewProvider {
    static var previews: some View {
        DetailEditView(scrum: .constant(DailyScrum.sampleData[0]))
    }
}
