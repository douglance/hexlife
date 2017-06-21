//
//  Tile.swift
//  RDRescue
//
//  Created by Doug Lance on 6/3/17.
//  Copyright © 2017 Caroline Begbie. All rights reserved.
//
//
import Foundation
import SpriteKit


public extension UIImage {
	public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
		let rect = CGRect(origin: .zero, size: size)
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		color.setFill()
		UIRectFill(rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		guard let cgImage = image?.cgImage else { return nil }
		self.init(cgImage: cgImage)
	}
}

extension UIColor {
	
	func add(overlay: UIColor) -> UIColor {
		var bgR: CGFloat = 0
		var bgG: CGFloat = 0
		var bgB: CGFloat = 0
		var bgA: CGFloat = 0
		
		var fgR: CGFloat = 0
		var fgG: CGFloat = 0
		var fgB: CGFloat = 0
		var fgA: CGFloat = 0
		
		self.getRed(&bgR, green: &bgG, blue: &bgB, alpha: &bgA)
		overlay.getRed(&fgR, green: &fgG, blue: &fgB, alpha: &fgA)
		
		let r = fgA * fgR + (1 - fgA) * bgR
		let g = fgA * fgG + (1 - fgA) * bgG
		let b = fgA * fgB + (1 - fgA) * bgB
		
		return UIColor(red: r, green: g, blue: b, alpha: 1.0)
	}
}

func +(lhs: UIColor, rhs: UIColor) -> UIColor {
	return lhs.add(overlay: rhs)
}


class DNA {
	let size = CGSize(width: 32, height: 32)
	let factor = 100
	
	
	init(father: DNA, mother: DNA) {
		self.color = father.color + mother.color
		let image = UIImage(color: color, size: size)
		let texture = SKTexture(image: image!)
		tileDef = SKTileDefinition(texture: texture, size: size)
		self.group = father.group
		self.power = (father.power + mother.power)/2
			
		

	}
	
	init() {
		
		let rand1 = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
		let rand2 = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
		let rand3 = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
		let rand4 = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
		let power = Int(arc4random_uniform(UInt32(factor)))
		color = UIColor(red: rand1, green: rand2, blue: rand3, alpha: 1)
		let image = UIImage(color: color, size: size)
		
		if let img = image {
			
			let texture = SKTexture(image: img)
			let newDef = SKTileDefinition(texture: texture, size: size)
			let newGroup = SKTileGroup(tileDefinition: newDef)
				
			self.group = newGroup
			self.power = power

		}
	}
	
	var tileDef = SKTileDefinition()
	var color = UIColor()
	var power = Int()
	var group = SKTileGroup()
	var coords = [(x: Int, y: Int)]()
	
}

func mutation(_ x:Int) -> (Int){
	let rand = Int(arc4random_uniform(UInt32(2)))
	switch rand {
	case 1:
		return Int(Double(x) * 1.2)
	case 2:
		return Int(Double(x) * 0.8)
	default:
		return x
	}
}




//func mate(male: DNA, female: DNA) -> (DNA){
//	let child = DNA()
//	child.power = mutation((male.power + female.power)/2)
//	return child
//
//}

//func mateString(male: String, female: String) -> String {
//	
//	let len = Int(male.characters.count)
//
//	let randos = male + female
//	let randoLen = Int(arc4random_uniform(UInt32(randos.characters.count)))
//	var childString = ""
//	
//	for x in 0 ..< len {
//		let randMate = Int(arc4random_uniform(2))
//		if randMate == 1 {
//			childString = childString + male[x]
//		} else if randMate == 2 {
//			childString = childString + female[x]
//		} else {
//			childString = childString + randos[randoLen]
//		}
//	}
//	
//	return childString
//}


extension DNA: Equatable {
	static func == (lhs: DNA, rhs: DNA) -> Bool {
		return lhs.power == rhs.power
	}
}

extension DNA: Comparable{
	static func < (lhs: DNA, rhs: DNA) -> Bool {
		return lhs.power < rhs.power
	}
}

extension String {
	
	subscript (i: Int) -> Character {
		return self[index(startIndex, offsetBy: i)]
	}
	
	subscript (i: Int) -> String {
		return String(self[i] as Character)
	}
	
	subscript (r: Range<Int>) -> String {
		let start = index(startIndex, offsetBy: r.lowerBound)
		let end = index(startIndex, offsetBy: r.upperBound - r.lowerBound)
		return self[Range(start ..< end)]
	}
}
