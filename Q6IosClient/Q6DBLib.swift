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
                    
                    //LoginStatus has two valude Login ,Logout
                    let sql_stmt = "CREATE TABLE IF NOT EXISTS UserInfos (ID INTEGER  PRIMARY  KEY , LogInEmail,PassWord, LoginStatus,PassCode,CompanyID)"
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
    public func addUserInfos(LoginEmail : String,PassWord: String,LoginStatus: String,CompanyID: String)
    {
        
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = filemgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        databasePath = dirPaths[0].URLByAppendingPathComponent("Q6IosClientDB.db").path!
        
        
        let q6IosClientDB = FMDatabase(path: databasePath as String)
        
        if q6IosClientDB.open() {
            
            if validateIfTableIsEmpty("UserInfos", Q6IosClientDB: q6IosClientDB) == true {
                
            
            let insertSQL = "INSERT INTO UserInfos (ID,LoginEmail,PassWord,LoginStatus,CompanyID) VALUES (1,'\(LoginEmail)' ,'\(PassWord)','Login','\(CompanyID)')"
            
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
         q6IosClientDB.close()
    }
    
    //inside other  open status functions
    public func validateIfTableIsEmpty(TableName: String ,Q6IosClientDB : FMDatabase) -> Bool {
        
        var isEmpty: Bool = true
       
            
        let result = Q6IosClientDB.executeQuery("SELECT COUNT(*) FROM \(TableName)", withArgumentsInArray: [])
        if result.next()
        {
            let count = result.intForColumnIndex(0)
            if count > 0 {
                isEmpty = false
              
            } else {
                isEmpty = true
          
            }
        } else {
            isEmpty = true
       
        
        
        }
        
     //q6IosClientDB!.close()
        return isEmpty
    }
    
    //outside isoloate database , so need to open DB status in function 
    public func validateIfTableIsEmpty(TableName: String ) -> Bool {
        
        var q6IosClientDB = FMDatabase()
        var isEmpty: Bool = true
   
            let filemgr = NSFileManager.defaultManager()
            let dirPaths = filemgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            
            databasePath = dirPaths[0].URLByAppendingPathComponent("Q6IosClientDB.db").path!
            q6IosClientDB  = FMDatabase(path: databasePath as String)
     
        if q6IosClientDB.open() {
        
        
        let result = q6IosClientDB.executeQuery("SELECT COUNT(*) FROM \(TableName)", withArgumentsInArray: [])
        if result.next()
        {
            let count = result.intForColumnIndex(0)
            if count > 0 {
                isEmpty = false
                
            } else {
                isEmpty = true
                
            }
        } else {
            isEmpty = true
            
            
            
        }
        }
        q6IosClientDB.close()
        
        //q6IosClientDB!.close()
        return isEmpty
    }
        
    public  func getUserInfos() ->[String:String]
    {
        var userLoginData = [String:String]()
    let filemgr = NSFileManager.defaultManager()
    let dirPaths = filemgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    
    databasePath = dirPaths[0].URLByAppendingPathComponent("Q6IosClientDB.db").path!
    
    
    let q6IosClientDB = FMDatabase(path: databasePath as String)
        
        if q6IosClientDB.open() {
            let querySQL = "SELECT LoginEmail , PassWord ,PassCode ,CompanyID FROM UserInfos"
            let results : FMResultSet? = q6IosClientDB.executeQuery(querySQL, withArgumentsInArray: nil)
            
            if results?.next() == true {
                
             userLoginData["LoginEmail"] = results?.stringForColumn("LoginEmail")
                userLoginData["PassWord"] = results?.stringForColumn("PassWord")
                  userLoginData["passCode"] = results?.stringForColumn("PassCode")
                userLoginData["CompanyID"] = results?.stringForColumn("CompanyID")
            }
        }
        return userLoginData
    }
    
    public  func validateLoginStatus() ->Bool
    {
        var userLoginData = [String:String]()
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = filemgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        var loginStatus: Bool = false
        
        databasePath = dirPaths[0].URLByAppendingPathComponent("Q6IosClientDB.db").path!
        
        var dd = databasePath as String
        let q6IosClientDB = FMDatabase(path: databasePath as String)
        
        if q6IosClientDB.open() {
            let querySQL = "SELECT LoginStatus FROM UserInfos"
            let results : FMResultSet? = q6IosClientDB.executeQuery(querySQL, withArgumentsInArray: nil)
            
            if results?.next() == true {
                
                if results?.stringForColumn("LoginStatus") == "Login" {
                    loginStatus = true
                }
            
                
            }
        }
        return loginStatus
    }
    
    public  func getUserPassCode() ->String?
    {
        var userPassCode: String? = ""
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = filemgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        databasePath = dirPaths[0].URLByAppendingPathComponent("Q6IosClientDB.db").path!
        
        
        let q6IosClientDB = FMDatabase(path: databasePath as String)
        
        if q6IosClientDB.open() {
            let querySQL = "SELECT PassCode FROM UserInfos"
            let results : FMResultSet? = q6IosClientDB.executeQuery(querySQL, withArgumentsInArray: nil)
            
            if results?.next() == true {
                
                userPassCode = results?.stringForColumn("PassCode")
            
                
            }
        }
        return userPassCode
    }
    
    
  public func editPassCode(PassCode: String) -> Bool {
    
    var isUpdated : Bool = false
    let filemgr = NSFileManager.defaultManager()
    let dirPaths = filemgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    
    databasePath = dirPaths[0].URLByAppendingPathComponent("Q6IosClientDB.db").path!
    
    let q6IosClientDB = FMDatabase(path: databasePath as String)
    
    if q6IosClientDB.open() {
        
        if validateIfTableIsEmpty("UserInfos", Q6IosClientDB: q6IosClientDB) == false {
            
            
            let updateSQL = "UPDATE UserInfos SET PassCode ='\(PassCode)' where ID = 1"
            
            let result = q6IosClientDB.executeUpdate(updateSQL, withArgumentsInArray: nil)
            
            if !result {
                print ("Error: \(q6IosClientDB.lastErrorMessage())")
            } else{
                print ("Sucess: update PassCode")
                isUpdated = true
            }
        }
    }
    else{
        print ("Error: \(q6IosClientDB.lastErrorMessage())")
    }
    q6IosClientDB.close()
    
    

        return isUpdated
    }

public func deleteUserInfos() -> Bool
{
    var isUpdateSuccessed: Bool = false
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = filemgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        databasePath = dirPaths[0].URLByAppendingPathComponent("Q6IosClientDB.db").path!
    
    var dbpathstr = databasePath as String
    print(dbpathstr)
        
        let q6IosClientDB = FMDatabase(path: databasePath as String)
        
        if q6IosClientDB.open() {
            
            if validateIfTableIsEmpty("UserInfos", Q6IosClientDB: q6IosClientDB) == false {
                
                
                let updateSQL = "delete from UserInfos "
                
                let result = q6IosClientDB.executeUpdate(updateSQL, withArgumentsInArray: nil)
                
                if !result {
                    print ("Error: \(q6IosClientDB.lastErrorMessage())")
                } else{
                    print ("Sucess: delete PassCode")
                    isUpdateSuccessed = true
                }
            }
        }
        else{
            print ("Error: \(q6IosClientDB.lastErrorMessage())")
        }
        q6IosClientDB.close()
        
        
        
        return isUpdateSuccessed
    
    }
    
}