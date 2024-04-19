//
//  Test.swift
//  SafetyButton
//
//  Created by Anya Li on 4/15/24.
//

import SwiftUI
import AVFoundation

struct Transcribe: View {
    @Binding var scrums: [DailyScrum]
    @Binding var scrum: DailyScrum
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    var body: some View {
        ZStack{
            Color(hex: "FFEBEB")
                .ignoresSafeArea()
            VStack {
                Text("The Button")
                    .font(.system(size: 40, weight: .bold))
                    .padding(.top, 75.0)
                Text("Start all processes.")
                    .font(.system(size: 20, weight: .medium))
                    .padding(.bottom)
                let transcript = speechRecognizer.transcript
                Text("Transcript: \(transcript)")
                    .font(.system(size: 20, weight: .medium))
                    .lineLimit(10)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button(action: {
                    if !isRecording {
                        speechRecognizer.transcribe()
                    } else {
                        speechRecognizer.stopTranscribing()
                        print(transcript)
                        let newHistory = History(emergency: scrum.emergency, car: scrum.car, meeting: scrum.meeting, conversation: scrum.conversation, other: scrum.other, transcript: speechRecognizer.transcript, event: scrum.event)
                        scrum.history.insert(newHistory, at: 0)
                    }
                    
                    isRecording.toggle()
                }) {
                    if !isRecording {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 200, weight: .bold))
                            .foregroundColor(Color(.red))
                    }
                    else {
                        Image(systemName: "pause.circle.fill")
                            .font(.system(size: 200, weight: .bold))
                            .foregroundColor(Color(.blue))
                    }
//                    Text(isRecording ? "Stop" : "Record")
//                        .font(.title)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(isRecording ? Color.red : Color.blue)
//                        .cornerRadius(10)
                }
                Text("Press Here")
                    .font(.system(size: 20, weight: .medium))
                    .padding(.bottom, 150.0)
                ZStack{
                    Color(hex: "fff")
                        .ignoresSafeArea()
                    VStack{
                        HStack{
                            NavigationLink(destination: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Destination@*/Text("Destination")/*@END_MENU_TOKEN@*/) {
                                
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 60, weight: .bold))
                                    .foregroundColor(Color(.label))
                                
                            }
                            .padding(.trailing)
                            NavigationLink(destination: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Destination@*/Text("Destination")/*@END_MENU_TOKEN@*/) {
                                Image(systemName: "gearshape.circle.fill")
                                    .font(.system(size: 60, weight: .bold))
                                    .foregroundColor(Color(.label))
                                
                                
                            }
                            .padding(.trailing)
                            NavigationLink(destination: Messages(scrums: $scrums)) {
                                Image(systemName: "message.circle.fill")
                                    .font(.system(size: 60, weight: .bold))
                                    .foregroundColor(Color(.label))
                            }
                        }
                        .padding(.top)
                    }
                }
            }
        }
    }
}
#Preview {
    Transcribe(scrums: .constant(DailyScrum.sampleData), scrum: .constant(DailyScrum.sampleData[0]))
}
