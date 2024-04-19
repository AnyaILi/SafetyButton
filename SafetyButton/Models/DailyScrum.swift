//
//  DailyScrum.swift
//  SafetyButton
//
//  Created by Anya Li on 4/16/24.
//

import Foundation

struct DailyScrum: Identifiable, Codable {
    let id: UUID
    var event: String
    var emergency: [Emergency]
    var car: [Car]
    var meeting: [Meeting]
    var conversation: [Conversation]
    var other: [Other]
//    var lengthInMinutes: Int
//    var lengthInMinutesAsDouble: Double {
//        get {
//            Double(lengthInMinutes)
//        }
//        set {
//            lengthInMinutes = Int(newValue)
//        }
//    }
    var history: [History] = []
    
    init(id: UUID = UUID(), event: String, emergency: [String], car: [String], meeting: [String], conversation: [String], other: [String] /*lengthInMinutes: Int*/) {
        self.id = id
        self.event = event
        self.emergency = emergency.map {Emergency(number: $0)}
        self.car = car.map { Car(wordCar: $0) }
        self.meeting = meeting.map { Meeting(wordMeeting: $0) }
        self.conversation = conversation.map { Conversation(wordConversation: $0) }
        self.other = other.map { Other(wordOther: $0) }
//        self.lengthInMinutes = lengthInMinutes
    }
}
extension DailyScrum {
    struct Meeting: Identifiable, Codable {
        let id: UUID
        var wordMeeting: String
        
        init(id: UUID = UUID(), wordMeeting: String) {
            self.id = id
            self.wordMeeting = wordMeeting
        }
    }
}
extension DailyScrum {
    struct Car: Identifiable, Codable {
        let id: UUID
        var wordCar: String
        
        init(id: UUID = UUID(), wordCar: String) {
            self.id = id
            self.wordCar = wordCar
        }
    }
    
//    static var emptyScrum: DailyScrum {
//        DailyScrum(emergency: [], car: [], lengthInMinutes: 5)
//    }
}
extension DailyScrum {
    struct Conversation: Identifiable, Codable {
        let id: UUID
        var wordConversation: String
        
        init(id: UUID = UUID(), wordConversation: String) {
            self.id = id
            self.wordConversation = wordConversation
        }
    }
}
extension DailyScrum {
    struct Other: Identifiable, Codable {
        let id: UUID
        var wordOther: String
        
        init(id: UUID = UUID(), wordOther: String) {
            self.id = id
            self.wordOther = wordOther
        }
    }
}

extension DailyScrum {
    struct Emergency: Identifiable, Codable {
        let id: UUID
        var number: String
        
        init(id: UUID = UUID(), number: String) {
            self.id = id
            self.number = number
        }
    }
    
    static var emptyScrum: DailyScrum {
        DailyScrum(event: "Car Ride", emergency: [], car: [], meeting: [], conversation: [], other: []/*lengthInMinutes: 5*/)
    }
}

extension DailyScrum {
    static let sampleData: [DailyScrum] =
    [
        DailyScrum(event: "Car Ride", emergency: ["test@gmail.com"],
                   car: ["help", "stop", "pineapple"], meeting: ["help"], conversation: ["help"], other: ["help"]
                   /*lengthInMinutes: 10*/),
//        DailyScrum(title: "App Dev",
//                   car: ["Katie", "Gray", "Euna", "Luis", "Darla"],
//                   lengthInMinutes: 5),
//        DailyScrum(title: "Web Dev",
//                   car: ["Chella", "Chris", "Christina", "Eden", "Karla", "Lindsey", "Aga", "Chad", "Jenn", "Sarah"],
//                   lengthInMinutes: 5)
    ]
}
