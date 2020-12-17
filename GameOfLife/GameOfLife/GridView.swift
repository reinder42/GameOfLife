//
//  GridView.swift
//  GameOfLife
//
//  Created by Reinder de Vries on 17/12/2020.
//

import UIKit

struct Grid
{
    var size = (width: 50, height: 50)
    var cells:[[Int]]
    
    init() {
        self.cells = Array(repeating: Array(repeating: 0, count: size.height), count: size.width)
    }
    
    mutating func insertCells(_ insertedCells: [[Int]], at start: (x: Int, y: Int))
    {
        for x in 0..<insertedCells.count {
            for y in 0..<insertedCells[x].count {
                let xd = x + start.x
                let yd = y + start.y
                
                if xd >= 0 && yd >= 0 && xd < size.width && yd < size.height {
                    cells[xd][yd] = insertedCells[x][y]
                }
            }
        }
    }
    
    mutating func generation()
    {
        var nextCells = Array(repeating: Array(repeating: 0, count: size.height), count: size.width)
        
        for x in 0..<size.width {
            for y in 0..<size.height {
                if staysAlive(x, y, isAlive: cells[x][y] == 1) {
                    nextCells[x][y] = 1
                }
            }
        }
        
        cells = nextCells
    }
    
    func staysAlive(_ x: Int, _ y: Int, isAlive: Bool) -> Bool
    {
        var count = 0
        
        let pairs = [
            [-1,-1], [0,-1], [1,-1],
            [-1, 0],         [1, 0],
            [-1, 1], [0, 1], [1, 1]
        ]
        
        for pair in pairs
        {
            let xd = x + pair[0]
            let yd = y + pair[1]
            
            if  xd >= 0 && yd >= 0 &&
                xd < size.width && yd < size.height &&
                cells[xd][yd] == 1 {
                
                count += 1
            }
        }
                
        if isAlive && (count == 2 || count == 3) {
            return true
        } else if !isAlive && count == 3 {
            return true
        }
        
        return false
    }
}

struct Factory
{
    static func glider() -> [[Int]]
    {
        return [
            [0, 1, 0],
            [0, 0, 1],
            [1, 1, 1],
        ]
    }
    
    static func blinker() -> [[Int]]
    {
        return [
            [0, 1, 0],
            [0, 1, 0],
            [0, 1, 0],
        ]
    }
    
    static func gun() -> [[Int]]
    {
        return [
            [0, 0, 0, 0, 1, 1, 0, 0, 0, 0],
            [0, 0, 0, 0, 1, 1, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 1, 1, 1, 0, 0, 0],
            [0, 0, 0, 1, 0, 0, 0, 1, 0, 0],
            [0, 0, 1, 0, 0, 0, 0, 0, 1, 0],
            [0, 0, 1, 0, 0, 0, 0, 0, 1, 0],
            [0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
            [0, 0, 0, 1, 0, 0, 0, 1, 0, 0],
            [0, 0, 0, 0, 1, 1, 1, 0, 0, 0],
            [0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 1, 1, 1, 0, 0, 0, 0, 0],
            [0, 0, 1, 1, 1, 0, 0, 0, 0, 0],
            [0, 1, 0, 0, 0, 1, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [1, 1, 0, 0, 0, 1, 1, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 1, 1, 0, 0, 0, 0, 0, 0],
            [0, 0, 1, 1, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        ]
    }
    
    static func random(size: Int) -> [[Int]]
    {
        var cells = Array(repeating: Array(repeating: 0, count: size), count: size)
        let odds = 1.0 / 5.0
        
        for x in 0..<size {
            for y in 0..<size {
                if Double.random(in: 0..<1) < odds {
                    cells[x][y] = 1
                }
            }
        }
        
        return cells
    }
}

class GridView: UIView
{
    var grid = Grid()
    
    override func draw(_ rect: CGRect)
    {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
                
        context.clear(CGRect(x: 0.0, y: 0.0, width: bounds.width, height: bounds.height))
        
        context.setFillColor(UIColor.white.cgColor)
        context.addRect(CGRect(x: 0.0, y: 0.0, width: bounds.width, height: bounds.height))
        context.fillPath()
        
        let cellSize = (width: bounds.width / CGFloat(grid.size.width), height: bounds.height / CGFloat(grid.size.height))
        
        context.setFillColor(UIColor.black.cgColor)
        
        for x in 0..<grid.size.width {
            for y in 0..<grid.size.height {
                if grid.cells[x][y] == 1 {
                    context.addRect(CGRect(x: CGFloat(x) * cellSize.width, y: CGFloat(y) * cellSize.height, width: cellSize.width, height: cellSize.height))
                    context.fillPath()
                }
            }
        }
    }
}
