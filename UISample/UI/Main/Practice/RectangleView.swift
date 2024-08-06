//
//  RectangleView.swift
//  UISample
//
//  Created by 정영민 on 2024/08/06.
//

import SwiftUI

enum EditMode {
    case addRemove
    case swapResize
}

struct Generator {
    
    struct Rectangles {
        static func random(editMode: EditMode) -> [RectangleModel] {
            Array(0..<60).map {
                let color = editMode == .swapResize ? disabledColor() : randomColor()
                return RectangleModel(index: $0, size: randomSize(), color: color)
            }
        }
        
        static func randomSize() -> CGFloat { CGFloat.random(in: 30...120) }

        static func fixedSize() -> CGFloat { 60 }
        
        static func randomColor() -> Color { [.red, .green, .blue, .orange, .yellow, .pink, .purple].randomElement()! }
        
        static func disabledColor() -> Color { .gray }
    }
    
    struct Images {
        static func random() -> [String] {
            Array(0..<22).map { "image\($0)" }.shuffled()
        }
    }
    
}

struct RectangleModel: Identifiable, Equatable {
    var id = UUID()
    var index: Int
    var size: CGFloat = Generator.Rectangles.randomSize()
    var color: Color = Generator.Rectangles.randomColor()
}

struct RectangleView: View {
    let rectangle: RectangleModel
    let scrollDirection: Axis.Set
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(rectangle.color)
                .frame(width: scrollDirection == .horizontal ? rectangle.size : nil, height: scrollDirection == .vertical ? rectangle.size : nil)
                .cornerRadius(8)
            Text("\(rectangle.index)")
                .foregroundColor(.white)
                .shadow(color: .gray, radius: 1, x: 1, y: 1)
        }
    }
}

struct RoundRectangle_Previews: PreviewProvider {
    static var previews: some View {
        RectangleView(rectangle: RectangleModel(index: 1, size: 100, color: .red), scrollDirection: .vertical)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
