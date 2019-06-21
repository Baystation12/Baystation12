/* Adds vector2 support to matrix procs.
*/

matrix
	/* Translate by a vector2.
	*/
	Translate(x, y)
		if(istype(x, /vector2))
			var vector2/v = x
			return ..(v.x, v.y)
		return ..()

	/* Scale by a vector2.
	*/
	Scale(x, y)
		if(istype(x, /vector2))
			var vector2/v = x
			return ..(v.x, v.y)
		return ..()
