/* A 2D vector datum with overloaded operators and other common functions.
*/

vector2
	var x, y

	/* Takes 2 numbers or a vector2 to copy.
	*/
	New(x = 0, y = 0)
		..()
		if(isnum(x)) if(!isnum(y)) y = x

		else if(istype(x, /vector2))
			var vector2/v = x
			x = v.x
			y = v.y

		else CRASH("Invalid args.")

		src.x = x
		src.y = y

	proc
		/* Equivalence checking. Compares components exactly.
		*/
		operator~=(vector2/v) return v ? x == v.x && y == v.y : FALSE

		/* Vector addition.
		*/
		operator+(vector2/v) return v ? new/vector2(x + v.x, y + v.y) : src

		/* Vector subtraction and negation.
		*/
		operator-(vector2/v) return v ? new/vector2(x - v.x, y - v.y) : new/vector2(-x, -y)

		/* Vector scaling.
		*/
		operator*(s)
			// Scalar
			if(isnum(s)) return new/vector2(x * s, y * s)

			// Transform
			else if(istype(s, /matrix))
				var matrix/m = s
				return new/vector2(x * m.a + y * m.b + m.c, x * m.d + y * m.e + m.f)

			// Component-wise
			else if(istype(s, /vector2))
				var vector2/v = s
				return new/vector2(x * v.x, y * v.y)

			else CRASH("Invalid args.")

		/* Vector inverse scaling.
		*/
		operator/(d)
			// Scalar
			if(isnum(d)) return new/vector2(x / d, y / d)

			// Inverse transform
			else if(istype(d, /matrix)) return src * ~d

			// Component-wise
			else if(istype(d, /vector2))
				var vector2/v = d
				return new/vector2(x / v.x, y / v.y)

			else CRASH("Invalid args.")

		/* Vector dot product.
			Returns the cosine of the angle between the vectors.
		*/
		Dot(vector2/v) return x * v.x + y * v.y

		/* Z-component of the 3D cross product.
			Returns the sine of the angle between the vectors.
		*/
		Cross(vector2/v) return x * v.y - y * v.x

		/* Square of the magnitude of the vector.
			Commonly used for comparing magnitudes more efficiently than with Magnitude.
		*/
		SquareMagnitude() return Dot(src)

		/* Magnitude of the vector.
		*/
		Magnitude() return hypot(x, y)

		/* Get a vector in the same direction but with magnitude m.
			Be careful about dividing by zero. This won't work with the zero vector.
		*/
		ToMagnitude(m)
			if(isnum(m)) return src * (m / Magnitude())
			else CRASH("Invalid args.")

		/* Get a vector in the same direction but with magnitude 1.
		*/
		Normalized() return ToMagnitude(1)

		/* Convert the vector to text with a specified number of significant figures.
		*/
		ToText(SigFig) return "vector2([num2text(x, SigFig)], [num2text(y, SigFig)])"

		/* Get the components via index (1, 2) or name ("x", "y").
		*/
		operator[](index)
			switch(index)
				if(1, "x") return x
				if(2, "y") return y
				else CRASH("Invalid args.")

		/* Get the matrix that rotates north to point in this direction.
			This can be used as the transform of an atom whose icon is drawn pointing north.
		*/
		Rotation() return RotationFrom(Vector2.North)

		/* Get the matrix that rotates from_vector to point in this direction.
			This can be used as the transform of an atom whose icon is drawn pointing in the direction of from_vector.
			Also accepts a dir.
		*/
		RotationFrom(vector2/from_vector = Vector2.North)
			var vector2/to_vector = Normalized()

			if(isnum(from_vector)) from_vector = Vector2.FromDir(from_vector)

			if(istype(from_vector, /vector2))
				from_vector = from_vector.Normalized()
				var
					cos_angle = to_vector.Dot(from_vector)
					sin_angle = to_vector.Cross(from_vector)
				return matrix(cos_angle, sin_angle, 0, -sin_angle, cos_angle, 0)

			else CRASH("Invalid 'from' vector.")

		/* Get a vector with the same magnitude rotated by a clockwise angle in degrees.
		*/
		Turn(angle) return src * matrix().Turn(angle)
