//
//  SKNSArrayConverter.m
//  SoapKit
//
//  Created by Hannes Tribus on 15/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "SKNSArrayConverter.h"
#import "SKSimpleConverter.h"
#import "SKArrayMapping.h"
#import "SKDataObjectMapping.h"
#import "SKDynamicAttribute.h"
#import "SKGenericConverter.h"
@interface SKNSArrayConverter()

@property(nonatomic, strong) SKParserConfiguration *configuration;

@end

@implementation SKNSArrayConverter

+ (SKNSArrayConverter *) arrayConverterForConfiguration: (SKParserConfiguration *)configuration {
    return [[self alloc] initWithConfiguration: configuration];
}

- (id)initWithConfiguration:(SKParserConfiguration *)configuration{
    self = [super init];
    if (self) {
        _configuration = configuration;
    }
    return self;   
}

- (id)transformValue:(SKData *)value forDynamicAttribute:(SKDynamicAttribute *)attribute data:(SKData *)data parentObject:(id)parentObject {

    NSArray<SKData *> *allChildren = [data childrenByName:value.name];
    if (![allChildren.firstObject.stringValue isEqualToString:value.stringValue]) {
        // parse whole array only for the first item
        return nil;
    }
    
    SKArrayMapping *mapper = [self.configuration arrayMapperForMapper:attribute.objectMapping];
    if (mapper) {
        SKDataObjectMapping *parser = [SKDataObjectMapping mapperForClass:mapper.classForElementsOnArray andConfiguration:self.configuration];
        return [parser parseArray:allChildren forParentObject:parentObject];
    }

    return nil;
}
- (id)serializeValue:(id)values forDynamicAttribute:(SKDynamicAttribute *)attribute {
    SKGenericConverter* genericConverter = [[SKGenericConverter alloc] initWithConfiguration:self.configuration];
    NSMutableArray *valuesHolder = [NSMutableArray array];
    for(id value in values){
        SKDynamicAttribute *valueClassAsAttribute = [[SKDynamicAttribute alloc] initWithClass:[value class]];
        [valuesHolder addObject:[genericConverter serializeValue:value forDynamicAttribute:valueClassAsAttribute]];
    }    
    return [NSArray arrayWithArray:valuesHolder];
}

- (BOOL)canTransformValueForClass:(Class)class {
    return [class isSubclassOfClass:[NSArray class]];
}
@end
