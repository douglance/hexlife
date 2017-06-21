/**
* Copyright (c) 2016 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import SpriteKit
import GameplayKit

func randNearby(_ x:Int) -> (Int){
	let rand = Int(arc4random_uniform(UInt32(2)))
	var y = Int()
	switch rand {
	case 1:
		y = 1
	case 2:
		y = -1
	default:
		y = 0
	}
	if x + y > 99 {
		return 99
	} else if x + y < 0 {
		return 0
	}
	return x + y
	
}


extension Array where Element == Int {
	/// Returns the sum of all elements in the array
	var total: Element {
		return reduce(0, +)
	}
	/// Returns the average of all elements in the array
	var average: Double {
		return isEmpty ? 0 : Double(reduce(0, +)) / Double(count)
	}
}



class GameScene: SKScene {
	
	var background:SKTileMapNode!
	var foreground:SKTileMapNode!
	var genes : [[DNA]] = Array(repeating: Array(repeating: DNA(), count: 102), count: 102)
	
	override func didMove(to view: SKView) {
		loadSceneNodes()
		setupObjects()
	}
	
	
	func loadSceneNodes() {
		
		guard let background = childNode(withName: "background")
			as? SKTileMapNode else {
				fatalError("Background node not loaded")
		}
		self.background = background
		
	}
	
	
	func setupObjects() {
	
		let columns = 100
		let rows = 100
		let size = CGSize(width: 32, height: 32)
		let factor = 100
		var tiles = [SKTileGroup]()
		
		for row in 1...rows {
			for column in 1...columns {
				genes[row][column] = DNA()
				tiles.append(genes[row][column].group)
				genes[row][column].coords.append(x: row, y: column)
			}
		}
		
		let hexPoint = SKTileSetType(rawValue: 3)
		let tileSet = SKTileSet(tileGroups: tiles, tileSetType: hexPoint!)
		foreground = SKTileMapNode(tileSet: tileSet,
		                           columns: columns,
		                           rows: rows,
		                           tileSize: size,
		                           tileGroupLayout:tiles)
		addChild(foreground)
		
	}
	
	func powerBattle(row: Int, column: Int){
		
		func fight(first: DNA, second: DNA){
			if first > second {
				var count = Int(arc4random_uniform(UInt32(1000)))
				for (x,y) in second.coords {
					if count > 0 {
					print("\(first.group): \((x,y)) Power: \(first.power)")
					foreground.setTileGroup(first.group, forColumn: y, row: x)
					first.coords.append((x,y))
					genes[x][y] = first
					first.power += 1
					count -= 1
					}
				}
				
			} else if second > first {
				fight(first: second, second: first)
				
			}
			
		}
		
		let rowRand = randNearby(row)
		let columnRand = randNearby(column)
		let genes1 = genes[row][column]
		let genes2 = genes[rowRand][columnRand]
		
		if genes1.group != genes2.group {
			fight(first:genes1, second: genes2)
		}
//		else {
//			let child = DNA(father: genes1, mother: genes2)
////			if let group = child.group {
//			foreground.setTileGroup(child.group, andTileDefinition: child.tileDef, forColumn: column, row: row)
////			let item = (row,column)
////			func == (lhs: item, rhs: item) -> Bool {
////				
////			}
////			if let index = genes1.coords.index(of: item){
////				genes1.coords.remove(at: index)
////			}
//
//			print(child.color)
//			child.coords.append((row,column))
//
//		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
	}
	
	override func update(_ currentTime: TimeInterval) {
		for _ in 0...100 {
			let x = Int(arc4random_uniform(UInt32(foreground.numberOfRows)))
			let y = Int(arc4random_uniform(UInt32(foreground.numberOfColumns)))
			powerBattle(row: randNearby(x) ,column: randNearby(y))
		}
	}
	
}
