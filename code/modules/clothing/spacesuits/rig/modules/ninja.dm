/*
 * Contains
 * /obj/item/rig_module/stealth_field
 * /obj/item/rig_module/teleporter
 * /obj/item/rig_module/fabricator/energy_net
 * /obj/item/rig_module/self_destruct
 */

/obj/item/rig_module/stealth_field

	name = "active camouflage module"
	desc = "A robust hardsuit-integrated stealth module."
	icon_state = "cloak"

	toggleable = 1
	disruptable = 1
	disruptive = 0

	use_power_cost = 250 KILOWATTS
	active_power_cost = 36 KILOWATTS		// ~5 min battery life /w best (3kWh) cell
	passive_power_cost = 0
	module_cooldown = 10 SECONDS

	activate_string = "Enable Cloak"
	deactivate_string = "Disable Cloak"

	interface_name = "integrated stealth system"
	interface_desc = "An integrated active camouflage system."

	suit_overlay_active =   "stealth_active"
	suit_overlay_inactive = "stealth_inactive"

	var/last_flick = 0
	var/turf/last_turf

/obj/item/rig_module/stealth_field/activate()

	if(!..())
		return 0

	var/mob/living/carbon/human/H = holder.wearer

	to_chat(H, "<font color='blue'><b>You are now invisible to normal detection.</b></font>")
	H.cloaked = TRUE
	H.update_icons()

	anim(get_turf(H), H, 'icons/effects/effects.dmi', "electricity",null,20,null)

	H.visible_message("[H.name] vanishes into thin air!",1)

	last_flick = 0
	last_turf = get_turf(holder.wearer)

/obj/item/rig_module/stealth_field/deactivate()

	if(!..())
		return 0

	var/mob/living/carbon/human/H = holder.wearer

	to_chat(H, "<span class='danger'>You are now visible.</span>")
	H.cloaked = FALSE
	H.update_icons()

	anim(get_turf(H), H,'icons/mob/mob.dmi',,"uncloak",,H.dir)
	anim(get_turf(H), H, 'icons/effects/effects.dmi', "electricity",null,20,null)

	for(var/mob/O in oviewers(H))
		O.show_message("[H.name] appears from thin air!",1)
	playsound(get_turf(H), 'sound/effects/stealthoff.ogg', 75, 1)


/obj/item/rig_module/stealth_field/process()
	if(!active)
		return

	var/mob/living/carbon/human/H = holder.wearer
	var/turf/new_turf = get_turf(holder.wearer)
	last_flick += (5*round(get_dist(new_turf,last_turf)**0.5)) //increases flick chance related to sqrt of distance between turf of last process

	if(prob(last_flick))
		anim(get_turf(H), H, 'icons/effects/effects.dmi', "electricity",null,20,null) //just a flicker
		if(prob(last_flick/5))
			anim(get_turf(H), H,'icons/mob/mob.dmi',,"uncloak",,H.dir) //if we're really unlucky it flicks that humanoid overlay
		last_flick = 0
	else
		last_flick += 2

	last_turf = new_turf

/obj/item/rig_module/teleporter
	name = "teleportation module"
	desc = "A complex, sleek-looking, hardsuit-integrated teleportation module."
	icon_state = "teleporter"
	use_power_cost = 375 KILOWATTS
	redundant = 1
	usable = 1
	selectable = 1
	module_cooldown = 60
	engage_string = "Emergency Leap"

	interface_name = "VOID-shift phase projector"
	interface_desc = "An advanced teleportation system. It is capable of pinpoint precision or random leaps forward."

/obj/item/rig_module/teleporter/proc/phase_in(var/mob/M,var/turf/T)
	if(!M || !T)
		return
	holder.spark_system.start()
	M.phase_in(T)

/obj/item/rig_module/teleporter/proc/phase_out(var/mob/M,var/turf/T)
	if(!M || !T)
		return
	M.phase_out(T)

/obj/item/rig_module/teleporter/engage(var/atom/target, var/notify_ai)

	var/mob/living/carbon/human/H = holder.wearer

	if(!istype(H.loc, /turf))
		to_chat(H, "<span class='warning'>You cannot teleport out of your current location.</span>")
		return 0

	var/turf/T
	if(target)
		T = get_turf(target)
	else
		T = get_teleport_loc(get_turf(H), H, 6, 1, 1, 1)

	if(!T)
		to_chat(H, "<span class='warning'>No valid teleport target found.</span>")
		return 0

	if(T.density)
		to_chat(H, "<span class='warning'>You cannot teleport into solid walls.</span>")
		return 0

	if(T.z in using_map.admin_levels)
		to_chat(H, "<span class='warning'>You cannot use your teleporter on this Z-level.</span>")
		return 0

	if(T.contains_dense_objects())
		to_chat(H, "<span class='warning'>You cannot teleport to a location with solid objects.</span>")
		return 0

	if(T.z != H.z || get_dist(T, get_turf(H)) > world.view)
		to_chat(H, "<span class='warning'>You cannot teleport to such a distant object.</span>")
		return 0

	if(!..()) return 0

	phase_out(H,get_turf(H))
	H.forceMove(T)
	phase_in(H,get_turf(H))

	for(var/obj/item/weapon/grab/G in H.contents)
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

	fabrication_type = /obj/item/weapon/energy_net
	use_power_cost = 20 KILOWATTS

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
	var/list/explosion_values = list(1,2,4,5)
	var/blinking = 0
	var/blink_mode = 0
	var/blink_delay = 10
	var/blink_time = 40
	var/blink_rapid_time = 40
	var/blink_solid_time = 20
	var/activation_check = 0 //used to detect whether proc was called via 'activate' or 'engage'
	var/self_destructing = 0 //used to prevent toggling the switch, then dying and having it toggled again
	var/death_activation = 0

/obj/item/rig_module/self_destruct/small
	explosion_values = list(0,0,3,4)


/obj/item/rig_module/self_destruct/activate()
	activation_check = 1
	if(!..())
		return 0

/obj/item/rig_module/self_destruct/engage(var/skip_check = FALSE)
	set waitfor = 0

	if(self_destructing) //prevents repeat calls
		return 0

	if(activation_check)
		activation_check = 0
		return 1

	if(!skip_check)
		if(!usr || alert(usr, "Are you sure you want to push that button?", "Self-destruct", "No", "Yes") == "No")
			return

		if(usr == holder.wearer)
			holder.wearer.visible_message("<span class='warning'> \The [src.holder.wearer] flicks a small switch on the back of \the [src.holder].</span>",1)
			sleep(blink_delay)

	self_destructing = 1
	src.blink_mode = 1
	src.blink()
	holder.visible_message("<span class='notice'>\The [src.holder] begins beeping.</span>","<span class='notice'> You hear beeping.</span>")
	sleep(blink_time)
	src.blink_mode = 2
	holder.visible_message("<span class='warning'>\The [src.holder] beeps rapidly!</span>","<span class='warning'> You hear rapid beeping!</span>")
	sleep(blink_rapid_time)
	src.blink_mode = 3
	holder.visible_message("<span class='danger'>\The [src.holder] emits a shrill tone!</span>","<span class='danger'> You hear a shrill tone!</span>")
	sleep(blink_solid_time)
	src.blink_mode = 0
	src.holder.set_light(0, 0, "#000000")

	explosion(get_turf(src), explosion_values[1], explosion_values[2], explosion_values[3], explosion_values[4])
	if(holder && holder.wearer)
		holder.wearer.drop_from_inventory(src)
		qdel(holder)
	qdel(src)

/obj/item/rig_module/self_destruct/process()
	// Not being worn, leave it alone.
	if(!holder || !holder.wearer || !holder.wearer.wear_suit == holder)
		return 0

	//OH SHIT.
	if(holder.wearer.stat == DEAD)
		if(src.active)
			blink_time *= 5 //Manually activating it should have a shorter time to detonate
			blink_rapid_time *= 4 //On-death triggering has a bit longer, for people to decide to leave without just having ten seconds to meta.
			blink_solid_time *= 2
			engage(1)

/obj/item/rig_module/self_destruct/proc/blink()
	set waitfor = 0
	switch (blink_mode)
		if(0)
			return
		if(1)
			src.holder.set_light(1.5, 8.5, "#FF0A00")
			sleep(6)
			src.holder.set_light(0, 0, "#000000")
			spawn(6) .()
		if(2)
			src.holder.set_light(1.5, 8.5, "#FF0A00")
			sleep(2)
			src.holder.set_light(0, 0, "#000000")
			spawn(2) .()
		if(3)
			src.holder.set_light(1.5, 8.5, "#FF0A00")