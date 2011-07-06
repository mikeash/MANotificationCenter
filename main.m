// gcc -framework Foundation main.m MANotificationCenter.m

#import "MANotificationCenter.h"


int main(int argc, char **argv)
{
    [NSAutoreleasePool new];
    
    MANotificationCenter *center = [[MANotificationCenter alloc] init];
    
    id obj = [[NSObject alloc] init];
    id otherObj = [[NSObject alloc] init];
    [center addObserverForName: @"name" object: obj block: ^(NSNotification *note) {
        NSLog(@"First block got notification %@", note);
    }];
    [center addObserverForName: @"name" object: obj block: ^(NSNotification *note) {
        NSLog(@"Second block got notification %@", note);
    }];
    [center addObserverForName: @"othername" object: obj block: ^(NSNotification *note) {
        NSLog(@"Third block got notification %@", note);
    }];
    [center addObserverForName: @"name" object: otherObj block: ^(NSNotification *note) {
        NSLog(@"Fourth block got notification %@", note);
    }];
    
    [center postNotification: [NSNotification notificationWithName: @"name" object: obj]];
}

