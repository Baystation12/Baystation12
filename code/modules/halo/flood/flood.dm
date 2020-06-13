GLOBAL_VAR(max_flood_simplemobs)
GLOBAL_LIST_EMPTY(live_flood_simplemobs)

#define PLAYER_FLOOD_HEALTH_MOD 1.5

#define AIRLOCK_INFEST_TIME 15 SECONDS

#define COMBAT_FORM_INFESTOR_SPAWN_DELAY 30SECONDS

#define TO_PLAYER_INFECTED_SOUND 'code/modules/halo/sounds/flood_infect_gravemind.ogg'

#define PLAYER_TRANSFORM_SFX 'code/modules/halo/sounds/flood_join_chorus.ogg'

#define ODST_FLOOD_GUN_LIST list(/obj/item/weapon/gun/projectile/m6d_magnum,/obj/item/weapon/gun/projectile/m6c_magnum_s,\
/obj/item/weapon/gun/projectile/ma5b_ar,/obj/item/weapon/gun/projectile/m7_smg,/obj/item/weapon/gun/projectile/m7_smg/silenced)

#define FLOOD_BURNDAM_MULTIPLIER 1.5

#define SPECIES_INFEST_TYPE_LIST list(\
/datum/species/sangheili = /mob/living/simple_animal/hostile/flood/combat_form/prisoner/abomination)

#define ITEM_INFEST_TYPE_LIST list(\
/obj/item/clothing/suit/armor/special/combatharness/minor = /mob/living/simple_animal/hostile/flood/combat_form/minor2,\
/obj/item/clothing/suit/armor/special/combatharness/major = /mob/living/simple_animal/hostile/flood/combat_form/major,\
/obj/item/clothing/suit/armor/special/combatharness/zealot = /mob/living/simple_animal/hostile/flood/combat_form/zealot,\
/obj/item/clothing/suit/armor/special/combatharness/ultra = /mob/living/simple_animal/hostile/flood/combat_form/ultra,\
/obj/item/clothing/suit/armor/special/combatharness/specops = /mob/living/simple_animal/hostile/flood/combat_form/specops,\
/obj/item/clothing/suit/armor/special/combatharness/ranger = /mob/living/simple_animal/hostile/flood/combat_form/ranger,\
/obj/item/clothing/under/unsc/odst_jumpsuit = /mob/living/simple_animal/hostile/flood/combat_form/ODST,\
/obj/item/clothing/under/unsc/marine_fatigues/oni_uniform = /mob/living/simple_animal/hostile/flood/combat_form/oni,\
/obj/item/clothing/under/color/orange = /mob/living/simple_animal/hostile/flood/combat_form/prisoner)

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
	break_stuff_probability = 50
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
	assault_target_type = /obj/effect/landmark/assault_target/flood
	see_in_dark = 6

	faction = "Flood"

/mob/living/simple_animal/hostile/flood/death()
	..()
	GLOB.live_flood_simplemobs -= src
	if(flood_spawner)
		flood_spawner.flood_die(src)
		flood_spawner = null

/mob/living/simple_animal/hostile/flood/New()
	our_overmind = GLOB.flood_overmind
	. = ..()
	GLOB.live_flood_simplemobs.Add(src)
	/*if(prob(50))
		wander = 1
		stop_automated_movement = 0*/

/mob/living/simple_animal/hostile/flood/Life()
	..()
	if(stat != DEAD && health < maxHealth)
		health += 1
	if(client || ckey)
		target_mob = null

/mob/living/simple_animal/hostile/flood/adjustFireLoss(damage)
	if(!client) //Players don't suffer this.
		damage *= FLOOD_BURNDAM_MULTIPLIER
	. = ..()


/mob/living/simple_animal/hostile/flood/proc/do_infect(var/mob/living/carbon/human/h)
	sound_to(h,TO_PLAYER_INFECTED_SOUND)
	var/obj/infest_placeholder = new /obj/effect/dead_infestor
	h.contents += infest_placeholder
	h.Stun(999)
	h.visible_message("<span class = 'danger'>[h.name] vomits up blood, red-feelers emerging from their chest...</span>")
	new /obj/effect/decal/cleanable/blood/splatter(h.loc)
	var/mob_type_spawn = /mob/living/simple_animal/hostile/flood/combat_form/human
	var/list/species_check = SPECIES_INFEST_TYPE_LIST
	for(var/species in species_check)
		if(istype(h.species,species))
			mob_type_spawn = species_check[species]
	var/list/item_check = ITEM_INFEST_TYPE_LIST
	for(var/item in item_check)
		var/obj/item_find = locate(item) in h.contents
		if(!isnull(item_find))
			mob_type_spawn = item_check[item]

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

