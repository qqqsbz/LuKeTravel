//
//  DBUtil.m
//  iPenYou
//
//  Created by coder on 16/3/15.
//  Copyright © 2016年 vbuy. All rights reserved.
//

#import "XBDBUtil.h"
#import "XBApplication.h"
#import "XBModel.h"
@interface XBDBUtil()

@property (strong, nonatomic) NSFetchedResultsController  *fetchedResultsController;

@property (strong, nonatomic) NSFetchRequest  *fetchRequest;

@end
@implementation XBDBUtil

+ (instancetype)shareDBUtil
{
    static XBDBUtil *util;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        util = [[XBDBUtil alloc] init];
        util.fetchRequest = [[NSFetchRequest alloc] init];
    });
    return util;
}

- (BOOL)add:(MTLModel<MTLManagedObjectSerializing> *)model
{
    NSError *error;
    NSManagedObject *managedObject = [MTLManagedObjectAdapter managedObjectFromModel:model insertingIntoContext:[XBApplication sharedManagedObjectContext] error:&error];
    if (managedObject) {
        [XBApplication saveSharedManagedObjectContext];
        return true;
    }
    return NO;
}

- (BOOL)adds:(NSArray<MTLModel<MTLManagedObjectSerializing> *> *)models
{
    BOOL result = NO;
    
    for (MTLModel<MTLManagedObjectSerializing> *model in models) {
        result = [self add:model];
    }
    
    return result;
}

- (void)update:(MTLModel<MTLManagedObjectSerializing> *)model
{
    [XBApplication saveSharedManagedObjectContext];
}

- (void)removes:(NSArray<MTLModel<MTLManagedObjectSerializing> *> *)models
{
    for (MTLModel<MTLManagedObjectSerializing> *model in models) {
        
        [self remove:model];
        
    }
}

- (void)remove:(MTLModel<MTLManagedObjectSerializing> *)model
{
    NSError *error;
    
    NSManagedObject *managedObject = [MTLManagedObjectAdapter managedObjectFromModel:model insertingIntoContext:[XBApplication sharedManagedObjectContext] error:&error];
    
    [XBApplication deleteShareManagedObjectContext:managedObject];
    
    [XBApplication saveSharedManagedObjectContext];
    
}

- (void)queryListWithEntityName:(NSString *)entityName fetchRequest:(NSFetchRequest *)fetchRequest sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors complete:(Complete)complete
{
    NSManagedObjectContext *moc = [XBApplication sharedManagedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:moc];
    if (!fetchRequest) {
        fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.fetchLimit = 100;
    }
    
    fetchRequest.entity = entity;
    
    if (sortDescriptors && sortDescriptors.count > 0) {
        fetchRequest.sortDescriptors = sortDescriptors;
    }
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:fetchRequest error:&error];
    if (error) {
        DDLogCDebug(@"query list from core data error:%@",error);
    }
    
    complete(result);

}

- (void)queryOneWithEntityName:(NSString *)entityName fetchRequest:(NSFetchRequest *)fetchRequest sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors complete:(OneComplete)complete
{
    NSManagedObjectContext *moc = [XBApplication sharedManagedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:moc];
    if (!fetchRequest) {
        fetchRequest = self.fetchRequest;
    }
    fetchRequest.entity = entity;
    fetchRequest.fetchLimit = 1;
    if (sortDescriptors && sortDescriptors.count > 0) {
        fetchRequest.sortDescriptors = sortDescriptors;
    }
    NSError *error = nil;
    id result = [[moc executeFetchRequest:fetchRequest error:&error] lastObject];
    if (error) {
        DDLogCDebug(@"query one from core data error:%@",error);
    } else {
        complete(result);
    }
}
@end
