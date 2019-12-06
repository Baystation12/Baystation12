/*
	You cannot call built-in BYOND methods directly using call()(), hence these helpers
*/

/proc/prob_call(var/probability)
	return prob(probability)
