//
//  QueryProcessor.h
//  FoaasImpl
//
//  Created by Massimo Gengarelli on 25/06/14.
//  Copyright (c) 2014 Massimo Gengarelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BModel;
@class QueryProcessor;
@class FoaasMethod;

@protocol QueryProcessorDelegate <NSObject>
-(void)processor:(QueryProcessor *)processor receivedModel:(BModel *)model;
@end

@interface QueryProcessor : NSObject

@property (strong, nonatomic) NSString * gistID;
@property (strong, nonatomic) NSString * jsonURL;
@property (strong, nonatomic) NSString * description;
@property (strong, nonatomic) NSArray  * knownMethods;

@property (weak, nonatomic) id<QueryProcessorDelegate> delegate;

- (void)executeMethod:(FoaasMethod *)method;

@end
