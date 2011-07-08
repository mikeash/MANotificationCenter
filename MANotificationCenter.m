
#import "MANotificationCenter.h"


@interface _MANotificationCenterDictionaryKey : NSObject
{
    NSString *_name;
    id _object;
}

+ (_MANotificationCenterDictionaryKey *)keyForName: (NSString *)name object: (id)obj;

@end

@implementation _MANotificationCenterDictionaryKey

- (id)_initWithName: (NSString *)name object: (id)obj
{
    if((self = [self init]))
    {
        _name = [name copy];
        _object = obj;
    }
    return self;
}

- (void)dealloc
{
    [_name release];
    [super dealloc];
}

+ (_MANotificationCenterDictionaryKey *)keyForName: (NSString *)name object: (id)obj
{
    return [[[self alloc] _initWithName: name object: obj] autorelease];
}

static BOOL Equal(id a, id b)
{
    if(!a && !b)
        return YES;
    else if(!a || !b)
        return NO;
    else
        return [a isEqual: b];
}

- (BOOL)isEqual: (id)other
{
    if(![other isKindOfClass: [_MANotificationCenterDictionaryKey class]])
        return NO;
    
    _MANotificationCenterDictionaryKey *otherKey = other;
    return Equal(_name, otherKey->_name) && _object == otherKey->_object;
}

- (NSUInteger)hash
{
    return [_name hash] ^ (uintptr_t)_object;
}

- (id)copyWithZone: (NSZone *)zone
{
    return [self retain];
}

@end

@implementation MANotificationCenter

- (id)init
{
    if((self = [super init]))
    {
        _map = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_map release];
    [super dealloc];
}

- (id)addObserverForName: (NSString *)name object: (id)object block: (void (^)(NSNotification *note))block
{
    _MANotificationCenterDictionaryKey *key = [_MANotificationCenterDictionaryKey keyForName: name object: object];
    
    NSMutableSet *observerBlocks = [_map objectForKey: key];
    if(!observerBlocks)
    {
        observerBlocks = [NSMutableSet set];
        [_map setObject: observerBlocks forKey: key];
    }
    
    void (^copiedBlock)(NSNotification *note);
    copiedBlock = [block copy];
    
    [observerBlocks addObject: copiedBlock];
    
    [copiedBlock release];
    
    void (^removalBlock)(void) = ^{
        [observerBlocks removeObject: copiedBlock];
        if([observerBlocks count] == 0)
            [_map removeObjectForKey: key];
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
    _MANotificationCenterDictionaryKey *key = [_MANotificationCenterDictionaryKey keyForName: name object: object];
    NSSet *observerBlocks = [_map objectForKey: key];
    for(void (^block)(NSNotification *) in observerBlocks)
        block(note);
}

- (void)postNotification: (NSNotification *)note
{
    NSString *name = [note name];
    id object = [note object];
    
    [self _postNotification: note name: name object: object];
    [self _postNotification: note name: name object: nil];
    [self _postNotification: note name: nil object: object];
    [self _postNotification: note name: nil object: nil];
}

@end

