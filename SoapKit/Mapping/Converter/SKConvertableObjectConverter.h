//
//  SKObjectConverter.h
//  Pods
//
//  Created by Gleb Tarasov on 12.08.16.
//
//

#import <Foundation/Foundation.h>
#import "SKValueConverter.h"

@interface SKConvertableObjectConverter : NSObject<SKValueConverter>

+ (instancetype)objectConverterForConfiguration:(SKParserConfiguration *)configuration;

@end
