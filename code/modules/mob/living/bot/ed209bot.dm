/mob/living/bot/secbot/ed209
	name = "ED-209 Security Robot"
	desc = "A security robot.  He looks less than thrilled."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "ed2090"
	density = 1
	health = 100
	maxHealth = 100

	bot_version = "2.5"
	is_ranged = 1
	preparing_arrest_sounds = new()

	a_intent = I_HURT
	mob_bump_flag = HEAVY
	mob_swap_flags = ~HEAVY
	mob_push_flags = HEAVY

	var/shot_delay = 4
	var/last_shot = 0
	var/projectile_type = /obj/item/projectile/beam/stun

// Assembly

/obj/item/weapon/secbot_assembly/ed209_assembly
	name = "ED-209 assembly"
	desc = "Some sort of bizarre assembly."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "ed209_frame"
	item_state = "ed209_frame"
	created_name = "ED-209 Security Robot"
	var/lasercolor = ""

/obj/item/weapon/secbot_assembly/ed209_assembly/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	..()

	if(istype(W, /obj/item/weapon/pen))
		var/t = sanitizeSafe(input(user, "Enter new robot name", name, created_name), MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && src.loc != usr)
			return
		created_name = t
		return

	switch(build_step)
		if(0, 1)
			if(istype(W, /obj/item/robot_parts/l_leg) || istype(W, /obj/item/robot_parts/r_leg))
				user.drop_item()
				qdel(W)
				build_step++
				user << "<span class='notice'>You add the robot leg to [src].</span>"
				name = "legs/frame assembly"
				if(build_step == 1)
					item_state = "ed209_leg"
					icon_state = "ed209_leg"
				else
					item_state = "ed209_legs"
					icon_state = "ed209_legs"

		if(2)
			if(istype(W, /obj/item/clothing/suit/redtag))
				user.drop_item()
				qdel(W)
				build_step++
				user << "<span class='notice'>You add the red lasertag vest to [src].</span>"
				created_name = "ED-209 Redtag Robot"
				name = "vest/legs/frame tag assembly"
				item_state = "red209_shell"
				icon_state = "red209_shell"
				lasercolor = "r"
			if(istype(W, /obj/item/clothing/suit/bluetag))
				user.drop_item()
				qdel(W)
				build_step++
				user << "<span class='notice'>You add the blue lasertag vest to [src].</span>"
				created_name = "ED-209 Blutag Robot"
				name = "vest/legs/frame assembly"
				item_state = "bed209_shell"
				icon_state = "bed209_shell"
				lasercolor = "b"
			if(istype(W, /obj/item/clothing/suit/storage/vest))
				user.drop_item()
				qdel(W)
				build_step++
				user << "<span class='notice'>You add the armor to [src].</span>"
				name = "vest/legs/frame assembly"
				item_state = "ed209_shell"
				icon_state = "ed209_shell"

		if(3)
			if(istype(W, /obj/item/weapon/weldingtool))
				var/obj/item/weapon/weldingtool/WT = W
				if(WT.remove_fuel(0, user))
					build_step++
					name = "shielded frame assembly"
					user << "<span class='notice'>You welded the vest to [src].</span>"
		if(4)
			if(istype(W, /obj/item/clothing/head/helmet) && lasercolor == "")
				user.drop_item()
				qdel(W)
				build_step++
				user << "<span class='notice'>You add the helmet to [src].</span>"
				name = "covered and shielded frame assembly"
				item_state = "ed209_hat"
				icon_state = "ed209_hat"
			if(istype(W, /obj/item/clothing/head/soft/grey) && (lasercolor == "r" || lasercolor == "b"))
				user.drop_item()
				qdel(W)
				build_step++
				user << "<span class='notice'>You stretch the cap over [src].</span>"
				name = "covered and shielded lasertag frame assembly"
				item_state = "[lasercolor]ed209_hat"
				icon_state = "[lasercolor]ed209_hat"

		if(5)
			if(isprox(W))
				user.drop_item()
				qdel(W)
				build_step++
				user << "<span class='notice'>You add the prox sensor to [src].</span>"
				name = "covered, shielded and sensored frame assembly"
				if(lasercolor == "r" || lasercolor == "b")
					item_state = "[lasercolor]ed209_prox"
				else
					item_state = "ed209_prox"
					icon_state = "ed209_prox"

		if(6)
			if(istype(W, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = W
				if (C.get_amount() < 1)
					user << "<span class='warning'>You need one coil of wire to wire [src].</span>"
					return
				user << "<span class='notice'>You start to wire [src].</span>"
				if(do_after(user, 40) && build_step == 6)
					if(C.use(1))
						build_step++
						user << "<span class='notice'>You wire the ED-209 assembly.</span>"
						name = "wired ED-209 assembly"
				return

		if(7)
			if(istype(W, /obj/item/weapon/gun/energy/taser))
				name = "taser ED-209 assembly"
				build_step++
				user << "<span class='notice'>You add [W] to [src].</span>"
				item_state = "ed209_taser"
				icon_state = "ed209_taser"
				user.drop_item()
				qdel(W)
			if(istype(W, /obj/item/weapon/gun/energy/lasertag/red) && lasercolor == "r")
				name = "red tag ED-209 assembly"
				build_step++
				user << "<span class='notice'>You add [W] to [src].</span>"
				item_state = "red209_taser"
				icon_state = "red209_taser"
				user.drop_item()
				qdel(W)
			if(istype(W, /obj/item/weapon/gun/energy/lasertag/blue) && lasercolor == "b")
				name = "blue tag ED-209 assembly"
				build_step++
				user << "<span class='notice'>You add [W] to [src].</span>"
				item_state = "bed209_taser"
				icon_state = "bed209_taser"
				user.drop_item()
				qdel(W)

		if(8)
			if(istype(W, /obj/item/weapon/screwdriver))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
				var/turf/T = get_turf(user)
				user << "<span class='notice'>Now attaching the gun to the frame...</span>"
				sleep(40)
				if(get_turf(user) == T && build_step == 8)
					build_step++
					name = "armed [name]"
					if(lasercolor != "r" && lasercolor != "b")
						user << "<span class='notice'>Taser gun attached.</span>"
					else
						user << "<span class='notice'>Lasertag gun attached.</span>"

		if(9)
			if(istype(W, /obj/item/weapon/cell))
				build_step++
				user << "<span class='notice'>You complete the ED-209.</span>"
				var/turf/T = get_turf(src)
				if(lasercolor != "r" && lasercolor != "b")
					new /mob/living/bot/secbot/ed209(T,created_name)
				else
					new /mob/living/bot/secbot/ed209/tag(T,created_name,lasercolor)
				user.drop_item()
				qdel(W)
				user.drop_from_inventory(src)
				qdel(src)