/obj/mecha
	var/item_worth = 20000

/obj/mecha/Destroy()
	station_damage_score += get_worth()
	..()

/obj/mecha/proc/get_worth()
	. = item_worth
	for(var/a in equipment)
		var/obj/item/mecha_parts/mecha_equipment/E = a
		. += E.get_worth()

/obj/mecha/combat
	item_worth = 50000