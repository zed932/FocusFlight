// MainView.swift
import SwiftUI
import Combine

enum Screen: Hashable {
    case AirportSelectionView
    case FlightView(Flight)
    case LandedView(Flight)
    case FlightsHistoryView
    case CheckInView(Flight)
}

struct MainView: View {
    
    @State private var greeting: String = ""
    @State private var path: [Screen] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            HStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(greeting)
                            .font(.largeTitle)
                            .bold()
                            .onAppear {
                                greeting = getGreeting()
                            }
                        
                        Text("What's our next destination?")
                            .font(.title2)
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
            .background(Color(red: 0.15, green: 0.15, blue: 0.15))
            .navigationDestination(for: Screen.self) { screen in
                switch screen {
                case .AirportSelectionView:
                    AirportSelectionView(path: $path)
                case .FlightView(let flight):
                    FlightView(flight: flight, path: $path)
                case .LandedView(let flight):
                    LandedView(flight: flight)
                case .FlightsHistoryView:
                    FlightsHistoryView()
                case .CheckInView(let flight):
                    CheckInView(path: $path, flight: flight)
                }
            }
        }
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
}
