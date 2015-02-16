#define TURRET_PRIORITY_TARGET 2
#define TURRET_SECONDARY_TARGET 1
#define TURRET_NOT_TARGET 0

/obj/machinery/porta_turret/tag
	// Reasonable defaults, in case someone manually spawns us
	var/lasercolor = "r"	//Something to do with lasertag turrets, blame Sieve for not adding a comment.
	installation = /obj/item/weapon/gun/energy/lasertag/red

/obj/machinery/porta_turret/tag/red

/obj/machinery/porta_turret/tag/blue
	lasercolor = "b"
	installation = /obj/item/weapon/gun/energy/lasertag/blue

/obj/machinery/porta_turret/tag/New()
	..()
	icon_state = "[lasercolor]grey_target_prism"

/obj/machinery/porta_turret/tag/weapon_setup(var/obj/item/weapon/gun/energy/E)
	switch(E.type)
		if(/obj/item/weapon/gun/energy/lasertag/blue)
			eprojectile = /obj/item/weapon/gun/energy/lasertag/blue
			lasercolor = "b"
			req_access = list(access_maint_tunnels, access_theatre)
			check_arrest = 0
			check_records = 0
			check_weapons = 1
			check_access = 0
			check_anomalies = 0
			shot_delay = 30

		if(/obj/item/weapon/gun/energy/lasertag/red)
			eprojectile = /obj/item/weapon/gun/energy/lasertag/red
			lasercolor = "r"
			req_access = list(access_maint_tunnels, access_theatre)
			check_arrest = 0
			check_records = 0
			check_weapons = 1
			check_access = 0
			check_anomalies = 0
			shot_delay = 30
			iconholder = 1

/obj/machinery/porta_turret/tag/interact(mob/user)
	var/dat

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(lasercolor == "b" && istype(H.wear_suit, /obj/item/clothing/suit/redtag))
			return
		if(lasercolor == "r" && istype(H.wear_suit, /obj/item/clothing/suit/bluetag))
			return
	dat += text({"
				<TT><B>Automatic Portable Turret Installation</B></TT><BR><BR>
				Status: []<BR>"},

				"<A href='?src=\ref[src];power=1'>[on ? "On" : "Off"]</A>" )


	user << browse("<HEAD><TITLE>Automatic Portable Turret Installation</TITLE></HEAD>[dat]", "window=autosec")
	onclose(user, "autosec")
	return

/obj/machinery/porta_turret/tag/update_icon()
	if(!anchored)
		icon_state = "turretCover"
		return
	if(stat & BROKEN)
		icon_state = "[lasercolor]destroyed_target_prism"
	else
		if(powered())
			if(on)
				if(iconholder)
					//lasers have a orange icon
					icon_state = "[lasercolor]orange_target_prism"
				else
					//almost everything has a blue icon
					icon_state = "[lasercolor]target_prism"
			else
				icon_state = "[lasercolor]grey_target_prism"
		else
			icon_state = "[lasercolor]grey_target_prism"

/obj/machinery/porta_turret/tag/bullet_act(obj/item/projectile/Proj)
	..()

	if(lasercolor == "b" && disabled == 0)
		if(istype(Proj, /obj/item/weapon/gun/energy/lasertag/red))
			disabled = 1
			del(Proj) // qdel
			sleep(100)
			disabled = 0
	if(lasercolor == "r" && disabled == 0)
		if(istype(Proj, /obj/item/weapon/gun/energy/lasertag/blue))
			disabled = 1
			del(Proj) // qdel
			sleep(100)
			disabled = 0

/obj/machinery/porta_turret/tag/assess_living(var/mob/living/L)
	if(!L)
		return TURRET_NOT_TARGET

	if(L.lying)
		return TURRET_NOT_TARGET

	var/target_suit
	var/target_weapon
	switch(lasercolor)
		if("b")
			target_suit = /obj/item/clothing/suit/redtag
			target_weapon = /obj/item/weapon/gun/energy/lasertag/red
		if("r")
			target_suit = /obj/item/clothing/suit/bluetag
			target_weapon = /obj/item/weapon/gun/energy/lasertag/blue


	if(target_suit)//Lasertag turrets target the opposing team, how great is that? -Sieve
		if((istype(L.r_hand, target_weapon)) || (istype(L.l_hand, target_weapon)))
			return TURRET_PRIORITY_TARGET

		if(istype(L, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = L
			if(istype(H.wear_suit, target_suit))
				return TURRET_PRIORITY_TARGET
			if(istype(H.belt, target_weapon))
				return TURRET_SECONDARY_TARGET

	return TURRET_NOT_TARGET