//
//  TableViewController.m
//  fastmenu
//
//  Created by HeartNest on 19/09/14.
//  Copyright (c) 2014 labt. All rights reserved.
//

#import "TableViewController.h"
#import "OrdersViewController.h"
#import "MenuViewController.h"


@interface TableViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation TableViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320, 1200)];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //get var
    double width = self.scrollView.frame.size.width;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.backgroundColor = [UIColor greenColor];
    [button addTarget:self
               action:@selector(didPressButton:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:@"Show View" forState:UIControlStateNormal];
    button.frame = CGRectMake(width/2 + 1, 100, 7*width/16, 100.0);

    [self.scrollView addSubview:button];
    

    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.backgroundColor = [UIColor greenColor];
    [button2 addTarget:self
               action:@selector(didPressButton2:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [button2 setTitle:@"Show View" forState:UIControlStateNormal];
    button2.frame = CGRectMake(1, 100, 7*width/16, 100.0);
    
    [self.scrollView addSubview:button2];
    
 
    
    
    //xxxxx
    
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(0.0,0.0,28.0,21.0);
    [textView setReturnKeyType: UIReturnKeyDone];
    textView.backgroundColor = NULL;
    
    textView.text = @"aaa";
    
    [button addSubview: textView];
    
}



#pragma mark - Navigation

-(void)someMethod
{
    [self performSegueWithIdentifier:@"occupiedtable" sender:self];
}

- (void)didPressButton:(UIButton *)sender
{
 
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    OrdersViewController *viewController = (OrdersViewController *)[storyboard instantiateViewControllerWithIdentifier:@"order-story-id"];
    
//    [self presentViewController:viewController animated:YES completion:nil];
 [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didPressButton2:(UIButton *)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MenuViewController *viewController = (MenuViewController *)[storyboard instantiateViewControllerWithIdentifier:@"menu-story-id"];
    
    //    [self presentViewController:viewController animated:YES completion:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

        
        if ([segue.identifier isEqualToString:@"occupiedtable"]) {
            
//            if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
            

                //NSLog(@"ccc %@", photo.imageURL);
          //  }
        }
    
    
}


@end
