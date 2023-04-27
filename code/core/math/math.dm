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
