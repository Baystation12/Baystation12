var/list/lunchables_lunches_ = list(/obj/item/weapon/reagent_containers/food/snacks/sandwich,
                                  /obj/item/weapon/reagent_containers/food/snacks/meatbreadslice,
                                  /obj/item/weapon/reagent_containers/food/snacks/tofubreadslice,
                                  /obj/item/weapon/reagent_containers/food/snacks/creamcheesebreadslice,
                                  /obj/item/weapon/reagent_containers/food/snacks/margheritaslice,
                                  /obj/item/weapon/reagent_containers/food/snacks/meatpizzaslice,
                                  /obj/item/weapon/reagent_containers/food/snacks/mushroompizzaslice,
                                  /obj/item/weapon/reagent_containers/food/snacks/vegetablepizzaslice,
                                  /obj/item/weapon/reagent_containers/food/snacks/tastybread,
                                  /obj/item/weapon/reagent_containers/food/snacks/liquidfood,
                                  /obj/item/weapon/reagent_containers/food/snacks/jellysandwich/cherry,
                                  /obj/item/weapon/reagent_containers/food/snacks/tossedsalad)

var/list/lunchables_snacks_ = list(/obj/item/weapon/reagent_containers/food/snacks/donut/jelly,
                                   /obj/item/weapon/reagent_containers/food/snacks/donut/cherryjelly,
                                   /obj/item/weapon/reagent_containers/food/snacks/muffin,
                                   /obj/item/weapon/reagent_containers/food/snacks/popcorn,
                                   /obj/item/weapon/reagent_containers/food/snacks/sosjerky,
                                   /obj/item/weapon/reagent_containers/food/snacks/no_raisin,
                                   /obj/item/weapon/reagent_containers/food/snacks/spacetwinkie,
                                   /obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers,
                                   /obj/item/weapon/reagent_containers/food/snacks/poppypretzel,
                                   /obj/item/weapon/reagent_containers/food/snacks/carrotfries,
                                   /obj/item/weapon/reagent_containers/food/snacks/candiedapple,
                                   /obj/item/weapon/reagent_containers/food/snacks/applepie,
                                   /obj/item/weapon/reagent_containers/food/snacks/cherrypie,
                                   /obj/item/weapon/reagent_containers/food/snacks/plumphelmetbiscuit,
                                   /obj/item/weapon/reagent_containers/food/snacks/appletart,
                                   /obj/item/weapon/reagent_containers/food/snacks/carrotcakeslice,
                                   /obj/item/weapon/reagent_containers/food/snacks/cheesecakeslice,
                                   /obj/item/weapon/reagent_containers/food/snacks/plaincakeslice,
                                   /obj/item/weapon/reagent_containers/food/snacks/orangecakeslice,
                                   /obj/item/weapon/reagent_containers/food/snacks/limecakeslice,
                                   /obj/item/weapon/reagent_containers/food/snacks/lemoncakeslice,
                                   /obj/item/weapon/reagent_containers/food/snacks/chocolatecakeslice,
                                   /obj/item/weapon/reagent_containers/food/snacks/birthdaycakeslice,
                                   /obj/item/weapon/reagent_containers/food/snacks/watermelonslice,
                                   /obj/item/weapon/reagent_containers/food/snacks/applecakeslice,
                                   /obj/item/weapon/reagent_containers/food/snacks/pumpkinpieslice,
                                   /obj/item/weapon/reagent_containers/food/snacks/skrellsnacks)

var/list/lunchables_drinks_ = list(/obj/item/weapon/reagent_containers/food/drinks/cans/cola,
                                   /obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle,
                                   /obj/item/weapon/reagent_containers/food/drinks/cans/space_mountain_wind,
                                   /obj/item/weapon/reagent_containers/food/drinks/cans/dr_gibb,
                                   /obj/item/weapon/reagent_containers/food/drinks/cans/starkist,
                                   /obj/item/weapon/reagent_containers/food/drinks/cans/space_up,
                                   /obj/item/weapon/reagent_containers/food/drinks/cans/lemon_lime,
                                   /obj/item/weapon/reagent_containers/food/drinks/cans/iced_tea,
                                   /obj/item/weapon/reagent_containers/food/drinks/cans/grape_juice,
                                   /obj/item/weapon/reagent_containers/food/drinks/cans/tonic,
                                   /obj/item/weapon/reagent_containers/food/drinks/cans/sodawater)

// This default list is a bit different, it contains items we don't want
var/list/lunchables_drink_reagents_ = list(/datum/reagent/drink/nothing,
                                           /datum/reagent/drink/doctor_delight,
                                           /datum/reagent/drink/dry_ramen,
                                           /datum/reagent/drink/hell_ramen,
                                           /datum/reagent/drink/hot_ramen,
                                           /datum/reagent/drink/nuka_cola,)

// This default list is a bit different, it contains items we don't want
var/list/lunchables_ethanol_reagents_ = list(/datum/reagent/ethanol/acid_spit,
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
                                             /datum/reagent/ethanol/toxins_special)

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
		.[initial(reagent.name)] = initial(reagent.id)
	return sortAssoc(.)
