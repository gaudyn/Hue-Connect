//
//  TileConnectView.swift
//  Hue Connect
//
//  Created by Administrator on 07/05/2020.
//  Copyright © 2020 Gniewomir Gaudyn. All rights reserved.
//

import SwiftUI

struct TileConnectView: View {
    
    var points: [CGPoint]
    let linewidth: CGFloat = 8.0
    
    var body: some View {
        GeometryReader{ geometry in
            Path{ path in
                let width = geometry.size.width/16
                let height = geometry.size.height/12
                
                let transform = CGAffineTransform(translationX: width/2, y: height/2).scaledBy(x: width, y: height)
                //let transform = CGAffineTransform(scaleX: width, y: height)//.translatedBy(x: width/2, y: height/2)
                //transform.translatedBy(x: width/2, y: height/2)
                print(transform)
                //print(transform.translatedBy(x: width/2, y: height/2))
                
                path.move(to: self.points.first!.applying(transform))
                self.points.forEach { (point) in
                    path.addLine(to: point.applying(transform))
                }
            }
            .stroke(style: StrokeStyle(lineWidth: self.linewidth, lineCap: .round, lineJoin: .round))
            .foregroundColor(Color.white)
        }
    }
    
    init(tileCoords: [CGPoint]) {
        self.points = tileCoords
    }
}

