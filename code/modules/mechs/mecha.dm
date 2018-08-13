// Big stompy robots.
/mob/living/heavy_vehicle
	name = "exosuit"
	density = 1
	opacity = 1
	anchored = 1

	status_flags = PASSEMOTES
	a_intent = I_HURT
	mob_size = MOB_LARGE

	var/emp_damage = 0

	// Used to offset a non-32x32 icon appropriately.
	var/offset_x = -8
	var/offset_y = 0

	var/obj/item/device/radio/radio

	var/wreckage_path = /obj/structure/mech_wreckage
	var/mech_turn_sound = 'sound/mecha/mechturn.ogg'
	var/mech_step_sound = 'sound/mecha/mechstep.ogg'

	// Access updating/container.
	var/obj/item/weapon/card/id/access_card
	var/list/saved_access = list()
	var/sync_access = 1

	// Visual shit.
	var/list/body_overlays = list()
	var/list/hardpoint_overlays = list()

	// Mob currently piloting the mech.
	var/mob/living/pilot
	var/image/draw_pilot

	// Visible external components. Not strictly accurately named for non-humanoid machines (submarines) but w/e
	var/obj/item/mech_component/manipulators/arms
	var/obj/item/mech_component/propulsion/legs
	var/obj/item/mech_component/sensors/head
	var/obj/item/mech_component/chassis/body
	var/decal

	// Invisible components.
	var/datum/effect/effect/system/spark_spread/sparks

	// Equipment tracking vars.
	var/obj/item/selected_system
	var/selected_hardpoint
	var/list/hardpoints = list()
	var/hardpoints_locked
	var/maintenance_protocols

	// Cockpit access vars.
	var/hatch_closed = 0
	var/hatch_locked = 0

	// Interface stuff.
	var/list/hud_elements = list()
	var/list/hardpoint_hud_elements = list()
	var/obj/screen/movable/mecha/health/hud_health
	var/obj/screen/movable/mecha/toggle/hatch_open/hud_open

/mob/living/heavy_vehicle/Destroy()

	selected_system = null

	if(pilot)
		if(pilot.client)
			pilot.client.screen -= hud_elements
			pilot.client.images -= hud_elements
		pilot.forceMove(get_turf(src))
		pilot = null

	for(var/thing in hud_elements)
		qdel(thing)
	hud_elements.Cut()

	for(var/hardpoint in hardpoints)
		qdel(hardpoints[hardpoint])
	hardpoints.Cut()

	QDEL_NULL(access_card)
	QDEL_NULL(arms)
	QDEL_NULL(legs)
	QDEL_NULL(head)
	QDEL_NULL(body)

	body_overlays.Cut()
	hardpoint_overlays.Cut()

	for(var/hardpoint in hardpoint_hud_elements)
		var/obj/screen/movable/mecha/hardpoint/H = hardpoint_hud_elements[hardpoint]
		H.owner = null
		H.holding = null
		qdel(H)
	hardpoint_hud_elements.Cut()

	. = ..()

/mob/living/heavy_vehicle/IsAdvancedToolUser()
	return 1

/mob/living/heavy_vehicle/examine(var/mob/user)
	. = ..()
	if(.)
		to_chat(user, "That's \a [src].")
		to_chat(user, desc)
		if(pilot && (!hatch_closed || body.open_cabin))
			to_chat(user, "It is being piloted by \the [pilot].")
		if(hardpoints.len)
			to_chat(user, "It has the following hardpoints:")
			for(var/hardpoint in hardpoints)
				var/obj/item/I = hardpoints[hardpoint]
				to_chat(user, "- [hardpoint]: [istype(I) ? "[I]" : "nothing"].")
		else
			to_chat(user, "It has no visible hardpoints.")

		for(var/obj/item/mech_component/thing in list(arms, legs, head, body))
			if(!thing)
				continue
			var/damage_string = "destroyed"
			switch(thing.damage_state)
				if(1)
					damage_string = "undamaged"
				if(2)
					damage_string = "damaged"
				if(3)
					damage_string = "badly damaged"
				if(4)
					damage_string = "almost destroyed"
			to_chat(user, "Its [thing.name] [thing.gender == PLURAL ? "are" : "is"] [damage_string].")

/mob/living/heavy_vehicle/New(var/newloc, var/obj/structure/heavy_vehicle_frame/source_frame)

	..(newloc)

	if(!access_card) access_card = new (src)

	if(offset_x) pixel_x = offset_x
	if(offset_y) pixel_y = offset_y
	sparks = new(src)
	radio = new(src)

	// Grab all the supplied components.
	if(source_frame)
		if(source_frame.set_name)
			name = source_frame.set_name
		if(source_frame.arms)
			source_frame.arms.forceMove(src)
			arms = source_frame.arms
		if(source_frame.legs)
			source_frame.legs.forceMove(src)
			legs = source_frame.legs
		if(source_frame.head)
			source_frame.head.forceMove(src)
			head = source_frame.head
		if(source_frame.body)
			source_frame.body.forceMove(src)
			body = source_frame.body
	updatehealth()

	// Generate hardpoint list.
	for(var/obj/item/mech_component/thing in list(arms, legs, head, body))
		if(thing && thing.has_hardpoints.len)
			for(var/hardpoint in thing.has_hardpoints)
				hardpoints[hardpoint] = null

	// Create HUD.
	InitializeHud()

	// Build icon.
	update_icon()

/mob/living/heavy_vehicle/return_air()
	return (body && !body.open_cabin) ? body.cockpit : loc.return_air()

/mob/living/heavy_vehicle/GetIdCard()
	return access_card