import Foundation

// MARK: - Quote
struct Quote: Codable, Identifiable {
    var id : UUID? = UUID()
    let quote: String
    let author: String
}

class GetQuotes: ObservableObject {
    @Published var quotes = [Quote]()

    init() {
        loadData()
    }

    func loadData() {
        guard let url = Bundle.main.url(forResource: "Quotes", withExtension: "json") else {
            print("Json file not found")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            var quotes = try decoder.decode([Quote].self, from: data)

            // Assign unique IDs to quotes
            for index in quotes.indices {
                quotes[index].id = UUID()
            }

            self.quotes = quotes
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
}
