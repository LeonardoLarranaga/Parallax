import SwiftUI

// connector shape.
struct MarkerConnector: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0.28571*width, y: height))
        path.addCurve(to: CGPoint(x: 0.56463*width, y: 0.73622*height), control1: CGPoint(x: 0.28571*width, y: height), control2: CGPoint(x: 0.43266*width, y: 0.80545*height))
        path.addCurve(to: CGPoint(x: width, y: 0.61417*height), control1: CGPoint(x: 0.6841*width, y: 0.67354*height), control2: CGPoint(x: width, y: 0.61417*height))
        path.addLine(to: CGPoint(x: width, y: 0.38583*height))
        path.addCurve(to: CGPoint(x: 0.54422*width, y: 0.29134*height), control1: CGPoint(x: width, y: 0.38583*height), control2: CGPoint(x: 0.66552*width, y: 0.35294*height))
        path.addCurve(to: CGPoint(x: 0.28571*width, y: 0), control1: CGPoint(x: 0.40243*width, y: 0.21934*height), control2: CGPoint(x: 0.28571*width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.closeSubpath()
        return path
    }
}

// marker tip.

struct MarkerTip: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addCurve(to: CGPoint(x: 0.77941*width, y: 0.5082*height), control1: CGPoint(x: width, y: 0), control2: CGPoint(x: 0.84215*width, y: 0.33323*height))
        path.addCurve(to: CGPoint(x: 0.63235*width, y: height), control1: CGPoint(x: 0.7194*width, y: 0.67557*height), control2: CGPoint(x: 0.63235*width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.closeSubpath()
        return path
    }
}

struct Marker: View {
    var color: Color
    var body: some View {
        HStack(spacing: 5) {
            Rectangle()
                .fill(color)
                .frame(width: 85)
            
            MarkerConnector()
                .frame(width: 55)
            
            MarkerTip()
                .fill(color)
                .frame(width: 35, height: 25)
        }
        .frame(height: 120)
    }
}

struct Marker_Previews: PreviewProvider {
    static var previews: some View {
        Marker(color: .blue)
    }
}
