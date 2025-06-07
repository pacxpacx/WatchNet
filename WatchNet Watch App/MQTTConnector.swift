import Foundation
import Network

class MQTTConnector: ObservableObject {
    @Published var state: NWConnection.State = .setup
    private var connection: NWConnection?

    func connect(to endpoint: NWEndpoint) {
        let params = NWParameters.tcp
        let connection = NWConnection(to: endpoint, using: params)
        connection.stateUpdateHandler = { [weak self] newState in
            DispatchQueue.main.async {
                self?.state = newState
                print("Connection state: \(newState)")
            }
        }
        self.connection = connection
        connection.start(queue: .main)
    }

    func disconnect() {
        connection?.cancel()
        connection = nil
    }
}
