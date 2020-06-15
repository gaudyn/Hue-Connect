//
//  HighscoresView.swift
//  Hue Connect
//
//  Created by Administrator on 15/06/2020.
//  Copyright © 2020 Gniewomir Gaudyn. All rights reserved.
//

import SwiftUI

struct HighscoresView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var scoresList: [Int]
    
    var body: some View {
        VStack(alignment: .leading){
            InfoView(info: "Highscores")
            ForEach((0..<scoresList.count), id: \.self){ index in
                Text("\(index+1). \(String(self.scoresList[index]))")
                    
            }
            if scoresList.count < 5{
                ForEach((scoresList.count+1...5), id: \.self){ index in
                    Text("\(index). - - -")
                }
            }
        }.preferredColorScheme(.dark)
        .font(.system(size: 35, weight: .regular, design: .rounded))
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack{
                    Image(systemName: "chevron.left")
                    Text("Go back")
                }
                .padding()
                .foregroundColor(Color.white)
                .background(Color.red)
                .cornerRadius(40)
                .fixedSize(horizontal: true, vertical: false)
            }))
    }
}

struct HighscoresView_Previews: PreviewProvider {
    static var previews: some View {
        HighscoresView(scoresList: [400, 300, 5000, 16000].sorted(by: >))
    }
}
