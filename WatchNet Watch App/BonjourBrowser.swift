import Foundation
import Network

class BonjourBrowser: ObservableObject {
    struct Service: Identifiable {
        let id = UUID()
        let name: String
        let endpoint: NWEndpoint
    }

    @Published var services: [Service] = []
    @Published var isBrowsing: Bool = false
    private var browser: NWBrowser?

    func startBrowsing() {
        let params = NWParameters()
        params.includePeerToPeer = true
        let browser = NWBrowser(for: .bonjour(type: "_mqtt._tcp", domain: nil), using: params)

        browser.stateUpdateHandler = { state in
            print("Browser state: \(state)")
        }
        browser.browseResultsChangedHandler = { results, _ in
            let newServices: [Service] = results.compactMap { result in
                if case let .service(name, _, _, _) = result.endpoint {
                    return Service(name: name, endpoint: result.endpoint)
                }
                return nil
            }
            DispatchQueue.main.async {
                self.services = newServices
                let names = newServices.map { $0.name }
                print("Found services: \(names)")
            }
        }
        self.browser = browser
        browser.start(queue: .main)
        isBrowsing = true
    }

    func stopBrowsing() {
        browser?.cancel()
        browser = nil
        isBrowsing = false
    }
}
