/obj/machinery/bot/secbot/ed209
	name = "ED-209 Security Robot"
	desc = "A security robot.  He looks less than thrilled."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "ed2090"
	density = 1
	health = 100
	maxhealth = 100

	bot_version = "2.5"
	search_range = 12

	preparing_arrest_sounds = new()
	secbot_assembly = /obj/item/weapon/secbot_assembly/ed209_assembly

/obj/item/weapon/secbot_assembly/ed209_assembly
	name = "ED-209 assembly"
	desc = "Some sort of bizarre assembly."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "ed209_frame"
	item_state = "ed209_frame"
	created_name = "ED-209 Security Robot" //To preserve the name if it's a unique securitron I guess
	var/lasercolor = ""

/obj/machinery/bot/secbot/ed209/update_icon()
	if(on && is_attacking)
		src.icon_state = "[lasercolor]ed209-c"
	else
		src.icon_state = "[lasercolor]ed209[src.on]"

/obj/machinery/bot/secbot/ed209/on_explosion(var/turf/Tsec)
	if(!lasercolor)
		var/obj/item/weapon/gun/energy/taser/G = new /obj/item/weapon/gun/energy/taser(Tsec)
		G.power_supply.charge = 0
	else if(lasercolor == "b")
		var/obj/item/weapon/gun/energy/laser/bluetag/G = new /obj/item/weapon/gun/energy/laser/bluetag(Tsec)
		G.power_supply.charge = 0
	else if(lasercolor == "r")
		var/obj/item/weapon/gun/energy/laser/redtag/G = new /obj/item/weapon/gun/energy/laser/redtag(Tsec)
		G.power_supply.charge = 0
	if (prob(50))
		new /obj/item/robot_parts/l_leg(Tsec)
		if (prob(25))
			new /obj/item/robot_parts/r_leg(Tsec)
	if (prob(25))//50% chance for a helmet OR vest
		if (prob(50))
			new /obj/item/clothing/head/helmet(Tsec)
		else
			if(!lasercolor)
				new /obj/item/clothing/suit/armor/vest(Tsec)
			if(lasercolor == "b")
				new /obj/item/clothing/suit/bluetag(Tsec)
			if(lasercolor == "r")
				new /obj/item/clothing/suit/redtag(Tsec)

/obj/item/weapon/secbot_assembly/ed209_assembly/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()

	if(istype(W, /obj/item/weapon/pen))
		var/t = copytext(stripped_input(user, "Enter new robot name", src.name, src.created_name),1,MAX_NAME_LEN)
		if(!t)	return
		if(!in_range(src, usr) && src.loc != usr)	return
		created_name = t
		return

	switch(build_step)
		if(0,1)
			if( istype(W, /obj/item/robot_parts/l_leg) || istype(W, /obj/item/robot_parts/r_leg) )
				user.drop_item()
				del(W)
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
			if( istype(W, /obj/item/clothing/suit/redtag) )
				lasercolor = "r"
			else if( istype(W, /obj/item/clothing/suit/bluetag) )
				lasercolor = "b"
			if( lasercolor || istype(W, /obj/item/clothing/suit/armor/vest) )
				user.drop_item()
				del(W)
				build_step++
				user << "<span class='notice'>You add the armor to [src].</span>"
				name = "vest/legs/frame assembly"
				item_state = "[lasercolor]ed209_shell"
				icon_state = "[lasercolor]ed209_shell"

		if(3)
			if( istype(W, /obj/item/weapon/weldingtool) )
				var/obj/item/weapon/weldingtool/WT = W
				if(WT.remove_fuel(0,user))
					build_step++
					name = "shielded frame assembly"
					user << "<span class='notice'>You welded the vest to [src].</span>"
		if(4)
			if( istype(W, /obj/item/clothing/head/helmet) )
				user.drop_item()
				del(W)
				build_step++
				user << "<span class='notice'>You add the helmet to [src].</span>"
				name = "covered and shielded frame assembly"
				item_state = "[lasercolor]ed209_hat"
				icon_state = "[lasercolor]ed209_hat"

		if(5)
			if( isprox(W) )
				user.drop_item()
				del(W)
				build_step++
				user << "<span class='notice'>You add the prox sensor to [src].</span>"
				name = "covered, shielded and sensored frame assembly"
				item_state = "[lasercolor]ed209_prox"
				icon_state = "[lasercolor]ed209_prox"

		if(6)
			if(istype(W, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = W
				if (C.get_amount() < 1)
					user << "<span class='warning'>You need one coil of wire to do wire [src].</span>"
					return
				user << "<span class='notice'>You start to wire [src].</span>"
				if (do_after(user, 40) && build_step == 6)
					if (C.use(1))
						build_step++
						user << "<span class='notice'>You wire the ED-209 assembly.</span>"
						name = "wired ED-209 assembly"
				return

		if(7)
			switch(lasercolor)
				if("b")
					if( !istype(W, /obj/item/weapon/gun/energy/laser/bluetag) )
						return
					name = "bluetag ED-209 assembly"
				if("r")
					if( !istype(W, /obj/item/weapon/gun/energy/laser/redtag) )
						return
					name = "redtag ED-209 assembly"
				if("")
					if( !istype(W, /obj/item/weapon/gun/energy/taser) )
						return
					name = "taser ED-209 assembly"
				else
					return
			build_step++
			user << "<span class='notice'>You add [W] to [src].</span>"
			src.item_state = "[lasercolor]ed209_taser"
			src.icon_state = "[lasercolor]ed209_taser"
			user.drop_item()
			del(W)

		if(8)
			if( istype(W, /obj/item/weapon/screwdriver) )
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
				var/turf/T = get_turf(user)
				user << "<span class='notice'>Now attaching the gun to the frame...</span>"
				sleep(40)
				if(get_turf(user) == T && build_step == 8)
					build_step++
					name = "armed [name]"
					user << "<span class='notice'>Taser gun attached.</span>"

		if(9)
			if( istype(W, /obj/item/weapon/cell) )
				build_step++
				user << "<span class='notice'>You complete the ED-209.</span>"
				var/turf/T = get_turf(src)
				new /obj/machinery/bot/secbot/ed209(T,created_name,lasercolor)
				user.drop_item()
				del(W)
				user.drop_from_inventory(src)
				del(src)


/obj/machinery/bot/secbot/ed209/bullet_act(var/obj/item/projectile/Proj)
	if((src.lasercolor == "b") && (src.disabled == 0))
		if(istype(Proj, /obj/item/projectile/beam/lastertag/red))
			src.disabled = 1
			del (Proj)
			sleep(100)
			src.disabled = 0
		else
			..()
	else if((src.lasercolor == "r") && (src.disabled == 0))
		if(istype(Proj, /obj/item/projectile/beam/lastertag/blue))
			src.disabled = 1
			del (Proj)
			sleep(100)
			src.disabled = 0
		else
			..()
	else
		..()

/obj/machinery/bot/secbot/ed209/bluetag/New()//If desired, you spawn red and bluetag bots easily
	new /obj/machinery/bot/secbot/ed209(get_turf(src),null,"b")
	del(src)


/obj/machinery/bot/secbot/ed209/redtag/New()
	new /obj/machinery/bot/secbot/ed209(get_turf(src),null,"r")
	del(src)
