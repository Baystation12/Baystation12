/// A random real number between low and high inclusive
#define Frand(low, high) ( rand() * ((high) - (low)) + (low) )


/// Value or the next multiple of divisor in a positive direction. Ceilm(-1.5, 0.3) = -1.5 , Ceilm(-1.5, 0.4) = -1.2
#define Ceilm(value, divisor) ( -round(-(value) / (divisor)) * (divisor) )


/// Value or the nearest power of power in a positive direction: Ceilp(3, 2) = 4 , Ceilp(5, 3) = 9
#define Ceilp(value, power) ( (power) ** -round(-log((power), (value))) )


/// Value or the next multiple of divisor in a negative direction: Floorm(-1.5, 0.3) = -1.5 , Floorm(-1.5, 0.4) = -1.6
#define Floorm(value, divisor) ( round((value) / (divisor)) * (divisor) )


/// Value or the nearest integer in either direction
#define Round(value) round((value), 1)


/// Value or the nearest multiple of divisor in either direction
#define Roundm(value, divisor) round((value), (divisor))


/// The percentage of value in max, rounded to places: 1 = nearest 0.1 , 0 = nearest 1 , -1 = nearest 10, etc
#define Percent(value, max, places) round((value) / (max) * 100, !(places) || 10 ** -(places))


/// True if value is an integer number.
#define IsInteger(value) (round(value) == (value))


//NB: Not actually truly all powers of 2 but this behavior is currently expected
/// True if value is a non-negative integer that is 0 or has a single bit set. 0, 1, 2, 4, 8 ...
#define IsPowerOfTwo(value) ( IsInteger(value) && !((value) & ((value) - 1)) )


/// True if value is an integer that is not zero and does not have the 1 bit set
#define IsEven(value) ( (value) && IsPowerOfTwo(value) )


/// True if value is an integer that has the 1 bit set.
#define IsOdd(value) ( IsInteger(value) && ((value) & 0x1) )


/// True if value is a multiple of divisor
#define IsMultiple(value, divisor) ((value) % (divisor) == 0)


/// True if value is between low and high inclusive
#define IsInRange(value, low, high) ( (value) >= (low) && (value) <= (high) )


/// The cosecant of degrees
#define Csc(degrees) (1 / sin(degrees))


/// The secant of degrees
#define Sec(degrees) (1 / cos(degrees))


/// The cotangent of degrees
#define Cot(degrees) (1 / tan(degrees))


/// The 2-argument arctangent of x and y
/proc/Atan2(x, y)
	if (!x && !y)
		return 0
	var/a = arccos(x / sqrt(x * x + y * y))
	return y >= 0 ? a : -a


/// Returns a linear interpolation from a to b according to weight. weight 0 is a, weight 1 is b, weight 0.5 is half-way between the two.
/proc/Interpolate(a, b, weight = 0.5)
	return a + (b - a) * weight


/// Returns the mean of either a list or variadic arguments: Mean(list(1, 2, 3)) = 2 , Mean(1, 2, 3) = 2
/proc/Mean(...)
	var/list/values = args
	if (islist(values[1]))
		values = values[1]
	var/sum = 0
	if (length(values))
		for (var/value in values)
			sum += value
		sum /= length(values)
	return sum


/// Returns the euclidian square magnitude of a vector of either a list or variadic arguments: VecSquareMag(list(1, 2, 3)) = 14 , VecSquareMag(1, 2, 3) = 14
/proc/VecSquareMag(...)
	var/list/parts = args
	if (islist(parts[1]))
		parts = parts[1]
	var/sum = 0
	for (var/part in parts)
		sum += part * part
	return sum


/// Returns the euclidian magnitude of a vector of either a list or variadic arguments: VecMag(list(3, 4)) = 5 , VecMag(3, 4) = 5
/proc/VecMag(...)
	var/squareMag = VecSquareMag(arglist(args))
	return sqrt(squareMag)


/// Returns a random real from an arbitrary XdY dice roll
/proc/Drand(x, y, normalize)
	var/sum = 0
	for (var/i = 1 to x)
		sum += floor(rand() * y)
	if (normalize)
		return sum / ((x * y) - x)
	return sum + x


/// An aproximate, fairly granular random normal real number in 0..1
#define Nrand Drand(4, 6, TRUE)


/// A circular random coordinate pair from 0, unit by default, scaled by radius, then rounded if round.
/proc/CircularRandomCoordinate(radius = 1, round)
	RETURN_TYPE(/list)
	var/angle = rand(0, 359)
	var/x = cos(angle) * radius
	var/y = sin(angle) * radius
	if (round)
		x = Round(x)
		y = Round(y)
	return list(x, y)


/**
* A circular random coordinate with radius on center_x, center_y,
* reflected into low_x,low_y -> high_x,high_y, clamped in low,high,
* and rounded if round is set
*
* Generally this proc is useful for placement around a point (eg a
* player) that must stay within map boundaries, or some similar circle
* in box constraint
*
* A "donut" pattern can be achieved by varying the number supplied as
* radius outside the scope of the proc, eg as BoundedCircularRandomCoordinate(Frand(1, 3), ...)
*/
/proc/BoundedCircularRandomCoordinate(radius, center_x, center_y, low_x, low_y, high_x, high_y, round)
	RETURN_TYPE(/list)
	var/list/xy = CircularRandomCoordinate(radius, round)
	var/dx = xy[1]
	var/dy = xy[2]
	var/x = center_x + dx
	var/y = center_y + dy
	if (x < low_x || x > high_x)
		x = center_x - dx
	if (y < low_y || y > high_y)
		y = center_y - dy
	return list(
		clamp(x, low_x, high_x),
		clamp(y, low_y, high_y)
	)


/// Pick a random turf using BoundedCircularRandomCoordinate about x,y on level z
/proc/CircularRandomTurf(radius, z, center_x, center_y, low_x = 1, low_y = 1, high_x = world.maxx, high_y = world.maxy)
	RETURN_TYPE(/turf)
	var/list/xy = BoundedCircularRandomCoordinate(radius, center_x, center_y, low_x, low_y, high_x, high_y, TRUE)
	return locate(xy[1], xy[2], z)


/// Pick a random turf using BoundedCircularRandomCoordinate around the turf of target
/proc/CircularRandomTurfAround(atom/target, radius, low_x = 1, low_y = 1, high_x = world.maxx, high_y = world.maxy)
	RETURN_TYPE(/turf)
	var/turf/turf = get_turf(target)
	return CircularRandomTurf(radius, turf.z, turf.x, turf.y, low_x, low_y, high_x, high_y)


/// Returns the angle of the matrix according to atan2 on the b, a parts
/matrix/proc/get_angle()
	return Atan2(b, a)


/// Roll a Y sided die X times, producing either a sum result or list of rolls.
/proc/xdy(x, y, as_list)
	var/result = 0
	if (as_list)
		result = list()
	x = max(1, round(x))
	y = max(1, round(y))
	for (var/i = 1 to x)
		result += rand(1, y)
	return result


/// Generate a random number from min to max on a sigma^2 = 1 gaussian distribution.
/proc/grand(min = 0, max = 1)
	var/static/generator/gauss = generator("num", 0, 1, NORMAL_RAND)
	return min + gauss.Rand() * (max - min)

/proc/gaussian(mean=0, stddev=1)
	var/u1 = rand()
	var/u2 = rand()
	var/z0 = sqrt(-2 * log(u1)) * cos(2 * PI * u2)
	return z0 * stddev + mean


/proc/rangedGaussian(min=0, max=1, mean=0, stddev=1)
	var/final_temp = min + rand() * (max - min)

	for (var/runs = 1 to 10)
		var/temp = gaussian(mean, stddev)

		if (temp < min || temp > max)
			continue
		final_temp = temp
		break

	return final_temp

/proc/skewedGaussian(min=0, max=1, skew=1)
	var/final_temp = min + rand() * (max - min)

	for (var/runs = 1 to 10)
		var/temp = gaussian() ** skew
		temp = temp * (max - min) + min

		if (temp < min || temp > max)
			continue

		final_temp = temp
		break

	return final_temp

/proc/Wrap(val, min, max)
	var/d = max - min
	var/t = round((val - min) / d)
	return val - (t * d)


/proc/MakeGenerator(g_type, g_min, g_max, g_rand = UNIFORM_RAND)
	switch (g_rand)
		if (1)
			g_rand = NORMAL_RAND
		if (2)
			g_rand = LINEAR_RAND
		if (3)
			g_rand = SQUARE_RAND
		else
			g_rand = UNIFORM_RAND

	if (!isnum(g_min) || !isnum(g_max))
		return null

	return generator(g_type, g_min, g_max, g_rand)
