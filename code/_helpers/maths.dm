/// Multiplier for converting degrees to radians
#define DEG_TO_RAD 0.0174532925


/// Multiplier for converting radians to degrees
#define RAD_TO_DEG 57.2957795


/// A random real number between low and high inclusive
#define Frand(low, high) ( rand() * ((high) - (low)) + (low) )


/// Value or the next integer in a positive direction: Ceil(-1.5) = -1 , Ceil(1.5) = 2
#define Ceil(value) ( -round(-(value)) )


/// Value or the next multiple of divisor in a positive direction. Ceilm(-1.5, 0.3) = -1.5 , Ceilm(-1.5, 0.4) = -1.2
#define Ceilm(value, divisor) ( -round(-(value) / (divisor)) * (divisor) )


/// Value or the nearest power of power in a positive direction: Ceilp(3, 2) = 4 , Ceilp(5, 3) = 9
#define Ceilp(value, power) ( (power) ** -round(-log((power), (value))) )


/// Value or the next integer in a negative direction: Floor(-1.5) = -2 , Floor(1.5) = 1
#define Floor(value) round(value)


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
	if (values.len)
		for (var/value in values)
			sum += value
		sum /= values.len
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


/// Returns the angle of the matrix according to atan2 on the b, a parts
/matrix/proc/get_angle()
	return Atan2(b, a)
