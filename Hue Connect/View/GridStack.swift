// Code from https://www.hackingwithswift.com/quick-start/swiftui/how-to-position-views-in-a-grid
import SwiftUI

/// Grid Stack View
struct GridStack<Content: View>: View{
    //MARK: Properties
    /// Number of rows of the grid.
    let rows: Int
    /// Number of columns of the grid.
    let columns: Int
    /// Function returning content for (x,y) cell in the grid.
    let content: (Int, Int) -> Content
    /// SwiftUI view
    var body: some View{
        VStack(alignment: .leading, spacing: 0){
            ForEach(0 ..< rows, id: \.self){ row in
                HStack(spacing: 0){
                    ForEach(0 ..< self.columns, id: \.self){ column in
                        self.content(row, column)
                    }
                }
            }
        }
    }
    //MARK: - Initializer
    /**
    Creates a grid view

     - parameters:
        - rows: Number of rows of grid.
        - columns: Number of columns of grid.
        - content: Function returning content for (x,y) cell in the grid.
    */
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content){
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}
