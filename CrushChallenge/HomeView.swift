//
//  HomeView.swift
//  CrushChallenge
//
//  Created by Patrick Samuel Owen Saritua Sinaga on 23/05/23.
//

import SwiftUI
import AVFAudio

struct HomeView: View {
    
    @State var audio: AVAudioPlayer!
    @State var isActive: Bool = true
    @State private var showingSheet = false
    
    var body: some View {
        GeometryReader { geo in
            
            NavigationView {
                
                ZStack {
                    
                    Image("27375")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                        .opacity(1.0)
                    
                        
                    VStack {
                        
                        
                        HStack(alignment: .firstTextBaseline) {
                            
                            if isActive {
                                Image("soundSymbol")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .padding(.leading, 20)
                                    .onTapGesture(perform: {
                                        stopAudio(key: "suara")
                                        isActive = false
                                    })
                                
                            } else {
                                Image("iconMute")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .padding(.leading, 20)
                                    .onTapGesture(perform: {
                                        playAudio(key: "suara")
                                        isActive = true
                                    })
                                
                            }
                            
                            
                            
                            
                            
                           
                            
                            Spacer()
                            
                            
                            Image("infoSymbol")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding(.trailing, 20)
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                            
                            Image("cobaDua")
                                .resizable()
                                .frame(width: 120, height: 80)
                        }
                        
                        
                        
                        Image("creditSymbol")
                            .resizable()
                            .frame(width: 120, height: 80)
                            .onTapGesture {
                                showingSheet.toggle()
                            }.sheet(isPresented: $showingSheet) {
                                
                                CreditView()
                                    .presentationDetents([.large])
                            }
                        
                        Spacer()
                    }
                }
            }
        }
        .onAppear(perform: {
            playAudio(key: "suara")
        })
    }
    
    func playAudio(key: String) {
        let url = Bundle.main.url(forResource: key, withExtension: "mp3")
                
                guard url != nil else {
                    return
                }
                
                do {
                    audio = try AVAudioPlayer(contentsOf: url!)
                    audio?.play()
                } catch {
                    print("Error")
                }
    }
    
    func stopAudio(key: String) {
        let url = Bundle.main.url(forResource: key, withExtension: "mp3")
                
                guard url != nil else {
                    return
                }
                
                do {
                    audio = try AVAudioPlayer(contentsOf: url!)
                    audio?.stop()
                } catch {
                    print("Error")
                }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
