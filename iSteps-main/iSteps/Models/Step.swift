
import Foundation

struct Step: Identifiable {
    let id = UUID().uuidString
    let count: Int
    let date: Date
}
