//
//  EventListDataProviderProtocol.swift
//  Uevents
//
//  Created by Hansen Phanggestu on 22/05/2016.
//  Copyright © 2016 ThongNguyen. All rights reserved.
//

import UIKit
import CoreData
import AddressBookUI

public protocol PeopleListDataProviderProtocol: UITableViewDataSource {
    var managedObjectContext: NSManagedObjectContext? { get set }
    weak var tableView: UITableView! { get set }
    
 //   func addPerson(Model: Model)
    //  func personForIndexPath(indexPath: NSIndexPath) -> Person?
    func fetch()
}
