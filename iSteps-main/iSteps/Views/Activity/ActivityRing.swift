import SwiftUI

struct ActivityRing: View {
    var progress: CGFloat

    // Offset for closing circle
    private let fullCircleDotOffset: CGFloat = 300 * -0.82 / 2
    private let ringThickness: CGFloat = 60.0

    private var ringColor: [Color] {
        [Color.darkRed, Color.mainRed]
    }

    var body: some View {
        ZStack {
            if progress < 0.98 {
                // Background ring
                Circle()
                    .scale(0.82)
                    .stroke(ringColor[1], lineWidth: ringThickness)

                // Activity Ring
                Circle()
                    .scale(0.82)
                    .trim(from: 0, to: progress)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [ringColor[0], ringColor[1]]),
                            center: .center,
                            startAngle: .degrees(0.0),
                            endAngle: .init(degrees: 360.0)
                        ),
                        style: StrokeStyle(lineWidth: ringThickness, lineCap: .round))
                    .rotationEffect(.degrees(-90.0))

                // Fix overlapping gradient from full cycle
                Circle()
                    .frame(width: ringThickness, height: ringThickness)
                    .foregroundColor(ringColor[0])
                    .offset(y: fullCircleDotOffset)

            } else {
                // Activity Ring
                Circle()
                    .scale(0.82)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [ringColor[0], ringColor[1]]),
                            center: .center,
                            startAngle: .degrees(0.0),
                            endAngle: .init(degrees: 360.0)
                        ),
                        style: StrokeStyle(lineWidth: ringThickness, lineCap: .round))
                    .rotationEffect(.degrees((360 * Double(progress)) - 90))

                // Dot to fix overlapping
                Circle()
                    .frame(width: ringThickness, height: ringThickness)
                    .offset(y: fullCircleDotOffset)
                    .foregroundColor(ringColor[1])
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: ringThickness / 4, y: 0)
                    .rotationEffect(.degrees(360 * Double(progress)))
            }
        }
        .frame(width: 300, height: 300)
    }
}

struct ActivityRing_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRing(progress: 0.5)
    }
}
