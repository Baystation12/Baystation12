
/obj/item/energybarricade/vacuum_shield
	name = "vacuum shield (packed)"
	desc = "A shimmering solid shield for sealing hull breaches in an emergency. This one is deactivated for transport."
	icon = 'energybarricade.dmi'
	icon_state = "vacuum"
	shield_type = /obj/structure/energybarricade/vacuum_shield



/obj/structure/energybarricade/vacuum_shield
	name = "vacuum shield"
	desc = "A shimmering solid shield for sealing hull breaches in an emergency."
	icon_state = "shield-old"
	fail_state = "blueshatter2"
	max_shield = 100
	recharge_time = 30
	blocks_air = 1
	blocks_mobs = 0
	item_type = /obj/item/energybarricade/vacuum_shield

/obj/structure/energybarricade/vacuum_shield/update_icon()
	if(shield_health > 0)
		icon_state = "shield-old"
	else
		icon_state = fail_state

/obj/structure/energybarricade/vacuum_shield/c_airblock(turf/other)
	if(shield_health > 0)
		return AIR_BLOCKED
	return ZONE_BLOCKED
