GLOBAL_VAR(max_flood_simplemobs)
GLOBAL_LIST_EMPTY(live_flood_simplemobs)

#define PLAYER_FLOOD_HEALTH_MOD 1.5

#define AIRLOCK_INFEST_TIME 15 SECONDS

#define COMBAT_FORM_INFESTOR_SPAWN_DELAY 30SECONDS

#define TO_PLAYER_INFECTED_SOUND 'code/modules/halo/sounds/flood_infect_gravemind.ogg'

#define PLAYER_TRANSFORM_SFX 'code/modules/halo/sounds/flood_join_chorus.ogg'

#define ODST_FLOOD_GUN_LIST list(/obj/item/weapon/gun/projectile/m6d_magnum,/obj/item/weapon/gun/projectile/m6c_magnum_s,\
/obj/item/weapon/gun/projectile/ma5b_ar,/obj/item/weapon/gun/projectile/m7_smg,/obj/item/weapon/gun/projectile/m7_smg/silenced)

#define FLOOD_BURNDAM_MULTIPLIER 2

/mob/living/simple_animal/hostile/flood
	attack_sfx = list(\
		'sound/flood/melee.melee1.ogg','sound/flood/melee.melee10.ogg',\
		'sound/flood/melee.melee11.ogg','sound/flood/melee.melee15.ogg',\
		'sound/flood/melee.melee2.ogg','sound/flood/melee.melee20.ogg',\
		'sound/flood/melee.melee5.ogg','sound/flood/melee.melee6.ogg',\
		'sound/flood/melee.melee7.ogg','sound/flood/melee.melee8.ogg',\
		)
	/*
	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	mob_push_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	*/
	break_stuff_probability = 50
	stop_automated_movement = 0
	wander = 1
	melee_damage_lower = 5
	melee_damage_upper = 10
	min_gas = list()
	max_gas = list()
	var/datum/flood_spawner/flood_spawner
	death_sounds = list('sound/flood/death.death10.ogg','sound/flood/death.death15.ogg',\
						'sound/flood/death.death2.ogg','sound/flood/death.death20.ogg',\
						'sound/flood/death.death3.ogg','sound/flood/death.death4.ogg',\
						'sound/flood/death.death5.ogg','sound/flood/death.ogg')
	pain_scream_sounds = list('sound/flood/pain.pain1.ogg','sound/flood/pain.pain15.ogg',\
							'sound/flood/pain.pain2.ogg','sound/flood/pain.pain3.ogg',\
							'sound/flood/pain.pain5.ogg','sound/flood/pain.pain6.ogg')
	assault_target_type = /obj/effect/landmark/assault_target

/mob/living/simple_animal/hostile/flood/death()
	..()
	GLOB.live_flood_simplemobs -= src
	if(flood_spawner)
		flood_spawner.flood_die(src)
		flood_spawner = null

/mob/living/simple_animal/hostile/flood/New()
	our_overmind = flood_overmind
	. = ..()
	GLOB.live_flood_simplemobs.Add(src)
	/*if(prob(50))
		wander = 1
		stop_automated_movement = 0*/

/mob/living/simple_animal/hostile/flood/Life()
	..()
	if(client || ckey)
		target_mob = null

/mob/living/simple_animal/hostile/flood/adjustFireLoss(damage)
	damage *= FLOOD_BURNDAM_MULTIPLIER
	. = ..()


/mob/living/simple_animal/hostile/flood/proc/do_infect(var/mob/living/carbon/human/h)
	sound_to(h,TO_PLAYER_INFECTED_SOUND)
	var/obj/infest_placeholder = new /obj/effect/dead_infestor
	h.contents += infest_placeholder
	h.Stun(999)
	h.visible_message("<span class = 'danger'>[h.name] vomits up blood, red-feelers emerging from their chest...</span>")
	new /obj/effect/decal/cleanable/blood/splatter(h.loc)
	var/mob_type_spawn = /mob/living/simple_animal/hostile/flood/combat_form/prisoner/crew
	if(istype(h.species,/datum/species/sangheili))
		mob_type_spawn = /mob/living/simple_animal/hostile/flood/combat_form/prisoner/abomination
	var/obj/item/clothing/suit/armor/special/combatharness/minor/MI = locate() in h.contents
	if(istype(MI))
		mob_type_spawn = /mob/living/simple_animal/hostile/flood/combat_form/minor
	var/obj/item/clothing/suit/armor/special/combatharness/major/MA = locate() in h.contents
	if(istype(MA))
		mob_type_spawn = /mob/living/simple_animal/hostile/flood/combat_form/major
	var/obj/item/clothing/under/unsc/odst_jumpsuit/OD = locate() in h.contents
	if(istype(OD))
		mob_type_spawn = /mob/living/simple_animal/hostile/flood/combat_form/ODST
	var/obj/item/clothing/under/unsc/marine_fatigues/MAR = locate() in h.contents
	if(istype(MAR))
		mob_type_spawn = /mob/living/simple_animal/hostile/flood/combat_form/human
	var/obj/item/clothing/under/unsc/marine_fatigues/oni_uniform/ONI = locate() in h.contents
	if(istype(ONI))
		mob_type_spawn = /mob/living/simple_animal/hostile/flood/combat_form/oni
	var/obj/item/clothing/under/color/orange/PR = locate() in h.contents
	if(istype(PR))
		mob_type_spawn = /mob/living/simple_animal/hostile/flood/combat_form/prisoner

	var/mob/living/simple_animal/hostile/flood/combat_form/new_combat_form = new mob_type_spawn
	new_combat_form.maxHealth *= PLAYER_FLOOD_HEALTH_MOD //Buff their health a bit.
	new_combat_form.health *= PLAYER_FLOOD_HEALTH_MOD
	new_combat_form.forceMove(h.loc)
	new_combat_form.ckey = h.ckey
	new_combat_form.name = h.real_name
	if(prob(50))
		playsound(new_combat_form.loc,PLAYER_TRANSFORM_SFX,70)
	if(new_combat_form.ckey)
		new_combat_form.stop_automated_movement = 1
	for(var/obj/i in h.contents)
		h.drop_from_inventory(i)
	qdel(h)

/mob/living/simple_animal/hostile/flood/infestor
	name = "Flood infestor"
	icon = 'code/modules/halo/flood/flood_infection.dmi'
	icon_state = "anim"
	icon_living = "anim"
	icon_dead = "dead"
	pass_flags = PASSTABLE
	mob_size = MOB_MINISCULE
	move_to_delay = 15
	health = 1
	maxHealth = 1
	melee_damage_lower = 1
	melee_damage_upper = 5
	attacktext = "leapt at"
	break_stuff_probability = 0
	var/spawning = 1
	var/swarm_size = 1
	var/swarm_size_max = 10

/obj/effect/dead_infestor
	name = "Flood infestor"
	icon = 'code/modules/halo/flood/flood_infection.dmi'
	icon_state = "dead"

/obj/effect/dead_infestor/New()
	. = ..()
	pixel_x = rand(-8,8)
	pixel_y = rand(0,24)

/mob/living/simple_animal/hostile/flood/infestor/New()
	. = ..()
	pixel_x = rand(-8,8)
	pixel_y = rand(0,24)
	spawn(30)
		spawning = 0

/mob/living/simple_animal/hostile/flood/infestor/proc/is_being_infested(var/mob/m)
	if(locate(/obj/effect/dead_infestor) in m.contents)
		return 1
	return 0

/mob/living/simple_animal/hostile/flood/infestor/proc/infest_airlocks_nearby()
	for(var/obj/machinery/door/door in view(2,src))
		var/obj/machinery/door/airlock/door_airlock = door
		if(door.stat & BROKEN || (istype(door_airlock) && door_airlock.welded == 1))
			continue
		visible_message("<span class = 'danger'>[name] leaps at [door], burrowing into the access control mechanisms...</span>")
		adjustBruteLoss(1)
		door.set_broken()
		spawn(AIRLOCK_INFEST_TIME)
			door.visible_message("<spanc class = 'danger>[door] sprouts tendrils of biomass from its control console, fully opening and then bolting.</span>")
			door.open(1,1)
		return 1//Only one door per loop.
	return 0

/mob/living/simple_animal/hostile/flood/infestor/proc/infect_mob(var/mob/living/carbon/human/h)
	if(is_being_infested(h))
		return 0
	visible_message("<span class = 'danger'>[name] leaps at [h.name], tearing at their armor and burrowing through their skin!</span>")
	h.bloodstr.add_reagent(/datum/reagent/floodinfectiontoxin,15)
	adjustBruteLoss(1)
	return 1

/mob/living/simple_animal/hostile/flood/infestor/proc/attempt_nearby_infect()
	for(var/mob/living/carbon/human/h in view(1,src))
		var/mob_healthdam = h.getBruteLoss() + h.getFireLoss()
		if((mob_healthdam > h.maxHealth/4) || h.stat != CONSCIOUS) //Less than quarter health or unconscious/dead? Jump 'em.
			if(infect_mob(h))
				return 1//No more than one at a time.
	return 0

/mob/living/simple_animal/hostile/flood/infestor/proc/revive_nearby_combatforms()
	for(var/mob/living/simple_animal/hostile/flood/combat_form/floodform in view(2,src))
		if(floodform.health > 0 || floodform.corpse_pulped == 1)
			continue
		var/mob/living/simple_animal/hostile/flood/combat_form/newform = new floodform.type (floodform.loc)
		if(floodform.ckey || floodform.client)
			newform.ckey = floodform.ckey
		newform.name = floodform.name
		newform.icon = floodform.icon
		newform.icon_state = initial(floodform.icon_state)
		if(floodform.corpse_pulped != -1)
			newform.corpse_pulped = 1
		visible_message("<span class = 'notice'>[src] leaps at [floodform]'s chest cavity and burrows in.</span>")
		visible_message("<span class = 'danger'>[floodform] lurches back to life, the new infection form twitching in place...</span>")
		qdel(floodform)
		adjustBruteLoss(1)
		return 1 //One at a time.
	return 0

/mob/living/simple_animal/hostile/flood/infestor/Move()
	. = ..()
	if(ckey || client)
		return
	if(health <= 0)
		return
	if(!attempt_nearby_infect())
		if(!revive_nearby_combatforms())
			infest_airlocks_nearby()

/mob/living/simple_animal/hostile/flood/infestor/AttackingTarget()
	. = ..()
	attempt_nearby_infect()

/mob/living/simple_animal/hostile/flood/infestor/adjustBruteLoss(damage)
	if(health > 0)
		swarm_size -= 1
		health -= 1
		maxHealth -= 1
		if(overlays.len)
			overlays.Cut(1,2)
		/*var/mob/living/simple_animal/hostile/flood/infestor/F = new(src.loc)
		F.adjustBruteLoss(1)
		F.death*/
			var/nearby_dead_infestors = 0
			for(var/obj/effect/dead_infestor/E in src.loc)
				nearby_dead_infestors++
			if(nearby_dead_infestors < 8)
				new /obj/effect/dead_infestor(src.loc)
		//atom_despawner.mark_for_despawn(E)
		/*if(health <= 0)
			death()*/

/mob/living/simple_animal/hostile/flood/infestor/Bump(atom/movable/AM, yes)
	//merge flood infestors together into a giant swarm
	if(src.type == AM.type && !spawning && !AM:spawning && src.loc && src.swarm_size < swarm_size_max && AM:swarm_size < swarm_size_max)
		src.overlays += AM
		src.overlays += AM:overlays
		src.maxHealth += AM:maxHealth
		src.health = src.maxHealth
		name = "Flood infestor swarm"
		swarm_size += AM:swarm_size
		melee_damage_lower = min(swarm_size, 30)
		melee_damage_upper = min(swarm_size * 5, 50)
		//
		GLOB.mob_list -= AM
		GLOB.live_flood_simplemobs -= AM
		qdel(AM)
		//AM.loc = null
		//AM:spawning = 1

		return
	return ..()

/mob/living/simple_animal/hostile/flood/infestor/death(gibbed, deathmessage = "bursts!", show_dead_message)
	//overlays.Cut()
	//atom_despawner.mark_for_despawn(src)
	name = "Flood Infestor"
	//for(var/i,0,i<swarm_size,i++)

	//killing a spore can kill others nearby
	/*for(var/mob/living/simple_animal/hostile/flood/infestor/S in view(1,src))
		if(prob(33))
			S.health = 0*/
	return ..()

/mob/living/simple_animal/hostile/flood/infestor/examine(mob/user, var/distance = -1, var/infix = "", var/suffix = "")
	..()
	if(swarm_size > 1)
		to_chat(user, "<span class='warning'>There are [swarm_size] in the swarm.</span>")


/mob/living/simple_animal/hostile/flood/carrier
	name = "Flood carrier"
	icon = 'code/modules/halo/flood/flood_carrier.dmi'
	icon_state = "anim"
	icon_living = "anim"
	icon_dead = ""
	//
	move_to_delay = 30
	health = 10
	maxHealth = 10
	melee_damage_lower = 5
	melee_damage_upper = 15

/mob/living/simple_animal/hostile/flood/carrier/AttackingTarget()
	if(!Adjacent(target_mob))
		return

	health = 0

/mob/living/simple_animal/hostile/flood/carrier/death(gibbed, deathmessage = "bursts!")
	to_chat(src,"<span class='danger'>You burst, propelling flood infestors in all directions!</span>")
	src.visible_message("<span class='danger'>[src] bursts, propelling flood infestors in all directions!</span>")
	playsound(src.loc, 'sound/weapons/heavysmash.ogg', 50, 0, 0)
	icon_state = "burst"

	var/turf/spawn_turf = src.loc
	spawn(0)
		var/sporesleft = rand(3,9)
		while(sporesleft > 0)
			var/mob/living/simple_animal/hostile/flood/infestor/S = new(spawn_turf)
			sporesleft -= 1
			walk_towards(S, pick(range(7, spawn_turf)), 0, 1)
			spawn(30)
				if(S)
					walk(S, 0)

	spawn(3)
		qdel(src)
	return ..(0,deathmessage)

/mob/living/simple_animal/hostile/flood/combat_form
	var/next_infestor_spawn = 0
	var/our_infestor

	var/obj/item/weapon/gun/our_gun

	var/corpse_pulped = 0 //1 = cannot be revived, -1 = can be revived infinitely.
	var/obj/item/inventory = null //an item goes in this variable of the instance with the full path "in/quotes". item in var will drop upon death

/mob/living/simple_animal/hostile/flood/combat_form/examine(var/examiner)
	. = ..()
	if(corpse_pulped == 1)
		to_chat(examiner,"<span class = 'notice'>[src] has been heavily damaged. Once dead, it's dead for good.</span>")
	if(corpse_pulped == -1)
		to_chat(examiner,"<span class = 'notice'>[src]'s flesh looks tougher than normal. It could likely endure the revivification process many times.</span>")

/mob/living/simple_animal/hostile/flood/combat_form/proc/spawn_infestor()
	if(world.time < next_infestor_spawn)
		if(client)
			to_chat(src,"<span class = 'notice'>Your biomass hasn't recovered from the previous formation.</span>")
		return
	next_infestor_spawn = world.time + COMBAT_FORM_INFESTOR_SPAWN_DELAY
	our_infestor = new /mob/living/simple_animal/hostile/flood/infestor (src.loc)
	visible_message("<span class = 'warning'>[src]'s flesh writhes for a moment, blood-red feelers emerging, followed by a singular infection form.</span>")

/mob/living/simple_animal/hostile/flood/combat_form/verb/create_infestor_form()
	set name = "Create Infestor Form"
	set category = "Abilities"

	if(stat == DEAD)
		to_chat(usr,"<span class = 'notice'>You can't do that, you're dead!</span>")
		return

	spawn_infestor()

/mob/living/simple_animal/hostile/flood/combat_form/verb/smash_airlocks_nearby()
	set name = "Destroy Weld"
	set category = "Abilities"

	if(stat == DEAD)
		to_chat(usr,"<span class = 'notice'>You can't do that, you're dead!</span>")
		return
	smash_airlock()

/mob/living/simple_animal/hostile/flood/combat_form/proc/smash_airlock()
	for(var/obj/machinery/door/airlock/door in view(1,src))
		if(door.welded == 1)
			visible_message("<span class = 'danger'>[name] swipes at [door], swiftly slicing the crude welding apart!</span>")
			door.welded = 0
			door.update_icon()
			playsound(src.loc, 'sound/effects/grillehit.ogg', 80)

/mob/living/simple_animal/hostile/flood/combat_form/IsAdvancedToolUser()
	if(our_gun) //Only class us as an advanced tool user if we need it to use our gun.
		return 1
	return 0

/mob/living/simple_animal/hostile/flood/combat_form/can_wield_item(var/obj/item)
	if(istype(item,/obj/item/weapon/gun))
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/flood/combat_form/UnarmedAttack(var/atom/attacked)
	. = ..(attacked)
	pickup_gun(attacked)

/mob/living/simple_animal/hostile/flood/combat_form/RangedAttack(var/atom/attacked)
	. = ..()
	if(!our_gun)
		return
	var/gun_fire = our_gun.Fire(attacked,src)
	if(!ckey && !gun_fire)
		drop_gun()

/mob/living/simple_animal/hostile/flood/combat_form/proc/pickup_gun(var/obj/item/weapon/gun/G)
	if(!istype(G))
		return
	if(our_gun)
		drop_gun()
	visible_message("<span class = 'notice'>[name] picks up [G.name]</span>")
	our_gun = G
	contents += our_gun
	ranged = 1

/mob/living/simple_animal/hostile/flood/combat_form/proc/drop_gun()
	if(our_gun)
		visible_message("<span class = 'notice'>[name] drops [our_gun.name]</span>")
		our_gun.forceMove(loc)
		contents -= our_gun
		ranged = 0

/mob/living/simple_animal/hostile/flood/combat_form/proc/human_in_sight()
	for(var/mob/living/carbon/human/h in view(7,src))
		return 1

/mob/living/simple_animal/hostile/flood/combat_form/proc/dump_inventory()
	if(inventory)
		new src.inventory(loc)

/mob/living/simple_animal/hostile/flood/combat_form/death()
	drop_gun()
	dump_inventory()
	. = ..()

/mob/living/simple_animal/hostile/flood/combat_form/Move()
	. = ..()
	if(stat == DEAD)
		return
	if(ckey || client)
		return
	if(human_in_sight() && isnull(our_infestor))
		spawn_infestor()
	if(locate(/obj/machinery/door/airlock) in view(1,src))
		smash_airlock()
	if(!our_gun)
		for(var/obj/item/weapon/gun/G in view(1,src))
			pickup_gun(G)
			return

/mob/living/simple_animal/hostile/flood/combat_form/human
	name = "Flood infested human"
	icon = 'code/modules/halo/flood/flood_combat_human.dmi'
	icon_state = "marine_infested"
	icon_living = "marine_infested"
	icon_dead = "marine_dead"
	//
	move_to_delay = 2
	health = 100
	maxHealth = 100
	resistance = 10
	melee_damage_lower = 25
	melee_damage_upper = 35
	attacktext = "bashed"

/mob/living/simple_animal/hostile/flood/combat_form/ODST
	name = "Flood infested ODST"
	icon = 'code/modules/halo/flood/flood_combat_odst.dmi'
	icon_state = "odst_infested"
	icon_living = "odst_infested"
	icon_dead = "odst_dead"
	//
	move_to_delay = 2
	health = 125 //Combat forms need to be hardier.
	maxHealth = 125
	resistance = 15
	melee_damage_lower = 30
	melee_damage_upper = 35
	attacktext = "bashed"

/mob/living/simple_animal/hostile/flood/combat_form/ODST/New()
	. = ..()
	var/gun_type_spawn = pick(ODST_FLOOD_GUN_LIST)
	pickup_gun(new gun_type_spawn (loc))

/mob/living/simple_animal/hostile/flood/combat_form/guard
	name = "Flood infested human"
	icon = 'code/modules/halo/flood/flood_combat_depotguard.dmi'
	icon_state = "guard_infested"
	icon_living = "guard_infested"
	icon_dead = "guard_dead"
	//
	move_to_delay = 2
	health = 100 //Combat forms need to be hardier.
	maxHealth = 100
	resistance = 15
	melee_damage_lower = 25
	melee_damage_upper = 30
	attacktext = "bashed"

/mob/living/simple_animal/hostile/flood/combat_form/oni
	name = "Flood infested human"
	icon = 'code/modules/halo/flood/flood_combat_oni.dmi'
	icon_state = "oni_infested"
	icon_living = "oni_infested"
	icon_dead = "oni_dead"
	//
	move_to_delay = 2
	health = 100 //Combat forms need to be hardier.
	maxHealth = 100
	resistance = 15
	melee_damage_lower = 30
	melee_damage_upper = 35
	attacktext = "bashed"

/mob/living/simple_animal/hostile/flood/combat_form/minor
	name = "Flood infested Minor"
	icon = 'code/modules/halo/flood/flood_combat_minor.dmi'
	icon_state = "elite_m"
	icon_living = "elite_m"
	icon_dead = "dead"
	//
	move_to_delay = 1
	health = 125 //Combat forms need to be hardier.
	maxHealth = 125
	resistance = 20
	melee_damage_lower = 35
	melee_damage_upper = 40
	attacktext = "slash"

/mob/living/simple_animal/hostile/flood/combat_form/major
	name = "Flood infested Major"
	icon = 'code/modules/halo/flood/flood_combat_major.dmi'
	icon_state = "elite_m"
	icon_living = "elite_m"
	icon_dead = "dead"
	//
	move_to_delay = 1
	health = 125 //Combat forms need to be hardier.
	maxHealth = 125
	resistance = 20
	melee_damage_lower = 35
	melee_damage_upper = 40
	attacktext = "slash"

/mob/living/simple_animal/hostile/flood/combat_form/juggernaut
	name = "Flood Juggernanut"
	icon = 'code/modules/halo/flood/floodjuggernaut.dmi'
	icon_state = "movement state"
	icon_living = "movement state"
	icon_dead = "death state"
	move_to_delay = 1
	health = 1000 //Combat forms need to be hardier.
	maxHealth = 1000
	melee_damage_lower = 40
	melee_damage_upper = 55
	attacktext = "Whips"
	mob_size = MOB_LARGE
	resistance = 20
	bound_width = 96
	bound_height = 96

//below are prison related flood
//these flood are gamemode specific and shouldn't be used elsewhere as they're crafted
//specifically for the achlys gamemode. you've been warned.

/mob/living/simple_animal/hostile/flood/combat_form/prisoner/spawn_infestor()
	our_infestor = 1

/mob/living/simple_animal/hostile/flood/combat_form/prisoner
	name = "infected prisoner"
	desc = "Some sort of creature that clearly used to be human, wearing an orange jumpsuit."
	icon = 'code/modules/halo/flood/flood_combat_human.dmi'
	icon_state = "prisoner_infected2"
	icon_dead = "prisoner_infected2_dead"
	icon_living = "prisoner_infected2"
	move_to_delay = 4
	health = 50 //intentionally squishy to give melee combat a chance
	maxHealth = 50
	melee_damage_lower = 15
	melee_damage_upper = 25 //damage is scaled on the basis that there will be a lot of these and players will need to live after encounters
	attacktext = "stabs at"

/mob/living/simple_animal/hostile/flood/combat_form/prisoner/mutated
	name = "lumpy creature"
	desc = "Some kind of monster with tatters of an orange jumpsuit clinging to it's bulbous body."
	icon_state = "prisoner_infected1"
	icon_living = "prisoner_infected1"
	icon_dead = "prisoner_infected1_dead"
	move_to_delay = 6 //slower than common counterpart to give sense of weight to it
	health = 85 //beefier than it's common counterpart to give a better sense of danger and urgency to encounters
	maxHealth = 85
	melee_damage_lower = 20 //as above so below
	melee_damage_upper = 30

/mob/living/simple_animal/hostile/flood/combat_form/prisoner/guard
	name = "infected guard"
	desc = "Some sort of creature that used to be human, donning a gray prison guard jumpsuit."
	icon_state = "guard_infected1"
	icon_living = "guard_infected1"
	icon_dead = "guard_infected1_dead"

/mob/living/simple_animal/hostile/flood/combat_form/prisoner/mutated/guard
	desc = "Some kind of monster with shredded remains of a gray jumpsuit stuck to it's mishappen body."
	icon_state = "guard_infected2"
	icon_living = "guard_infected2"
	icon_dead = "guard_infected2_dead"

/mob/living/simple_animal/hostile/flood/combat_form/prisoner/abomination
	name = "abomination"
	desc = "A huge, bizarre monster that propels itself on two torso sized arms, leaving it's legs to dangle uselessly below it."
	icon_state = "abomination"
	icon_living = "abomination"
	icon_dead = "abomination_dead"
	move_to_delay = 2 //fast enough to give a sense of danger and muscle
	resistance = 5
	health = 250
	maxHealth = 250 //these will be specifically put in certain locations and not RNG based
	melee_damage_lower = 30
	melee_damage_upper = 40
	attacktext = "smashes"

/mob/living/simple_animal/hostile/flood/combat_form/prisoner/crew
	name = "sickly creature"
	desc = "This used to be a human male, and it's body has changed somehow."
	icon_state = "nudist"
	icon_living = "nudist"
	icon_dead = "nudist_dead"
