
/obj/structure/evac_pelican/
	name = "D77-TC Pelican"
	desc = "A versatile aircraft used by the UNSC for medium-lift operations of personnel, vehicles and equipment. Tt can also be used as a support gunship."
	anchored = 1
	density = 1
	icon = 'evac_pelican.dmi'
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
		var/image/I = image(icon = 'pilot_head.dmi', icon_state = "head")
		to_world("\
			<span class='radio'>\
				<span class='name'>D77-TC Pilot</span> \
				\icon[I] \
				<b>\[UNSC Emergency Freq\]</b> \
				<span class='message'>\"[pilot_message]\"</span>\
			<span>")
		qdel(I)
	/*
	attack_sfx = list(\
		'sound/effects/attackblob.ogg',\
		'sound/effects/blobattack.ogg'\
		)
		*/
