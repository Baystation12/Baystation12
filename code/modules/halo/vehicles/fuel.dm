
#define REFILL_SUCCEED -1
#define REFILL_FAIL -2

/datum/fuel
	var/name = "Fuel"

	var/list/volume = list(0,100) //Current / Maximum

/datum/fuel/fusion
	name = "Fusion Fuel"

	volume = list(100,100)

/datum/fuel/proc/attempt_refill(var/amount)
	var/potential_volume = volume[1] + amount
	if(potential_volume > volume[2]) //Used when refilling to make sure we don't set the fuel in the giving object to 0 whilst hitting the vehicle's fuel cap.
		volume [1] = volume[2]
		return (potential_volume - volume[2])
	else if(potential_volume < 0) //Ensuring we don't set the fuel to negative levels.
		return REFILL_FAIL
	else
		volume[1] = potential_volume //No other issues, so we can set the fuel level.
		return REFILL_SUCCEED

/datum/fuel/proc/drain_fuel(var/amount)
	return attempt_refill(-amount)

/obj/item/fuel_item
	name = "Fuel Item"

	var/contained_fuel = newlist()//A list of fuel datums that this canister contains.

/obj/item/fuel_item/debug
	name = "Fuel Item - Debug"

	contained_fuel = newlist(/datum/fuel/fusion)
