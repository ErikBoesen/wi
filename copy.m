/* The official example for CoreWLAN is now obsolete,
  so here's a small command-line example that works with Xcode 6 and Yosemite.
  It only demonstrates how to get basic wi-fi connection properties and scan.
  Enjoy!
  pavel_a@fastmail.fm  01-Mar-2015
  */

#import <Foundation/Foundation.h>
#import <CoreWLAN/CoreWLAN.h>
#include <stdio.h>

char const *phyModeName( enum CWPHYMode n )
{
    switch( (int)n ) {
        case kCWPHYModeNone: return "none";
        case kCWPHYMode11n: return "802.11n";
        case kCWPHYMode11a: return "802.11a";
        case kCWPHYMode11ac: return "802.11ac";
        case kCWPHYMode11g: return "802.11g";
        case kCWPHYMode11b: return "802.11b";
        default: return "other/unknown";

    }
}

char const *intfModeName( enum CWInterfaceMode m )
{
    switch( (int)m ) {
        case kCWInterfaceModeNone: return "none";
        case kCWInterfaceModeStation: return "STA";
        case kCWInterfaceModeIBSS: return "ADHOC";
        case kCWInterfaceModeHostAP: return "AP";
        default: return "unknown";
    }
}

// Enumerate available wi-fi interfaces and print:
void enumWifiInterfaces()
{
    NSArray *aif = CWWiFiClient.interfaceNames;
    for ( NSString *s in aif)  {
        NSLog(@"Ifname: %@\n", s);
    }
}

//  Convert NSstring to a "normal C" string, fast and dirty
char const * toCstr(NSString *ns ) {
    return [ns cStringUsingEncoding:[NSString defaultCStringEncoding]];
}

///////////
// - Register as CoreWLAN client
// - get some connection properties
// - Scan and display some neigbor info
//////////
int wlanTest()
{
    CWWiFiClient *wfc = CWWiFiClient.sharedWiFiClient;
    //NSLog(@"client: %@\n", wfc);
    if ( !wfc ) {
        return 1;
    }

    CWInterface *wif = wfc.interface; // get default interface
    if (!wif) {
        return 1;
    }

    printf("Default wifi interface name: %s\n", toCstr(wif.interfaceName));

    CWPHYMode phyMode = wif.activePHYMode;
    printf("Phy mode = %s\n", phyModeName((int)phyMode) );
    printf("Intf. mode: %s\n", intfModeName(wif.interfaceMode));

    if ( wif.interfaceMode == kCWInterfaceModeStation ) {
        printf("RSSI with assoc. AP (dBm)=%d ", (int)wif.rssiValue);  // returns 0 if not assoc. or error
        printf("Noise (dBm)=%d\n", (int)wif.noiseMeasurement);        // -"-"-
    }

    printf("Scanning...\n");
    NSError *err;
    // Nil for SSID does normal passive scan
    // Scan returns NSset of CWNetwork*
    NSSet *scanset = [wif scanForNetworksWithSSID:Nil error:&err];
    if (err) {
        printf("Scan failed, err=%ld\n", err.code);
        return 1;
    }

    printf("Scan found %d networks\n", (int)scanset.count);
    if ( scanset.count != 0 ) {
        int ix = 1;
        for (CWNetwork * nw in scanset)
        {
            printf(" %d. Bssid=%s rssi=%ld on channel %ld\n", ix++, toCstr([nw bssid] ), (long)[nw rssiValue], (long)[[nw wlanChannel] channelNumber]);
        }
    }

    return 0;
}


int main(int argc, const char * argv[])
{
    @autoreleasepool {
        printf("Wi-Fi scan test on the default adapter\n");
        wlanTest();
    }
    return 0;
}
