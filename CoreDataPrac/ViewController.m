//
//  ViewController.m
//  CoreDataPrac
//
//  Created by RainShen on 16/3/6.
//  Copyright © 2016年 小雨. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "Employee.h"

@interface ViewController ()

{
    NSManagedObjectContext *_context;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1，创建模型文件（相当于数据库里面的一个表）
    //2，添加实体
    //3，创建一个实体类（就是对象，关联里面的每一个字段）
    
    //4，生成上下文，关联模型文件生成数据库
    
    //上下文
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    //上下文关联数据库
    //持久化：把数据保存在一个文件里面，而不是内存
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil]; // 模型文件
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model]; // 持久化调度器
    // 告诉coredata数据库的名字和路径
    NSError *error = nil;
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"company.db"];
    NSLog(@"%@", path);
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:path] options:nil error:&error];
    context.persistentStoreCoordinator = store; // 上下文需要一个持久化存储对象
    _context = context;
    
}

// 数据库的操作 CURD Create，Update，Read，Delete

- (IBAction)addEmployee {
    // 直接给对象添加到数据库里面，创建一个员工对象
    
   // Employee *employee = [[Employee alloc] init];
    Employee *employee = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:_context];
    employee.name = @"LiSi";
    employee.height = @2.90;
    employee.birthday = [NSDate date];
    
    NSError *error = nil;
    [_context save:&error];
    if (error) {
        NSLog(@"error: %@", error);
    }
}

- (IBAction)readEmployee {
    // 1,抓取请求对象 2设置过滤条件 3，设置排序 4，执行请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    NSError *error = nil;
    [request setPredicate:[NSPredicate predicateWithFormat:@"name == %@", @"wangwu"]];
    NSArray *results = [_context executeFetchRequest:request error:&error];
    for (Employee *emp in results) {
        NSLog(@"name:%@, height: %@, birthday: %@", emp.name, emp.height, emp.birthday);
    }
    
//    NSError *saveError = nil;
//    [_context save:&saveError];
//    if (saveError) {
//        NSLog(@"saveError : %@", saveError);
//    }
    
}

- (IBAction)updateEmployee {
    // 更改“zhangsan”的身高为2.20
    
    // 1,查找zhangsan
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    NSError *error = nil;
    [request setPredicate:[NSPredicate predicateWithFormat:@"name == %@", @"wangwu"]];
    NSArray *results = [_context executeFetchRequest:request error:&error];
    // 2，更改身高
    for (Employee *emp in results) {
        NSLog(@"name:%@, height: %@, birthday: %@", emp.name, emp.height, emp.birthday);
        emp.height = @2.20;
    }
    // 3，保存
    [_context save:nil];
}

- (IBAction)deleteEmployee {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    NSError *error = nil;
    [request setPredicate:[NSPredicate predicateWithFormat:@"name == %@", @"LiSi"]];
    NSArray *results = [_context executeFetchRequest:request error:&error];
    for (Employee *emp in results) {
        [_context deleteObject:emp];
    }
    [_context save:nil];
}
/*
    什么时候用Coredata，什么时候使用FMDatabases？
    数据存储结构比较简单的时候用Coredata，开发效率会高一点（是直接面向对象的）
    FMDatabases数据结构关系复杂的时候，表与表之间的关联比较多的时候
 */

@end
