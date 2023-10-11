/obj/landmark/corpse/fleet
	name = "Fleet Armsman"
	corpse_outfits = list(/singleton/hierarchy/outfit/job/torch/ert/hostile)
	spawn_flags = CORPSE_SPAWNER_RANDOM_NAMELESS | CORPSE_SPAWNER_ALL_SKIPS

/obj/landmark/corpse/fleet/leader
	name = "Fleet Team Leader"
	corpse_outfits = list(/singleton/hierarchy/outfit/job/torch/ert/hostile/leader)

/obj/landmark/corpse/fleet/space
	name = "Fleet Assault Armsman"
	corpse_outfits = list(/singleton/hierarchy/outfit/job/torch/ert/hostile/suit)

/obj/item/clothing/suit/armor/bulletproof/armsman
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S)
	accessories = list(
		/obj/item/clothing/accessory/arm_guards/riot,
		/obj/item/clothing/accessory/leg_guards/riot,
		/obj/item/clothing/accessory/armor_tag/solgov/lead,
		/obj/item/clothing/accessory/storage/pouches
		)

/obj/item/clothing/head/helmet/armsman
	accessories = list(/obj/item/clothing/accessory/helmet_cover/lead)

/mob/living/simple_animal/hostile/human/fleet
	name = "\improper Fleet Armsman"
	desc = "An armsman wearing Fleet garbs. They have a Fleet patch on their uniform, and pride on their shoulders."
	icon_state = "fleetarmsman"
	icon_living = "fleetarmsman"
	icon_dead = "fleetassault_dead"
	icon_gib = "fleetarmsman_gib"
	turns_per_move = 5
	response_help = "pats"
	response_disarm = "shoves"
	response_harm = "hits"
	natural_armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL
		)
	speed = 8
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	natural_weapon = /obj/item/natural_weapon/punch
	can_escape = TRUE
	a_intent = I_HURT
	var/corpse = null
	var/weapon1
	var/weapon2
	unsuitable_atmos_damage = 15
	environment_smash = 1
	faction = "roguefleet"
	status_flags = CANPUSH

	ai_holder = /datum/ai_holder/simple_animal/humanoid/hostile/fleet
	say_list_type = /datum/say_list/fleet/traitor
	ranged = TRUE

/mob/living/simple_animal/hostile/human/fleet/death(gibbed, deathmessage, show_dead_message)
	..(gibbed, deathmessage, show_dead_message)
	if(corpse)
		new corpse (loc)
	if(weapon1)
		new weapon1 (loc)
	if(weapon2)
		new weapon2 (loc)
	qdel(src)
	return

///////////////Pistol////////////////

/mob/living/simple_animal/hostile/human/fleet/ranged
	name = "\improper Armed Fleet Armsman"
	icon_state = "fleetarmsmanarmed"
	icon_living = "fleetarmsmanarmed"

	corpse = /obj/landmark/corpse/fleet

	casingtype = /obj/item/ammo_casing/pistol
	projectiletype = /obj/item/projectile/bullet/pistol
	natural_weapon = /obj/item/gun/projectile/pistol/m22f
	weapon1 = /obj/item/gun/projectile/pistol/m22f
	status_flags = EMPTY_BITFIELD

/mob/living/simple_animal/hostile/human/fleet/ranged/neutral
	say_list_type = /datum/say_list/fleet/friendly
	faction = MOB_FACTION_CREW

//////////////Bullpup////////////////

/mob/living/simple_animal/hostile/human/fleet/ranged/bullpup
	name = "\improper Fleet Rifleman"
	icon_state = "fleetrifleman"
	icon_living = "fleetrifleman"
	casingtype = /obj/item/ammo_casing/rifle
	projectiletype = /obj/item/projectile/bullet/rifle
	natural_weapon = /obj/item/gun/projectile/automatic/bullpup_rifle/light
	weapon1 = /obj/item/gun/projectile/automatic/bullpup_rifle/light
	status_flags = EMPTY_BITFIELD

/mob/living/simple_animal/hostile/human/fleet/ranged/bullpup/neutral
	say_list_type = /datum/say_list/fleet/friendly
	faction = MOB_FACTION_CREW

//////////////Team Leader////////////////

/mob/living/simple_animal/hostile/human/fleet/ranged/leader
	name = "\improper Fleet Team Leader"
	desc = "A Fleet armsman with armaments. This one seems to be more armed than the rest, sporting a Vesper machine-pistol."
	icon_state = "fleetteamlead"
	icon_living = "fleetteamlead"
	maxHealth = 150
	health = 150
	casingtype = /obj/item/ammo_casing/pistol
	projectiletype = /obj/item/projectile/bullet/pistol
	natural_weapon = /obj/item/gun/projectile/automatic/machine_pistol
	weapon1 = /obj/item/gun/projectile/automatic/machine_pistol
	status_flags = EMPTY_BITFIELD

	corpse = /obj/landmark/corpse/fleet/leader

	ai_holder = /datum/ai_holder/simple_animal/humanoid/hostile/fleet/ranged/teamlead
	rapid = TRUE

/mob/living/simple_animal/hostile/human/fleet/ranged/leader/neutral
	say_list_type = /datum/say_list/fleet/friendly
	faction = MOB_FACTION_CREW

// These guys are chonky. Use them for BIG fights. Or sparingly.

//////////////Rigsuit////////////////

/mob/living/simple_animal/hostile/human/fleet/space
	name = "\improper Fleet Assault Armsman"
	desc = "A Fleet Armsman clad in a special-purpose rigsuit. They seem tough and hardy."
	icon_state = "fleetassault"
	icon_living = "fleetassault"
	icon_dead = "fleetassault_dead"
	corpse = /obj/landmark/corpse/fleet/space
	ranged = TRUE
	natural_armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_HANDGUNS
		)
	speed = 4
	maxHealth = 200
	health = 200
	min_gas = null
	max_gas = null
	minbodytemp = 0

	var/deactivated = FALSE
	ai_holder = /datum/ai_holder/simple_animal/humanoid/hostile/fleet/ranged/space


/mob/living/simple_animal/hostile/human/fleet/space/emp_act(severity)
	if (status_flags & GODMODE)
		return
	. = ..()
	stun()

/mob/living/simple_animal/hostile/human/fleet/space/proc/stun()
	if (deactivated)
		return
	set_AI_busy(TRUE)
	deactivated = TRUE
	visible_message(SPAN_MFAUNA("\The [src]'s rigsuit flashes hastily, locking into place!"))
	update_icon()
	addtimer(new Callback(src, .proc/reactivate), 6 SECONDS)

/mob/living/simple_animal/hostile/human/fleet/space/proc/reactivate()
	set_AI_busy(FALSE)
	deactivated = FALSE
	visible_message(SPAN_MFAUNA("\The [src]'s rigsuit stops flashing, regaining motion!"))
	update_icon()

/mob/living/simple_animal/hostile/human/fleet/space/neutral
	say_list_type = /datum/say_list/fleet/friendly
	faction = MOB_FACTION_CREW

/mob/living/simple_animal/hostile/human/fleet/space/Process_Spacemove()
	return 1

//////////////Rigsuit - Bullpup////////////////

/mob/living/simple_animal/hostile/human/fleet/space/ranged
	icon_state = "fleetassaultarmed"
	icon_living = "fleetassaultarmed"
	casingtype = /obj/item/ammo_casing/rifle
	projectiletype = /obj/item/projectile/bullet/rifle
	natural_weapon = /obj/item/gun/projectile/automatic/bullpup_rifle/light
	weapon1 = /obj/item/gun/projectile/automatic/bullpup_rifle/light

/mob/living/simple_animal/hostile/human/fleet/space/ranged/on_update_icon()
	..()
	if(stat != DEAD)
		if(deactivated)
			AddOverlays(image(icon, "disabled"))
			return

		ClearOverlays()

/mob/living/simple_animal/hostile/human/fleet/space/ranged/neutral
	say_list_type = /datum/say_list/fleet/friendly
	faction = MOB_FACTION_CREW

//////////////Rigsuit - Heavy////////////////
/* Has a special, telegraphed rig-mounted laser cannon */

#define ATTACK_MODE_LAS      "las"
#define ATTACK_MODE_SAW      "saw"

/mob/living/simple_animal/hostile/human/fleet/space/ranged/heavy
	name = "\improper Fleet Heavy Weapons Specialist"
	desc = "A Fleet Specialist clad in a heavier variant of the special-purpose rigsuit. Their module seems to carry a shoulder-mounted laser. Complementing their L6 SAW."
	icon_state = "fleetheavy"
	icon_living = "fleetheavy"
	rapid = TRUE
	maxHealth = 300
	health = 300
	special_attack_cooldown = 1.5 MINUTES
	base_attack_cooldown = 0.5 SECONDS
	say_list_type = /datum/say_list/fleet/heavy

	casingtype = /obj/item/ammo_casing/rifle
	projectiletype = /obj/item/projectile/bullet/rifle
	natural_weapon = /obj/item/gun/projectile/automatic/l6_saw
	weapon1 = /obj/item/rig_module/mounted/energy/lcannon

	var/attack_mode = ATTACK_MODE_SAW
	var/num_shots

/mob/living/simple_animal/hostile/human/fleet/space/ranged/heavy/Initialize()
	. = ..()
	switch_mode(ATTACK_MODE_LAS)

/mob/living/simple_animal/hostile/human/fleet/space/ranged/heavy/Life()
	. = ..()
	if(!.)
		return

	if(time_last_used_ability < world.time)
		switch_mode(ATTACK_MODE_LAS)

/mob/living/simple_animal/hostile/human/fleet/space/ranged/heavy/proc/switch_mode(new_mode)
	if(!new_mode || new_mode == attack_mode)
		return

	switch(new_mode)
		if(ATTACK_MODE_LAS)
			attack_mode = ATTACK_MODE_LAS
			ranged = TRUE
			projectilesound = 'sound/weapons/Laser.ogg'
			projectiletype = /obj/item/projectile/beam/midlaser
			num_shots = 2
			fire_desc = "fires a laser"
			time_last_used_ability = special_attack_cooldown + world.time
			visible_message(SPAN_MFAUNA("\The [src]'s rig-mounted laser cannon shines brightly!"))
		if(ATTACK_MODE_SAW)
			attack_mode = ATTACK_MODE_SAW
			ranged = TRUE
			projectiletype = /obj/item/projectile/bullet/rifle
			num_shots = 10
			fire_desc = "fires a burst"
			time_last_used_ability = base_attack_cooldown + world.time
			visible_message(SPAN_MFAUNA("\The [src] pulls up \the machinegun to bear!"))

	update_icon()

/mob/living/simple_animal/hostile/human/fleet/space/ranged/heavy/shoot_target(target_mob)
	if(num_shots <= 0)
		if(attack_mode == ATTACK_MODE_LAS)
			switch_mode(ATTACK_MODE_SAW)
		else
			switch_mode(ATTACK_MODE_LAS)
	..()

/mob/living/simple_animal/hostile/human/fleet/space/ranged/heavy/shoot(target, start, user, bullet)
	if (projectiletype)
		..()
		num_shots--

/mob/living/simple_animal/hostile/human/fleet/space/ranged/heavy/on_update_icon()
	..()
	if(stat != DEAD)
		if(deactivated)
			AddOverlays(image(icon, "disabled"))
			return

		ClearOverlays()
		switch(attack_mode)
			if(ATTACK_MODE_LAS)
				AddOverlays(image(icon, "laser"))

/mob/living/simple_animal/hostile/human/fleet/space/ranged/heavy/neutral
	say_list_type = /datum/say_list/fleet/friendly
	faction = MOB_FACTION_CREW

/* AI */

/datum/ai_holder/simple_animal/humanoid/hostile/fleet
	threaten_delay = 2 SECOND
	threaten_timeout = 30 SECONDS
	violent_breakthrough = FALSE
	speak_chance = 5
	base_wander_delay = 5

/datum/ai_holder/simple_animal/humanoid/hostile/fleet/ranged/teamlead
	threaten_delay = 2 SECOND
	threaten_timeout = 30 SECONDS
	base_wander_delay = 3
	conserve_ammo = FALSE
	pointblank = TRUE
/datum/ai_holder/simple_animal/humanoid/hostile/fleet/ranged/space
	threaten_delay = 2 SECOND
	threaten_timeout = 30 SECONDS
	speak_chance = 5
	base_wander_delay = 3
	returns_home = FALSE
	violent_breakthrough = TRUE
	conserve_ammo = FALSE
	destructive = TRUE
	pointblank = TRUE

/datum/ai_holder/simple_animal/humanoid/hostile/fleet/ranged/friendly
	intelligence_level = AI_NORMAL
	threaten_delay = 2 SECOND
	threaten_timeout = 30 SECONDS
	violent_breakthrough = FALSE
	speak_chance = 5
	base_wander_delay = 5

/* SAY LIST */

/datum/say_list/fleet/friendly
	speak = list(
		"Wish someone would act up. Just once.",
		"I love this job, but boy do I hate the damn wait...",
		"Really wish something would happen right about now.",
		"The hell'd we pack all this ammo for if we're not using it?",
		"Wish something would pop up to shoot now..."
	)
	emote_hear = list(
		"fidgets, antsy.",
		"unloads their weapon to check their ammo, before reloading.",
		"is rearing and ready to go, bouncing in their boots.",
		"scans the area for threats."
	)
	say_threaten = list(
		"There you are, let's get the party started!",
		"Hey, contact spotted, load up!",
		"Found one, a hostile!",
		"About time I got to shoot something!",
		"Time to lock and load!"
	)
	say_maybe_target = list(
		"Hold up, heard something.",
		"Saw a contact, checking them.",
		"Hey, you, hold a minute!",
		"Think I heard something over there.",
		"Saw something move, let's check it out."
	)
	say_escalate = list(
		"Fire on that one!!",
		"Engage that hostile!",
		"Fire at will!",
		"Pursuing hostile target!",
		"Clearing the area!",
		"Engaging hostile target!"
	)
	say_stand_down = list(
		"We're clear! Let's find these guys!",
		"All hostiles down or gone, area clear. Keep watch!",
		"Hostiles have broken contact, pull security!",
		"Visual broken, find them!",
		"Visual lost, make sure they're gone!",
		"They're gone, clear the area!"
	)

/datum/say_list/fleet/traitor
	speak = list(
		"I don't like this feeling.",
		"You ever think maybe we're the baddies?",
		"...mmm, something feels off.",
		"Best of the best... condemned to this."
	)
	emote_hear = list(
		"checks their weapon, antsy.",
		"unloads their weapon to check their ammo, before reloading.",
		"is scanning for threats.",
		"snaps their gun somewhere nearby, before grunting as nothing's there."
	)
	say_threaten = list(
		"Knew I fucking saw you!",
		"Hey- Load up! We found one!",
		"They fucking found us!",
		"I knew it wasn't the fucking shadows!",
		"HEY, asshole! Time to die!"
	)
	say_maybe_target = list(
		"FUCK! Heard something again...",
		"Think there's a fucking person over here!",
		"I'm not jumping at shadows, I saw someone!",
		"Think I heard something over there!",
		"Saw something move, tempted to shoot it."
	)
	say_escalate = list(
		"Kill that fucker!",
		"Contact, front!",
		"Blast 'em!",
		"Fire! Fire fire fire!"
	)
	say_stand_down = list(
		"Fuck! What if there's more?!",
		"Get ready! More will probably come!",
		"Pull up on defense! Can't let them catch us off guard!",
		"Lost sight of them, find them!",
		"Visual's lost, make sure there isn't more lurking!",
		"They're gone! Search the damn area!"
	)

/datum/say_list/fleet/heavy
	speak = list(
		"At this rate I'll never get to use this cannon...",
		"I've got this place locked down.",
		"This rig's as ready as it can be. Just waiting for action."
	)
	say_threaten = list(
		"Scope's picked up target!",
		"Finally!",
	)
	say_maybe_target = list(
		"Just me. Nothing real.",
		"Gah, thought I saw something..",
		"Nevermind..",
		"Guess I don't get to use this this, after all."
	)
	say_escalate = list(
		"Got you!",
		"Stand still!",
		"Big mistake, buddy!",
		"Can't run from my machinegun!"
	)
	say_stand_down = list(
		"Piece of cake.",
		"Rig makes this too easy.",
		"Watch 'em go!"
	)

#undef ATTACK_MODE_LAS
#undef ATTACK_MODE_SAW
