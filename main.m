// gcc -framework Foundation main.m MANotificationCenter.m

#import "MANotificationCenter.h"


int main(int argc, char **argv)
{
    [NSAutoreleasePool new];
    
    MANotificationCenter *center = [[MANotificationCenter alloc] init];
    
    id obj = [[NSObject alloc] init];
    id otherObj = [[NSObject alloc] init];
    
    NSMutableArray *removalObjs = [NSMutableArray array];
    id removalObj;
    
    removalObj = [center addObserverForName: @"name" object: obj block: ^(NSNotification *note) {
        NSLog(@"First block got notification %@", note);
    }];
    [removalObjs addObject: removalObj];
    
    removalObj = [center addObserverForName: @"name" object: obj block: ^(NSNotification *note) {
        NSLog(@"Second block got notification %@", note);
    }];
    [removalObjs addObject: removalObj];
    
    removalObj = [center addObserverForName: @"othername" object: obj block: ^(NSNotification *note) {
        NSLog(@"Third block got notification %@", note);
    }];
    [removalObjs addObject: removalObj];
    
    removalObj = [center addObserverForName: @"name" object: otherObj block: ^(NSNotification *note) {
        NSLog(@"Fourth block got notification %@", note);
    }];
    [removalObjs addObject: removalObj];
    
    removalObj = [center addObserverForName: nil object: obj block: ^(NSNotification *note) {
        NSLog(@"Nil name block got notification %@", note);
    }];
    [removalObjs addObject: removalObj];
    
    removalObj = [center addObserverForName: nil object: otherObj block: ^(NSNotification *note) {
        NSLog(@"Second nil name block got notification %@", note);
    }];
    [removalObjs addObject: removalObj];
    
    removalObj = [center addObserverForName: @"name" object: nil block: ^(NSNotification *note) {
        NSLog(@"Nil object block got notification %@", note);
    }];
    [removalObjs addObject: removalObj];
    
    removalObj = [center addObserverForName: @"othername" object: nil block: ^(NSNotification *note) {
        NSLog(@"Second nil object block got notification %@", note);
    }];
    [removalObjs addObject: removalObj];
    
    removalObj = [center addObserverForName: nil object: nil block: ^(NSNotification *note) {
        NSLog(@"Nil-nil catchall block got notification %@", note);
    }];
    [removalObjs addObject: removalObj];
    
    [center postNotification: [NSNotification notificationWithName: @"name" object: obj]];
    for(id obj in removalObjs)
        [center removeObserver: obj];
    [center postNotification: [NSNotification notificationWithName: @"name" object: obj]];
}

