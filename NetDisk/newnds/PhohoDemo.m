//
//  PhohoDemo.m
//  NetDisk
//
//  Created by Yangsl on 13-5-3.
//
//

#import "PhohoDemo.h"

@implementation PhohoDemo
@synthesize compressaddr,date,f_id,f_mime,f_modify,f_name,f_ownerid,f_pid,f_size,img_create,total,f_create;

-(void)dealloc
{
    [compressaddr release];
    [date release];
    [f_mime release];
    [f_modify release];
    [f_name release];
    [img_create release];
    [f_create release];
    [super dealloc];
}

@end