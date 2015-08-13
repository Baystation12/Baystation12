// Macro functions.
#define RAND_F(LOW, HIGH) (rand()*(HIGH-LOW) + LOW)

/proc/Clamp(val, min, max)
	return max(min, min(val, max))

// min is inclusive, max is exclusive
/proc/Wrap(val, min, max)
	var/d = max - min
	var/t = Floor((val - min) / d)
	return val - (t * d)

/proc/Default(a, b)
	return a ? a : b

// Trigonometric functions.
/proc/Tan(x)
	return sin(x) / cos(x)

/proc/Cot(x)
	return 1 / Tan(x)

/proc/Atan2(x, y)
	if(!x && !y) return 0
	var/a = arccos(x / sqrt(x*x + y*y))
	return y >= 0 ? a : -a

/proc/IsInteger(x)
	return round(x) == x

/proc/IsMultiple(x, y)
	return x % y == 0

/proc/ToDegrees(radians)
	// 180 / Pi ~ 57.2957795
	return radians * 57.2957795

/proc/IsPowerOfTwo(var/val)
    return (val & (val-1)) == 0

/proc/RoundUpToPowerOfTwo(var/val)
    return 2 ** ceil(log(2,val))

/proc/sign(x)
	return x!=0?x/abs(x):0
