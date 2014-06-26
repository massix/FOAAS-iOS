//
//  FoaasMethod.h
//  FoaasImpl
//
//  Created by Massimo Gengarelli on 25/06/14.
//  Copyright (c) 2014 Massimo Gengarelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoaasMethod : NSObject

@property (strong, nonatomic) NSString *methodName;
@property (strong, nonatomic) NSArray *fields;

- (id)initWithMethodName:(NSString *)methodName andFields:(NSArray *)fields;

@end
