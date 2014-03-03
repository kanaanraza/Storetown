//
//  ProductsListViewController.m
//  LoginScreen
//
//  Created by VS on 27/02/2014.
//  Copyright (c) 2014 VS. All rights reserved.
//


#import "ProductsListViewController.h"
#import "SBJson.h"
#import "UIImageView+WebCache.h"

#define getDataURL @"http://storetown.i3x.co.uk/mapp/product/?token=208898273"

@interface ProductsListViewController ()
{
    NSArray *productsList;
}

@end

@implementation ProductsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)addProduct
{
    NSLog(@"addBtn clicked");
}

-(void)viewWillAppear:(BOOL)animated
{
    UIBarButtonItem* addBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProduct)];
    self.navigationItem.rightBarButtonItem = addBtn;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Background work
        [self getProducts];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI
            [productsTableView reloadData];
        });
    });

}


//  image downloads by creating this method:

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return productsList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dictionary = (NSDictionary *)[productsList objectAtIndex:indexPath.row];
    
    UILabel *headingLabel = (UILabel *)[cell viewWithTag:101];
    headingLabel.text = [NSString stringWithFormat:@"Product: %@",[dictionary valueForKey:@"title"]];
    
    UILabel *categoryLabel = (UILabel *)[cell viewWithTag:102];
    categoryLabel.text = [NSString stringWithFormat:@"Category: %@",[dictionary valueForKey:@"category"]];
    
    UILabel *priceLabel = (UILabel *)[cell viewWithTag:103];
    priceLabel.text = [NSString stringWithFormat:@"Price: %@",[dictionary valueForKey:@"price"]];

    
    
    
    NSArray* tempArray  = (NSArray *)[dictionary valueForKey:@"files"];
    
    UIImageView *productImageView = (UIImageView *)[cell viewWithTag:100];
    [productImageView setContentMode:UIViewContentModeScaleAspectFit];
    productImageView.image = [UIImage imageNamed:@"loading.png"];
    
    if(tempArray.count > 0)
    {
        //get imagee path of first image in array of images
        NSString *imagePath = [[tempArray objectAtIndex:0] valueForKey:@"path"];
        NSLog(@"imagePath %@",imagePath);
        //complete the url by appendin ght comany url and sent it to downloadImageWithURL method
        
        [productImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://storetown.i3x.co.uk%@", imagePath]] placeholderImage:[UIImage imageNamed:@"loading.png"]];
    
    }
    

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)getProducts{
    
    //NSURL * url = [NSURL URLWithString:getDataURL];
    
    
    
                
    
    @try {
        
        
        NSURL *url=[NSURL URLWithString:@"http://storetown.i3x.co.uk/mapp/product/?token=208898273"];
//            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//            
//            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:url];
            [request setHTTPMethod:@"GET"];
//            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//            [request setHTTPBody:postData];
        
            //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
            
            NSError *error = [[NSError alloc] init];
            NSHTTPURLResponse *response = nil;
            NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
//            NSLog(@"Response code: %d", [response statusCode]);
            if ([response statusCode] >=200 && [response statusCode] <300)
            {
                NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
//                NSLog(@"Response ==> %@", responseData);
                
                SBJsonParser *jsonParser = [SBJsonParser new];
                NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
//                NSLog(@"%@",jsonData);
                productsList = (NSArray *) [jsonData objectForKey:@"products"];
                NSLog(@"%@",productsList);
                
            } else {
                if (error) NSLog(@"Error: %@", error);

            }
        
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);

    }
}
    



@end



        