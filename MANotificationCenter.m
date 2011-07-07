
#import "MANotificationCenter.h"


@implementation MANotificationCenter

- (id)init
{
    if((self = [super init]))
    {
        _objectsDict = CFDictionaryCreateMutable(NULL, 0, NULL, &kCFTypeDictionaryValueCallBacks);
    }
    return self;
}

- (void)dealloc
{
    CFRelease(_objectsDict);
    [super dealloc];
}

- (id)addObserverForName: (NSString *)name object: (id)object block: (void (^)(NSNotification *note))block
{
    if(!name)
        name = (id)[NSNull null];
    if(!object)
        object = [NSNull null];
    
    NSMutableDictionary *innerDict = (id)CFDictionaryGetValue(_objectsDict, object);
    if(!innerDict)
    {
        innerDict = [NSMutableDictionary dictionary];
        CFDictionarySetValue(_objectsDict, object, innerDict);
    }
    
    NSMutableSet *observerBlocks = [innerDict objectForKey: name];
    if(!observerBlocks)
    {
        observerBlocks = [NSMutableSet set];
        [innerDict setObject: observerBlocks forKey: name];
    }
    
    void (^copiedBlock)(NSNotification *note);
    copiedBlock = [block copy];
    
    [observerBlocks addObject: copiedBlock];
    
    [copiedBlock release];
    
    __block id weakObject = object;
    void (^removalBlock)(void) = ^{
        NSMutableDictionary *innerDict = (id)CFDictionaryGetValue(_objectsDict, weakObject);
        NSMutableSet *observerBlocks = [innerDict objectForKey: name];
        [observerBlocks removeObject: copiedBlock];
        if([observerBlocks count] == 0)
            [innerDict removeObjectForKey: name];
        if([innerDict count] == 0)
            CFDictionaryRemoveValue(_objectsDict, weakObject);
    };
    
    return [[removalBlock copy] autorelease];
}

- (void)removeObserver: (id)observer
{
    void (^removalBlock)(void) = observer;
    removalBlock();
}

- (void)_postNotification: (NSNotification *)note name: (NSString *)name object: (id)object
{
    NSDictionary *innerDict = (id)CFDictionaryGetValue(_objectsDict, object);
    NSSet *observerBlocks = [innerDict objectForKey: name];
    for(void (^block)(NSNotification *) in observerBlocks)
        block(note);
}

- (void)postNotification: (NSNotification *)note
{
    NSString *name = [note name];
    id object = [note object];
    id null = [NSNull null];
    
    [self _postNotification: note name: name object: object];
    [self _postNotification: note name: name object: null];
    [self _postNotification: note name: null object: object];
    [self _postNotification: note name: null object: null];
}

@end

