//
//  InfoView.swift
//  SafetyButton
//
//  Created by Anya Li on 4/20/24.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        ZStack{
            Color(hex: "FFEBEB")
                .ignoresSafeArea()
            ScrollView{
                VStack{
                    Text("Resources Page")
                        .font(.system(size: 35, weight: .bold))
                    Text("These links will help you in dangerous situations")
                        .font(.system(size: 14, weight: .medium))
                        .padding(.bottom)
                    //                Link("Personal Safety Tips & Advice", destination: URL(string: "https://peoplesafe.co.uk/blogs/personal-safety-tips-advice/")!)
                    //                NavigationLink(destination: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Destination@*/Text("Destination")/*@END_MENU_TOKEN@*/) {
                    HStack{
                        VStack(alignment: .leading){
                            Link("Personal Safety Tips & Advice", destination: URL(string: "https://peoplesafe.co.uk/blogs/personal-safety-tips-advice/")!)
                                .font(.system(size: 23))
                                .foregroundColor(Color(hex: "000"))
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        //                              Image(systemName: "chevron.right")
                        //                                .foregroundColor(Color.black)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 30)
                    .background(Color.white)
                    .border(.black, width: 7)
                    .mask(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius:5)
                    
                    //                }
                    .padding([.top, .leading, .trailing])
                    //                NavigationLink(destination: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Destination@*/Text("Destination")/*@END_MENU_TOKEN@*/) {
                    HStack{
                        VStack(alignment: .leading){
                            Link("When Calling 911 is Dangerous", destination: URL(string: "https://www.rescusaveslives.com/blog/5-emergency-situations-where-calling-911-is-dangerous/#:~:text=In%20many%20emergencies%2C%20it's%20perfectly,these%20are%20all%20prime%20examples.")!)
                                .font(.system(size: 22))
                                .foregroundColor(Color(hex: "000"))
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        //                              Image(systemName: "chevron.right")
                        //                                .foregroundColor(Color.black)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 30)
                    .background(Color.white)
                    .border(.black, width: 7)
                    .mask(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius:5)
                    
                    //                }
                    .padding([.top, .leading, .trailing])
                    
                    //                NavigationLink(destination: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Destination@*/Text("Destination")/*@END_MENU_TOKEN@*/) {
                    HStack{
                        VStack(alignment: .leading){
                            Link("Internet Crime Complaint Center", destination: URL(string: "https://www.ic3.gov/Home/ComplaintChoice")!)
                                .font(.system(size: 21))
                                .foregroundColor(Color(hex: "000"))
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        //                              Image(systemName: "chevron.right")
                        //                                .foregroundColor(Color.black)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 30)
                    .background(Color.white)
                    .border(.black, width: 7)
                    .mask(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius:5)
                    
                    //                }
                    .padding([.top, .leading, .trailing])
                    
                    //                NavigationLink(destination: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Destination@*/Text("Destination")/*@END_MENU_TOKEN@*/) {
                    HStack{
                        VStack(alignment: .leading){
                            Text("Numbers to Reach Out To:")
                                .font(.system(size: 23))
                            Link("\t408-642-9824", destination: URL(string: "tel:4086429824")!)
                                .foregroundColor(.blue)
                            
                            Text("\n\t911: Emergencies\n\n\t988: Suicide Prevention + Crises\n\n\t1-800-656-4673: National Sexual \n\tAssault Hotline\n\n\t1-877-446-2632: Missing and \n\tExploited Children\n\n\t1-800-225-5324: Hate Crime FBI\n\n\t1-800-799-SAFE: National \n\tDomestic Violence Hotline\n\n\t1-800-395-5755: Greif couceling\n\n\t1-800-252-8966: Elder \n\tAbuse Hotline\n\n\t1-800-313-1310: Family Violence \n\tPrevention Center")
                                .multilineTextAlignment(.leading)
                            //                                .font(.system(size: 20))
                                .foregroundColor(Color(hex: "000"))
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        //                              Image(systemName: "chevron.right")
                        //                                .foregroundColor(Color.black)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 30)
                    .background(Color.white)
                    .border(.black, width: 7)
                    .mask(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius:5)
                    .padding([.top, .leading, .trailing])
                    
                    
                    
                }
                
                //            }
            }
        }
    }
}

#Preview {
    InfoView()
}
