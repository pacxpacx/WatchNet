import SwiftUI

struct ContentView: View {
    @StateObject var browser = BonjourBrowser()
    @StateObject var connector = MQTTConnector()

    var body: some View {
        VStack {
            Text("Bonjour MQTT Discovery")
                .font(.headline)
            Button(browser.isBrowsing ? "Stop Browsing" : "Start Browsing") {
                if browser.isBrowsing {
                    browser.stopBrowsing()
                } else {
                    browser.startBrowsing()
                }
            }
            List(browser.services) { service in
                Button(service.name) {
                    connector.connect(to: service.endpoint)
                }
            }
            Text("MQTT state: \(String(describing: connector.state))")
        }
        .padding()
    }
}
