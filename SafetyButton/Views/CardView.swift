//
//  CardView.swift
//  SafetyButton
//
//  Created by Anya Li on 4/16/24.
//

import SwiftUI

struct CardView: View {
    let scrum: DailyScrum
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text(scrum.event)
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)
//                Text("Transcript"/*scrum.transcript*/)
//                    .font(.headline)
//                    .accessibilityAddTraits(.isHeader)
                Spacer()
            }
//            Spacer()
//            HStack {
//                Label("\(scrum.car.count)", systemImage: "person.3")
//                    .accessibilityLabel("\(scrum.car.count) attendees")
//                Spacer()
//                Label("\(scrum.lengthInMinutes)", systemImage: "clock")
//                    .accessibilityLabel("\(scrum.lengthInMinutes) minute meeting")
////                    .labelStyle(.trailingIcon)
//            }
//            .font(.caption)
        }
        .padding()
//        .foregroundColor(Color(hex: "FFEBEB"))
    }
}

struct CardView_Previews: PreviewProvider {
    static var scrum = DailyScrum.sampleData[0]
    static var previews: some View {
        CardView(scrum: scrum)
//            .background(scrum.theme.mainColor)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
