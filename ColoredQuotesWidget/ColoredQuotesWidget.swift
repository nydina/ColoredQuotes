import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct ColoredQuotesWidgetEntryView: View {
    var entry: Provider.Entry
    @ObservedObject var quotesViewModel = GetQuotes()
    
    var body: some View {
        let color = determineColor(for: entry.date)
        let quote = determineQuote()
        
        ZStack {
            Rectangle()
                .fill(color)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Text(quote.quote)
                .foregroundColor(.white)
        }
    }
     private func determineQuote() -> Quote {
        let currentDate = Date()
        let dayOfWeek = Calendar.current.component(.weekday, from: currentDate)
        
        // Subtract 1 from dayOfWeek since indixes start from 0
        let index = dayOfWeek - 1
        
        // Use the index to get the corresponding quote, or use the first quote as a default
        let selectedQuote = quotesViewModel.quotes.indices.contains(index) ? quotesViewModel.quotes[index] : Quote(quote: "Default quote", author: "Default author")
        
        return selectedQuote
    }

    private func determineColor(for date: Date) -> Color {
        let dayOfWeek = Calendar.current.component(.weekday, from: date)
        
        switch dayOfWeek {
        case 1: return .cyan      // Sunday
        case 2: return .orange   // Monday
        case 3: return .yellow   // Tuesday
        case 4: return .green    // Wednesday
        case 5: return .mint     // Thursday
        case 6: return .purple   // Friday
        case 7: return .pink     // Saturday
        default: return .black
        }
    }
}


struct ColoredQuotesWidget: Widget {
    let kind: String = "ColoredQuotesWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ColoredQuotesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("Display a different color and a different quote depending on the day of the week")
    }
}

struct ColoredQuotesWidget_Previews: PreviewProvider {
    static var previews: some View {
        ColoredQuotesWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
