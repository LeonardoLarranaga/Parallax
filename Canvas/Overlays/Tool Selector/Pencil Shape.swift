import SwiftUI

// pencil body shape.

struct PencilBody: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0, y: 0.50629*height))
        path.addCurve(to: CGPoint(x: 0.0872*width, y: 0.75472*height), control1: CGPoint(x: 0, y: 0.64349*height), control2: CGPoint(x: 0.03904*width, y: 0.75472*height))
        path.addLine(to: CGPoint(x: 0.9128*width, y: 0.75472*height))
        path.addCurve(to: CGPoint(x: width, y: 0.50629*height), control1: CGPoint(x: 0.96096*width, y: 0.75472*height), control2: CGPoint(x: width, y: 0.64349*height))
        path.addCurve(to: CGPoint(x: 0.9128*width, y: 0.25786*height), control1: CGPoint(x: width, y: 0.36909*height), control2: CGPoint(x: 0.96096*width, y: 0.25786*height))
        path.addLine(to: CGPoint(x: 0.0872*width, y: 0.25786*height))
        path.addCurve(to: CGPoint(x: 0, y: 0.50629*height), control1: CGPoint(x: 0.03904*width, y: 0.25786*height), control2: CGPoint(x: 0, y: 0.36909*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0, y: 0.10692*height))
        path.addLine(to: CGPoint(x: width, y: 0.10692*height))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: width, y: 0.89308*height))
        path.addLine(to: CGPoint(x: 0, y: 0.89308*height))
        path.closeSubpath()
        return path
    }
}

// pencil pre-tip shape.
struct PencilPreTip: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0.15909*width, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0.33333*height))
        path.addLine(to: CGPoint(x: width, y: 0.67925*height))
        path.addLine(to: CGPoint(x: 0.1875*width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.closeSubpath()
        return path
    }
}

// pencil tip shape.

struct PencilTip: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.97222*width, y: 0.51695*height))
        path.addCurve(to: CGPoint(x: 0.02735*width, y: 0.05085*height), control1: CGPoint(x: 0.97238*width, y: 0.40838*height), control2: CGPoint(x: 0.02735*width, y: 0.05085*height))
        path.addLine(to: CGPoint(x: 0.02735*width, y: 0.98305*height))
        path.addCurve(to: CGPoint(x: 0.97222*width, y: 0.51695*height), control1: CGPoint(x: 0.02735*width, y: 0.98305*height), control2: CGPoint(x: 0.97208*width, y: 0.6096*height))
        path.closeSubpath()
        return path
    }
}

struct Pencil: View {
    var color: Color
    var body: some View {
        HStack {
            PencilBody()
                .frame(width: 120)
            
            PencilPreTip()
                .frame(width: 65)            
            
            PencilTip()
                .fill(color)
                .frame(width: 35, height: 25)
        }
        .frame(height: 80)
    }
}

struct Pencil_Previews: PreviewProvider {
    static var previews: some View {
        Pencil(color: .blue)
    }
}
