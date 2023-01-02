/datum/vector3
	var/x = 0
	var/y = 0
	var/z = 0


/datum/vector3/New(x = 0, y = 0, z = 0)
	if (istext(x))
		var/text = x
		var/size = length(text)
		if (size < 7 || text[1] != "<" || text[size] != ">")
			throw EXCEPTION("Invalid vector3 text: [text]")
		var/list/parts = splittext(copytext(text, 2, size), ",")
		if (length(parts) != 3)
			throw EXCEPTION("Invalid vector3 text: [text]")
		x = text2num(trimtext(parts[1]))
		y = text2num(trimtext(parts[2]))
		z = text2num(trimtext(parts[3]))
		if (!isfinite(x) || !isfinite(y) || !isfinite(z))
			throw EXCEPTION("Invalid vector3 text: [text]")
	src.x = x
	src.y = y
	src.z = z


/datum/vector3/proc/operator~=(datum/vector3/other)
	return other && x == other.x && y == other.y && z == other.z


/* spacemandmm 1.5.1 doesn't know this overload
/datum/vector3/proc/operator~!(datum/vector3/other)
	return !other || x != other.x || y != other.y && z != other.z
*/


/datum/vector3/proc/operator>=(datum/vector3/other)
	return SquareMagnitude() >= other.SquareMagnitude()


/datum/vector3/proc/operator>(datum/vector3/other)
	return SquareMagnitude() > other.SquareMagnitude()


/datum/vector3/proc/operator<(datum/vector3/other)
	return SquareMagnitude() < other.SquareMagnitude()


/datum/vector3/proc/operator<=(datum/vector3/other)
	return SquareMagnitude() <= other.SquareMagnitude()


/datum/vector3/proc/operator+=(datum/vector3/other)
	x += other.x
	y += other.y
	z += other.z


/datum/vector3/proc/operator-=(datum/vector3/other)
	x -= other.x
	y -= other.y
	z -= other.z


/datum/vector3/proc/operator*=(datum/vector3/other)
	if (isnum(other))
		x *= other
		y *= other
		z *= other
	else
		x *= other.x
		y *= other.y
		z *= other.z


/* spacemandmm 1.5.1 doesn't know this overload
/datum/vector3/proc/operator/=(datum/vector3/other)
	if (isnum(other))
		x /= other
		y /= other
		z /= other
	else
		x /= other.x
		y /= other.y
		z /= other.z
*/


/* spacemandmm 1.5.1 doesn't know this overload
/datum/vector3/proc/operator:=(datum/vector3/other)
	return new /datum/vector3 (other.x, other.y, other.z)
*/


/datum/vector3/proc/operator+(datum/vector3/other)
	return new /datum/vector3 (x + other.x, y + other.y, z + other.z)


/datum/vector3/proc/operator-(datum/vector3/other)
	if (!other)
		return new /datum/vector3 (-x, -y, -z)
	return new /datum/vector3 (x - other.x, y - other.y, z - other.z)


/datum/vector3/proc/operator*(datum/vector3/other)
	if (isnum(other))
		return new /datum/vector3 (x * other, y * other, z * other)
	return new /datum/vector3 (x * other.x, y * other.y, z * other.z)


/datum/vector3/proc/operator/(datum/vector3/other)
	if (isnum(other))
		return new /datum/vector3 (x / other, y / other, z / other)
	return new /datum/vector3 (x / other.x, y / other.y, z / other.z)


/* 515
/datum/vector3/proc/operator""()
	return ToText()
*/


/datum/vector3/proc/ToText()//515 as text
	return "<[x],[y],[z]>"


/datum/vector3/proc/SquareMagnitude()//515 as num
	return x * x + y * y + z * z


/datum/vector3/proc/Magnitude()//515 as num
	var/squareMagnitude = SquareMagnitude()
	if (squareMagnitude)
		return sqrt(squareMagnitude)
	return 0


/datum/vector3/proc/Normal()//515 as /datum/vector3
	var/magnitude = Magnitude()
	return src / magnitude


/datum/vector3/proc/Normalize()//515 as /datum/vector3
	var/datum/vector3/normal = Normal()
	x = normal.x
	y = normal.y
	z = normal.y
	return src
