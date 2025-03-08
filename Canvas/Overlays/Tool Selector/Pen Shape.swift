import SwiftUI

// pen base shape.

struct PenBase: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: width, y: 0.21569*height))
        path.addLine(to: CGPoint(x: width, y: 0.78431*height))
        path.addCurve(to: CGPoint(x: 0.61584*width, y: 0.94118*height), control1: CGPoint(x: width, y: 0.78431*height), control2: CGPoint(x: 0.74424*width, y: 0.91275*height))
        path.addCurve(to: CGPoint(x: 0, y: 0.98039*height), control1: CGPoint(x: 0.41089*width, y: 0.98654*height), control2: CGPoint(x: 0, y: 0.98039*height))
        path.addLine(to: CGPoint(x: 0, y: 0.01961*height))
        path.addCurve(to: CGPoint(x: 0.6129*width, y: 0.06863*height), control1: CGPoint(x: 0, y: 0.01961*height), control2: CGPoint(x: 0.4099*width, y: 0.02409*height))
        path.addCurve(to: CGPoint(x: width, y: 0.21569*height), control1: CGPoint(x: 0.74325*width, y: 0.09723*height), control2: CGPoint(x: width, y: 0.21569*height))
        path.closeSubpath()
        return path
    }
}

// pen middle shape.

struct PenMiddle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: width, y: 0.76364*height))
        path.addLine(to: CGPoint(x: width, y: 0.25455*height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.closeSubpath()
        return path
    }
}

// pen tip shape.

struct PenTip: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.95122*width, y: 0.53571*height))
        path.addCurve(to: CGPoint(x: 0.00762*width, y: 0.07143*height), control1: CGPoint(x: 0.95295*width, y: 0.32219*height), control2: CGPoint(x: 0.00762*width, y: 0.07143*height))
        path.addLine(to: CGPoint(x: 0.00762*width, y: height))
        path.addCurve(to: CGPoint(x: 0.95122*width, y: 0.53571*height), control1: CGPoint(x: 0.00762*width, y: height), control2: CGPoint(x: 0.94922*width, y: 0.78212*height))
        path.closeSubpath()
        return path
    }
}

struct Pen: View {
    var color: Color
    var body: some View {
        HStack {
            PenBase()
                .frame(width: 225, height: 100)
            PenMiddle()
                .frame(width: 65, height: 55)
            PenTip()
                .fill(color)
                .frame(width: 55, height: 28)
        }
        .frame(height: 120)
    }
}

struct Pen_Previews: PreviewProvider {
    static var previews: some View {
        Pen(color: .blue)
    }
}
