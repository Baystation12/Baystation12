/obj/machinery/bluespacedrive
	name = "bluespace drive"
	desc = "A bewilderingly complex prototype designed to split the fabric of spacetime and allow access to Bluespace."
	icon = 'icons/obj/machines/bluespacedrive.dmi'
	icon_state = "bsd_core"
	anchored = TRUE
	density = TRUE
	pixel_y = -32
	pixel_x = -32
	idle_power_usage = 15000
	construct_state = /decl/machine_construction/default/panel_closed

	machine_name = "bluespace drive"
	machine_desc = "A bewilderingly complex prototype designed to split the fabric of spacetime and allow access to Bluespace."

	var/drive_max_integrity = 1000		// How much damage can we sustain?
	var/drive_integrity					// How much damage have we sustained?
	var/drive_broken = FALSE			// Are we currently broken?
	var/drive_repaired = FALSE			// Did someone repair us?
	var/drive_core_unstable = FALSE		// Are we currently unstable?
	var/drive_sound
	var/image/overlay

particles/bluespace_torus
	width = 700
	height = 700
	count = 2700
	spawning = 260
	lifespan = 0.75 SECONDS
	fade = 0.95 SECONDS
	position = generator("circle", 16, 24, NORMAL_RAND)
	velocity = generator("circle", -6, 6, NORMAL_RAND)
	friction = 0.15
	gradient = list(0, COLOR_WHITE, 0.75, COLOR_BLUE_LIGHT)
	color_change = 0.125
	drift = generator("vector", list(-0.2, -0.2), list(0.2, 0.2))

/obj/machinery/bluespacedrive/Initialize()
	. = ..()
	drive_sound = GLOB.sound_player.PlayLoopingSound(src, "\ref[src]", 'sound/machines/BSD_idle.ogg', 50, 7)
	drive_integrity = drive_max_integrity
	particles = new/particles/bluespace_torus
	update_icon()

/obj/machinery/bluespacedrive/on_update_icon()
	if(!drive_core_unstable)
		overlays += "bsd_stable"
	else
		overlays += "bsd_unstable"
	if (!drive_broken)
		icon_state = "bsd_core"
	else
		icon_state = "bsd_core_broken"
	set_light(1, 5, 15, 10, COLOR_CYAN)
	overlay.plane = EFFECTS_ABOVE_LIGHTING_PLANE

/obj/machinery/bluespacedrive/emp_act(severity)
	..()
	if(prob(50/severity))
		visible_message(SPAN_WARNING("\The [src]'s field warps and buckles uneasily!"))
		playsound(loc, 'sound/machines/BSD_damaging.ogg', 80)
		take_damage(drive_max_integrity)

/obj/machinery/bluespacedrive/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(25))
				qdel(src)
				return
			if (prob(50))
				for(var/x in verbs)
					verbs -= x
				take_damage(drive_max_integrity)
		if(3.0)
			if (prob(25))
				for(var/x in verbs)
					verbs -= x
				take_damage(drive_max_integrity)

/obj/machinery/bluespacedrive/bullet_act(var/obj/item/projectile/Proj)
	if(!drive_broken)
		take_damage(Proj.get_structure_damage())
		visible_message(SPAN_WARNING("\The [src]'s field crackles disturbingly!"))
		playsound(loc, 'sound/machines/BSD_damaging.ogg', 80)
	else
		return
	..()

/obj/machinery/bluespacedrive/proc/take_damage(var/damage)
	if (drive_integrity <= 0)
		return

	drive_integrity -= damage
	if(drive_integrity <= 0)
		playsound(loc, 'sound/machines/BSD_explosion.ogg', 100)
		visible_message(SPAN_DANGER(FONT_LARGE("\The [src] beings emitting an ear-splitting, horrible shrill! get back!")))
		if(do_after(src, 4 SECONDS))
			visible_message(SPAN_DANGER(FONT_LARGE("\The [src]'s containment field is wracked by a series of horrendous distortions, buckling and twisting like a living thing before bursting in a flash of light!")))
			explosion(get_turf(src),-1, 5, 10)
			empulse(get_turf(src),7, 14)
			drive_broken = TRUE
			drive_core_unstable = TRUE
			update_icon()
		else
			return

/obj/machinery/bluespacedrive/attackby(var/obj/item/O, var/mob/user)
	user.visible_message(
		SPAN_WARNING("\The [user] reaches out \a [O] to \the [src], warping briefly as it disappears in a flash of blue light, scintillating motes left behind."),
		SPAN_DANGER("You touch \the [src] with \a [O], the field buckling around it before retracting with a crackle as it leaves small, blue scintillas on your hand as you flinch away."),
		SPAN_WARNING("You hear an otherwordly crackle, followed by humming.")
	)

	if (prob(5))
		playsound(loc, 'sound/items/eatfood.ogg', 40)		//Yum
	else
		playsound(loc, 'sound/machines/BSD_interact.ogg', 40)

	user.drop_from_inventory(O)
	qdel(O)

/obj/machinery/bluespacedrive/examine(mob/user)
	. = ..()
	if(drive_broken)
		user.visible_message(SPAN_DANGER("Its field is completely destroyed, the core revealed under the arcing debris."))
		return
	else
		switch(drive_integrity) 	// Nightmare nightmare nightmare, swap for something prettier.
			if(1 to 250)
				user.visible_message(SPAN_DANGER("Its unstable field is cracking and shifting dangerously, revealing the core inside briefly!"))
			if(206 to 500)
				user.visible_message(SPAN_WARNING("Its damaged field is twitching and crackling dangerously!"))
			if(501 to 750)
				user.visible_message(SPAN_NOTICE("Its field is crackling gently, with the ocassional twitch."))
			else
				user.visible_message(SPAN_NOTICE("At a glance, its field is peacefully humming without any alterations."))

/obj/machinery/bluespacedrive/attack_hand(mob/user as mob)
	. = ..()

/obj/machinery/bluespacedrive/Process()
	. = ..()

/obj/machinery/bluespacedrive/Destroy()
	QDEL_NULL(drive_sound)
	. = ..()