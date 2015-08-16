/mob/living/bot/floorbot
	name = "Floorbot"
	desc = "A little floor repairing robot, he looks so excited!"
	icon_state = "floorbot0"
	req_access = list(access_construction)

	var/amount = 10 // 1 for tile, 2 for lattice
	var/maxAmount = 60
	var/tilemake = 0 // When it reaches 100, bot makes a tile
	var/repairing = 0
	var/improvefloors = 0
	var/eattiles = 0
	var/maketiles = 0
	var/targetdirection = null
	var/list/path = list()
	var/list/ignorelist = list()
	var/turf/target
	var/floor_build_type = /decl/flooring/tiling // Basic steel floor.

/mob/living/bot/floorbot/update_icons()
	if(repairing)
		icon_state = "floorbot-c"
	else if(amount > 0)
		icon_state = "floorbot[on]"
	else
		icon_state = "floorbot[on]e"

/mob/living/bot/floorbot/attack_hand(var/mob/user)
	user.set_machine(src)
	var/dat
	dat += "<TT><B>Automatic Station Floor Repairer v1.0</B></TT><BR><BR>"
	dat += "Status: <A href='?src=\ref[src];operation=start'>[src.on ? "On" : "Off"]</A><BR>"
	dat += "Maintenance panel is [open ? "opened" : "closed"]<BR>"
	//dat += "Tiles left: [amount]<BR>"
	dat += "Behvaiour controls are [locked ? "locked" : "unlocked"]<BR>"
	if(!locked || issilicon(user))
		dat += "Improves floors: <A href='?src=\ref[src];operation=improve'>[improvefloors ? "Yes" : "No"]</A><BR>"
		dat += "Finds tiles: <A href='?src=\ref[src];operation=tiles'>[eattiles ? "Yes" : "No"]</A><BR>"
		dat += "Make singles pieces of metal into tiles when empty: <A href='?src=\ref[src];operation=make'>[maketiles ? "Yes" : "No"]</A><BR>"
		var/bmode
		if(targetdirection)
			bmode = dir2text(targetdirection)
		else
			bmode = "Disabled"
		dat += "<BR><BR>Bridge Mode : <A href='?src=\ref[src];operation=bridgemode'>[bmode]</A><BR>"

	user << browse("<HEAD><TITLE>Repairbot v1.0 controls</TITLE></HEAD>[dat]", "window=autorepair")
	onclose(user, "autorepair")
	return

/mob/living/bot/floorbot/emag_act(var/remaining_charges, var/mob/user)
	. = ..()
	if(!emagged)
		emagged = 1
		if(user)
			user << "<span class='notice'>The [src] buzzes and beeps.</span>"
		return 1

/mob/living/bot/floorbot/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	switch(href_list["operation"])
		if("start")
			if (on)
				turn_off()
			else
				turn_on()
		if("improve")
			improvefloors = !improvefloors
		if("tiles")
			eattiles = !eattiles
		if("make")
			maketiles = !maketiles
		if("bridgemode")
			switch(targetdirection)
				if(null)
					targetdirection = 1
				if(1)
					targetdirection = 2
				if(2)
					targetdirection = 4
				if(4)
					targetdirection = 8
				if(8)
					targetdirection = null
				else
					targetdirection = null
	attack_hand(usr)

/mob/living/bot/floorbot/turn_off()
	..()
	target = null
	path = list()
	ignorelist = list()

/mob/living/bot/floorbot/Life()
	..()

	if(!on)
		return

	++tilemake
	if(tilemake >= 100)
		tilemake = 0
		addTiles(1)

	if(client)
		return

	if(prob(5))
		custom_emote(2, "makes an excited booping beeping sound!")

	if(ignorelist.len) // Don't stick forever
		for(var/T in ignorelist)
			if(prob(1))
				ignorelist -= T

	if(amount && !emagged)
		if(!target && targetdirection) // Building a bridge
			var/turf/T = get_step(src, targetdirection)
			while(T in range(src))
				if(istype(T, /turf/space))
					target = T
					break
				T = get_step(T, targetdirection)

		if(!target) // Fixing floors
			for(var/turf/T in view(src))
				if(T.loc.name == "Space")
					continue
				if(T in ignorelist)
					continue
				if(istype(T, /turf/space))
					if(get_turf(T) == loc || prob(40)) // So they target the same tile all the time
						target = T
				if(improvefloors && istype(T, /turf/simulated/floor))
					var/turf/simulated/floor/F = T
					if(!F.flooring && (get_turf(T) == loc || prob(40)))
						target = T

	if(emagged) // Time to griff
		for(var/turf/simulated/floor/D in view(src))
			if(D.loc.name == "Space")
				continue
			if(D in ignorelist)
				continue
			target = D
			break

	if(!target && amount < maxAmount && eattiles || maketiles) // Eat tiles
		if(eattiles)
			for(var/obj/item/stack/tile/floor/T in view(src))
				if(T in ignorelist)
					continue
				target = T
				break
		if(maketiles && !target)
			for(var/obj/item/stack/material/steel/T in view(src))
				if(T in ignorelist)
					continue
				target = T
				break

	if(target && get_turf(target) == loc)
		UnarmedAttack(target)

	if(target && get_turf(target) != loc && !path.len)
		spawn(0)
			path = AStar(loc, get_turf(target), /turf/proc/AdjacentTurfsSpace, /turf/proc/Distance, 0, 30, id = botcard)
			if(!path)
				path = list()
				ignorelist += target
				target = null

	if(path.len)
		step_to(src, path[1])
		path -= path[1]

/mob/living/bot/floorbot/UnarmedAttack(var/atom/A, var/proximity)
	if(!..())
		return

	if(repairing)
		return

	if(get_turf(A) != loc)
		return

	if(emagged && istype(A, /turf/simulated/floor))
		var/turf/simulated/floor/F = A
		repairing = 1
		update_icons()
		if(F.is_plating())
			visible_message("<span class='warning'>[src] begins to tear the floor tile from the floor!</span>")
			if(do_after(src, 50))
				F.break_tile_to_plating()
				addTiles(1)
		else
			visible_message("<span class='danger'>[src] begins to tear through the floor!</span>")
			if(do_after(src, 150)) // Extra time because this can and will kill.
				F.ReplaceWithLattice()
				addTiles(1)
		target = null
		repairing = 0
		update_icons()
	else if(istype(A, /turf/space))
		var/building = 2
		if(locate(/obj/structure/lattice, A))
			building = 1
		if(amount < building)
			return
		repairing = 1
		update_icons()
		visible_message("<span class='notice'>[src] begins to repair the hole.</span>")
		if(do_after(src, 50))
			if(A && (locate(/obj/structure/lattice, A) && building == 1 || !locate(/obj/structure/lattice, A) && building == 2)) // Make sure that it still needs repairs
				var/obj/item/I
				if(building == 1)
					I = new /obj/item/stack/tile/floor(src)
				else
					I = PoolOrNew(/obj/item/stack/rods, src)
				A.attackby(I, src)
		target = null
		repairing = 0
		update_icons()
	else if(istype(A, /turf/simulated/floor))
		var/turf/simulated/floor/F = A
		if(!F.flooring && amount)
			repairing = 1
			update_icons()
			visible_message("<span class='notice'>[src] begins to improve the floor.</span>")
			if(do_after(src, 50))
				if(!F.flooring)
					F.set_flooring(get_flooring_data(floor_build_type))
					addTiles(-1)
			target = null
			repairing = 0
			update_icons()
	else if(istype(A, /obj/item/stack/tile/floor) && amount < maxAmount)
		var/obj/item/stack/tile/floor/T = A
		visible_message("<span class='notice'>[src] begins to collect tiles.</span>")
		repairing = 1
		update_icons()
		if(do_after(src, 20))
			if(T)
				var/eaten = min(maxAmount - amount, T.get_amount())
				T.use(eaten)
				addTiles(eaten)
		target = null
		repairing = 0
		update_icons()
	else if(istype(A, /obj/item/stack/material) && amount + 4 <= maxAmount)
		var/obj/item/stack/material/M = A
		if(M.get_material_name() == DEFAULT_WALL_MATERIAL)
			visible_message("<span class='notice'>[src] begins to make tiles.</span>")
			repairing = 1
			update_icons()
			if(do_after(50))
				if(M)
					M.use(1)
					addTiles(4)

/mob/living/bot/floorbot/explode()
	turn_off()
	visible_message("<span class='danger'>[src] blows apart!</span>")
	var/turf/Tsec = get_turf(src)

	var/obj/item/weapon/storage/toolbox/mechanical/N = new /obj/item/weapon/storage/toolbox/mechanical(Tsec)
	N.contents = list()
	new /obj/item/device/assembly/prox_sensor(Tsec)
	if(prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)
	var/obj/item/stack/tile/floor/T = new /obj/item/stack/tile/floor(Tsec)
	T.amount = amount
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)

/mob/living/bot/floorbot/proc/addTiles(var/am)
	amount += am
	if(amount < 0)
		amount = 0
	else if(amount > maxAmount)
		amount = maxAmount

/* Assembly */

/obj/item/weapon/storage/toolbox/mechanical/attackby(var/obj/item/stack/tile/floor/T, mob/user as mob)
	if(!istype(T, /obj/item/stack/tile/floor))
		..()
		return
	if(contents.len >= 1)
		user << "<span class='notice'>They wont fit in as there is already stuff inside.</span>"
		return
	if(user.s_active)
		user.s_active.close(user)
	if(T.use(10))
		var/obj/item/weapon/toolbox_tiles/B = new /obj/item/weapon/toolbox_tiles
		user.put_in_hands(B)
		user << "<span class='notice'>You add the tiles into the empty toolbox. They protrude from the top.</span>"
		user.drop_from_inventory(src)
		qdel(src)
	else
		user << "<span class='warning'>You need 10 floor tiles for a floorbot.</span>"
	return

/obj/item/weapon/toolbox_tiles
	desc = "It's a toolbox with tiles sticking out the top"
	name = "tiles and toolbox"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "toolbox_tiles"
	force = 3.0
	throwforce = 10.0
	throw_speed = 2
	throw_range = 5
	w_class = 3.0
	var/created_name = "Floorbot"

/obj/item/weapon/toolbox_tiles/attackby(var/obj/item/W, mob/user as mob)
	..()
	if(isprox(W))
		qdel(W)
		var/obj/item/weapon/toolbox_tiles_sensor/B = new /obj/item/weapon/toolbox_tiles_sensor()
		B.created_name = created_name
		user.put_in_hands(B)
		user << "<span class='notice'>You add the sensor to the toolbox and tiles!</span>"
		user.drop_from_inventory(src)
		qdel(src)
	else if (istype(W, /obj/item/weapon/pen))
		var/t = sanitizeSafe(input(user, "Enter new robot name", name, created_name), MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, user) && loc != user)
			return
		created_name = t

/obj/item/weapon/toolbox_tiles_sensor
	desc = "It's a toolbox with tiles sticking out the top and a sensor attached"
	name = "tiles, toolbox and sensor arrangement"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "toolbox_tiles_sensor"
	force = 3.0
	throwforce = 10.0
	throw_speed = 2
	throw_range = 5
	w_class = 3.0
	var/created_name = "Floorbot"

/obj/item/weapon/toolbox_tiles_sensor/attackby(var/obj/item/W, mob/user as mob)
	..()
	if(istype(W, /obj/item/robot_parts/l_arm) || istype(W, /obj/item/robot_parts/r_arm))
		qdel(W)
		var/turf/T = get_turf(user.loc)
		var/mob/living/bot/floorbot/A = new /mob/living/bot/floorbot(T)
		A.name = created_name
		user << "<span class='notice'>You add the robot arm to the odd looking toolbox assembly! Boop beep!</span>"
		user.drop_from_inventory(src)
		qdel(src)
	else if(istype(W, /obj/item/weapon/pen))
		var/t = sanitizeSafe(input(user, "Enter new robot name", name, created_name), MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, user) && loc != user)
			return
		created_name = t