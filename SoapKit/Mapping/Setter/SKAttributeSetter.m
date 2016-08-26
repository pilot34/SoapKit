//
//  SKAttributeSetter.m
//  SoapKit
//
//  Created by Hannes Tribus on 15/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "SKAttributeSetter.h"

@implementation SKAttributeSetter

+ (void)assingValue:(id)value forAttributeName: (NSString *)attributeName andAttributeClass: (Class) attributeClass onObject:(id)object {
    if([object validateValue:&value forKey:attributeName error:nil]){
        if([value isKindOfClass:[NSNull class]]){
            value = nil;
        }
        
        // skip nils for array converters
        if (value) {
            [object setValue:value forKey:attributeName];
        }
    }
}

@end
