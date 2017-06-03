/obj/item/slime_extract/Value(var/base)
	return base * Uses

/obj/item/ammo_casing/Value()
	if(!projectile)
		return 1
	return ..()

/obj/item/weapon/reagent_containers/Value()
	. = ..()
	if(reagents)
		for(var/a in reagents.reagent_list)
			var/datum/reagent/reg = a
			. += reg.value * reg.volume
	. = round(.)

/obj/item/stack/Value(var/base)
	return base * amount

/obj/item/stack/material/Value()
	if(!material)
		return ..()
	return material.value * amount

/obj/item/weapon/ore/Value()
	var/material/mat = get_material_by_name(ore.material)
	if(mat)
		return mat.value
	return 0

/obj/item/weapon/material/Value()
	return material.value * worth_multiplier

/obj/item/weapon/spacecash/Value()
	return worth
