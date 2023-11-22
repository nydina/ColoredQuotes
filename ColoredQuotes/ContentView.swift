import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = GetQuotes()

    var body: some View {
        NavigationView {
            List(viewModel.quotes) { quote in
                VStack(alignment: .leading) {
                    Text(quote.quote)
                        .font(.headline)
                    Text("- \(quote.author)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Quotes")
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: GetQuotes())
    }
}
