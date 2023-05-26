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


/**
Sample t(0..1) into a quadratic binomial polynomial.
Generally this is useful for shaping rand() distribution.
see tools/polyvis.html for a parameter picker.
*/
/proc/poly_interp2(t, p0, p1, p2)
	var/mt = 1 - t
	return p0 * mt * mt +\
		2 * p1 * mt * t +\
		p2 * t * t

/**
Sample t(0..1) into a cubic binomial polynomial.
Generally this is useful for shaping rand() distribution.
see tools/polyvis.html for a parameter picker.
More expensive than poly_interp2.
*/
/proc/poly_interp3(t, p0, p1, p2, p3)
	var/t2 = t * t
	var/mt = 1 - t
	var/mt2 = mt * mt
	return p0 * mt2 * mt +\
		3 * p1 * mt2 * t +\
		3 * p2 * mt * t2 +\
		p3 * t2 * t

/**
Sample t(0..1) into a quartic binomial polynomial.
Generally this is useful for shaping rand() distribution.
see tools/polyvis.html for a parameter picker.
More expensive than poly_interp3.
*/
/proc/poly_interp4(t, p0, p1, p2, p3, p4)
	var/t2 = t * t
	var/t3 = t2 * t
	var/mt = 1 - t
	var/mt2 = mt * mt
	var/mt3 = mt2 * mt
	return p0 * mt3 * mt +\
		4 * p1 * mt3 * t +\
		6 * p2 * mt2 * t2 +\
		4 * p3 * mt * t3 +\
		p4 * t3 * t
