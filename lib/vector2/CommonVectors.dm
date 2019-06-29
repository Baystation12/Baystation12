/* Common vectors.
	Make sure you don't modify these vectors.
	You should treat all vectors as immutable in general.
*/
var Vector2/Vector2 = new

Vector2
	var
		vector2
			Zero = new(0, 0)
			One = new(1, 1)
			North = new(0, 1)
			South = new(0, -1)
			East = new(1, 0)
			West = new(-1, 0)
			Northeast = new(sqrt(1/2), sqrt(1/2))
			Northwest = new(-sqrt(1/2), sqrt(1/2))
			Southeast = new(sqrt(1/2), -sqrt(1/2))
			Southwest = new(-sqrt(1/2), -sqrt(1/2))

	proc
		FromDir(dir)
			switch(dir)
				if(NORTH) return North
				if(SOUTH) return South
				if(EAST) return East
				if(WEST) return West
				if(NORTHEAST) return Northeast
				if(SOUTHEAST) return Southeast
				if(NORTHWEST) return Northwest
				if(SOUTHWEST) return Southwest
				else CRASH("Invalid direction.")
