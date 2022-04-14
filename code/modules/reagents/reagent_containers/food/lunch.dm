var/global/list/lunchables_lunches_ = list(
									/obj/item/reagent_containers/food/snacks/sandwich,
									/obj/item/reagent_containers/food/snacks/slice/meatbread/filled,
									/obj/item/reagent_containers/food/snacks/slice/tofubread/filled,
									/obj/item/reagent_containers/food/snacks/slice/creamcheesebread/filled,
									/obj/item/reagent_containers/food/snacks/slice/margherita/filled,
									/obj/item/reagent_containers/food/snacks/slice/meatpizza/filled,
									/obj/item/reagent_containers/food/snacks/slice/mushroompizza/filled,
									/obj/item/reagent_containers/food/snacks/slice/vegetablepizza/filled,
									/obj/item/reagent_containers/food/snacks/tastybread,
									/obj/item/reagent_containers/food/snacks/liquidfood,
									/obj/item/reagent_containers/food/snacks/jellysandwich/cherry,
									/obj/item/reagent_containers/food/snacks/tossedsalad,
									/obj/item/reagent_containers/food/snacks/vegetablesoup,
									/obj/item/reagent_containers/food/snacks/plainsteak
								  )

var/global/list/lunchables_snacks_ = list(
									/obj/item/reagent_containers/food/snacks/donut/jelly,
									/obj/item/reagent_containers/food/snacks/donut/cherryjelly,
									/obj/item/reagent_containers/food/snacks/muffin,
									/obj/item/reagent_containers/food/snacks/popcorn,
									/obj/item/reagent_containers/food/snacks/sosjerky,
									/obj/item/reagent_containers/food/snacks/no_raisin,
									/obj/item/reagent_containers/food/snacks/spacetwinkie,
									/obj/item/reagent_containers/food/snacks/cheesiehonkers,
									/obj/item/reagent_containers/food/snacks/poppypretzel,
									/obj/item/reagent_containers/food/snacks/carrotfries,
									/obj/item/reagent_containers/food/snacks/candiedapple,
									/obj/item/reagent_containers/food/snacks/applepie,
									/obj/item/reagent_containers/food/snacks/cherrypie,
									/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit,
									/obj/item/reagent_containers/food/snacks/appletart,
									/obj/item/reagent_containers/food/snacks/slice/carrotcake/filled,
									/obj/item/reagent_containers/food/snacks/slice/cheesecake/filled,
									/obj/item/reagent_containers/food/snacks/slice/plaincake/filled,
									/obj/item/reagent_containers/food/snacks/slice/orangecake/filled,
									/obj/item/reagent_containers/food/snacks/slice/limecake/filled,
									/obj/item/reagent_containers/food/snacks/slice/lemoncake/filled,
									/obj/item/reagent_containers/food/snacks/slice/chocolatecake/filled,
									/obj/item/reagent_containers/food/snacks/slice/birthdaycake/filled,
									/obj/item/reagent_containers/food/snacks/watermelonslice,
									/obj/item/reagent_containers/food/snacks/slice/applecake/filled,
									/obj/item/reagent_containers/food/snacks/slice/pumpkinpie/filled,
									/obj/item/reagent_containers/food/snacks/skrellsnacks,
									/obj/item/reagent_containers/food/snacks/venus,
									/obj/item/reagent_containers/food/snacks/lunacake,
									/obj/item/reagent_containers/food/snacks/mars
								   )

var/global/list/lunchables_drinks_ = list(
									/obj/item/reagent_containers/food/drinks/cans/cola,
									/obj/item/reagent_containers/food/drinks/cans/cola_apple,
									/obj/item/reagent_containers/food/drinks/cans/cola_orange,
									/obj/item/reagent_containers/food/drinks/cans/cola_grape,
									/obj/item/reagent_containers/food/drinks/cans/cola_lemonlime,
									/obj/item/reagent_containers/food/drinks/cans/cola_strawberry,
									/obj/item/reagent_containers/food/drinks/cans/cola_diet,
									/obj/item/reagent_containers/food/drinks/cans/vanillacola,
									/obj/item/reagent_containers/food/drinks/cans/cherrycola,
									/obj/item/reagent_containers/food/drinks/cans/orangecola,
									/obj/item/reagent_containers/food/drinks/cans/coffeecola,
									/obj/item/reagent_containers/food/drinks/cans/waterbottle,
									/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind,
									/obj/item/reagent_containers/food/drinks/cans/dr_gibb,
									/obj/item/reagent_containers/food/drinks/cans/ionbru,
									/obj/item/reagent_containers/food/drinks/cans/space_up,
									/obj/item/reagent_containers/food/drinks/cans/lemon_lime,
									/obj/item/reagent_containers/food/drinks/cans/iced_tea,
									/obj/item/reagent_containers/food/drinks/cans/grape_juice,
									/obj/item/reagent_containers/food/drinks/cans/tonic,
									/obj/item/reagent_containers/food/drinks/cans/sodawater,
									/obj/item/reagent_containers/food/drinks/cans/rootbeer
								   )

// This default list is a bit different, it contains items we don't want
var/global/list/lunchables_drink_reagents_ = list(
											/datum/reagent/drink,
											/datum/reagent/drink/nothing,
											/datum/reagent/drink/doctor_delight,
											/datum/reagent/drink/dry_ramen,
											/datum/reagent/drink/hell_ramen,
											/datum/reagent/drink/hot_ramen,
											/datum/reagent/drink/nuka_cola
										)

// This default list is a bit different, it contains items we don't want
var/global/list/lunchables_ethanol_reagents_ = list(
												/datum/reagent/ethanol,
												/datum/reagent/ethanol/bilk,
												/datum/reagent/ethanol/acid_spit,
												/datum/reagent/ethanol/atomicbomb,
												/datum/reagent/ethanol/beepsky_smash,
												/datum/reagent/ethanol/coffee,
												/datum/reagent/ethanol/hippies_delight,
												/datum/reagent/ethanol/hooch,
												/datum/reagent/ethanol/thirteenloko,
												/datum/reagent/ethanol/manhattan_proj,
												/datum/reagent/ethanol/neurotoxin,
												/datum/reagent/ethanol/pwine,
												/datum/reagent/ethanol/threemileisland,
												/datum/reagent/ethanol/toxins_special,
												/datum/reagent/ethanol/alien/qokkloa,
												/datum/reagent/ethanol/alien/qokkhrona,
												/datum/reagent/ethanol/iridast
											)

/proc/lunchables_lunches()
	if(!(lunchables_lunches_[lunchables_lunches_[1]]))
		lunchables_lunches_ = init_lunchable_list(lunchables_lunches_)
	return lunchables_lunches_

/proc/lunchables_snacks()
	if(!(lunchables_snacks_[lunchables_snacks_[1]]))
		lunchables_snacks_ = init_lunchable_list(lunchables_snacks_)
	return lunchables_snacks_

/proc/lunchables_drinks()
	if(!(lunchables_drinks_[lunchables_drinks_[1]]))
		lunchables_drinks_ = init_lunchable_list(lunchables_drinks_)
	return lunchables_drinks_

/proc/lunchables_drink_reagents()
	if(!(lunchables_drink_reagents_[lunchables_drink_reagents_[1]]))
		lunchables_drink_reagents_ = init_lunchable_reagent_list(lunchables_drink_reagents_, /datum/reagent/drink)
	return lunchables_drink_reagents_

/proc/lunchables_ethanol_reagents()
	if(!(lunchables_ethanol_reagents_[lunchables_ethanol_reagents_[1]]))
		lunchables_ethanol_reagents_ = init_lunchable_reagent_list(lunchables_ethanol_reagents_, /datum/reagent/ethanol)
	return lunchables_ethanol_reagents_

/proc/init_lunchable_list(var/list/lunches)
	. = list()
	for(var/lunch in lunches)
		var/obj/O = lunch
		.[initial(O.name)] = lunch
	return sortAssoc(.)

/proc/init_lunchable_reagent_list(var/list/banned_reagents, var/reagent_types)
	. = list()
	for(var/reagent_type in subtypesof(reagent_types))
		if(reagent_type in banned_reagents)
			continue
		var/datum/reagent/reagent = reagent_type
		.[initial(reagent.name)] = reagent_type
	return sortAssoc(.)
