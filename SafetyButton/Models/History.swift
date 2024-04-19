//
//  History.swift
//  SafetyButton
//
//  Created by Anya Li on 4/16/24.
//

import Foundation

struct History: Identifiable, Codable {
    let id: UUID
    let date: Date
    var emergency: [DailyScrum.Emergency]
    var car: [DailyScrum.Car]
    var meeting: [DailyScrum.Meeting]
    var conversation: [DailyScrum.Conversation]
    var other: [DailyScrum.Other]
    var transcript: String?
    var event: String?
    
    init(id: UUID = UUID(), date: Date = Date(), emergency: [DailyScrum.Emergency], car: [DailyScrum.Car], meeting: [DailyScrum.Meeting], conversation: [DailyScrum.Conversation], other: [DailyScrum.Other], transcript: String? = nil, event: String? = nil) {
        self.id = id
        self.date = date
        self.emergency = emergency
        self.car = car
        self.meeting = meeting
        self.conversation = conversation
        self.other = other
        self.transcript = transcript
        self.event = event
    }
}
