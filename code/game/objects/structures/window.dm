/obj/structure/window
	name = "window"
	desc = "A window."
	icon = 'icons/obj/window.dmi'
	density = 1
	w_class = ITEM_SIZE_NORMAL

	layer = SIDE_WINDOW_LAYER
	anchored = 1.0
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CHECKS_BORDER
	obj_flags = OBJ_FLAG_ROTATABLE
	alpha = 180
	var/material/reinf_material
	var/init_material = MATERIAL_GLASS
	var/init_reinf_material = null
	var/maxhealth
	var/health
	var/damage_per_fire_tick = 2 		// Amount of damage per fire tick. Regular windows are not fireproof so they might as well break quickly.
	var/construction_state = 2
	var/id
	var/polarized = 0
	var/basestate = "window"
	var/reinf_basestate = "rwindow"
	rad_resistance_modifier = 0.5
	blend_objects = list(/obj/machinery/door, /turf/simulated/wall) // Objects which to blend with
	noblend_objects = list(/obj/machinery/door/window)

	atmos_canpass = CANPASS_PROC

/obj/structure/window/get_material()
	return material

/obj/structure/window/Initialize(mapload, start_dir=null, constructed=0, var/new_material, var/new_reinf_material)
	. = ..()
	if(!new_material)
		new_material = init_material
		if(!new_material)
			new_material = MATERIAL_GLASS
	if(!new_reinf_material)
		new_reinf_material = init_reinf_material
	material = SSmaterials.get_material_by_name(new_material)
	if(!istype(material))
		return INITIALIZE_HINT_QDEL

	if(new_reinf_material)
		reinf_material = SSmaterials.get_material_by_name(new_reinf_material)

	name = "[reinf_material ? "reinforced " : ""][material.display_name] window"
	desc = "A window pane made from [material.display_name]."
	color =  material.icon_colour

	if (start_dir)
		set_dir(start_dir)

	maxhealth = material.integrity
	if(reinf_material)
		maxhealth += 0.5 * reinf_material.integrity

	if(is_fulltile())
		layer = FULL_WINDOW_LAYER

	health = maxhealth

	set_anchored(!constructed)
	update_connections(1)
	update_icon()
	update_nearby_tiles(need_rebuild=1)

/obj/structure/window/Destroy()
	set_density(0)
	update_nearby_tiles()
	var/turf/location = loc
	. = ..()
	for(var/obj/structure/window/W in orange(location, 1))
		W.update_icon()

/obj/structure/window/examine(mob/user)
	. = ..(user)
	if(reinf_material)
		to_chat(user, "<span class='notice'>It is reinforced with the [reinf_material.display_name] lattice.</span>")
	if(health == maxhealth)
		to_chat(user, "<span class='notice'>It looks fully intact.</span>")
	else
		var/perc = health / maxhealth
		if(perc > 0.75)
			to_chat(user, "<span class='notice'>It has a few cracks.</span>")
		else if(perc > 0.5)
			to_chat(user, "<span class='warning'>It looks slightly damaged.</span>")
		else if(perc > 0.25)
			to_chat(user, "<span class='warning'>It looks moderately damaged.</span>")
		else
			to_chat(user, "<span class='danger'>It looks heavily damaged.</span>")

/obj/structure/window/CanFluidPass(var/coming_from)
	return (!is_fulltile() && coming_from != dir)

/obj/structure/window/take_damage(damage = 0,  var/sound_effect = 1)
	var/initialhealth = health

	health = max(0, health - damage)

	if(health <= 0)
		shatter()
	else
		if(sound_effect)
			playsound(loc, 'sound/effects/Glasshit.ogg', 100, 1)
		if(health < maxhealth / 4 && initialhealth >= maxhealth / 4)
			visible_message(SPAN_DANGER("\The [src] looks like it's about to shatter!"))
			playsound(loc, "glasscrack", 100, 1)
		else if(health < maxhealth / 2 && initialhealth >= maxhealth / 2)
			visible_message(SPAN_WARNING("\The [src] looks seriously damaged!"))
			playsound(loc, "glasscrack", 100, 1)
		else if(health < maxhealth * 3/4 && initialhealth >= maxhealth * 3/4)
			visible_message(SPAN_WARNING("Cracks begin to appear in \the [src]!"))
			playsound(loc, "glasscrack", 100, 1)
	return

/obj/structure/window/proc/shatter(var/display_message = 1)
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message("<span class='warning'>\The [src] shatters!</span>")

	var/debris_count = is_fulltile() ? 4 : 1
	for(var/i = 0 to debris_count)
		material.place_shard(loc)
		if(reinf_material)
			new /obj/item/stack/material/rods(loc, 1, reinf_material.name)
	qdel(src)

/obj/structure/window/bullet_act(var/obj/item/projectile/Proj)
	var/proj_damage = Proj.get_structure_damage()
	if(!proj_damage) return
	..()
	take_damage(proj_damage)

/obj/structure/window/ex_act(severity)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			shatter(0)
		if(3)
			if(prob(50))
				shatter(0)

/obj/structure/window/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASS_FLAG_GLASS))
		return 1
	if(is_fulltile())
		return 0	//full tile window, you can't move into it!
	if(get_dir(loc, target) & dir)
		return !density
	else
		return 1

/obj/structure/window/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASS_FLAG_GLASS))
		return 1
	if(get_dir(O.loc, target) == dir)
		return 0
	return 1

/obj/structure/window/hitby(atom/movable/AM, var/datum/thrownthing/TT)
	..()
	visible_message("<span class='danger'>[src] was hit by [AM].</span>")
	var/tforce = 0
	if(ismob(AM)) // All mobs have a multiplier and a size according to mob_defines.dm
		var/mob/I = AM
		tforce = I.mob_size * (TT.speed/THROWFORCE_SPEED_DIVISOR)
	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce * (TT.speed/THROWFORCE_SPEED_DIVISOR)
	if(reinf_material) tforce *= 0.25
	if(health - tforce <= 7 && !reinf_material)
		set_anchored(FALSE)
		step(src, get_dir(AM, src))
	take_damage(tforce)

/obj/structure/window/attack_hand(mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(MUTATION_HULK in user.mutations)
		user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!"))
		user.visible_message("<span class='danger'>[user] smashes through [src]!</span>")
		user.do_attack_animation(src)
		shatter()

	else if (user.a_intent && user.a_intent == I_HURT)

		if (istype(user,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(H.species.can_shred(H))
				attack_generic(H,25)
				return

		playsound(src.loc, 'sound/effects/glassknock.ogg', 80, 1)
		user.do_attack_animation(src)
		user.visible_message("<span class='danger'>\The [user] bangs against \the [src]!</span>",
							"<span class='danger'>You bang against \the [src]!</span>",
							"You hear a banging sound.")
	else
		playsound(src.loc, 'sound/effects/glassknock.ogg', 80, 1)
		user.visible_message("[user.name] knocks on the [src.name].",
							"You knock on the [src.name].",
							"You hear a knocking sound.")
	return

/obj/structure/window/attack_generic(var/mob/user, var/damage, var/attack_verb, var/environment_smash)
	if(environment_smash >= 1)
		damage = max(damage, 10)

	if(istype(user))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(src)
	if(!damage)
		return
	if(damage >= 10)
		visible_message("<span class='danger'>[user] [attack_verb] into [src]!</span>")
		take_damage(damage)
	else
		visible_message("<span class='notice'>\The [user] bonks \the [src] harmlessly.</span>")
	return 1

/obj/structure/window/do_simple_ranged_interaction(var/mob/user)
	visible_message(SPAN_NOTICE("Something knocks on \the [src]."))
	playsound(loc, 'sound/effects/Glasshit.ogg', 50, 1)
	return TRUE

/obj/structure/window/attackby(obj/item/W as obj, mob/user as mob)
	if(!istype(W)) return//I really wish I did not need this

	if(W.item_flags & ITEM_FLAG_NO_BLUDGEON) return

	if(isScrewdriver(W))
		if(reinf_material && construction_state >= 1)
			construction_state = 3 - construction_state
			update_nearby_icons()
			playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
			to_chat(user, (construction_state == 1 ? "<span class='notice'>You have unfastened the window from the frame.</span>" : "<span class='notice'>You have fastened the window to the frame.</span>"))
		else if(reinf_material && construction_state == 0)
			set_anchored(!anchored)
			playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
			to_chat(user, (anchored ? "<span class='notice'>You have fastened the frame to the floor.</span>" : "<span class='notice'>You have unfastened the frame from the floor.</span>"))
		else if(!reinf_material)
			set_anchored(!anchored)
			playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
			to_chat(user, (anchored ? "<span class='notice'>You have fastened the window to the floor.</span>" : "<span class='notice'>You have unfastened the window.</span>"))
	else if(isCrowbar(W) && reinf_material && construction_state <= 1)
		construction_state = 1 - construction_state
		playsound(loc, 'sound/items/Crowbar.ogg', 75, 1)
		to_chat(user, (construction_state ? "<span class='notice'>You have pried the window into the frame.</span>" : "<span class='notice'>You have pried the window out of the frame.</span>"))
	else if(isWrench(W) && !anchored && (!construction_state || !reinf_material))
		if(!material.stack_type)
			to_chat(user, "<span class='notice'>You're not sure how to dismantle \the [src] properly.</span>")
		else
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			visible_message("<span class='notice'>[user] dismantles \the [src].</span>")
			var/obj/item/stack/material/S = material.place_sheet(loc, is_fulltile() ? 4 : 1)
			if(S && reinf_material)
				S.reinf_material = reinf_material
				S.update_strings()
				S.update_icon()
			qdel(src)
	else if(isCoil(W) && !polarized && is_fulltile())
		var/obj/item/stack/cable_coil/C = W
		if (C.use(1))
			playsound(src.loc, 'sound/effects/sparks1.ogg', 75, 1)
			polarized = TRUE
	else if(polarized && isMultitool(W))
		var/t = sanitizeSafe(input(user, "Enter the ID for the window.", src.name, null), MAX_NAME_LEN)
		if(user.incapacitated() || !user.Adjacent(src))
			return
		if (user.get_active_hand() != W)
			return
		if (t)
			src.id = t
			to_chat(user, "<span class='notice'>The new ID of the window is [id]</span>")
		return
	else if(istype(W, /obj/item/weapon/gun/energy/plasmacutter) && anchored)
		var/obj/item/weapon/gun/energy/plasmacutter/cutter = W
		if(!cutter.slice(user))
			return
		playsound(src, 'sound/items/Welder.ogg', 80, 1)
		visible_message("<span class='notice'>[user] has started slicing through the window's frame!</span>")
		if(do_after(user,20,src))
			visible_message("<span class='warning'>[user] has sliced through the window's frame!</span>")
			playsound(src, 'sound/items/Welder.ogg', 80, 1)
			construction_state = 0
			set_anchored(0)
	else
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(W.damtype == BRUTE || W.damtype == BURN)
			user.do_attack_animation(src)
			hit(W.force)
			if(health <= 7)
				set_anchored(FALSE)
				step(src, get_dir(user, src))
		else
			playsound(loc, 'sound/effects/Glasshit.ogg', 75, 1)
		..()
	return

/obj/structure/window/grab_attack(var/obj/item/grab/G)
	if (G.assailant.a_intent != I_HURT)
		return TRUE
	if (!G.force_danger())
		to_chat(G.assailant, "<span class='danger'>You need a better grip to do that!</span>")
		return TRUE
	var/def_zone = ran_zone(BP_HEAD, 20)
	if(G.damage_stage() < 2)
		G.affecting.visible_message("<span class='danger'>[G.assailant] bashes [G.affecting] against \the [src]!</span>")
		if (prob(50))
			G.affecting.Weaken(1)
		G.affecting.apply_damage(10, BRUTE, def_zone, used_weapon = src)
		hit(25)
	else
		G.affecting.visible_message("<span class='danger'>[G.assailant] crushes [G.affecting] against \the [src]!</span>")
		G.affecting.Weaken(5)
		G.affecting.apply_damage(20, BRUTE, def_zone, used_weapon = src)
		hit(50)
	return TRUE

/obj/structure/window/proc/hit(var/damage, var/sound_effect = 1)
	if(reinf_material) damage *= 0.5
	take_damage(damage)

/obj/structure/window/rotate(mob/user)
	if(!CanPhysicallyInteract(user))
		to_chat(user, SPAN_NOTICE("You can't interact with \the [src] right now!"))
		return

	if (anchored)
		to_chat(user, SPAN_NOTICE("\The [src] is secured to the floor!"))
		return

	update_nearby_tiles(need_rebuild=1) //Compel updates before
	set_dir(turn(dir, 90))
	update_nearby_tiles(need_rebuild=1)

/obj/structure/window/Move()
	var/ini_dir = dir
	update_nearby_tiles(need_rebuild=1)
	..()
	set_dir(ini_dir)
	update_nearby_tiles(need_rebuild=1)

//checks if this window is full-tile one
/obj/structure/window/proc/is_fulltile()
	if(dir & (dir - 1))
		return 1
	return 0

/obj/structure/window/proc/set_anchored(var/new_anchored)
	if(anchored == new_anchored)
		return
	anchored = new_anchored
	update_connections(1)
	update_nearby_icons()

//This proc is used to update the icons of nearby windows. It should not be confused with update_nearby_tiles(), which is an atmos proc!
/obj/structure/window/proc/update_nearby_icons()
	update_icon()
	for(var/obj/structure/window/W in orange(src, 1))
		W.update_icon()

// Visually connect with every type of window as long as it's full-tile.
/obj/structure/window/can_visually_connect()
	return ..() && is_fulltile()

/obj/structure/window/can_visually_connect_to(var/obj/structure/S)
	return istype(S, /obj/structure/window)

//merges adjacent full-tile windows into one (blatant ripoff from game/smoothwall.dm)
/obj/structure/window/on_update_icon()
	//A little cludge here, since I don't know how it will work with slim windows. Most likely VERY wrong.
	//this way it will only update full-tile ones
	if(reinf_material)
		basestate = reinf_basestate
	else
		basestate = initial(basestate)
	overlays.Cut()
	layer = FULL_WINDOW_LAYER
	if(!is_fulltile())
		layer = SIDE_WINDOW_LAYER
		icon_state = basestate
		return

	var/image/I
	icon_state = ""
	if(is_on_frame())
		for(var/i = 1 to 4)
			if(other_connections[i] != "0")
				I = image(icon, "[basestate]_other_onframe[connections[i]]", dir = 1<<(i-1))
			else
				I = image(icon, "[basestate]_onframe[connections[i]]", dir = 1<<(i-1))
			overlays += I
	else
		for(var/i = 1 to 4)
			if(other_connections[i] != "0")
				I = image(icon, "[basestate]_other[connections[i]]", dir = 1<<(i-1))
			else
				I = image(icon, "[basestate][connections[i]]", dir = 1<<(i-1))
			overlays += I

/obj/structure/window/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	var/melting_point = material.melting_point
	if(reinf_material)
		melting_point += 0.25*reinf_material.melting_point
	if(exposed_temperature > melting_point)
		hit(damage_per_fire_tick, 0)
	..()

/obj/structure/window/basic
	icon_state = "window"
	color = GLASS_COLOR

/obj/structure/window/basic/full
	dir = 5
	icon_state = "window_full"

/obj/structure/window/basic/full/polarized
	polarized = 1

/obj/structure/window/phoronbasic
	name = "phoron window"
	color = GLASS_COLOR_PHORON
	init_material = MATERIAL_PHORON_GLASS

/obj/structure/window/phoronbasic/full
	dir = 5
	icon_state = "window_full"

/obj/structure/window/phoronreinforced
	name = "reinforced borosilicate window"
	icon_state = "rwindow"
	color = GLASS_COLOR_PHORON
	init_material = MATERIAL_PHORON_GLASS
	init_reinf_material = MATERIAL_STEEL

/obj/structure/window/phoronreinforced/full
	dir = 5
	icon_state = "window_full"

/obj/structure/window/reinforced
	name = "reinforced window"
	icon_state = "rwindow"
	init_material = MATERIAL_GLASS
	init_reinf_material = MATERIAL_STEEL

/obj/structure/window/reinforced/full
	dir = 5
	icon_state = "rwindow_full"

/obj/structure/window/reinforced/tinted
	name = "tinted window"
	opacity = 1
	color = GLASS_COLOR_TINTED

/obj/structure/window/reinforced/tinted/frosted
	name = "frosted window"
	color = GLASS_COLOR_FROSTED

/obj/structure/window/shuttle
	name = "shuttle window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon = 'icons/obj/podwindows.dmi'
	basestate = "w"
	reinf_basestate = "w"
	dir = 5

/obj/structure/window/reinforced/polarized
	name = "electrochromic window"
	desc = "Adjusts its tint with voltage. Might take a few good hits to shatter it."
	basestate = "rwindow"
	polarized = 1

/obj/structure/window/reinforced/polarized/full
	dir = 5
	icon_state = "rwindow_full"

/obj/structure/window/proc/toggle()
	if(!polarized)
		return
	if(opacity)
		animate(src, color=material.icon_colour, time=5)
		set_opacity(0)
	else
		animate(src, color=GLASS_COLOR_TINTED, time=5)
		set_opacity(1)

/obj/structure/window/proc/is_on_frame()
	if(locate(/obj/structure/wall_frame) in loc)
		return TRUE

/obj/machinery/button/windowtint
	name = "window tint control"
	icon = 'icons/obj/power.dmi'
	icon_state = "light0"
	desc = "A remote control switch for electrochromic windows."
	var/id
	var/range = 7
	stock_part_presets = null // This isn't a radio-enabled button; it communicates with nearby structures in view.
	uncreated_component_parts = list(
		/obj/item/weapon/stock_parts/power/apc
	)

/obj/machinery/button/windowtint/attackby(obj/item/device/W as obj, mob/user as mob)
	if(isMultitool(W))
		var/t = sanitizeSafe(input(user, "Enter the ID for the button.", src.name, id), MAX_NAME_LEN)
		if(user.incapacitated() && !user.Adjacent(src))
			return
		if (user.get_active_hand() != W)
			return
		if (!in_range(src, user) && src.loc != user)
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if (t)
			src.id = t
			to_chat(user, "<span class='notice'>The new ID of the button is [id]</span>")
		return
	if(istype(W, /obj/item/weapon/screwdriver))
		new /obj/item/frame/light_switch/windowtint(user.loc, 1)
		qdel(src)

/obj/machinery/button/windowtint/activate()
	if(operating)
		return
	for(var/obj/structure/window/W in range(src,range))
		if(W.polarized && (W.id == src.id || !W.id))
			W.toggle()
	..()

/obj/machinery/button/windowtint/power_change()
	. = ..()
	if(active && (stat & NOPOWER))
		activate()

/obj/machinery/button/windowtint/on_update_icon()
	icon_state = "light[active]"

//Centcomm windows
/obj/structure/window/reinforced/crescent/attack_hand()
	return

/obj/structure/window/reinforced/crescent/attackby()
	return

/obj/structure/window/reinforced/crescent/ex_act()
	return

/obj/structure/window/reinforced/crescent/hitby()
	return

/obj/structure/window/reinforced/crescent/take_damage()
	return

/obj/structure/window/reinforced/crescent/shatter()
	return

/proc/place_window(mob/user, loc, dir_to_set, obj/item/stack/material/ST)
	var/required_amount = (dir_to_set & (dir_to_set - 1)) ? 4 : 1
	if (!ST.can_use(required_amount))
		to_chat(user, "<span class='notice'>You do not have enough sheets.</span>")
		return
	for(var/obj/structure/window/WINDOW in loc)
		if(WINDOW.dir == dir_to_set)
			to_chat(user, "<span class='notice'>There is already a window facing this way there.</span>")
			return
		if(WINDOW.is_fulltile() && (dir_to_set & (dir_to_set - 1))) //two fulltile windows
			to_chat(user, "<span class='notice'>There is already a window there.</span>")
			return
	to_chat(user, "<span class='notice'>You start placing the window.</span>")
	if(do_after(user,20))
		for(var/obj/structure/window/WINDOW in loc)
			if(WINDOW.dir == dir_to_set)//checking this for a 2nd time to check if a window was made while we were waiting.
				to_chat(user, "<span class='notice'>There is already a window facing this way there.</span>")
				return
			if(WINDOW.is_fulltile() && (dir_to_set & (dir_to_set - 1)))
				to_chat(user, "<span class='notice'>There is already a window there.</span>")
				return

		if (ST.use(required_amount))
			var/obj/structure/window/WD = new(loc, dir_to_set, FALSE, ST.material.name, ST.reinf_material && ST.reinf_material.name)
			to_chat(user, "<span class='notice'>You place [WD].</span>")
			WD.construction_state = 0
			WD.set_anchored(FALSE)
		else
			to_chat(user, "<span class='notice'>You do not have enough sheets.</span>")
			return