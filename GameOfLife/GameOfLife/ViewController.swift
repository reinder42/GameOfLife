//
//  ViewController.swift
//  GameOfLife
//
//  Created by Reinder de Vries on 17/12/2020.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet var gridView:GridView?
    @IBOutlet var countLabel:UILabel?
    var count = 0
    
    var timer:DispatchSourceTimer?
    
    var isTimerRunning = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        gridView?.layer.borderWidth = 2
        gridView?.layer.borderColor = UIColor.gray.cgColor
        
        countLabel?.text = "0"
        
        gridView?.grid.insertCells(Factory.gun(), at: (x: 1, y: 1))
        
        /*gridView?.grid.insertCells(Factory.glider(), at: (x: 2, y: 2))
        gridView?.grid.insertCells(Factory.glider(), at: (x: 10, y: 10))
        gridView?.grid.insertCells(Factory.blinker(), at: (x: 5, y: 10))
        gridView?.grid.insertCells(Factory.random(size: 20), at: (x: 20, y: 20))*/
    }
    
    @IBAction func start()
    {
        guard isTimerRunning == false else {
            return
        }
        
        isTimerRunning = true
        
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: .now(), repeating: .milliseconds(250))
        timer?.setEventHandler(handler: {
            
            self.gridView?.grid.generation()
            self.count += 1
            
            DispatchQueue.main.async {
                self.gridView?.setNeedsDisplay()
                self.countLabel?.text = "\(self.count)"
            }
        })
        
        timer?.activate()
    }
    
    @IBAction func stop()
    {
        timer?.cancel()
        timer = nil
        isTimerRunning = false
    }
}

