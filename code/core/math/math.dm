var/global/const/POSITIVE_INFINITY = 1#INF // win: 1.#INF, lin: inf

var/global/const/NEGATIVE_INFINITY = -1#INF // win: -1.#INF, lin: -inf

//var/const/POSITIVE_NAN = -(1#INF/1#INF) // win: 1.#QNAN, lin: nan -- demonstration of creation, but not useful

//var/const/NEGATIVE_NAN = (1#INF/1#INF) //win: -1.#IND, lin: -nan -- demonstration of creation, but not useful

/// Multiplier for converting degrees to radians, rounded to 10 places
var/global/const/DEG_TO_RAD = 0.0174532925

/// Multiplier for converting radians to degrees, rounded to 10 places
var/global/const/RAD_TO_DEG = 57.295779513

/// The mathematical constant pi, rounded to 10 places
var/global/const/PI = 3.1415926536

/// Twice the mathematical constant pi, rounded to 10 places
var/global/const/TWO_PI = 6.2831853072

/// Half the mathematical constant pi, rounded to 10 places
var/global/const/HALF_PI = 1.5707963268


/// True if number is a number that is not nan or an infinity.
/proc/isfinite(number)
	return isnum(number) && !isnan(number) && !isinf(number)


/*
cbrand - random numbers fitted to a 1d cubic bezier curve

Samples the "height" at distance t (0..1) into the otherwise
dimensionless parametric curve along p0 -> p1 -> p2 -> p3,
each also mostly 0..1 if you want to be safe.

Generally this is useful only for creating complex distribution
patterns.

See tools/cbrand-visualizer.html for a handy parameter picker.

See https://pomax.github.io/bezierinfo for more spicy curves ;)
*/
/proc/cbrand(p0, p1, p2, p3, t = rand())
	var/t2 = t * t
	var/t3 = t2 * t
	return p0 + (-p0 * 3 + t * (3 * p0 - p0 * t)) * t \
		+ (3 * p1 + t * (-6 * p1 + p1 * 3 * t)) * t \
		+ (p2 * 3 - p2 * 3 * t) * t2 \
		+ p3 * t3
