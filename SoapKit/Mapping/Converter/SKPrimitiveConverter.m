//
//  SKPrimitiveConverter.m
//  Pods
//
//  Created by Gleb Tarasov on 12.08.16.
//
//

#import "SKPrimitiveConverter.h"
#import "SKDynamicAttribute.h"

@implementation SKPrimitiveConverter

+ (instancetype)primitiveConverter {
    return [[self alloc] init];
}

- (NSNumber *)charForValue:(id)value {
    if ([value isKindOfClass:NSNumber.class]) {
        return value;
    }
    
    if ([value isKindOfClass:NSString.class]) {
        if ([value isEqualToString:@"false"]) {
            return @NO;
        } else if ([value isEqualToString:@"true"]) {
            return @YES;
        } else {
            return @([value integerValue]);
        }
    }
    
    return value;
}

- (NSNumber *)doubleForValue:(id)value {
    if ([value isKindOfClass:NSNumber.class]) {
        return value;
    }
    
    if ([value isKindOfClass:NSString.class]) {
        return @([value doubleValue]);
    }
    
    return value;
}

- (NSNumber *)integerForValue:(id)value {
    if ([value isKindOfClass:NSNumber.class]) {
        return value;
    }
    
    if ([value isKindOfClass:NSString.class]) {
        return @([value integerValue]);
    }
    
    return value;
}

- (id)transformValue:(SKData *)val forDynamicAttribute:(SKDynamicAttribute *)attribute data:(SKData *)data parentObject:(id)parentObject {
    
    NSString *value = val.stringValue;
    
    if ([attribute.typeName isEqualToString:@"c"]) {
        return [self charForValue:value];
    }
    
    if ([attribute.typeName isEqualToString:@"i"]) {
        return [self integerForValue:value];
    }
    
    if ([attribute.typeName isEqualToString:@"d"]) {
        return [self doubleForValue:value];
    }
    
    return value;
}

-(id)serializeValue:(id)value forDynamicAttribute:(SKDynamicAttribute *)attribute{
    return value;
}

- (BOOL)canTransformValueForClass:(Class)class {
    return !class || [class isSubclassOfClass:NSNumber.class];
}


@end
