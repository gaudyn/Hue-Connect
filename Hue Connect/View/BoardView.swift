
import SwiftUI

/// Board view for the game
struct BoardView: View {
    @ObservedObject var board: Board
    
    var body: some View {
        ZStack{
            GridStack(rows:12, columns: 16){ row, col in
                if(row == 0 || row == 11 || col == 0 || col == 15){
                    TileView(color: .clear, isSelected: false)
                }else{
                    TileView(color: self.board.getTileAt(x: col, y: row).getColor(), isSelected: self.board.isSelectedAt(x: col, y: row) || self.board.isHintedAt(x: col, y: row))
                    .gesture(TapGesture()
                        .onEnded({_ in
                            self.board.selectTileAt(x: col, y: row)
                        }))
                }
            }
            .zIndex(1)
            
            TileConnectView(board: self.board)
            .zIndex(2)
        }

    }
}
