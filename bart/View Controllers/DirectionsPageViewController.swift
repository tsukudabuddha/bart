//
//  DirectionsPageViewController.swift
//  bart
//
//  Created by Andrew Tsukuda on 3/11/18.
//  Copyright © 2018 Andrew Tsukuda. All rights reserved.
//

// Page View Stuff https://medium.com/how-to-swift/how-to-create-a-uipageviewcontroller-a948047fb6af

import UIKit

class DirectionsPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var trips: [Trip]? = nil
    var allStations: [Station]? = nil
    
    fileprivate lazy var pages: [DirectionsViewController] = {
        return [
            self.getViewController(withIdentifier: "directionsVC", index: 0),
            self.getViewController(withIdentifier: "directionsVC", index: 1),
            self.getViewController(withIdentifier: "directionsVC", index: 2),
            self.getViewController(withIdentifier: "directionsVC", index: 3)
        ]
        }() as! [DirectionsViewController]
    
    fileprivate func getViewController(withIdentifier identifier: String, index: Int) -> UIViewController
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier) as! DirectionsViewController
        vc.trip = self.trips?[index] ?? Trip(fare: "Broken", departingTime: "Broken", arrivalTime: "Broken", legs: [], travelTime: "Broken")
        vc.allStations = allStations
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dataSource = self
        self.delegate = self
        
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController as! DirectionsViewController) else { return nil }
    
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return pages.last }
        guard pages.count > previousIndex else { return nil        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = pages.index(of: viewController as! DirectionsViewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return pages.first }
        guard pages.count > nextIndex else { return nil }
        
        return pages[nextIndex]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
