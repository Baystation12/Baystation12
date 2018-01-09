
/obj/effect/evac_pelican/
	name = "Evac Pelican Spawn"
	desc = "You shouldn't see this."
	invisibility = 101
	anchored = 1
	density = 0
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x3"
	var/spawned = 0

/obj/effect/evac_pelican/proc/spawn_pelican()

	if(!spawned)
		spawned = 1
		. = new /obj/structure/evac_pelican(src.loc)
		qdel(src)

/obj/structure/evac_pelican/
	name = "D77-TC Pelican"
	desc = "A versatile aircraft used by the UNSC for medium-lift operations of personnel, vehicles and equipment. Tt can also be used as a support gunship."
	anchored = 1
	density = 1
	icon = 'maps/desert_outpost/gamemode/evac_pelican.dmi'
	icon_state = "base"
	var/health = 600
	var/healthmax = 600
	var/is_thrusting = 0
	bound_width = 96
	bound_height = 192

/obj/structure/evac_pelican/New()
	..()
	layer = MOB_LAYER + 1
	var/matrix/M = src.transform
	M.Translate(-48,0)
	src.transform = M
	set_thrust(1)
	spawn(50)
		set_thrust(0)

/obj/structure/evac_pelican/proc/set_thrust(var/thrusting = 1)
	var/old_thrust = is_thrusting
	is_thrusting = thrusting
	if(old_thrust != is_thrusting)
		if(is_thrusting)
			overlays += "thrust"
		else
			overlays -= "thrust"

/obj/structure/evac_pelican/attack_generic(var/atom/movable/attacker, var/amount, var/attacktext)
	//..()
	var/old_icon_state = icon_state
	var/pilot_message = pick("They're tearing into the armour plating!","Don't let them near me!","They're destroying the engine housing!","I'm taking damage!")
	health -= amount
	if(health < 0)
		//destroy
		explosion(src.loc,20,30,40,50)
		qdel(src)

	else if(health / healthmax < 0.2)
		icon_state = "dam5"
		pilot_message = "Any more hits and we won't be getting out of here!"
	else if(health / healthmax < 0.4)
		icon_state = "dam4"
	else if(health / healthmax < 0.6)
		icon_state = "dam3"
	else if(health / healthmax < 0.8)
		icon_state = "dam2"
	else if(health / healthmax < 1)
		icon_state = "dam1"
		pilot_message = "I'm taking damage, you've got to protect me while we evacuate the survivors!"
	else
		icon_state = "base"

	if((icon_state != old_icon_state))
		world_say_pilot_message(pilot_message)
	/*
	attack_sfx = list(\
		'sound/effects/attackblob.ogg',\
		'sound/effects/blobattack.ogg'\
		)
		*/

/obj/structure/evac_pelican/proc/world_say_pilot_message(var/pilot_message)
	//var/image/I = image(icon = 'pilot_head.dmi', icon_state = "head")
	to_world("\
		<span class='radio'>\
			<span class='name'>D77-TC Pelican Pilot</span> \
			\icon[src] \
			<b>\[UNSC Emergency Freq\]</b> \
			<span class='message'>\"[pilot_message]\"</span>\
		</span>")
	//qdel(I)

/obj/structure/evac_pelican/attack_hand(var/mob/M)
	attempt_enter(M)

/obj/structure/evac_pelican/proc/attempt_enter(var/mob/L)
	if(isliving(usr))
		var/mob/living/M = usr
		if(!M.incapacitated())
			var/success = 0
			for(var/turf/T in range(1,M))
				if(T in src.locs)
					success = 1
					M.loc = src
					to_chat(M, "<span class='info'>You enter [src].</span>")
					break
			if(!success)
				to_chat(M, "<span class='warning'>You are too far to do that.</span>")
		else
			to_chat(M, "<span class='warning'>You are unable to do that.</span>")

/obj/structure/evac_pelican/verb/enter_pelican()
	set name = "Enter the Evac Pelican"
	set src in view()
	set category = "IC"

	attempt_enter(usr)
