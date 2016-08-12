//
//  SKSimpleConverter.m
//  SoapKit
//
//  Created by Hannes Tribus on 15/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "SKSimpleConverter.h"
#import "SKDynamicAttribute.h"

@implementation SKSimpleConverter

+ (instancetype)simpleConverter {
    return [[self alloc] init];
}

- (id)transformValue:(SKData *)val forDynamicAttribute:(SKDynamicAttribute *)attribute data:(SKData *)data parentObject:(id)parentObject {
    NSString *value = val.stringValue;
    return value;
}

-(id)serializeValue:(id)value forDynamicAttribute:(SKDynamicAttribute *)attribute{
    return value;
}

- (BOOL)canTransformValueForClass:(Class)class {
    return YES;
}

@end
