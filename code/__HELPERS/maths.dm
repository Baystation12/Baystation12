// Credits to Nickr5 for the useful procs I've taken from his library resource.

var/const/E		= 2.71828183
var/const/Sqrt2	= 1.41421356


/proc/Atan2(x, y)
	if(!x && !y) return 0
	var/a = arccos(x / sqrt(x*x + y*y))
	return y >= 0 ? a : -a

/proc/Ceiling(x)
	return -round(-x)

/proc/Clamp(val, min, max)
	return max(min, min(val, max))

// cotangent
/proc/Cot(x)
	return 1 / Tan(x)

// cosecant
/proc/Csc(x)
	return 1 / sin(x)

/proc/Default(a, b)
	return a ? a : b

/proc/Floor(x)
	return round(x)

// Greatest Common Divisor - Euclid's algorithm
/proc/Gcd(a, b)
	return b ? Gcd(b, a % b) : a

/proc/Inverse(x)
	return 1 / x

/proc/IsAboutEqual(a, b, deviation = 0.1)
	return abs(a - b) <= deviation

/proc/IsEven(x)
	return x % 2 == 0

// Returns true if val is from min to max, inclusive.
/proc/IsInRange(val, min, max)
	return min <= val && val <= max

/proc/IsInteger(x)
	return Floor(x) == x

/proc/IsOdd(x)
	return !IsEven(x)

/proc/IsMultiple(x, y)
	return x % y == 0

// Least Common Multiple
/proc/Lcm(a, b)
	return abs(a) / Gcd(a, b) * abs(b)

// Performs a linear interpolation between a and b.
// Note that amount=0 returns a, amount=1 returns b, and
// amount=0.5 returns the mean of a and b.
/proc/Lerp(a, b, amount = 0.5)
	return a + (b - a) * amount

/proc/Mean(...)
	var/values 	= 0
	var/sum		= 0
	for(var/val in args)
		values++
		sum += val
	return sum / values


// Returns the nth root of x.
/proc/Root(n, x)
	return x ** (1 / n)

// secant
/proc/Sec(x)
	return 1 / cos(x)

// The quadratic formula. Returns a list with the solutions, or an empty list
// if they are imaginary.
/proc/SolveQuadratic(a, b, c)
	ASSERT(a)
	. = list()
	var/d		= b*b - 4 * a * c
	var/bottom  = 2 * a
	if(d < 0) return
	var/root = sqrt(d)
	. += (-b + root) / bottom
	if(!d) return
	. += (-b - root) / bottom

// tangent
/proc/Tan(x)
	return sin(x) / cos(x)

/proc/ToDegrees(radians)
				  // 180 / Pi
	return radians * 57.2957795

/proc/ToRadians(degrees)
				  // Pi / 180
	return degrees * 0.0174532925

// min is inclusive, max is exclusive
/proc/Wrap(val, min, max)
	var/d = max - min
	var/t = Floor((val - min) / d)
	return val - (t * d)

//converts a uniform distributed random number into a normal distributed one
//since this method produces two random numbers, one is saved for subsequent calls
//(making the cost negligble for every second call)
//This will return +/- decimals, situated about mean with standard deviation stddev
//68% chance that the number is within 1stddev
//95% chance that the number is within 2stddev
//98% chance that the number is within 3stddev...etc
var/gaussian_next
#define ACCURACY 10000
/proc/gaussian(mean, stddev)
	var/R1;var/R2;var/working
	if(gaussian_next != null)
		R1 = gaussian_next
		gaussian_next = null
	else
		do
			R1 = rand(-ACCURACY,ACCURACY)/ACCURACY
			R2 = rand(-ACCURACY,ACCURACY)/ACCURACY
			working = R1*R1 + R2*R2
		while(working >= 1 || working==0)
		working = sqrt(-2 * log(working) / working)
		R1 *= working
		gaussian_next = R2 * working
	return (mean + stddev * R1)
#undef ACCURACY