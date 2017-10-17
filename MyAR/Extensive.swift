//
//  Expansion.swift
//  MyAR
//
//  Created by 孙港 on 2017/10/10.
//  Copyright © 2017年 孙港. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import CoreLocation

public let MAXDISTANCE:Double = 100.0
public let LATITUDEDEVIATION = -0.00234
public let LONGITUDEDEVIATION = 0.00551

public var start = true
public var USERNAME:String = "Sun.G"
public var selfLatitude_Double:Double = 0 //当前维度 角度
public var selfLongitude_Double:Double = 0 //当前经度 角度
public var selfDirection_Double:Double = 0 //0-360 角度

public var authorOfMessage = "Sun.G"
public var idOfMessage = "0000000"
public var contentOfMessage = "Hello world!"


//Function
public func getHorizonalDistance(selfLocation:CLLocation, messageLocation:CLLocation)->Double{
    let tempLocation = CLLocation(latitude: selfLocation.coordinate.latitude, longitude: messageLocation.coordinate.longitude)
    let distance:CLLocationDistance = selfLocation.distance(from: tempLocation)
    
    if messageLocation.coordinate.longitude > selfLocation.coordinate.longitude{
        return distance
    }
    else{
        return -distance
    }
}
public func getVerticalDistance(selfLocation:CLLocation, messageLocation:CLLocation)->Double{
    let tempLocation = CLLocation(latitude: messageLocation.coordinate.latitude, longitude: selfLocation.coordinate.longitude)
    let distance:CLLocationDistance = selfLocation.distance(from: tempLocation)
    if messageLocation.coordinate.latitude > selfLocation.coordinate.latitude{
        return distance
    }
    else{
        return -distance
    }
}
public func getDistance(selfLocation:CLLocation, messageLocation:CLLocation)->Double{
    let distance:CLLocationDistance = selfLocation.distance(from: messageLocation)
    return distance
}


public var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: "myar")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            
            /*
             Typical reasons for an error here include:
             * The parent directory does not exist, cannot be created, or disallows writing.
             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
             * The device is out of space.
             * The store could not be migrated to the current model version.
             Check the error message to determine what the actual problem was.
             */
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container
}()

// MARK: - Core Data Saving support

public func saveContext (messageContent:String) {
    let now = Date()
    //当前时间的时间戳
    let timeInterval:TimeInterval = now.timeIntervalSince1970
    let timeStamp = Int(timeInterval)
    
    let context = persistentContainer.viewContext
    
    let message = NSEntityDescription.insertNewObject(forEntityName: "Message",into: context) as! Message
    //对象赋值
    message.name = USERNAME
    message.content = messageContent
    message.latitude = selfLatitude_Double
    message.longitude = selfLongitude_Double
    message.timestamp = String(timeStamp)
    
    if context.hasChanges {
        do {
            try context.save()
            print(message.latitude)
            print(message.longitude)
            print("保存消息成功！")
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

/*
 *function: searchMessage
 *author: sungang
 *date: 2017/08/31
 */
public func searchMessage(){
    let context = persistentContainer.viewContext
    
    //声明数据的请求
    let fetchRequest = NSFetchRequest<Message>(entityName:"Message")
    //fetchRequest.fetchLimit = 10 // 限定查询结果的数量
    //fetchRequest.fetchOffset = 0 // 查询的偏移量
    
    //设置查询条件
    //let predicate = NSPredicate(format: "id= '1' ", "")
    //fetchRequest.predicate = predicate
    
    //查询操作
    do {
        let fetchedObjects = try context.fetch(fetchRequest)
        
        //遍历查询的结果
        for info in fetchedObjects{
            print("name=\(String(describing: info.name))")
            print("content=\(String(describing: info.content))")
            print("latitude=\(info.latitude)")
            print("longitude=\(info.longitude)")
        }
    }
    catch {
        fatalError("不能保存：\(error)")
    }
}

public func saveUser (name:String,id:String,pwd:String) {
    let context = persistentContainer.viewContext
    let user = NSEntityDescription.insertNewObject(forEntityName: "User",into: context) as! User
    user.name = name
    user.id = id
    user.pwd = pwd
    if context.hasChanges {
        do {
            try context.save()
            print("保存成功！")
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

public func searchUser(){
    let context = persistentContainer.viewContext
    
    //声明数据的请求
    let fetchRequest = NSFetchRequest<User>(entityName:"User")
    //fetchRequest.fetchLimit = 10 // 限定查询结果的数量
    //fetchRequest.fetchOffset = 0 // 查询的偏移量
    
    //设置查询条件
    //let predicate = NSPredicate(format: "id= '1' ", "")
    //fetchRequest.predicate = predicate
    
    //查询操作
    do {
        let fetchedObjects = try context.fetch(fetchRequest)
        
        //遍历查询的结果
        for info in fetchedObjects{
            print("name=\(String(describing: info.name))")
            print("id=\(String(describing: info.id))")
            print("pwd=\(String(describing: info.pwd))")
        }
    }
    catch {
        fatalError("不能保存：\(error)")
    }
}

public func ifUser(id: String,pwd: String) -> Bool{
    let context = persistentContainer.viewContext
    
    //声明数据的请求
    let fetchRequest = NSFetchRequest<User>(entityName:"User")
    //fetchRequest.fetchLimit = 10 // 限定查询结果的数量
    //fetchRequest.fetchOffset = 0 // 查询的偏移量
    
    //设置查询条件
    let predicate = NSPredicate(format: "id= \(id) ", "")
    fetchRequest.predicate = predicate
    
    //查询操作
    do {
        let fetchedObjects = try context.fetch(fetchRequest)
        
        //遍历查询的结果
        for info in fetchedObjects{
            if pwd == info.pwd!{
                USERNAME = info.name!
                return true
            }
            else{
                return false
            }
        }
        return false
    }
    catch {
        fatalError("不能保存：\(error)")
    }
}
