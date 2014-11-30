//
//  DataInit.h
//  RSS_Reader
//
//  Created by Paola Mata Maldonado on 11/21/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h> 
@class App, PMEntry;

@protocol DataServicesProtocol <NSObject>

-(void)receivedData:(NSArray*)entries;

@end

@interface PMDataServices : NSObject <NSURLConnectionDelegate>

{
    NSMutableData *_responseData;
}

@property (strong, nonatomic)NSURLConnection *connection;

-(id)init;
-(void)getAppData;

@property(strong, nonatomic) NSArray *allEntries;
@property(nonatomic, weak)id<DataServicesProtocol>delegate;

//Core Data
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void)initModelContext;
-(void)insertNewObject:(PMEntry*)entry;
- (void)saveContext;
-(NSArray*)fetchRequest;
-(NSArray*)checkWhetherDataSavedForAppName:(NSString*)name;
-(void)deleteObject:(App*)app;



@end
