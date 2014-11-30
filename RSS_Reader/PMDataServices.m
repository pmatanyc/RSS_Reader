//
//  DataInit.m
//  RSS_Reader
//
//  Created by Paola Mata Maldonado on 11/21/14.
//
//

#import "PMDataServices.h"
#import "PMEntry.h"
#import "App.h"


@implementation PMDataServices


-(id)init{
    
    if (self) {

        _allEntries = [NSArray new];
    }
    
    return self;
}

-(void)getAppData{
    
    NSURL *url = [NSURL URLWithString:@"http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topgrossingapplications/sf=143441/limit=25/json"];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    self.connection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
    
}


#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
   
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&error];
    
    if (error != nil) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    else{
        
        NSArray *allEntries = [NSArray new];
        allEntries = [json valueForKeyPath:@"feed.entry"];
        
        NSMutableArray *entryFeed = [NSMutableArray new];
        
        for (NSArray *item in allEntries) {
            
            PMEntry *entry = [PMEntry new];
            entry.name = [item valueForKeyPath:@"im:name.label"];
            entry.artist = [item valueForKey:@"im:artist.label"];
            entry.category = [item valueForKeyPath:@"category.attributes.label"];
            entry.price = [item valueForKeyPath:@"im:price.label"];
            entry.iTunesURL = [item valueForKeyPath:@"link.attributes.href"];
            entry.summary = [item valueForKeyPath:@"summary.label"];
            entry.imageURL = [item valueForKeyPath:@"im:image.label"][0]; //smallest image
            [entryFeed addObject:entry];
        }
        
        self.allEntries = entryFeed;
        [self.delegate receivedData:self.allEntries];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

    NSLog(@"%@", error.localizedDescription);
}



#pragma mark - CORE DATA STACK

-(void)initModelContext
{
    self.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSString *path = [self archivePath];
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    if(![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
    }
    self.managedObjectContext = [[NSManagedObjectContext alloc] init];
    [self.managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    
}


-(NSString*)archivePath
{
    NSArray *documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [documentsDirectories objectAtIndex:0];
  
    return [documentsDirectory stringByAppendingPathComponent:@"Apps.sqlite"];
}


-(NSArray*)fetchRequest
{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [[self.managedObjectModel entitiesByName] objectForKey:@"App"];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if(!result){
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
        abort();
    }
    
    else{
        
        return result;
    }
}

-(NSArray*)checkWhetherDataSavedForAppName:(NSString*)name{
    
    //Checks whether app is in core data, and if so, disables Save button
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [[self.managedObjectModel entitiesByName] objectForKey:@"App"];
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"name == %@",name]];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if(!result){
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
        abort();
    }
    
    return result;
}

-(void)insertNewObject:(PMEntry*)entry{
    
    App *app = [NSEntityDescription insertNewObjectForEntityForName:@"App" inManagedObjectContext:self.managedObjectContext];
    
    app.imageURL = entry.imageURL;
    app.name = entry.name;
    app.artist = entry.artist;
    app.category = entry.category;
    app.price = entry.price;
    app.iTunesURL = entry.iTunesURL;
    app.summary = entry.summary;

    [self saveContext];
}

- (void)saveContext
{
    NSError *err = nil;
    BOOL successful = [self.managedObjectContext save:&err];
    if(!successful){
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    NSLog(@"Data Saved");
    
}


-(void)deleteObject:(App*)app{
    
    [self.managedObjectContext deleteObject:app];
    [self saveContext];
}


@end
