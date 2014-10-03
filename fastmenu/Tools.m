//
//  Tools.m
//  fastmenu
//
//  Created by HeartNest on 03/10/14.
//  Copyright (c) 2014 labt. All rights reserved.
//

#import "Tools.h"

@implementation Tools


#pragma mark - Button Descriptions -

+(UIButton *)createMenuBtnComponentWithName:(NSString *)name price:(double)price color:(NSString *)cl{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    //make the buttons content appear in the top-left
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    
    //move text 10 pixels down and right
    [button setTitleEdgeInsets:UIEdgeInsetsMake(9.0f, 10.0f, 0.0f, 0.0f)];
    
    //enable line break
    button.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    //button layer
    [[button layer] setBorderWidth:1.0f];
    [[button layer] setBorderColor: [Tools colorFromHexString:@"#EEC591"].CGColor];
    //    [[button layer] setBorderColor:[UIColor grayColor].CGColor];
    //color
    if(cl != nil)
        button.backgroundColor = [Tools colorFromHexString:cl];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    //prepare the style
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentLeft];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    UIFont *font1 = [UIFont fontWithName:@"HelveticaNeue-bold"  size:16.0f];
    NSDictionary *dict1 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                            NSFontAttributeName:font1,
                            NSForegroundColorAttributeName:[Tools colorFromHexString:@"#1C1C1C"],
                            NSParagraphStyleAttributeName:style}; // Added line
    
    UIFont *font2 = [UIFont fontWithName:@"HelveticaNeue-Light"  size:16.0f];
    NSDictionary *dict2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                            NSFontAttributeName:font2,
                            NSForegroundColorAttributeName:[UIColor blackColor],
                            NSParagraphStyleAttributeName:style}; // Added line
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:[[NSString alloc] initWithFormat:@"%@ ",name]    attributes:dict1]];
    
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:[[NSString alloc] initWithFormat:@"%.02f€",price ]   attributes:dict2]];
    ;
    
    
    [button setAttributedTitle:attString forState:UIControlStateNormal];
    return button;
}

+ (UIButton *)createPlusBtnComponentWithQnt:(NSString *)quantity andColor:(NSString *)cl{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //move text 10 pixels down and right
    [button setTitleEdgeInsets:UIEdgeInsetsMake(2.0f, 2.0f, 0.0f, 0.0f)];
    //button layer
    [[button layer] setBorderWidth:1.0f];
    [[button layer] setBorderColor: [Tools colorFromHexString:@"#EEC591"].CGColor];
    //[[button layer] setBorderColor:[UIColor grayColor].CGColor];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentLeft];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    if(cl != nil)
        button.backgroundColor = [Tools colorFromHexString:cl];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIFont *font1 = [UIFont fontWithName:@"HelveticaNeue-bold"  size:14.0f];
    NSDictionary *dict1 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                            NSFontAttributeName:font1,
                            NSForegroundColorAttributeName:[UIColor blackColor],
                            NSParagraphStyleAttributeName:style}; // Added line
    
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:quantity attributes:dict1]];
    [button setAttributedTitle:attString forState:UIControlStateNormal];
    return button;
}

+(UIButton *)createCopertoBtnWithNumPeople:(float) copertoCost{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    //move text 10 pixels down and right
    [button setTitleEdgeInsets:UIEdgeInsetsMake(2.0f, 10.0f, 0.0f, 0.0f)];
    //button layer
    [[button layer] setBorderWidth:1.0f];
    [[button layer] setBorderColor: [Tools colorFromHexString:@"#EEC591"].CGColor];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentLeft];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    UIFont *font1 = [UIFont fontWithName:@"Helvetica Neue"  size:14.0f];
    NSDictionary *dict1 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                            NSFontAttributeName:font1,
                            NSForegroundColorAttributeName:[UIColor blackColor],
                            NSParagraphStyleAttributeName:style}; // Added line
    
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:[[NSString alloc] initWithFormat:@"Service fee %.02f€",copertoCost ]      attributes:dict1]];
    [button setAttributedTitle:attString forState:UIControlStateNormal];
    return button;
    
}



+(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
