import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { proxy in
            let ld = calculateLayout(
                w: proxy.size.width, 
                h: proxy.size.height,
                data: prefectureData.map({ (name: String, area: Double) in
                    area
                }),
                from: 0
            )
            
            TreeMapView(ld: ld)
        }
        .ignoresSafeArea()
    }
}

struct TreeMapView: View {
    
    let ld: LayoutData
    
    var body: some View {
        if ld.direction == .h {
            HStack(spacing: 0.0) {
                VStack(spacing: 0.0) {
                    ForEach(0..<ld.content.count, id: \.self) { i in
                        Rectangle()
                            .foregroundColor(randomColor())
                            .frame(width: ld.content[i].w, 
                                   height: ld.content[i].h)
                            .overlay { 
                                Text(prefectureData[ld.content[i].index].name)
                            }
                    }
                }
                if let child = ld.child {
                    TreeMapView(ld: child)
                }
            }
        } else {
            VStack(spacing: 0.0) {
                HStack(spacing: 0.0) {
                    ForEach(0..<ld.content.count, id: \.self) { i in
                        Rectangle()
                            .foregroundColor(randomColor())
                            .frame(width: ld.content[i].w, 
                                   height: ld.content[i].h)
                            .overlay { 
                                Text(prefectureData[ld.content[i].index].name)
                            }
                    }
                }
                if let child = ld.child {
                    TreeMapView(ld: child)
                }
            }
        }
    }
    
    func randomColor() -> Color {
        Color(hue: Double.random(in: 0.0...1.0), 
              saturation: Double.random(in: 0.08...0.18), 
              brightness: Double.random(in: 0.90...1.0))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

