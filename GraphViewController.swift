//
//  GraphViewController.swift
//  Calculator2.0
//
//  Created by Connor Fitzpatrick on 3/10/16.
//  Copyright © 2016 Connor Fitzpatrick. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

//phoneview = 0,0; 0,200; 200,0; 200,200
//graphview = -10,0; 10,0; 0,10; 0,-10
//phoneview/graphview = scale  (10)
//x coor = scale * graphpoint + phoneviewmax/2
//y coor = scale * (graphpoint * -1) + phoneviewmax/2
   
//pinching will change scale factor
    
//ex.
    //phoneview = 300x300
    //graphview = -15 margins
    //scale = 10
    //150
    //10 * 10 + 150
    //10 * (-5 * -1) + 150
    //(10,-5) -> (250, 200)
    
    
    //Graph View Controller needs set up... See Psychologist??
    //Is the segue set up correctly?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController
        }
        if let gvc = destination as? GraphViewController {
            //gvc.scale = scalemath
            
            }
        }
    //use graph segue??

    //let equation = CalculatorBrain.history()
    
    @IBOutlet weak var equation: UILabel!
    
    var rect = CGRect(
        origin: CGPoint(x: 100, y: 100),
        size: UIScreen.mainScreen().bounds.size
    )
    var center = CGPoint(x: 100, y: 100)
    var float = CGFloat(10)
    
    func graphme() {
        let A = AxesDrawer()
        
        equation.text = "y = mx + b"
        A.drawAxesInRect(rect, origin: center, pointsPerUnit: float)
    }
}


