/datum/vector2
	var/x = 0
	var/y = 0


/datum/vector2/New(x = 0, y = 0)
	if (istext(x))
		var/text = x
		var/size = length(text)
		if (size < 5 || text[1] != "<" || text[size] != ">")
			throw EXCEPTION("Invalid vector2 text: [text]")
		var/list/parts = splittext(copytext(text, 2, size), ",")
		if (length(parts) != 2)
			throw EXCEPTION("Invalid vector2 text: [text]")
		x = text2num(trimtext(parts[1]))
		y = text2num(trimtext(parts[2]))
		if (!isfinite(x) || !isfinite(y))
			throw EXCEPTION("Invalid vector2 text: [text]")
	src.x = x
	src.y = y


/datum/vector2/proc/operator~=(datum/vector2/other)
	return other && x == other.x && y == other.y


/* spacemandmm 1.5.1 doesn't know this overload
/datum/vector2/proc/operator~!(datum/vector2/other)
	return !other || x != other.x || y != other.y
*/


/datum/vector2/proc/operator>=(datum/vector2/other)
	return SquareMagnitude() >= other.SquareMagnitude()


/datum/vector2/proc/operator>(datum/vector2/other)
	return SquareMagnitude() > other.SquareMagnitude()


/datum/vector2/proc/operator<(datum/vector2/other)
	return SquareMagnitude() < other.SquareMagnitude()


/datum/vector2/proc/operator<=(datum/vector2/other)
	return SquareMagnitude() <= other.SquareMagnitude()


/datum/vector2/proc/operator+=(datum/vector2/other)
	x += other.x
	y += other.y


/datum/vector2/proc/operator-=(datum/vector2/other)
	x -= other.x
	y -= other.y


/datum/vector2/proc/operator*=(datum/vector2/other)
	if (isnum(other))
		x *= other
		y *= other
	else
		x *= other.x
		y *= other.y


/* spacemandmm 1.5.1 doesn't know this overload
/datum/vector2/proc/operator/=(datum/vector2/other)
	if (isnum(other))
		x /= other
		y /= other
	else
		x /= other.x
		y /= other.y
*/


/* spacemandmm 1.5.1 doesn't know this overload
/datum/vector2/proc/operator:=(datum/vector2/other)
	return new /datum/vector2 (other.x, other.y)
*/


/datum/vector2/proc/operator+(datum/vector2/other)
	return new /datum/vector2 (x + other.x, y + other.y)


/datum/vector2/proc/operator-(datum/vector2/other)
	if (!other)
		return new /datum/vector2 (-x, -y)
	return new /datum/vector2 (x - other.x, y - other.y)


/datum/vector2/proc/operator*(datum/vector2/other)
	if (isnum(other))
		return new /datum/vector2 (x * other, y * other)
	return new /datum/vector2 (x * other.x, y * other.y)


/datum/vector2/proc/operator/(datum/vector2/other)
	if (isnum(other))
		return new /datum/vector2 (x / other, y / other)
	return new /datum/vector2 (x / other.x, y / other.y)


/* 515
/datum/vector2/proc/operator""()
	return ToText()
*/


/datum/vector2/proc/ToText()//515 as text
	return "<[x],[y]>"


/datum/vector2/proc/SquareMagnitude()//515 as num
	return x * x + y * y


/datum/vector2/proc/Magnitude()//515 as num
	var/squareMagnitude = SquareMagnitude()
	if (squareMagnitude)
		return sqrt(squareMagnitude)
	return 0


/datum/vector2/proc/Normal()//515 as /datum/vector3
	var/magnitude = Magnitude()
	return src / magnitude


/datum/vector2/proc/Normalize()//515 as /datum/vector3
	var/datum/vector3/normal = Normal()
	x = normal.x
	y = normal.y
	return src
