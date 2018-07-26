#import <CoreWLAN/CoreWLAN.h>

int main() {
    CWInterface *cwInterface = [[CWInterface alloc] interfaceWithName:@"en1"]; // specify here the WiFi interface
    NSError *err = nil;

    // get all networks
    NSSet *networksSet = [cwInterface scanForNetworksWithName:nil error:&err];
    NSArray *allNetworks = [networksSet allObjects];

    CWNetwork *selectedNetwork;

    // check if one of the scanned networks SSIDs matches network with SSID "network_name"
    for (CWNetwork *network in allNetworks) {

        // perhaps you will have another for here, looping over NSDictionary with network name as key and password as value
        if ([network.ssid isEqualToString:@"network_name"]) {
            selectedNetwork = network;
        }
    }

    // finally connect to the selected network
    [cwInterface associateToNetwork:selectedNetwork password:@"network_password" error:&err];

    // you can also disconnect as well
    [cwInterface disassociate];
}
