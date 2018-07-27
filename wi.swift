import Foundation
import CoreWLAN

func main() throws {
    let client = CWWiFiClient.shared()
    let iface  = client.interface()

    let networks = try iface!.scanForNetworks(withSSID: nil)

    print(networks.first().ssid)
}
