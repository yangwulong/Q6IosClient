//
//  File.swift
//  Q6IosClient
//
//  Created by yang wulong on 4/04/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import Foundation

public class Q6DBLib{
    
    var databasePath = NSString()
    
    
    public func createDB() {
        
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = filemgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        databasePath = dirPaths[0].URLByAppendingPathComponent("Q6IosClientDB.db").path!
        
  
        if !filemgr.fileExistsAtPath(databasePath as String){
            
            let q6IosClientDB = FMDatabase(path: databasePath as String)
            
           
            if q6IosClientDB == nil {
                print("Error:\(q6IosClientDB.lastErrorMessage())")
            }
            
            if q6IosClientDB.open()
            {
                
                 if  q6IosClientDB.tableExists("UserInfos") == false
                 {
                    let sql_stmt = "CREATE TABLE IF NOT EXISTS UserInfos (ID INTEGER  PRIMARY  KEY AUTOINCREMENT, LogInEmail,PassWord, CompanyID)"
                    if !q6IosClientDB.executeStatements(sql_stmt)
                    {
                       print("Error:\(q6IosClientDB.lastErrorMessage())")
                
                     }
            
                    
                }
                
//                if  q6IosClientDB.tableExists("TaxCode") == false
//                {
//                    let sql_stmt = "CREATE TABLE IF NOT EXISTS TaxCode (ID INTEGER  PRIMARY  KEY AUTOINCREMENT, LoginInEmail,Password, CompanyID)"
//                    if !q6IosClientDB.executeStatements(sql_stmt)
//                    {
//                        print("Error:\(q6IosClientDB.lastErrorMessage())")
//                        
//                    }
//                    
//                    
//                }
                q6IosClientDB.close()

            } else {
                print("Error:\(q6IosClientDB.lastErrorMessage())")
            }
        }
        
    }
    public func addUserInfos(LoginEmail : String,PassWord: String,CompanyID: String)
    {
        
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = filemgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        databasePath = dirPaths[0].URLByAppendingPathComponent("Q6IosClientDB.db").path!
        
        
        let q6IosClientDB = FMDatabase(path: databasePath as String)
        
        if q6IosClientDB.open() {
            
            if validateIfTableIsEmpty("UserInfos", Q6IosClientDB: q6IosClientDB) == true {
                
            
            let insertSQL = "INSERT INTO UserInfos (LoginEmail,PassWord,CompanyID) VALUES ('\(LoginEmail)' ,'\(PassWord)','\(CompanyID)')"
            
            let result = q6IosClientDB.executeUpdate(insertSQL, withArgumentsInArray: nil)
            
            if !result {
                print ("Error: \(q6IosClientDB.lastErrorMessage())")
            } else{
                print ("Sucess: add UserInfos")
            }
            }
        }
        else{
                   print ("Error: \(q6IosClientDB.lastErrorMessage())")
        }
    }
    
    public func validateIfTableIsEmpty(TableName: String ,Q6IosClientDB : FMDatabase) -> Bool {
        
        
        let result = Q6IosClientDB.executeQuery("SELECT COUNT(*) FROM \(TableName)", withArgumentsInArray: [])
        if result.next()
        {
            let count = result.intForColumnIndex(0)
            if count > 0 {
               return false
            } else {
               return true
            }
        } else {
           return true
        }
    
    }
    public  func getUserInfos() ->[String:String]
    {
        var userLoginData = [String:String]()
    let filemgr = NSFileManager.defaultManager()
    let dirPaths = filemgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    
    databasePath = dirPaths[0].URLByAppendingPathComponent("Q6IosClientDB.db").path!
    
    
    let q6IosClientDB = FMDatabase(path: databasePath as String)
        
        if q6IosClientDB.open() {
            let querySQL = "SELECT LoginEmail , PassWord FROM UserInfos"
            let results : FMResultSet? = q6IosClientDB.executeQuery(querySQL, withArgumentsInArray: nil)
            
            if results?.next() == true {
                
             userLoginData["LoginEmail"] = results?.stringForColumn("LoginEmail")
                userLoginData["passWord"] = results?.stringForColumn("PassWord")
                
            }
        }
        return userLoginData
    }
}