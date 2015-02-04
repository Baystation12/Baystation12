/obj/item/projectile/energy
	name = "energy"
	icon_state = "spark"
	damage = 0
	damage_type = BURN
	flag = "energy"


//releases a very short burst of light on impact, mainly used to blind people
/obj/item/projectile/energy/flash
	name = "shell" //a chemical filled shell or something
	icon_state = "bullet"
	damage = 5
	var/flash_range = 1
	var/brightness = 5
	var/light_duration = 10

/obj/item/projectile/energy/flash/on_impact()
	var/turf/T = get_turf(src)

	if(!istype(T)) return

	src.visible_message("<span class='warning'>\The [src] explodes in a bright flash!</span>")
	for (var/mob/living/carbon/M in viewers(T, flash_range))
		if(M.eyecheck() < 1)
			flick("e_flash", M.flash)

	playsound(src, 'sound/effects/snap.ogg', 50, 1)
	new/obj/effect/effect/smoke/illumination(src.loc, brightness=max(flash_range*2, brightness), lifetime=light_duration)

//blinds people like the flash round, but can also be used for temporary illumination
/obj/item/projectile/energy/flash/flare
	damage = 10
	flash_range = 1
	brightness = 7 //similar to a flare
	light_duration = 150

/obj/item/projectile/energy/electrode
	name = "electrode"
	icon_state = "spark"
	nodamage = 1
	/*
	stun = 10
	weaken = 10
	stutter = 10
	*/
	taser_effect = 1
	agony = 40
	damage_type = HALLOSS
	//Damage will be handled on the MOB side, to prevent window shattering.

/obj/item/projectile/energy/electrode/stunshot
	name = "stunshot"
	damage = 5
	taser_effect = 1
	agony = 80

/obj/item/projectile/energy/declone
	name = "declone"
	icon_state = "declone"
	nodamage = 1
	damage_type = CLONE
	irradiate = 40


/obj/item/projectile/energy/dart
	name = "dart"
	icon_state = "toxin"
	damage = 5
	damage_type = TOX
	weaken = 5


/obj/item/projectile/energy/bolt
	name = "bolt"
	icon_state = "cbbolt"
	damage = 10
	damage_type = TOX
	nodamage = 0
	agony = 40
	stutter = 10


/obj/item/projectile/energy/bolt/large
	name = "largebolt"
	damage = 20


/obj/item/projectile/energy/neurotoxin
	name = "neuro"
	icon_state = "neurotoxin"
	damage = 5
	damage_type = TOX
	weaken = 5

/obj/item/projectile/energy/phoron
	name = "phoron bolt"
	icon_state = "energy"
	damage = 20
	damage_type = TOX
	irradiate = 20
