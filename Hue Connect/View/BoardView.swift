//
//  BoardView.swift
//  Hue Connect
//
//  Created by Administrator on 13/06/2020.
//  Copyright © 2020 Gniewomir Gaudyn. All rights reserved.
//

import SwiftUI

struct BoardView: View {
    
    @EnvironmentObject var board: Board
    
    var body: some View {
        ZStack{
            GridStack(rows:12, columns: 16){ row, col in
                if(row == 0 || row == 11 || col == 0 || col == 15){
                    TileView(x: -1, y: -1)
                }else{
                    TileView(x: col, y: row)
                    .gesture(TapGesture()
                        .onEnded({_ in
                            self.board.selectTileAt(x: col, y: row)
                        }))
                }
            }.zIndex(1)
            
            TileConnectView()
            .opacity(self.board.isConnectionShown ? 1 : 0)
            .zIndex(2)
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
