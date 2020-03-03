

// Big stompy robots.
/mob/living/exosuit
	name = "exosuit"
	desc = "A powerful machine piloted from a cockpit, but worn like a suit of armour."
	density =  TRUE
	opacity =  TRUE
	anchored = TRUE
	default_pixel_x = -8
	default_pixel_y = 0
	status_flags = PASSEMOTES
	a_intent =     I_HURT
	mob_size =     MOB_LARGE
	
	meat_type = null
	meat_amount = 0
	skin_material = null
	skin_amount = 0
	bone_material = null
	bone_amount = 0

	var/emp_damage = 0

	var/obj/item/device/radio/exosuit/radio

	var/wreckage_path = /obj/structure/mech_wreckage
	var/mech_turn_sound = 'sound/mecha/mechturn.ogg'
	var/mech_step_sound = 'sound/mecha/mechstep.ogg'

	// Access updating/container.
	var/obj/item/weapon/card/id/access_card
	var/list/saved_access = list()
	var/sync_access = 1

	// Mob currently piloting the exosuit.
	var/list/pilots
	var/list/pilot_overlays

	// Visible external components. Not strictly accurately named for non-humanoid machines (submarines) but w/e
	var/obj/item/mech_component/manipulators/arms
	var/obj/item/mech_component/propulsion/legs
	var/obj/item/mech_component/sensors/head
	var/obj/item/mech_component/chassis/body

	// Invisible components.
	var/datum/effect/effect/system/spark_spread/sparks

	// Equipment tracking vars.
	var/obj/item/mech_equipment/selected_system
	var/selected_hardpoint
	var/list/hardpoints = list()
	var/hardpoints_locked
	var/maintenance_protocols

	// Material
	var/material/material

	// Cockpit access vars.
	var/hatch_closed = FALSE
	var/hatch_locked = FALSE

	//Air!
	var/use_air      = FALSE

	// Interface stuff.
	var/list/hud_elements = list()
	var/list/hardpoint_hud_elements = list()
	var/obj/screen/movable/exosuit/health/hud_health
	var/obj/screen/movable/exosuit/toggle/hatch_open/hud_open
	var/obj/screen/movable/exosuit/power/hud_power

/mob/living/exosuit/is_flooded(lying_mob, absolute)
	. = (body && body.pilot_coverage >= 100 && hatch_closed) ? FALSE : ..()

/mob/living/exosuit/Initialize(mapload, var/obj/structure/heavy_vehicle_frame/source_frame)
	. = ..()

	if(!access_card) access_card = new (src)

	pixel_x = default_pixel_x
	pixel_y = default_pixel_y
	sparks = new(src)

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
		if(source_frame.material)
			material = source_frame.material

	updatehealth()

	// Generate hardpoint list.
	var/list/component_descriptions
	for(var/obj/item/mech_component/comp in list(arms, legs, head, body))
		if(comp.exosuit_desc_string)
			LAZYADD(component_descriptions, comp.exosuit_desc_string)
		if(LAZYLEN(comp.has_hardpoints))
			for(var/hardpoint in comp.has_hardpoints)
				hardpoints[hardpoint] = null

	if(head && head.radio)
		radio = new(src)

	if(LAZYLEN(component_descriptions))
		desc = "[desc] It has been built with [english_list(component_descriptions)]."

	// Create HUD.
	InitializeHud()

	// Build icon.
	queue_icon_update()

/mob/living/exosuit/Destroy()

	selected_system = null

	for(var/thing in pilots)
		var/mob/pilot = thing
		if(pilot.client)
			pilot.client.screen -= hud_elements
			pilot.client.images -= hud_elements
		pilot.forceMove(get_turf(src))
	pilots = null

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

	for(var/hardpoint in hardpoint_hud_elements)
		var/obj/screen/movable/exosuit/hardpoint/H = hardpoint_hud_elements[hardpoint]
		H.owner = null
		H.holding = null
		qdel(H)
	hardpoint_hud_elements.Cut()

	. = ..()

/mob/living/exosuit/IsAdvancedToolUser()
	return TRUE

/mob/living/exosuit/examine(mob/user)
	. = ..()
	if(LAZYLEN(pilots) && (!hatch_closed || body.pilot_coverage < 100 || body.transparent_cabin))
		to_chat(user, "It is being piloted by [english_list(pilots, nothing_text = "nobody")].")
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
			if(MECH_COMPONENT_DAMAGE_UNDAMAGED)
				damage_string = "undamaged"
			if(MECH_COMPONENT_DAMAGE_DAMAGED)
				damage_string = "damaged"
			if(MECH_COMPONENT_DAMAGE_DAMAGED_BAD)
				damage_string = "badly damaged"
			if(MECH_COMPONENT_DAMAGE_DAMAGED_TOTAL)
				damage_string = "almost destroyed"
		to_chat(user, "Its [thing.name] [thing.gender == PLURAL ? "are" : "is"] [damage_string].")

	to_chat(user, "It menaces with reinforcements of [material].")

/mob/living/exosuit/return_air()
	return (body && body.pilot_coverage >= 100 && hatch_closed) ? body.cockpit : loc.return_air()

/mob/living/exosuit/GetIdCard()
	return access_card

/mob/living/exosuit/set_dir()
	. = ..()
	if(.)
		update_pilots()

		


