//
//  DBMenuViewController.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 12.12.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit
import SQLite

extension MenuViewController{
    
    func createTable_groups(){
        
        let createTable = self.groupsTable.create{ (table) in
            table.column(self.id_groups, primaryKey: true)
            table.column(self.name_groups)
            table.column(self.user_id_groups)
        }
        
        do{ try database.run(createTable)  }catch{print(error)}
        
    }
    
    func insert_groups(_group: Group){
        
        let insertGroup = self.groupsTable.insert(self.id_groups <- _group.id, self.name_groups <- _group.name, self.user_id_groups <- _group.user_id)
        
        do{ try database.run(insertGroup)  }catch{print(error)}
        
    }
    
    func list_groups(){
        groupsArray.removeAll()
        do{
            let groups = try database.prepare(self.groupsTable)
            for group in groups{
                let myGroup = Group()
                myGroup.id = group[self.id_groups]
                myGroup.name = group[self.name_groups]
                myGroup.user_id = group[self.user_id_groups]
                groupsArray.append(myGroup)
                print(myGroup.id)
            }
        }
        catch{
            print(error)
        }
        
    }
    
    func update_groups(_group: Group){
        
        let currentGroup = self.groupsTable.filter(self.id_groups == _group.id)
        let updateGroup = currentGroup.update(self.name_groups <- _group.name)
        do{ try database.run(updateGroup)  } catch{print(error)}
        
    }
    
    func delete_groups(_group: Group){
        
        let currentGroup = self.groupsTable.filter(self.id_groups == _group.id)
        let deleteGroup = currentGroup.delete()
        do{ try database.run(deleteGroup)  }catch{print(error)}
        
    }
    
    func truncateTable_groups(){
        
        let dropTable = self.groupsTable.drop()
        do{ try database.run(dropTable)  }catch{print(error)}
        createTable_groups()
        
    }
    
    func createTable_tags(){
        
        let createTable = self.tagsTable.create{ (table) in
            table.column(self.id_tags, primaryKey: true)
            table.column(self.name_tags)
            table.column(self.user_id_tags)
        }
        
        do{ try database.run(createTable)  }catch{print(error)}
        
    }
    
    func insert_tags(_tag: Tag){
        
        let insertTag = self.tagsTable.insert(self.id_tags <- _tag.id, self.name_tags <- _tag.name, self.user_id_tags <- _tag.user_id)
        
        do{ try database.run(insertTag)  }catch{print(error)}
        
    }
    
    func list_tags(){
        tagsArray.removeAll()
        do{
            let tags = try database.prepare(self.tagsTable)
            for tag in tags{
                let myTag = Tag()
                myTag.id = tag[self.id_tags]
                myTag.name = tag[self.name_tags]
                myTag.user_id = tag[self.user_id_tags]
                tagsArray.append(myTag)
            }
        }
        catch{
            print(error)
        }
        
    }
    
    func update_tags(_tag: Tag){
        
        let currentTag = self.tagsTable.filter(self.id_tags == _tag.id)
        let updateTag = currentTag.update(self.name_tags <- _tag.name)
        do{ try database.run(updateTag)  } catch{print(error)}
        
    }
    
    func delete_tags(_tag: Tag){
        
        let currentTag = self.tagsTable.filter(self.id_tags == _tag.id)
        let deleteTag = currentTag.delete()
        do{ try database.run(deleteTag)  }catch{print(error)}
        
    }
    
    func truncateTable_tags(){
        
        let dropTable = self.tagsTable.drop()
        do{ try database.run(dropTable)  }catch{print(error)}
        createTable_tags()
        
    }
    
}
