//
//  Business.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class Business: NSObject {
  let name: String?
  let address: String?
  let imageURL: NSURL?
  let categories: String?
  let distance: String?
  let ratingImageURL: NSURL?
  let reviewCount: NSNumber?
  let hasDeal: Bool!
  let location: Location!
  
  init(dictionary: NSDictionary) {
    name = dictionary["name"] as? String
    
    let imageURLString = dictionary["image_url"] as? String
    if imageURLString != nil {
      imageURL = NSURL(string: imageURLString!)!
    } else {
      imageURL = nil
    }
    
    let location = dictionary["location"] as? NSDictionary
    var address = ""
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    
    if location != nil {
      let addressArray = location!["address"] as? NSArray
      if addressArray != nil && addressArray!.count > 0 {
        address = addressArray![0] as! String
      }
      
      let neighborhoods = location!["neighborhoods"] as? NSArray
      if neighborhoods != nil && neighborhoods!.count > 0 {
        if !address.isEmpty {
          address += ", "
        }
        address += neighborhoods![0] as! String
      }
      
      latitude = (location!["coordinate"]!["latitude"] as? CLLocationDegrees)!
      longitude = (location!["coordinate"]!["longitude"] as? CLLocationDegrees)!
    }
    self.address = address
    
    let categoriesArray = dictionary["categories"] as? [[String]]
    if categoriesArray != nil {
      var categoryNames = [String]()
      for category in categoriesArray! {
        let categoryName = category[0]
        categoryNames.append(categoryName)
      }
      categories = categoryNames.joinWithSeparator(", ")
    } else {
      categories = nil
    }
    
    let distanceMeters = dictionary["distance"] as? NSNumber
    if distanceMeters != nil {
      // let milesPerMeter = 0.000621371
      // distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
      distance = String(format: "%.2f km", distanceMeters!.doubleValue/1000)
    } else {
      distance = nil
    }
    
    let ratingImageURLString = dictionary["rating_img_url_large"] as? String
    if ratingImageURLString != nil {
      ratingImageURL = NSURL(string: ratingImageURLString!)
    } else {
      ratingImageURL = nil
    }
    
    self.hasDeal = dictionary["deals"] == nil ? false : true
    
    reviewCount = dictionary["review_count"] as? NSNumber
    
    self.location = Location(title: name!, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), info: address)
  }
  
  class func businesses(array array: [NSDictionary]) -> [Business] {
    var businesses = [Business]()
    for dictionary in array {
      let business = Business(dictionary: dictionary)
      businesses.append(business)
    }
    return businesses
  }
  
  class func searchWithTerm(term: String, completion: ([Business]!, NSError!) -> Void) {
    YelpClient.sharedInstance.searchWithTerm(term, completion: completion)
  }
  
  class func searchWithTerm(term: String, sort: YelpSortMode?, distance: Int?, categories: [String]?, deals: Bool?, starting: Int?, completion: ([Business]!, NSError!) -> Void) -> Void {
    YelpClient.sharedInstance.searchWithTerm(term, sort: sort, distance: distance, categories: categories, deals: deals, starting: starting, completion: completion)
  }
}
