import UIKit
import PlaygroundSupport

// Code inspired by:
// https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
// https://en.wikipedia.org/wiki/Glider_(Conway%27s_Life)
// https://blog.scottlogic.com/2014/09/10/game-of-life-in-functional-swift.html
// https://rosettacode.org/wiki/Conway%27s_Game_of_Life#Swift

typealias Point = (x: Int, y: Int)

struct Cell: Hashable {
    var x: Int
    var y: Int
}

struct Grid
{
    var size = (width: 50, height: 50)
    var cells = Set<Cell>()
    
    mutating func insertCells(_ insertedCells: Set<Cell>) {
        cells = cells.union(insertedCells)
    }
    
    func getNeighbors(of cell: Cell) -> Set<Cell>
    {
        let pairs = [
            [-1,-1], [0,-1], [1,-1],
            [-1, 0],         [1, 0],
            [-1, 1], [0, 1], [1, 1]
        ]
        
        var neighbors = Set<Cell>()
        
        for pair in pairs
        {
            let x = cell.x + pair[0]
            let y = cell.y + pair[1]
            
            if x >= 0 && y >= 0 && x < size.width && y < size.height {
                neighbors.insert(Cell(x: x, y: y))
            }
        }
        
        return neighbors
    }
    
    func numberOfNeighbors(of cell: Cell) -> Int
    {
        let neighbors = getNeighbors(of: cell)
        let livingNeighbors = cells.intersection(neighbors)
        
        return livingNeighbors.count
    }
    
    func staysAlive(_ cell: Cell, isAlive: Bool) -> Bool
    {
        let count = numberOfNeighbors(of: cell)
        
        if isAlive && (count == 2 || count == 3) {
            return true
        } else if !isAlive && count == 3 {
            return true
        }
        
        return false
    }
    
    mutating func generation()
    {
        var nextCells = Set<Cell>()
        let neighbors = Set<Cell>(cells.flatMap(getNeighbors(of:)))
        
        // Only looping over neighbors of all cells is faster than
        // looping over each cell in the grid, but there's some
        // double computation going on with 'get living neighbors'
        // and it's slower for a more crowded grid
        
        for cell in neighbors
        {
            let isAlive = cells.contains(cell)
            
            if staysAlive(cell, isAlive: isAlive) {
                nextCells.insert(cell)
            }
        }
        
        cells = nextCells
    }
}

struct Factory
{
    static func glider(offset: Point? = nil) -> Set<Cell>
    {
        return fromGrid([
            [0, 1, 0],
            [0, 0, 1],
            [1, 1, 1],
        ], offset: offset)
    }
    
    static func blinker(offset: Point? = nil) -> Set<Cell>
    {
        return fromGrid([
            [0, 1, 0],
            [0, 1, 0],
            [0, 1, 0],
        ], offset: offset)
    }
    
    static func random(size: Int, offset: Point? = nil) -> Set<Cell>
    {
        var cells = Set<Cell>()
        let odds = 1.0 / 5.0
        
        for x in 0..<size {
            for y in 0..<size {
                if Double.random(in: 0..<1) < odds {
                    cells.insert(Cell(x: x, y: y))
                }
            }
        }
        
        return cells
    }
    
    static func fromGrid(_ grid: [[Int]], offset: Point? = nil) -> Set<Cell>
    {
        var cells = Set<Cell>()
        
        for (y, row) in grid.enumerated() {
            for (x, value) in row.enumerated() {
                if value == 1 {
                    cells.insert(Cell(x: x + (offset?.x ?? 0), y: y + (offset?.y ?? 0)))
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
            
        for cell in grid.cells
        {
            context.setFillColor(UIColor.black.cgColor)
            context.addRect(CGRect(x: CGFloat(cell.x) * cellSize.width, y: CGFloat(cell.y) * cellSize.height, width: cellSize.width, height: cellSize.height))
            context.fillPath()
        }
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true

let gridView = GridView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
PlaygroundPage.current.liveView = gridView

gridView.grid.insertCells(Factory.glider(offset: (x: 2, y: 2)))
gridView.grid.insertCells(Factory.glider(offset: (x: 10, y: 10)))
gridView.grid.insertCells(Factory.blinker(offset: (x: 5, y: 10)))
gridView.grid.insertCells(Factory.random(size: 20, offset: (x: 20, y: 20)))

let timer = DispatchSource.makeTimerSource()
timer.schedule(deadline: .now(), repeating: .milliseconds(200))
timer.setEventHandler(handler: {
    
    gridView.grid.generation()
    
    DispatchQueue.main.async {
        gridView.setNeedsDisplay()
    }
})

timer.activate()
