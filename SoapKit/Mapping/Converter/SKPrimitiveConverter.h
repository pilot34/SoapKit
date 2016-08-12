//
//  SKPrimitiveConverter.h
//  Pods
//
//  Created by Gleb Tarasov on 12.08.16.
//
//

#import <Foundation/Foundation.h>
#import "SKValueConverter.h"

@interface SKPrimitiveConverter : NSObject<SKValueConverter>

+ (instancetype)primitiveConverter;

@end
