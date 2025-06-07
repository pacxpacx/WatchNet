import Foundation
import Network

class BonjourBrowser: ObservableObject {
    @Published var foundServices: [String] = []
    private var browser: NWBrowser?

    func startBrowsing() {
        let params = NWParameters()
        params.includePeerToPeer = true
        let browser = NWBrowser(for: .bonjour(type: "_mqtt._tcp", domain: nil), using: params)

        browser.stateUpdateHandler = { state in
            print("Browser state: \(state)")
        }
        browser.browseResultsChangedHandler = { results, _ in
            let serviceNames = results.compactMap { result -> String? in
                switch result.endpoint {
                case .service(let name, _, _, _): return name
                default: return nil
                }
            }
            DispatchQueue.main.async {
                self.foundServices = serviceNames
                print("Found services: \(serviceNames)")
            }
        }
        self.browser = browser
        browser.start(queue: .main)
    }

    func stopBrowsing() {
        browser?.cancel()
        browser = nil
    }
}
