
#import <Foundation/Foundation.h>


@interface MANotificationCenter : NSObject
{
    CFMutableDictionaryRef _objectsDict;
}

- (id)addObserverForName: (NSString *)name object: (id)object block: (void (^)(NSNotification *note))block;
- (void)removeObserver: (id)observer;

- (void)postNotification: (NSNotification *)note;

@end
