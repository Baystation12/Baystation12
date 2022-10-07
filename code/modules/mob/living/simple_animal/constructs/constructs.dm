/mob/living/simple_animal/construct
	name = "Construct"
	real_name = "Construct"
	desc = ""
	speak_emote = list("шипит")
	response_help  = "thinks better of touching"
	response_disarm = "flailed at"
	response_harm   = "punched"
	icon_dead = "shade_dead"
	speed = -1
	a_intent = I_HURT
	status_flags = CANPUSH
	universal_speak = FALSE
	universal_understand = TRUE
	min_gas = null
	max_gas = null
	minbodytemp = 0
	show_stat_health = 1
	faction = "cult"
	supernatural = 1
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	mob_swap_flags = HUMAN|SIMPLE_ANIMAL|SLIME|MONKEY
	mob_push_flags = ALLMOBS
	bleed_colour = "#331111"

	meat_type =     null
	meat_amount =   0
	bone_material = null
	bone_amount =   0
	skin_material = null
	skin_amount =   0

	var/nullblock = 0
	var/list/construct_spells = list()

	ai_holder = /datum/ai_holder/simple_animal/melee
	say_list = /datum/say_list/construct

/mob/living/simple_animal/construct/cultify()
	return

/mob/living/simple_animal/construct/New()
	..()
	name = text("[initial(name)] ([random_id(/mob/living/simple_animal/construct, 1000, 9999)])")
	real_name = name
	add_language(LANGUAGE_CULT)
	add_language(LANGUAGE_CULT_GLOBAL)
	for(var/spell in construct_spells)
		add_spell(new spell, "const_spell_ready")
	update_icon()

/mob/living/simple_animal/construct/death(gibbed, deathmessage, show_dead_message)
	new /obj/item/ectoplasm (src.loc)
	..(null,"collapses in a shattered heap.","The bonds tying you to this mortal plane have been severed.")
	ghostize()
	qdel(src)

/mob/living/simple_animal/construct/on_update_icon()
	overlays.Cut()
	..()
	add_glow()

/mob/living/simple_animal/construct/examine(mob/user)
	. = ..()
	if (health < maxHealth)
		if (health >= maxHealth / 2)
			to_chat(user, SPAN_WARNING("It looks slightly dented."))
		else
			to_chat(user, SPAN_WARNING(SPAN_BOLD("It looks severely dented!")))

/obj/item/ectoplasm
	name = "ectoplasm"
	desc = "Spooky."
	gender = PLURAL
	icon = 'icons/obj/wizard.dmi'
	icon_state = "ectoplasm"

/////////////////Juggernaut///////////////



/mob/living/simple_animal/construct/armoured
	name = "Juggernaut"
	real_name = "Juggernaut"
	desc = "A possessed suit of armour driven by the will of the restless dead."
	icon = 'icons/mob/mob.dmi'
	icon_state = "behemoth"
	icon_living = "behemoth"
	maxHealth = 250
	health = 250
	speak_emote = list("грохочет")
	response_harm   = "harmlessly punches"
	harm_intent_damage = 0
	natural_weapon = /obj/item/natural_weapon/juggernaut
	mob_size = MOB_LARGE
	speed = 3
	environment_smash = 2
	status_flags = 0
	resistance = 10
	construct_spells = list(/spell/aoe_turf/conjure/forcewall/lesser)
	can_escape = TRUE

/obj/item/natural_weapon/juggernaut
	name = "armored gauntlet"
	gender = NEUTER
	attack_verb = list("smashed", "demolished")
	hitsound = 'sound/weapons/heavysmash.ogg'
	force = 30

/mob/living/simple_animal/construct/armoured/Life()
	weakened = 0
	if ((. = ..()))
		return

/mob/living/simple_animal/construct/armoured/bullet_act(var/obj/item/projectile/P)
	if (status_flags & GODMODE)
		return PROJECTILE_FORCE_MISS
	if(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam))
		var/reflectchance = 80 - round(P.damage/3)
		if(prob(reflectchance))
			adjustBruteLoss(P.damage * 0.5)
			visible_message("<span class='danger'>The [P.name] gets reflected by [src]'s shell!</span>", \
							"<span class='userdanger'>The [P.name] gets reflected by [src]'s shell!</span>")

			// Find a turf near or on the original location to bounce to
			if(P.starting)
				var/new_x = P.starting.x + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
				var/new_y = P.starting.y + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
				var/turf/curloc = get_turf(src)

				// redirect the projectile
				P.redirect(new_x, new_y, curloc, src)

			return -1 // complete projectile permutation

	return (..(P))



////////////////////////Wraith/////////////////////////////////////////////



/mob/living/simple_animal/construct/wraith
	name = "Wraith"
	real_name = "Wraith"
	desc = "A wicked contraption with a bladed shell, piloted by a bound spirit."
	icon = 'icons/mob/mob.dmi'
	icon_state = "floating"
	icon_living = "floating"
	icon_dead = "floating_dead"
	maxHealth = 75
	health = 75
	natural_weapon = /obj/item/natural_weapon/wraith
	speed = -1
	environment_smash = 1
	see_in_dark = 7
	construct_spells = list(/spell/targeted/ethereal_jaunt/shift)

/mob/living/simple_animal/construct/wraith/can_fall(anchor_bypass, turf/location_override)
	return FALSE

/mob/living/simple_animal/construct/wraith/can_overcome_gravity()
	return TRUE

/obj/item/natural_weapon/wraith
	name = "wicked blade"
	gender = NEUTER
	attack_verb = list("slashed", "tore into")
	hitsound = 'sound/weapons/rapidslice.ogg'
	edge = TRUE
	force = 25

/////////////////////////////Artificer/////////////////////////



/mob/living/simple_animal/construct/builder
	name = "Artificer"
	real_name = "Artificer"
	desc = "A bulbous construct dedicated to building and maintaining The Cult of Nar-Sie's armies."
	icon = 'icons/mob/mob.dmi'
	icon_state = "artificer"
	icon_living = "artificer"
	maxHealth = 50
	health = 50
	response_harm = "viciously beaten"
	harm_intent_damage = 5
	natural_weapon = /obj/item/natural_weapon/cult_builder
	speed = 0
	environment_smash = 1
	construct_spells = list(/spell/aoe_turf/conjure/construct/lesser,
							/spell/aoe_turf/conjure/wall,
							/spell/aoe_turf/conjure/floor,
							/spell/aoe_turf/conjure/soulstone,
							/spell/aoe_turf/conjure/pylon
							)

/obj/item/natural_weapon/cult_builder
	name = "heavy arms"
	attack_verb = list("rammed")
	force = 5

/obj/item/natural_weapon/cult_builder/attack(mob/living/M, mob/living/user)
	if(istype(M, /mob/living/simple_animal/construct))
		if(M.health < M.maxHealth)
			M.adjustBruteLoss(-5)
			user.visible_message(SPAN_NOTICE("\The [user] mends some of \the [M]'s wounds."))
		else
			to_chat(user, SPAN_NOTICE("\The [M] is undamaged."))
		return
	return ..()

/////////////////////////////Behemoth/////////////////////////


/mob/living/simple_animal/construct/behemoth
	name = "Behemoth"
	real_name = "Behemoth"
	desc = "The pinnacle of occult technology, Behemoths are the ultimate weapon in the Cult of Nar-Sie's arsenal."
	icon = 'icons/mob/mob.dmi'
	icon_state = "behemoth"
	icon_living = "behemoth"
	maxHealth = 750
	health = 750
	speak_emote = list("грохочет")
	response_harm   = "harmlessly punched"
	harm_intent_damage = 0
	natural_weapon = /obj/item/natural_weapon/juggernaut/behemoth
	speed = 5
	environment_smash = 2

	resistance = 10
	var/energy = 0
	var/max_energy = 1000
	construct_spells = list(/spell/aoe_turf/conjure/forcewall/lesser)
	can_escape = TRUE

/obj/item/natural_weapon/juggernaut/behemoth
	force = 50

////////////////////////Harvester////////////////////////////////



/mob/living/simple_animal/construct/harvester
	name = "Harvester"
	real_name = "Harvester"
	desc = "The promised reward of the livings who follow Nar-Sie. Obtained by offering their bodies to the geometer of blood."
	icon = 'icons/mob/mob.dmi'
	icon_state = "harvester"
	icon_living = "harvester"
	icon_dead = "harvester_dead"
	maxHealth = 150
	health = 150
	natural_weapon = /obj/item/natural_weapon/harvester
	speed = -1
	environment_smash = 1
	see_in_dark = 7

	construct_spells = list(
			/spell/targeted/harvest
		)

/obj/item/natural_weapon/harvester
	name = "malicious spike"
	gender = NEUTER
	attack_verb = list("violently stabbed", "ran through")
	hitsound = 'sound/weapons/pierce.ogg'
	sharp = TRUE
	force = 25

////////////////Glow//////////////////
/mob/living/simple_animal/construct/proc/add_glow()
	var/image/eye_glow = image(icon,"glow-[icon_state]")
	eye_glow.plane = EFFECTS_ABOVE_LIGHTING_PLANE
	eye_glow.layer = EYE_GLOW_LAYER
	overlays += eye_glow
	set_light(-2, 0.1, 1.5, l_color = "#ffffff")

////////////////HUD//////////////////////

/mob/living/simple_animal/construct/Life()
	. = ..()
	if(.)
		if(fire)
			if(fire_alert)							fire.icon_state = "fire1"
			else									fire.icon_state = "fire0"
		if(pullin)
			if(pulling)								pullin.icon_state = "pull1"
			else									pullin.icon_state = "pull0"

		if(purged)
			if(purge > 0)							purged.icon_state = "purge1"
			else									purged.icon_state = "purge0"

		silence_spells(purge)

/mob/living/simple_animal/construct/armoured/Life()
	. = ..()
	if(healths)
		switch(health)
			if(250 to INFINITY)		healths.icon_state = "juggernaut_health0"
			if(208 to 249)			healths.icon_state = "juggernaut_health1"
			if(167 to 207)			healths.icon_state = "juggernaut_health2"
			if(125 to 166)			healths.icon_state = "juggernaut_health3"
			if(84 to 124)			healths.icon_state = "juggernaut_health4"
			if(42 to 83)			healths.icon_state = "juggernaut_health5"
			if(1 to 41)				healths.icon_state = "juggernaut_health6"
			else					healths.icon_state = "juggernaut_health7"


/mob/living/simple_animal/construct/behemoth/Life()
	. = ..()
	if(healths)
		switch(health)
			if(750 to INFINITY)		healths.icon_state = "juggernaut_health0"
			if(625 to 749)			healths.icon_state = "juggernaut_health1"
			if(500 to 624)			healths.icon_state = "juggernaut_health2"
			if(375 to 499)			healths.icon_state = "juggernaut_health3"
			if(250 to 374)			healths.icon_state = "juggernaut_health4"
			if(125 to 249)			healths.icon_state = "juggernaut_health5"
			if(1 to 124)			healths.icon_state = "juggernaut_health6"
			else					healths.icon_state = "juggernaut_health7"

/mob/living/simple_animal/construct/builder/Life()
	. = ..()
	if(healths)
		switch(health)
			if(50 to INFINITY)		healths.icon_state = "artificer_health0"
			if(42 to 49)			healths.icon_state = "artificer_health1"
			if(34 to 41)			healths.icon_state = "artificer_health2"
			if(26 to 33)			healths.icon_state = "artificer_health3"
			if(18 to 25)			healths.icon_state = "artificer_health4"
			if(10 to 17)			healths.icon_state = "artificer_health5"
			if(1 to 9)				healths.icon_state = "artificer_health6"
			else					healths.icon_state = "artificer_health7"



/mob/living/simple_animal/construct/wraith/Life()
	. = ..()
	if(healths)
		switch(health)
			if(75 to INFINITY)		healths.icon_state = "wraith_health0"
			if(62 to 74)			healths.icon_state = "wraith_health1"
			if(50 to 61)			healths.icon_state = "wraith_health2"
			if(37 to 49)			healths.icon_state = "wraith_health3"
			if(25 to 36)			healths.icon_state = "wraith_health4"
			if(12 to 24)			healths.icon_state = "wraith_health5"
			if(1 to 11)				healths.icon_state = "wraith_health6"
			else					healths.icon_state = "wraith_health7"


/mob/living/simple_animal/construct/harvester/Life()
	. = ..()
	if(healths)
		switch(health)
			if(150 to INFINITY)		healths.icon_state = "harvester_health0"
			if(125 to 149)			healths.icon_state = "harvester_health1"
			if(100 to 124)			healths.icon_state = "harvester_health2"
			if(75 to 99)			healths.icon_state = "harvester_health3"
			if(50 to 74)			healths.icon_state = "harvester_health4"
			if(25 to 49)			healths.icon_state = "harvester_health5"
			if(1 to 24)				healths.icon_state = "harvester_health6"
			else					healths.icon_state = "harvester_health7"

/datum/say_list/construct
	speak = list("Hsssssssszsht.", "Hsssssssss...", "Tcshsssssssszht!")
	emote_hear = list("wails","screeches")
