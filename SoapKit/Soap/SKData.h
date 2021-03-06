//
//  SKData.h
//  SoapKit
//
//  Created by Hannes Tribus on 02/09/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKRequest;

@interface SKData : NSObject <NSCopying>;

+ (instancetype)dataWithName:(NSString *)name;
+ (instancetype)dataWithName:(NSString *)name andStringValue:(NSString *)value;
+ (instancetype)dataWithName:(NSString *)name andBoolValue:(BOOL)value;
+ (instancetype)dataWithName:(NSString *)name andIntValue:(NSInteger)value;
+ (instancetype)dataWithName:(NSString *)name andDateValue:(NSDate *)value;
+ (instancetype)dataWithName:(NSString *)name andChild:(SKData *)child;
+ (instancetype)dataWithName:(NSString *)name andChildren:(NSArray *)children;
+ (instancetype)dataWithName:(NSString *)name andAttributes:(NSDictionary<NSString *, NSString *> *)attributes;

- (instancetype)initWithName:(NSString *)name;

- (void)addChild:(SKData *)child;
- (void)addChildren:(NSArray<SKData *> *)children;

- (NSArray<SKData *> *)children;
- (SKData *)childByName:(NSString *)name;
- (NSArray<SKData *> *)childrenByName:(NSString *)name;
- (NSArray<SKData *> *)descendantsByName:(NSString *)name;

@property (strong, nonatomic) NSString *stringValue;
@property (nonatomic)         NSInteger intValue;
@property (nonatomic)         BOOL boolValue;
@property (strong, nonatomic) NSDate *dateValue;

- (void)addNamespace:(NSString *)value;

- (NSString *)name;
- (NSArray *)attributes;
- (NSString *)description;

@end
