/atom/proc/Value(var/base)
	return base

/obj/Value()
	. = ..()
	for(var/a in contents)
		. += get_value(a)

/obj/machinery/Value()
	. = ..()
	if(stat & BROKEN)
		. *= 0.5
	. = round(.)

/obj/structure/barricade/Value()
	return material.value

/obj/structure/bed/Value()
	return ..() * material.value

/obj/item/slime_extract/Value(var/base)
	return base * Uses

/obj/item/ammo_casing/Value()
	if(!BB)
		return 1
	return ..()

/obj/item/reagent_containers/Value()
	. = ..()
	if(reagents)
		for(var/a in reagents.reagent_list)
			var/datum/reagent/reg = a
			. += reg.Value() * reg.volume
	. = round(.)

/datum/reagent/proc/Value()
	return value

/obj/item/stack/Value(var/base)
	return base * amount

/obj/item/stack/material/Value()
	if(!material)
		return ..()
	return material.value * amount

/obj/item/ore/Value()
	return material ? material.value : 0

/obj/item/material/Value()
	return material.value * worth_multiplier

/obj/item/spacecash/Value()
	return worth

/mob/living/carbon/human/Value(var/base)
	. = ..()
	if(species)
		. *= species.rarity_value