//
//  HistoryView.swift
//  SafetyButton
//
//  Created by Anya Li on 4/16/24.
//

import SwiftUI

struct HistoryView: View {
    let history: History

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Divider()
                    .padding(.bottom)
                Text("Car")
                    .font(.headline)
                Text(history.emergencyString)
                Text(history.carString)
                Text(history.meetingString)
                Text(history.conversationString)
                Text(history.otherString)
                if let transcript = history.transcript {
                    Text("Transcript")
                        .font(.headline)
                        .padding(.top)
                    Text(transcript)
                }
            }
        }
        .navigationTitle(Text(history.date, style: .date))
        .padding()
    }
}
extension History {
    var emergencyString: String {
        ListFormatter.localizedString(byJoining: emergency.map { $0.number })
    }
}
extension History {
        var carString: String {
        ListFormatter.localizedString(byJoining: car.map { $0.wordCar })
    }
}
extension History {
        var meetingString: String {
        ListFormatter.localizedString(byJoining: meeting.map { $0.wordMeeting })
    }
}
extension History {
        var conversationString: String {
        ListFormatter.localizedString(byJoining: conversation.map { $0.wordConversation })
    }
}

extension History {
        var otherString: String {
        ListFormatter.localizedString(byJoining: other.map { $0.wordOther })
    }
}


struct HistoryView_Previews: PreviewProvider {
    static var history: History {
        History(emergency: [
            DailyScrum.Emergency(number: "Jon"),
            DailyScrum.Emergency(number: "Darla"),
            DailyScrum.Emergency(number: "Luis")
        ], car: [
            DailyScrum.Car(wordCar: "Jon"),
            DailyScrum.Car(wordCar: "Darla"),
            DailyScrum.Car(wordCar: "Luis")
        ], meeting: [
            DailyScrum.Meeting(wordMeeting: "Jon"),
        ], conversation: [
            DailyScrum.Conversation(wordConversation: "Jon"),
        ], other: [
            DailyScrum.Other(wordOther: "Jon"),
        ],
                transcript: "Darla, would you like to start today? Sure, yesterday I reviewed Luis' PR and met with the design team to finalize the UI...", event: "Car Ride")
    }
    
    static var previews: some View {
        HistoryView(history: history)
    }
}
