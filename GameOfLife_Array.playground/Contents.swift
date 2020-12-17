import UIKit
import PlaygroundSupport

struct Grid
{
    /// Size of the grid in cells
    var size = (width: 50, height: 50)
    
    /// Dead/Alive cells for current generation
    var cells:[[Int]]
    
    /// Initialize `cells` with 2D array of zeroes of width/height
    init() {
        self.cells = Array(repeating: Array(repeating: 0, count: size.height), count: size.width)
    }
    
    /// Inserts cells into the current grid at coordinate (useful for adding gliders etc.)
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
    
    /// Computes the next generation of Game of Life
    mutating func generation()
    {
        // Initialize 2D array of zeroes of width/height
        var nextCells = Array(repeating: Array(repeating: 0, count: size.height), count: size.width)
        
        // For each x,y cell in grid, check if stays alive
        for x in 0..<size.width {
            for y in 0..<size.height {
                if staysAlive(x, y, isAlive: cells[x][y] == 1) {
                    nextCells[x][y] = 1
                }
            }
        }
        
        // Overwrite `cells` with next generation
        cells = nextCells
    }
    
    /// Determines if a cell stays alive, based on current generation
    func staysAlive(_ x: Int, _ y: Int, isAlive: Bool) -> Bool
    {
        // Number of alive neighbors
        var count = 0
        
        // Matrix of neighbors around current cell
        let pairs = [
            [-1,-1], [0,-1], [1,-1],
            [-1, 0],         [1, 0],
            [-1, 1], [0, 1], [1, 1]
        ]
        
        // For each neighbor around current cell
        for pair in pairs
        {
            // Get actual x,y coord in width/height
            let xd = x + pair[0]
            let yd = y + pair[1]
            
            // If neighbor is within bounds and alive
            if  xd >= 0 && yd >= 0 &&
                xd < size.width && yd < size.height &&
                cells[xd][yd] == 1 {
                
                count += 1
            }
        }
        
        if isAlive && (count == 2 || count == 3) {
            // Live cell with 2 or 3 neighbors -> LIVES
            return true
        } else if !isAlive && count == 3 {
            // Dead cell with 3 neighbors -> LIVES
            return true
        }
        
        // Underpopulation, overpopulation
        return false
    }
}

/// Factory of cell configurations – x/y rotated -90 deg
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
    
    // Gosper's glider gun FTW!
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
    
    /// Generates random cells of size/size
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
    
        // Clear drawing rectangle
        context.clear(CGRect(x: 0.0, y: 0.0, width: bounds.width, height: bounds.height))
        
        // Fill with white background
        context.setFillColor(UIColor.white.cgColor)
        context.addRect(CGRect(x: 0.0, y: 0.0, width: bounds.width, height: bounds.height))
        context.fillPath()
        
        // Determine size of square cell based on grid width/height
        let cellSize = (width: bounds.width / CGFloat(grid.size.width), height: bounds.height / CGFloat(grid.size.height))
        
        // Draw sqaures with black
        context.setFillColor(UIColor.black.cgColor)
        
        // Loop over each x/y in grid, if alive, draw rect
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

// Runs playground indefinitely
PlaygroundPage.current.needsIndefiniteExecution = true

// Add `gridView` to playground live view
let gridView = GridView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
PlaygroundPage.current.liveView = gridView

// Insert a bunch of cells
gridView.grid.insertCells(Factory.glider(), at: (x: 2, y: 2))
gridView.grid.insertCells(Factory.glider(), at: (x: 10, y: 10))
gridView.grid.insertCells(Factory.blinker(), at: (x: 5, y: 10))
gridView.grid.insertCells(Factory.random(size: 20), at: (x: 20, y: 20))

// Create timer on default serial background queue
let timer = DispatchSource.makeTimerSource()
timer.schedule(deadline: .now(), repeating: .milliseconds(500))
timer.setEventHandler(handler: {
    
    // Calculate next generation
    gridView.grid.generation()
    
    // Show grid on main thread
    DispatchQueue.main.async {
        gridView.setNeedsDisplay()
    }
})

// Starts the timer/queue
timer.activate()
