import SwiftUI

struct ContentView: View {
    @StateObject var browser = BonjourBrowser()

    var body: some View {
        VStack {
            Text("Bonjour MQTT Discovery")
                .font(.headline)
            Button("Start Browsing") {
                browser.startBrowsing()
            }
            List(browser.foundServices, id: \.self) { service in
                Text(service)
            }
        }
        .padding()
    }
}
