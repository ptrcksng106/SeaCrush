//
//  CreditView.swift
//  CrushChallenge
//
//  Created by Patrick Samuel Owen Saritua Sinaga on 24/05/23.
//

import SwiftUI

struct CreditView: View {
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            Color(red: 0.235, green: 0.28, blue: 0.419, opacity: 0.5)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                
                VStack(alignment: .center) {
                    Spacer()
                    
                    Text("##Sounds\n1. Sound from [Freesound.org](https://pixabay.com/sound-effects/frying-steak-74556/)\n2.GameOverImage  from [Freepik.com](https://www.freepik.com/free-vector/game_3967994.htm#query=game%20over%20game&position=3&from_view=search&track=ais)\n3.All Asset  from [Freepik.com](https://www.freepik.com)")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding(.leading, 100)
                        .padding(.trailing, 100)
                        .accentColor(.black)
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Back")
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 300, height: 80, alignment: .center)
                            .background(Color(red: 0.99, green: 0.82, blue: 0.41))
                            .cornerRadius(15)
                            .padding(.top, 80)
                    }
                }
//                .offset(y: -50)
                
            }
            

        }
    }
}

struct CreditView_Previews: PreviewProvider {
    static var previews: some View {
        CreditView()
    }
}
