/*
 * Contains
 * /obj/item/rig_module/stealth_field
 * /obj/item/rig_module/teleporter
 * /obj/item/rig_module/fabricator/energy_net
 * /obj/item/rig_module/self_destruct
 * /obj/item/rig_module/actuators
 * /obj/item/rig_module/personal_shield
 */

/obj/item/rig_module/stealth_field

	name = "active camouflage module"
	desc = "A robust hardsuit-integrated stealth module."
	icon_state = "cloak"

	toggleable = 1
	disruptable = 1
	disruptive = 0

	use_power_cost = 500 KILOWATTS
	active_power_cost = 60 KILOWATTS
	passive_power_cost = 0
	module_cooldown = 10 SECONDS
	origin_tech = list(TECH_MATERIAL = 5, TECH_POWER = 6, TECH_MAGNET = 6, TECH_ESOTERIC = 6, TECH_ENGINEERING = 7)
	activate_string = "Enable Cloak"
	deactivate_string = "Disable Cloak"

	interface_name = "integrated stealth system"
	interface_desc = "An integrated active camouflage system."

	suit_overlay_active =   "stealth_active"
	suit_overlay_inactive = "stealth_inactive"

/obj/item/rig_module/stealth_field/activate()

	if(!..())
		return 0

	var/mob/living/carbon/human/H = holder.wearer

	if(H.add_cloaking_source(src))
		anim(H, 'icons/effects/effects.dmi', "electricity",null,20,null)

/obj/item/rig_module/stealth_field/deactivate()

	if(!..())
		return 0

	var/mob/living/carbon/human/H = holder.wearer

	if(H.remove_cloaking_source(src))
		anim(H,'icons/mob/mob.dmi',,"uncloak",,H.dir)
		anim(H, 'icons/effects/effects.dmi', "electricity",null,20,null)

	// We still play the sound, even if not visibly uncloaking. Ninjas are not that stealthy.
	playsound(get_turf(H), 'sound/effects/stealthoff.ogg', 75, 1)


/obj/item/rig_module/teleporter

	name = "teleportation module"
	desc = "A complex, sleek-looking, hardsuit-integrated teleportation module."
	icon_state = "teleporter"
	use_power_cost = 800 KILOWATTS
	redundant = 1
	usable = 1
	selectable = 1
	module_cooldown = 60
	engage_string = "Emergency Leap"

	interface_name = "VOID-shift phase projector"
	interface_desc = "An advanced teleportation system. It is capable of pinpoint precision or random leaps forward."

/obj/item/rig_module/teleporter/proc/phase_in(mob/M,turf/T)
	if(!M || !T)
		return
	holder.spark_system.start()
	M.phase_in(T)

/obj/item/rig_module/teleporter/proc/phase_out(mob/M,turf/T)
	if(!M || !T)
		return
	M.phase_out(T)

/obj/item/rig_module/teleporter/engage(atom/target)

	var/mob/living/carbon/human/H = holder.wearer

	if(!isturf(H.loc))
		to_chat(H, SPAN_WARNING("You cannot teleport out of your current location."))
		return 0

	var/turf/T
	if(target)
		T = get_turf(target)
	else
		T = get_teleport_loc(get_turf(H), H, 6, 1, 1, 1)

	if(!T)
		to_chat(H, SPAN_WARNING("No valid teleport target found."))
		return 0

	if(T.density)
		to_chat(H, SPAN_WARNING("You cannot teleport into solid walls."))
		return 0

	if(T.z in GLOB.using_map.admin_levels)
		to_chat(H, SPAN_WARNING("You cannot use your teleporter on this Z-level."))
		return 0

	if(T.contains_dense_objects())
		to_chat(H, SPAN_WARNING("You cannot teleport to a location with solid objects."))
		return 0

	if(T.z != H.z || get_dist(T, get_turf(H)) > world.view)
		to_chat(H, SPAN_WARNING("You cannot teleport to such a distant object."))
		return 0

	if(!..()) return 0

	phase_out(H,get_turf(H))
	H.forceMove(T)
	phase_in(H,get_turf(H))

	for(var/obj/item/grab/G in H.contents)
		if(G.affecting)
			phase_out(G.affecting,get_turf(G.affecting))
			G.affecting.forceMove(locate(T.x+rand(-1,1),T.y+rand(-1,1),T.z))
			phase_in(G.affecting,get_turf(G.affecting))

	return 1


/obj/item/rig_module/fabricator/energy_net

	name = "net projector"
	desc = "Some kind of complex energy projector with a hardsuit mount."
	icon_state = "enet"
	module_cooldown = 100

	interface_name = "energy net launcher"
	interface_desc = "An advanced energy-patterning projector used to capture targets."

	engage_string = "Fabricate Net"

	fabrication_type = /obj/item/energy_net
	use_power_cost = 50 KILOWATTS
	origin_tech = list(TECH_MATERIAL = 5, TECH_POWER = 6, TECH_MAGNET = 5, TECH_ESOTERIC = 4, TECH_ENGINEERING = 6)

/obj/item/rig_module/fabricator/energy_net/engage(atom/target)

	if(holder && holder.wearer)
		if(..(target) && target)
			holder.wearer.Beam(target,"n_beam",,10)
		return 1
	return 0

/obj/item/rig_module/self_destruct
	name = "self-destruct module"
	desc = "Oh my God, Captain. A bomb."
	icon_state = "deadman"
	toggleable = 1
	usable = 1
	permanent = 1

	activate_string = "Enable Auto Self-Destruct"
	deactivate_string = "Disable Auto Self-Destruct"

	engage_string = "Detonate"

	interface_name = "dead man's switch"
	interface_desc = "An integrated automatic self-destruct module. When the wearer dies, so does the surrounding area. Can be triggered manually."
	var/explosion_radius = 7
	var/explosion_max_power = EX_ACT_DEVASTATING
	var/blinking = 0
	var/blink_mode = 0
	var/blink_delay = 10
	var/blink_time = 40
	var/blink_rapid_time = 40
	var/blink_solid_time = 20
	var/activation_check = 0 //used to detect whether proc was called via 'activate' or 'engage'
	var/self_destructing = 0 //used to prevent toggling the switch, then dying and having it toggled again

/obj/item/rig_module/self_destruct/small
	explosion_radius = 3
	explosion_max_power = EX_ACT_LIGHT


/obj/item/rig_module/self_destruct/activate()
	activation_check = 1
	if(!..())
		return 0

/obj/item/rig_module/self_destruct/engage(atom/target, skip_check)
	set waitfor = 0

	if(self_destructing) //prevents repeat calls
		return 0

	if(activation_check)
		activation_check = 0
		return 1

	if(!skip_check)
		if (alert(usr, "Are you sure you want to push that button?", "Self-destruct", "No", "Yes") != "Yes")
			return 0
		if(usr == holder.wearer)
			holder.wearer.visible_message(SPAN_WARNING(" \The [src.holder.wearer] flicks a small switch on the back of \the [src.holder]."),1)
			sleep(blink_delay)

	self_destructing = 1
	src.blink_mode = 1
	src.blink()
	holder.visible_message(SPAN_NOTICE("\The [src.holder] begins beeping."),SPAN_NOTICE(" You hear beeping."))
	sleep(blink_time)
	src.blink_mode = 2
	holder.visible_message(SPAN_WARNING("\The [src.holder] beeps rapidly!"),SPAN_WARNING(" You hear rapid beeping!"))
	sleep(blink_rapid_time)
	src.blink_mode = 3
	holder.visible_message(SPAN_DANGER("\The [src.holder] emits a shrill tone!"),SPAN_DANGER(" You hear a shrill tone!"))
	sleep(blink_solid_time)
	src.blink_mode = 0
	src.holder.set_light(2, 0, "#000000")

	explosion(get_turf(src), explosion_radius, explosion_max_power)
	if(holder && holder.wearer)
		holder.wearer.gib()
		qdel(holder)
	qdel(src)

/obj/item/rig_module/self_destruct/Process()
	// Not being worn, leave it alone.
	if(!holder || !holder.wearer || !holder.wearer.wear_suit == holder)
		return 0

	//OH SHIT.
	if(holder.wearer.stat == DEAD)
		if(active)
			engage(null, TRUE)

/obj/item/rig_module/self_destruct/proc/blink()
	set waitfor = 0
	switch (blink_mode)
		if(0)
			return
		if(1)
			src.holder.set_light(8.5, 1, "#ff0a00")
			sleep(6)
			src.holder.set_light(0)
			spawn(6) .()
		if(2)
			src.holder.set_light(8.5, 1, "#ff0a00")
			sleep(2)
			src.holder.set_light(0)
			spawn(2) .()
		if(3)
			src.holder.set_light(8.5, 1, "#ff0a00")

/obj/item/rig_module/grenade_launcher/ninja
	suit_overlay = null


/* Not a doc comment.
* While on, prevents fall damage.
* Also allows the user to dash to locations while scaling low obstacles and negating damage.
* Also causes the user to: grab mobs, scale ladders, and enter exosuits at their dash endpoint.
*/
/obj/item/rig_module/actuators
	name = "hardsuit mobility module"
	desc = {"\
		A set of actuators and a linked "Vaanyari" speedware chip. They allow the suit to be able \
		to absorb impacts from fatal falls, jump remarkable heights, and move at incredible speeds.\
	"}
	icon_state = "actuators"
	interface_name = "hardsuit mobility module"
	interface_desc = {"\
		A set of actuators and a linked \"Vaanyari\" speedware chip that dampen falls and allow you \
		to absorb impacts from fatal falls, jump remarkable heights, and move at incredible speeds.\
	"}
	use_power_cost = 250 KILOWATTS
	module_cooldown = 0.5 SECONDS
	toggleable = TRUE
	selectable = TRUE
	usable = FALSE
	engage_string = "Engage Dash"
	activate_string = "Engage Fall Dampeners"
	deactivate_string = "Disable Fall Dampeners"

	/// Leaping radius. Inclusive. Applies to diagonal distances.
	var/leapDistance = 7

	var/datum/effect/trail/afterimage/afterimages


/obj/item/rig_module/actuators/Initialize()
	. = ..()
	afterimages = new /datum/effect/trail/afterimage
	afterimages.set_up(src)


/obj/item/rig_module/actuators/engage(atom/target)
	if (!..())
		return FALSE
	if (!target)
		return TRUE
	var/mob/living/carbon/human/wearer = holder.wearer
	if (!isturf(wearer.loc))
		to_chat(wearer, SPAN_WARNING("You cannot dash out of your current location!"))
		return FALSE
	var/turf/turf = get_turf(target)
	if (!turf)
		to_chat(wearer, SPAN_WARNING("You cannot  dash into that location!"))
		return FALSE
	var/dist = max(get_dist(turf, get_turf(wearer)), 0)
	if (turf.z != wearer.z || dist > leapDistance)
		to_chat(wearer, SPAN_WARNING("You cannot dash at such a distant object!"))
		return FALSE
	if (!dist)
		return FALSE
	wearer.visible_message(
		SPAN_WARNING("\The [wearer]'s suit blitzes at incredible speed towards \the [target]!"),
		SPAN_WARNING("You feel your senses dilate as you rush toward \the [target]!"),
		SPAN_WARNING("You hear an electric <i>whirr</i> followed by a weighty thump!")
	)
	wearer.face_atom(turf)
	afterimages.start()
	playsound(wearer, 'sound/effects/basscannon.ogg', 35, TRUE)
	var/old_pass_flags = wearer.pass_flags
	wearer.pass_flags |= PASS_FLAG_TABLE
	wearer.status_flags |= GODMODE
	wearer.jump_layer_shift()
	var/on_complete = new Callback(src, TYPE_PROC_REF(/obj/item/rig_module/actuators, end_dash), target, old_pass_flags)
	wearer.throw_at(turf, leapDistance, 1, wearer, FALSE, on_complete)


/obj/item/rig_module/actuators/proc/end_dash(atom/target, old_pass_flags)
	var/mob/living/carbon/human/wearer = holder.wearer
	wearer.pass_flags = old_pass_flags
	wearer.status_flags &= ~GODMODE
	wearer.jump_layer_shift_end()
	afterimages.stop()
	if (!wearer.Adjacent(target))
		return
	else if (istype(target, /mob/living/carbon/human))
		if(istype(wearer.get_active_hand(),/obj/item/melee))
			wearer.visible_message(
			SPAN_WARNING("\The [wearer] moves before \the [target] can even react!"),
			SPAN_WARNING("You instinctively attack \the [target] before they can even react!")
			)
			target.use_weapon(wearer.get_active_hand(),wearer)
			return
		if (!wearer.species.attempt_grab(wearer, target))
			return
		var/obj/item/grab/grab = wearer.IsHolding(/obj/item/grab)
		if (!istype(grab))
			return
		if (istype(grab, /obj/item/grab/normal))
			grab.upgrade()
		wearer.visible_message(
			SPAN_WARNING("\The [wearer] latches onto \the [target]!"),
			SPAN_WARNING("You latch onto \the [target] at the end of your dash!")
		)
	else if (istype(target, /obj/structure/ladder))
		var/obj/structure/ladder/ladder = target
		wearer.visible_message(
			SPAN_WARNING("\The [wearer] quickly climbs \the [target]!"),
			SPAN_WARNING("You quickly climb \the [target]!")
		)
		ladder.instant_climb(wearer)
	else if (istype(target, /mob/living/exosuit))
		var/mob/living/exosuit/exo = target
		if (!exo.check_enter(wearer))
			return
		exo.enter(wearer, TRUE, FALSE, TRUE)
		wearer.visible_message(
			SPAN_WARNING("\The [wearer] dives into \the [target]!"),
			SPAN_WARNING("You dive into \the [target]'s driver seat!")
		)

/obj/item/rig_module/personal_shield
	name = "hardsuit energy shield"
	desc = "Truly a life-saver: this device protects its user from being hit by objects moving very, very fast. It draws power from a hardsuit's internal battery."
	icon = 'icons/obj/tools/batterer.dmi'
	icon_state = "battereroff"
	var/shield_type = /obj/aura/personal_shield/device
	var/shield_power_cost = 200
	var/obj/aura/personal_shield/device/shield

	VAR_PRIVATE/currently_stored_power = 1000
	VAR_PRIVATE/max_stored_power = 1000
	VAR_PRIVATE/restored_power_per_tick = 5
	VAR_PRIVATE/enable_when_powered = FALSE

	toggleable = TRUE

	interface_name = "energy shield"
	interface_desc = "A device that protects its user from being hit by fast moving projectiles. Its internal capacitor can hold 5 charges at a time and recharges slowly over time."
	module_cooldown = 10 SECONDS
	origin_tech = list(TECH_MATERIAL = 5, TECH_POWER = 6, TECH_MAGNET = 6, TECH_ESOTERIC = 6, TECH_ENGINEERING = 7)
	activate_string = "Enable Shield"
	deactivate_string = "Disable Shield"

/obj/item/rig_module/personal_shield/Initialize()
	. = ..()
	if (holder?.cell)
		currently_stored_power = holder.cell.use(max_stored_power)

/obj/item/rig_module/personal_shield/activate()
	if (!..())
		return FALSE

	var/mob/living/carbon/human/H = holder.wearer

	if (shield || !H)
		return FALSE
	if (currently_stored_power < shield_power_cost)
		to_chat(H, SPAN_WARNING("\The [src]'s internal capacitor does not have enough charge."))
		return FALSE
	shield = new shield_type(H, src)
	return TRUE

/obj/item/rig_module/personal_shield/deactivate()
	if (!..())
		return FALSE

	if (!shield)
		return
	QDEL_NULL(shield)
	next_use = world.time + module_cooldown
	return TRUE

/obj/item/rig_module/personal_shield/Process(wait)
	if (!holder.cell?.charge || currently_stored_power >= max_stored_power)
		return PROCESS_KILL
	var/amount_to_restore = min(restored_power_per_tick * wait, max_stored_power - currently_stored_power)
	currently_stored_power += holder.cell.use(amount_to_restore)

	if (enable_when_powered && currently_stored_power >= shield_power_cost)
		activate(get_holder_of_type(src, /mob))

/obj/item/rig_module/personal_shield/proc/take_charge()
	if (!actual_take_charge())
		deactivate()
		return FALSE
	return TRUE

/obj/item/rig_module/personal_shield/proc/actual_take_charge()
	if (!holder.cell)
		return FALSE
	if (currently_stored_power < shield_power_cost)
		return FALSE

	currently_stored_power -= shield_power_cost
	START_PROCESSING(SSobj, src)

	if (currently_stored_power < shield_power_cost)
		enable_when_powered = TRUE
		return FALSE
	return TRUE

//Returns location. Returns null if no location was found.
/proc/get_teleport_loc(turf/location,mob/target,distance = 1, density = FALSE, errorx = 0, errory = 0, eoffsetx = 0, eoffsety = 0)
	RETURN_TYPE(/turf)
/*
Location where the teleport begins, target that will teleport, distance to go, density checking 0/1(yes/no).
Random error in tile placement x, error in tile placement y, and block offset.
Block offset tells the proc how to place the box. Behind teleport location, relative to starting location, forward, etc.
Negative values for offset are accepted, think of it in relation to North, -x is west, -y is south. Error defaults to positive.
Turf and target are seperate in case you want to teleport some distance from a turf the target is not standing on or something.
*/

	var/dirx = 0//Generic location finding variable.
	var/diry = 0

	var/xoffset = 0//Generic counter for offset location.
	var/yoffset = 0

	var/b1xerror = 0//Generic placing for point A in box. The lower left.
	var/b1yerror = 0
	var/b2xerror = 0//Generic placing for point B in box. The upper right.
	var/b2yerror = 0

	errorx = abs(errorx)//Error should never be negative.
	errory = abs(errory)
	//var/errorxy = round((errorx+errory)/2)//Used for diagonal boxes.

	switch(target.dir)//This can be done through equations but switch is the simpler method. And works fast to boot.
	//Directs on what values need modifying.
		if(1)//North
			diry+=distance
			yoffset+=eoffsety
			xoffset+=eoffsetx
			b1xerror-=errorx
			b1yerror-=errory
			b2xerror+=errorx
			b2yerror+=errory
		if(2)//South
			diry-=distance
			yoffset-=eoffsety
			xoffset+=eoffsetx
			b1xerror-=errorx
			b1yerror-=errory
			b2xerror+=errorx
			b2yerror+=errory
		if(4)//East
			dirx+=distance
			yoffset+=eoffsetx//Flipped.
			xoffset+=eoffsety
			b1xerror-=errory//Flipped.
			b1yerror-=errorx
			b2xerror+=errory
			b2yerror+=errorx
		if(8)//West
			dirx-=distance
			yoffset-=eoffsetx//Flipped.
			xoffset+=eoffsety
			b1xerror-=errory//Flipped.
			b1yerror-=errorx
			b2xerror+=errory
			b2yerror+=errorx

	var/turf/destination=locate(location.x+dirx,location.y+diry,location.z)

	if(destination)//If there is a destination.
		if(errorx||errory)//If errorx or y were specified.
			var/destination_list[] = list()//To add turfs to list.
			//destination_list = new()
			/*This will draw a block around the target turf, given what the error is.
			Specifying the values above will basically draw a different sort of block.
			If the values are the same, it will be a square. If they are different, it will be a rectengle.
			In either case, it will center based on offset. Offset is position from center.
			Offset always calculates in relation to direction faced. In other words, depending on the direction of the teleport,
			the offset should remain positioned in relation to destination.*/

			var/turf/center = locate((destination.x+xoffset),(destination.y+yoffset),location.z)//So now, find the new center.

			//Now to find a box from center location and make that our destination.
			for(var/turf/T in block(locate(center.x+b1xerror,center.y+b1yerror,location.z), locate(center.x+b2xerror,center.y+b2yerror,location.z) ))
				if(density && T.contains_dense_objects())	continue//If density was specified.
				if(T.x>world.maxx || T.x<1)	continue//Don't want them to teleport off the map.
				if(T.y>world.maxy || T.y<1)	continue
				destination_list += T
			if(length(destination_list))
				destination = pick(destination_list)
			else	return

		else//Same deal here.
			if(density && destination.contains_dense_objects())	return
			if(destination.x>world.maxx || destination.x<1)	return
			if(destination.y>world.maxy || destination.y<1)	return
	else	return

	return destination
