import SwiftUI
import HealthKit

struct ContentView: View {
    
    private var healthStore: HealthStore?
    @State private var steps: [Step] = [Step]()
    
    init() {
        healthStore = HealthStore()
    }
    
    private func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection) {
        let today = Date()
        let calendar = Calendar.current
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start, let lastWeekDay = week?.end else { return }
        
        statisticsCollection.enumerateStatistics(from: firstWeekDay, to: lastWeekDay - 1) { (statistics, stop) in
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            steps.append(step)
        }
    }
    
    var body: some View {
        NavigationView {
            ActivityView(steps: steps)
                .navigationBarTitle("Activity")
                .onAppear {
                    if let healthStore = healthStore {
                        healthStore.requestAuthorization { success in
                            if success {
                                healthStore.calculateSteps { statisticsCollection in
                                    if let statisticsCollection = statisticsCollection {
                                        updateUIFromStatistics(statisticsCollection)
                                    }
                                }
                            }
                        }
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
