/obj/structure/railing
	name = "railing"
	desc = "A standard steel railing. Prevents from human stupidity."
	icon = 'icons/obj/railing.dmi'
	density = 1
	throwpass = 1
	layer = 5.2
	anchored = FALSE
	atom_flags = ATOM_FLAG_CHECKS_BORDER | ATOM_FLAG_CLIMBABLE
	icon_state = "railing0"

	var/material/material
	var/broken =    FALSE
	var/health =    70
	var/maxhealth = 70
	var/neighbor_status = 0

/obj/structure/railing/mapped
	color = COLOR_GUNMETAL
	anchored = TRUE

/obj/structure/railing/mapped/Initialize()
	. = ..()
	color = COLOR_GUNMETAL // They're not painted!

/obj/structure/railing/New(var/newloc, var/material_key = "steel")
	material = material_key // Converted to datum in initialize().
	..(newloc)

/obj/structure/railing/Process()
	if(!material || !material.radioactivity)
		return
	for(var/mob/living/L in range(1,src))
		L.apply_effect(round(material.radioactivity/20),IRRADIATE, blocked = L.getarmor(null, "rad"))

/obj/structure/railing/Initialize()
	. = ..()

	if(!isnull(material) && !istype(material))
		material = get_material_by_name(material)
	if(!istype(material))
		return INITIALIZE_HINT_QDEL

	name = "[material.display_name] [initial(name)]"
	desc = "An unremarkable [material.display_name] railing. Guards against human stupidity."
	maxhealth = round(material.integrity / 5)
	health = maxhealth
	color = material.icon_colour

	if(material.products_need_process())
		START_PROCESSING(SSobj, src)
	if(material.conductive)
		obj_flags |= OBJ_FLAG_CONDUCTIBLE
	else
		obj_flags &= (~OBJ_FLAG_CONDUCTIBLE)
	if(anchored)
		update_icon(FALSE)

/obj/structure/railing/Destroy()
	anchored = FALSE
	atom_flags = 0
	broken = TRUE
	for(var/thing in trange(1, src))
		var/turf/T = thing
		for(var/obj/structure/railing/R in T.contents)
			R.update_icon()
	. = ..()

/obj/structure/railing/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!istype(mover) || mover.checkpass(PASS_FLAG_TABLE))
		return TRUE
	if(get_dir(loc, target) == dir)
		return !density
	return TRUE

/obj/structure/railing/examine(mob/user)
	. = ..()
	if(health < maxhealth)
		switch(health / maxhealth)
			if(0.0 to 0.5)
				to_chat(user, "<span class='warning'>It looks severely damaged!</span>")
			if(0.25 to 0.5)
				to_chat(user, "<span class='warning'>It looks damaged!</span>")
			if(0.5 to 1.0)
				to_chat(user, "<span class='notice'>It has a few scrapes and dents.</span>")

/obj/structure/railing/proc/take_damage(amount)
	health -= amount
	if(health <= 0)
		visible_message("<span class='danger'>\The [src] [material.destruction_desc]!</span>")
		playsound(loc, 'sound/effects/grillehit.ogg', 50, 1)
		material.place_shard(get_turf(usr))
		qdel(src)

/obj/structure/railing/proc/NeighborsCheck(var/UpdateNeighbors = 1)
	neighbor_status = 0
	var/Rturn = turn(src.dir, -90)
	var/Lturn = turn(src.dir, 90)

	for(var/obj/structure/railing/R in src.loc)
		if ((R.dir == Lturn) && R.anchored)
			neighbor_status |= 32
			if (UpdateNeighbors)
				R.update_icon(0)
		if ((R.dir == Rturn) && R.anchored)
			neighbor_status |= 2
			if (UpdateNeighbors)
				R.update_icon(0)
	for (var/obj/structure/railing/R in get_step(src, Lturn))
		if ((R.dir == src.dir) && R.anchored)
			neighbor_status |= 16
			if (UpdateNeighbors)
				R.update_icon(0)
	for (var/obj/structure/railing/R in get_step(src, Rturn))
		if ((R.dir == src.dir) && R.anchored)
			neighbor_status |= 1
			if (UpdateNeighbors)
				R.update_icon(0)
	for (var/obj/structure/railing/R in get_step(src, (Lturn + src.dir)))
		if ((R.dir == Rturn) && R.anchored)
			neighbor_status |= 64
			if (UpdateNeighbors)
				R.update_icon(0)
	for (var/obj/structure/railing/R in get_step(src, (Rturn + src.dir))).
		if ((R.dir == Lturn) && R.anchored)
			neighbor_status |= 4
			if (UpdateNeighbors)
				R.update_icon(0)

/obj/structure/railing/update_icon(var/update_neighbors = TRUE)
	NeighborsCheck(update_neighbors)
	overlays.Cut()
	if (!neighbor_status || !anchored)
		icon_state = "railing0"
	else
		icon_state = "railing1"
		if (neighbor_status & 32)
			overlays += image(icon, "corneroverlay")
		if ((neighbor_status & 16) || !(neighbor_status & 32) || (neighbor_status & 64))
			overlays += image(icon, "frontoverlay_l")
		if (!(neighbor_status & 2) || (neighbor_status & 1) || (neighbor_status & 4))
			overlays += image(icon, "frontoverlay_r")
			if(neighbor_status & 4)
				var/pix_offset_x = 0
				var/pix_offset_y = 0
				switch(dir)
					if(NORTH)
						pix_offset_x = 32
					if(SOUTH)
						pix_offset_x = -32
					if(EAST)
						pix_offset_y = -32
					if(WEST)
						pix_offset_y = 32
				overlays += image(icon, "mcorneroverlay", pixel_x = pix_offset_x, pixel_y = pix_offset_y)

/obj/structure/railing/verb/rotate()
	set name = "Rotate Railing Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(anchored)
		to_chat(usr, "<span class='warning'>It is fastened to the floor and cannot be rotated.</span>")
		return 0

	set_dir(turn(dir, 90))
	update_icon()

/obj/structure/railing/verb/revrotate()
	set name = "Rotate Railing Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(anchored)
		to_chat(usr, "<span class='warning'>It is fastened to the floor and cannot be rotated.</span>")
		return 0

	set_dir(turn(dir, -90))
	update_icon()

/obj/structure/railing/verb/flip() // This will help push railing to remote places, such as open space turfs
	set name = "Flip Railing"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(anchored)
		to_chat(usr, "<span class='warning'>It is fastened to the floor and cannot be flipped.</span>")
		return 0

	if(!turf_is_crowded())
		to_chat(usr, "<span class='warning'>You can't flip \the [src] - something is in the way.</span>")
		return 0

	forceMove(get_step(src, src.dir))
	set_dir(turn(dir, 180))
	update_icon()

/obj/structure/railing/CheckExit(var/atom/movable/O, var/turf/target)
	if(istype(O) && O.checkpass(PASS_FLAG_TABLE))
		return 1
	if(get_dir(O.loc, target) == dir)
		return 0
	return 1

/obj/structure/railing/attackby(var/obj/item/W, var/mob/user)
	// Handle harm intent grabbing/tabling.
	if(istype(W, /obj/item/grab) && get_dist(src,user)<2)
		var/obj/item/grab/G = W
		if(istype(G.affecting, /mob/living/carbon/human))
			var/obj/occupied = turf_is_crowded()
			if(occupied)
				to_chat(user, "<span class='danger'>There's \a [occupied] in the way.</span>")
				return

			if(G.force_danger())
				if(user.a_intent == I_HURT)
					visible_message("<span class='danger'>[G.assailant] slams [G.affecting]'s face against \the [src]!</span>")
					playsound(loc, 'sound/effects/grillehit.ogg', 50, 1)
					var/blocked = G.affecting.run_armor_check(BP_HEAD, "melee")
					if (prob(30 * blocked_mult(blocked)))
						G.affecting.Weaken(5)
					G.affecting.apply_damage(8, BRUTE, BP_HEAD, blocked)
				else
					if (get_turf(G.affecting) == get_turf(src))
						G.affecting.forceMove(get_step(src, src.dir))
					else
						G.affecting.forceMove(get_turf(src))
					G.affecting.Weaken(5)
					visible_message("<span class='danger'>[G.assailant] throws \the [G.affecting] over \the [src].</span>")
			else
				to_chat(user, "<span class='danger'>You need a better grip to do that!</span>")
			return

	// Dismantle
	if(isWrench(W) && !anchored)
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 20, src))
			user.visible_message("<span class='notice'>\The [user] dismantles \the [src].</span>", "<span class='notice'>You dismantle \the [src].</span>")
			material.place_sheet(loc)
			material.place_sheet(loc)
			qdel(src)
		return

	// Repair
	if(isWelder(W))
		var/obj/item/weapon/weldingtool/F = W
		if(F.isOn())
			if(health >= maxhealth)
				to_chat(user, "<span class='warning'>\The [src] does not need repairs.</span>")
				return
			playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
			if(do_after(user, 20, src))
				user.visible_message("<span class='notice'>\The [user] repairs some damage to \the [src].</span>", "<span class='notice'>You repair some damage to \the [src].</span>")
				health = min(health+(maxhealth/5), maxhealth)
			return

	// Install
	if(isScrewdriver(W))
		user.visible_message(anchored ? "<span class='notice'>\The [user] begins unscrew \the [src].</span>" : "<span class='notice'>\The [user] begins fasten \the [src].</span>" )
		playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
		if(do_after(user, 10, src))
			to_chat(user, (anchored ? "<span class='notice'>You have unfastened \the [src] from the floor.</span>" : "<span class='notice'>You have fastened \the [src] to the floor.</span>"))
			anchored = !anchored
			update_icon()
		return

	if(W.force && (W.damtype == "fire" || W.damtype == "brute"))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		visible_message("<span class='danger'>\The [src] has been [LAZYLEN(W.attack_verb) ? pick(W.attack_verb) : "attacked"] with \the [W] by \the [user]!</span>")
		take_damage(W.force)
		return
	. = ..()

/obj/structure/railing/ex_act(severity)
	qdel(src)

/obj/structure/railing/do_climb(var/mob/living/user)
	if(!can_climb(user))
		return

	user.visible_message("<span class='warning'>\The [user] starts climbing onto \the [src]!</span>")
	climbers |= user

	if(!do_after(user,(issmall(user) ? 20 : 34)))
		climbers -= user
		return

	if(!can_climb(user, post_climb_check=1))
		climbers -= user
		return

	if(!turf_is_crowded())
		to_chat(user, "<span class='warning'>You can't climb there, the way is blocked.</span>")
		climbers -= user
		return

	if(get_turf(user) == get_turf(src))
		user.forceMove(get_step(src, src.dir))
	else
		user.forceMove(get_turf(src))

	user.visible_message("<span class='danger'>\The [user] climbed over \the [src]!</span>")
	if(!anchored || material.is_brittle())
		take_damage(maxhealth) // Fatboy
	climbers -= user
