#include <Foundation/Foundation.h>
#include <CoreWLAN/CoreWLAN.h>

int main() {
    CWInterface *cwInterface = [[CWInterface alloc] interfaceWithName:@"en1"]; // specify here the WiFi interface
}
