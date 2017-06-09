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
        
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        databasePath = dirPaths[0].appendingPathComponent("Q6IosClientDB.db").path as NSString
        
  
        if !filemgr.fileExists(atPath: databasePath as String){
            
            let q6IosClientDB = FMDatabase(path: databasePath as String)
            
           
            if q6IosClientDB == nil {
                print("Error:\(String(describing: q6IosClientDB?.lastErrorMessage()))")
            }
            
            if (q6IosClientDB?.open())!
            {
                
                 if  q6IosClientDB?.tableExists("UserInfos") == false
                 {
                    
                    //LoginStatus has two valude Login ,Logout
                    let sql_stmt = "CREATE TABLE IF NOT EXISTS UserInfos (ID INTEGER  PRIMARY  KEY , LogInEmail,PassWord, LoginStatus,PassCode,CompanyID,LoginFirstName,LoginLastName)"
                    if !(q6IosClientDB?.executeStatements(sql_stmt))!
                    {
                       print("Error:\(String(describing: q6IosClientDB?.lastErrorMessage()))")
                
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
                q6IosClientDB?.close()

            } else {
                print("Error:\(String(describing: q6IosClientDB?.lastErrorMessage()))")
            }
        }
        
    }
    public func addUserInfos(LoginEmail : String,PassWord: String,LoginStatus: String,CompanyID: String,LoginFirstName:String,LoginLastName: String)
    {
        
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        databasePath = dirPaths[0].appendingPathComponent("Q6IosClientDB.db").path as NSString
        
        
        let q6IosClientDB = FMDatabase(path: databasePath as String)
        
        if (q6IosClientDB?.open())! {
            
            if validateIfTableIsEmpty(TableName: "UserInfos", Q6IosClientDB: q6IosClientDB!) == true {
                
            
            let insertSQL = "INSERT INTO UserInfos (ID,LoginEmail,PassWord,LoginStatus,CompanyID,LoginFirstName,LoginLastName) VALUES (1,'\(LoginEmail)' ,'\(PassWord)','Login','\(CompanyID)','\(LoginFirstName)','\(LoginLastName)')"
            
            let result = q6IosClientDB?.executeUpdate(insertSQL, withArgumentsIn: nil)
            
            if !result! {
                print ("Error: \(String(describing: q6IosClientDB?.lastErrorMessage()))")
            } else{
                print ("Sucess: add UserInfos")
            }
            }
        }
        else{
                   print ("Error: \(String(describing: q6IosClientDB?.lastErrorMessage()))")
        }
         q6IosClientDB?.close()
    }
    
    //inside other  open status functions
    public func validateIfTableIsEmpty(TableName: String ,Q6IosClientDB : FMDatabase) -> Bool {
        
        var isEmpty: Bool = true
       
            
        let result = Q6IosClientDB.executeQuery("SELECT COUNT(*) FROM \(TableName)", withArgumentsIn: [])
        if (result?.next())!
        {
            let count = result?.int(forColumnIndex: 0)
            if count! > 0 {
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
   
            let filemgr = FileManager.default
            let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
            
            databasePath = dirPaths[0].appendingPathComponent("Q6IosClientDB.db").path as NSString
            q6IosClientDB  = FMDatabase(path: databasePath as String)
     
        if q6IosClientDB.open() {
        
        
        let result = q6IosClientDB.executeQuery("SELECT COUNT(*) FROM \(TableName)", withArgumentsIn: [])
        if (result?.next())!
        {
            let count = result?.int(forColumnIndex: 0)
            if count! > 0 {
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
    let filemgr = FileManager.default
    let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
    
    databasePath = dirPaths[0].appendingPathComponent("Q6IosClientDB.db").path as NSString
    
    
    let q6IosClientDB = FMDatabase(path: databasePath as String)
        
        if (q6IosClientDB?.open())! {
            let querySQL = "SELECT LoginEmail , PassWord ,PassCode ,CompanyID ,LoginFirstName,LoginLastName FROM UserInfos"
            let results : FMResultSet? = q6IosClientDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            if results?.next() == true {
                
             userLoginData["LoginEmail"] = results?.string(forColumn: "LoginEmail")
                userLoginData["PassWord"] = results?.string(forColumn: "PassWord")
                  userLoginData["passCode"] = results?.string(forColumn: "PassCode")
                userLoginData["CompanyID"] = results?.string(forColumn: "CompanyID")
                userLoginData["LoginFirstName"] = results?.string(forColumn: "LoginFirstName")
                    userLoginData["LoginLastName"] = results?.string(forColumn: "LoginLastName")
            }
        }
        return userLoginData
    }
    
    public  func validateLoginStatus() ->Bool
    {
//        var userLoginData = [String:String]()
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        var loginStatus: Bool = false
        
        databasePath = dirPaths[0].appendingPathComponent("Q6IosClientDB.db").path as NSString
        
        let dd = databasePath as String
        let q6IosClientDB = FMDatabase(path: dd)
        
        if (q6IosClientDB?.open())! {
            let querySQL = "SELECT LoginStatus FROM UserInfos"
            let results : FMResultSet? = q6IosClientDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            if results?.next() == true {
                
                if results?.string(forColumn: "LoginStatus") == "Login" {
                    loginStatus = true
                }
            
                
            }
        }
        return loginStatus
    }
    
    public  func getUserPassCode() ->String?
    {
        var userPassCode: String? = ""
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        databasePath = dirPaths[0].appendingPathComponent("Q6IosClientDB.db").path as NSString
        
        let q6IosClientDB = FMDatabase(path: databasePath as String)
        
        if (q6IosClientDB?.open())! {
            let querySQL = "SELECT PassCode FROM UserInfos"
            let results : FMResultSet? = q6IosClientDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            if results?.next() == true {
                
                userPassCode = results?.string(forColumn: "PassCode")
            }
        }
        return userPassCode
    }
    
    
  public func editPassCode(PassCode: String) -> Bool {
    
    var isUpdated : Bool = false
    let filemgr = FileManager.default
    let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
    
    databasePath = dirPaths[0].appendingPathComponent("Q6IosClientDB.db").path as NSString
    
    let q6IosClientDB = FMDatabase(path: databasePath as String)
    
    if (q6IosClientDB?.open())! {
        
        if validateIfTableIsEmpty(TableName: "UserInfos", Q6IosClientDB: q6IosClientDB!) == false {
            
            
            let updateSQL = "UPDATE UserInfos SET PassCode ='\(PassCode)' where ID = 1"
            
            let result = q6IosClientDB?.executeUpdate(updateSQL, withArgumentsIn: nil)
            
            if !result! {
                print ("Error: \(String(describing: q6IosClientDB?.lastErrorMessage()))")
            } else{
                print ("Sucess: update PassCode")
                isUpdated = true
            }
        }
    }
    else{
        print ("Error: \(String(describing: q6IosClientDB?.lastErrorMessage()))")
    }
    q6IosClientDB?.close()
    
    

        return isUpdated
    }

public func deleteUserInfos() -> Bool
{
    var isUpdateSuccessed: Bool = false
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        databasePath = dirPaths[0].appendingPathComponent("Q6IosClientDB.db").path as NSString
    
    let dbpathstr = databasePath as String
    print(dbpathstr)
        
        let q6IosClientDB = FMDatabase(path: databasePath as String)
        
        if (q6IosClientDB?.open())! {
            
            if validateIfTableIsEmpty(TableName: "UserInfos", Q6IosClientDB: q6IosClientDB!) == false {
                
                
                let updateSQL = "delete from UserInfos "
                
                let result = q6IosClientDB?.executeUpdate(updateSQL, withArgumentsIn: nil)
                
                if !result! {
                    print ("Error: \(String(describing: q6IosClientDB?.lastErrorMessage()))")
                } else{
                    print ("Sucess: delete PassCode")
                    isUpdateSuccessed = true
                }
            }
        }
        else{
            print ("Error: \(String(describing: q6IosClientDB?.lastErrorMessage()))")
        }
        q6IosClientDB?.close()
        
        
        
        return isUpdateSuccessed
    
    }
    
}
