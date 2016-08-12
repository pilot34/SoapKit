//
//  SKObjectConverter.m
//  Pods
//
//  Created by Gleb Tarasov on 12.08.16.
//
//

#import "SKConvertableObjectConverter.h"
#import "SKDynamicAttribute.h"
#import "SKDataObjectMapping.h"

@interface SKConvertableObjectConverter()

@property(nonatomic, strong) SKParserConfiguration *configuration;

@end

@implementation SKConvertableObjectConverter

- (instancetype)initWithConfiguration:(SKParserConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.configuration = configuration;
    }
    return self;
}

+ (instancetype)objectConverterForConfiguration:(SKParserConfiguration *)configuration {
    return [[self alloc] initWithConfiguration:configuration];
}

- (id)transformValue:(id)value forDynamicAttribute:(SKDynamicAttribute *)attribute data:(SKData *)data parentObject:(id)parentObject {
    if (![value isKindOfClass:[SKData class]]) {
        return nil;
    }

    SKDataObjectMapping *parser = [SKDataObjectMapping mapperForClass:attribute.objectMapping.classReference
                                                     andConfiguration:self.configuration];
    value = [parser parseData:(SKData *)value forParentObject:parentObject];
    
    return value;
}

-(id)serializeValue:(id)value forDynamicAttribute:(SKDynamicAttribute *)attribute{
    return value;
}

- (BOOL)canTransformValueForClass:(Class)class {
    return [class conformsToProtocol:@protocol(SKConvertableObject)];
}

@end
