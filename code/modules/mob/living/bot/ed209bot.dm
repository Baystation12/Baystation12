/mob/living/bot/secbot/ed209
	name = "ED-209 Security Robot"
	desc = "A security robot.  He looks less than thrilled."
	icon = 'icons/mob/bot/ED209.dmi'
	icon_state = "ed2090"
	attack_state = "ed209-c"
	layer = MOB_LAYER
	density = TRUE
	health = 100
	maxHealth = 100

	is_ranged = 1
	preparing_arrest_sounds = new()

	a_intent = I_HURT
	mob_bump_flag = HEAVY
	mob_swap_flags = ~HEAVY
	mob_push_flags = HEAVY

	var/shot_delay = 4
	var/last_shot = 0


/mob/living/bot/secbot/ed209/get_construction_info()
	return list(
		"Use <b>5 Sheets of Steel</b> on a <b>Standard Robot Frame</b> that has no other parts installed.",
		"Add a robotic <b>Left Leg</b> and a robotic <b>Right Leg</b>.",
		"Add an <b>Armor Plate</b>.",
		"Use a <b>Welding Tool</b> to secure the armor plating.",
		"Add a <b>Helmet</b>.",
		"Add a <b>Proximity Sensor</b>.",
		"Add <b>1 Length of Cable Coil</b>.",
		"Add an <b>Electrolaser</b>.",
		"Use a <b>Screwdriver</b> to secure the taser in place.",
		"Add a <p>Power Cell</p> to complete the ED-209."
	)


/mob/living/bot/secbot/ed209/update_icons()
	icon_state = "ed2090"

/mob/living/bot/secbot/ed209/explode()
	visible_message(SPAN_WARNING("[src] blows apart!"))
	var/turf/Tsec = get_turf(src)

	var/obj/item/gun/energy/stunrevolver/G = new /obj/item/gun/energy/stunrevolver(Tsec)
	G.power_supply.charge = 0
	if(prob(50))
		new /obj/item/robot_parts/l_leg(Tsec)
	if(prob(50))
		new /obj/item/robot_parts/r_leg(Tsec)
	if(prob(50))
		if(prob(50))
			new /obj/item/clothing/head/helmet(Tsec)
		else
			new /obj/item/clothing/suit/armor/vest(Tsec)

	var/datum/effect/spark_spread/s = new /datum/effect/spark_spread
	s.set_up(3, 1, src)
	s.start()

	new /obj/decal/cleanable/blood/oil(Tsec)
	qdel(src)

/mob/living/bot/secbot/ed209/handleRangedTarget()
	RangedAttack(target)

/mob/living/bot/secbot/ed209/RangedAttack(atom/A, params)
	if(last_shot + shot_delay > world.time)
		to_chat(src, "You are not ready to fire yet!")
		return TRUE

	last_shot = world.time
	var/projectile = /obj/item/projectile/beam/stun
	if(emagged)
		projectile = /obj/item/projectile/beam

	playsound(loc, emagged ? 'sound/weapons/Laser.ogg' : 'sound/weapons/Taser.ogg', 50, 1)
	var/obj/item/projectile/P = new projectile(loc)
	var/def_zone = get_exposed_defense_zone(A)
	P.launch(A, def_zone)
	return TRUE
