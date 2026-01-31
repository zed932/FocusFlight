// MainView.swift
import SwiftUI
import Combine

enum Screen: Hashable {
    case BookFlightView
    case FlightView(Flight)
    case LandedView(Flight)
    case FlightsHistoryView
    case CheckInView(Flight)
}

struct MainView: View {

    @EnvironmentObject var flightHistory: FlightHistoryService
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var greeting: String = ""
    @State private var path: [Screen] = []

    /// Крупнее на iPad и Mac.
    private var isWideLayout: Bool { horizontalSizeClass == .regular }

    private var mainTitleFont: Font {
        isWideLayout ? .system(size: 44, weight: .bold) : .largeTitle
    }

    private var mainSubtitleFont: Font {
        isWideLayout ? .system(size: 26, weight: .regular) : .title2
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            HStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(greeting)
                            .font(mainTitleFont)
                            .bold()
                            .foregroundStyle(.white)
                            .onAppear {
                                greeting = getGreeting()
                            }
                        
                        if let city = flightHistory.originForNextFlight?.municipality {
                            Text(city)
                                .font(mainSubtitleFont)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white.opacity(0.85))
                        }
                        
                        Text("What's our next destination?")
                            .font(mainSubtitleFont)
                            .foregroundStyle(.white.opacity(0.75))
                    }
                    .fixedSize(horizontal: true, vertical: false)
                    
                    Spacer()
                    
                    MainButtonsView(path: $path)
                        .frame(minWidth: 250)
                        .frame(maxWidth: 350)
                }
                .padding(35)
                
                Spacer() 
            }
            .background {
                GlobeBackgroundView(
                    center: flightHistory.originForNextFlight?.coordinate,
                    blurred: false
                )
            }
            .navigationDestination(for: Screen.self) { screen in
                switch screen {
                case .BookFlightView:
                    BookFlightView(path: $path)
                case .FlightView(let flight):
                    FlightView(flight: flight, path: $path)
                case .LandedView(let flight):
                    LandedView(flight: flight, path: $path)
                case .FlightsHistoryView:
                    FlightsHistoryView()
                case .CheckInView(let flight):
                    CheckInView(path: $path, flight: flight)
                }
            }
        }
        .environmentObject(flightHistory)
    }
    
    private func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 0..<5:
            return "Good Night!"
        case 5..<12:
            return "Good Morning!"
        case 12..<17:
            return "Good Afternoon!"
        case 17..<22:
            return "Good Evening!"
        default:
            return "Good Night!"
        }
    }
}

#Preview {
    MainView()
        .environmentObject(FlightHistoryService())
}
