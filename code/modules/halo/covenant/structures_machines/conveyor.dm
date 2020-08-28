
/obj/machinery/conveyor/covenant
	icon = 'code/modules/halo/covenant/structures_machines/conveyor.dmi'

/obj/machinery/conveyor/covenant/update_icon()
	. = ..()
	overlays = list()
	if(operating > 0)
		overlays += "active"
	else if(operating < 0)
		var/image/I = image("active")
		I.transform = turn(I.transform, 180)
		overlays += I

/obj/machinery/conveyor_switch/covenant
	//req_access = list(access_covenant)
	icon = 'code/modules/halo/covenant/structures_machines/conveyor.dmi'

/obj/structure/mob_shield
	name = "organic shield"
	desc = "Blocks the passage of living creatures and gases when activated."
	icon = 'code/modules/halo/covenant/structures_machines/conveyor.dmi'
	icon_state = "mob-shield1"
	density = 1
	anchored = 1

/obj/structure/mob_shield/attack_hand(var/mob/user)
	if(is_covenant_mob(user))
		if(density)
			temp_off()
			to_chat(user, "<span class='info'>You temporarily disable [src] so you can pass.</span>")
	else
		to_chat(user, "<span class='warning'>You can't get past!</span>")

/obj/structure/mob_shield/proc/temp_off()
	density = 0
	icon_state = "mob-shield0"
	spawn(50)
		density = 1
		icon_state = "mob-shield1"

/obj/structure/mob_shield/CanPass(atom/movable/A, turf/T, height=1.5, air_group = 0)
	if(density)
		if(iscarbon(A))
			return FALSE
	return TRUE

/obj/structure/mob_shield/c_airblock(turf/other)
	if(density)
		return AIR_BLOCKED
	return ZONE_BLOCKED
