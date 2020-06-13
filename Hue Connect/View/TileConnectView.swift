//
//  TileConnectView.swift
//  Hue Connect
//
//  Created by Administrator on 07/05/2020.
//  Copyright © 2020 Gniewomir Gaudyn. All rights reserved.
//

import SwiftUI

struct TileConnectView: View {
    
    let linewidth: CGFloat = 8.0
    @EnvironmentObject var game: Game
    
    var body: some View {
        
        GeometryReader{ geometry in
            if(!self.game.board.connectionPoints.isEmpty){
            Path{ path in
                let width = geometry.size.width/16
                let height = geometry.size.height/12
                
                let transform = CGAffineTransform(translationX: width/2, y: height/2).scaledBy(x: width, y: height)
                
                path.move(to: self.game.board.connectionPoints.first!.applying(transform))
                self.game.board.connectionPoints.forEach { (point) in
                    path.addLine(to: point.applying(transform))
                }
            }
            .stroke(style: StrokeStyle(lineWidth: self.linewidth, lineCap: .round, lineJoin: .round))
            .foregroundColor(Color.gray)
            }
        }
        .opacity(self.game.board.isConnectionShown ? 1 : 0)
        .onReceive(self.game.board.$isConnectionShown) { _ in
            if(self.game.board.isConnectionShown) {
                withAnimation(.easeIn(duration: 0.3)) {
                    self.game.board.isConnectionShown = false
                }
                
            }
        }
    }
}


