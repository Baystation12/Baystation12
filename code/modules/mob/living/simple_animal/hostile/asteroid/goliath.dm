////////////////Goliath////////////////

/mob/living/simple_animal/hostile/asteroid/goliath
	name = "goliath"
	desc = "A massive beast that uses long tentacles to ensare its prey, threatening them is not advised under any conditions."
	icon = 'icons/mob/asteroid/goliath.dmi'
	icon_state = "Goliath"
	icon_living = "Goliath"
	icon_aggro = "Goliath_alert"
	icon_dead = "Goliath_dead"
	icon_gib = "syndicate_gib"
	attack_sound = 'sound/weapons/punch4.ogg'
	mouse_opacity = 2
	move_to_delay = 40
	ranged = 1
	ranged_cooldown = 2 //By default, start the Goliath with his cooldown off so that people can run away quickly on first sight
	ranged_cooldown_cap = 8
	friendly = "wails at"
	vision_range = 5
	speed = 2
	maxHealth = 300
	health = 300
	harm_intent_damage = 0
	melee_damage_lower = 25
	melee_damage_upper = 25
	attacktext = "pulverizes"
	throw_message = "does nothing to the rocky hide of the"
	aggro_vision_range = 9
	idle_vision_range = 5
	var/pre_attack = 0
	var/dead = FALSE

/mob/living/simple_animal/hostile/asteroid/goliath/Life()
	..()
	handle_preattack()
	if(dead && icon_state != icon_dead)
		icon_state = icon_dead

/mob/living/simple_animal/hostile/asteroid/goliath/proc/handle_preattack()
	if(ranged_cooldown <= 2 && !pre_attack)
		pre_attack++
	if(!pre_attack || stat || stance == HOSTILE_STANCE_IDLE)
		return
	if(!dead)
		icon_state = "Goliath_preattack"

/mob/living/simple_animal/hostile/asteroid/goliath/OpenFire()
	var/tturf = get_turf(target_mob)
	if(get_dist(src, target_mob) <= 7)//Screen range check, so you can't get tentacle'd offscreen
		visible_message("<span class='warning'>The [src.name] digs its tentacles under [target_mob.name]!</span>")
		new /obj/effect/goliath_tentacle/original(tturf)
		ranged_cooldown = ranged_cooldown_cap
		icon_state = icon_aggro
		pre_attack = 0
	return

/mob/living/simple_animal/hostile/asteroid/goliath/adjustBruteLoss(damage)
	ranged_cooldown--
	handle_preattack()
	..()

/mob/living/simple_animal/hostile/asteroid/goliath/Aggro()
	vision_range = aggro_vision_range
	handle_preattack()
	if(icon_state != icon_aggro)
		icon_state = icon_aggro
	return

/obj/effect/goliath_tentacle
	name = "Goliath tentacle"
	icon = 'icons/mob/asteroid/goliath.dmi'
	icon_state = "Goliath_tentacle"

/obj/effect/goliath_tentacle/New()
	. = ..()
	var/turftype = get_turf(src)
	if(istype(turftype, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = turftype
		M.GetDrilled()
	addtimer(CALLBACK(src, .proc/Trip), 20)

/obj/effect/goliath_tentacle/original

/obj/effect/goliath_tentacle/original/New()
	. = ..()
	var/list/directions = list(NORTH, SOUTH, EAST, WEST)
	for (var/i in 1 to 3)
		var/spawndir = pick(directions)
		directions -= spawndir
		var/turf/T = get_step(src, spawndir)
		new /obj/effect/goliath_tentacle(T)

/obj/effect/goliath_tentacle/proc/Trip()
	for(var/mob/living/M in src.loc)
		M.Weaken(3)
		visible_message("<span class='warning'>The [src.name] knocks [M.name] down!</span>")
	qdel(src)

/obj/effect/goliath_tentacle/Crossed(AM as mob|obj)
	if(isliving(AM))
		Trip()
		return
	..()

/mob/living/simple_animal/hostile/asteroid/goliath/death(gibbed)
	dead = TRUE
	var/obj/item/asteroid/goliath_hide/G = new /obj/item/asteroid/goliath_hide(src.loc)
	G.layer = 4.1
	..(gibbed)

/obj/item/asteroid/goliath_hide
	name = "goliath hide plates"
	desc = "Pieces of a goliath's rocky hide, these might be able to make your suit a bit more durable to attack from the local fauna."
	icon = 'icons/obj/mining.dmi'
	icon_state = "goliath_hide"
	item_flags = ITEM_FLAG_NO_BLUDGEON
	w_class = 3
	layer = 4

/obj/item/asteroid/goliath_hide/afterattack(atom/target, mob/user, proximity_flag)
	if(proximity_flag)
		if(istype(target, /obj/item/clothing/suit/space) || istype(target, /obj/item/clothing/head/helmet/space))
			var/obj/item/clothing/suit/space/C = target
			var/list/current_armor = C.armor
			if(current_armor.["melee"] < 80)
				current_armor.["melee"] = min(current_armor.["melee"] + 10, 80)
				C.breach_threshold = min(C.breach_threshold + 2, 24)
				to_chat(user, "<span class='info'>You strengthen [target], improving its resistance against melee attacks.</span>")
				qdel(src)
			else
				to_chat(user, "<span class='warning'>You can't improve [C] any further!</span>")
				return
		if(istype(target, /obj/mecha/working/ripley))
			var/obj/mecha/working/ripley/D = target
			var/list/damage_absorption = D.damage_absorption
			if(D.hides < 3)
				D.hides++
				damage_absorption["brute"] = max(damage_absorption["brute"] - 0.1, 0.3)
				damage_absorption["bullet"] = damage_absorption["bullet"] - 0.05
				damage_absorption["fire"] = damage_absorption["fire"] - 0.05
				damage_absorption["laser"] = damage_absorption["laser"] - 0.025
				to_chat(user, "<span class='info'>You strengthen [target], improving its resistance against melee attacks.</span>")
				D.update_icon()
				if(D.hides == 3)
					D.desc = "Autonomous Power Loader Unit. It's wearing a fearsome carapace entirely composed of goliath hide plates - its pilot must be an experienced monster hunter."
				else
					D.desc = "Autonomous Power Loader Unit. Its armour is enhanced with some goliath hide plates."
				qdel(src)
			else
				to_chat(user, "<span class='warning'>You can't improve [D] any further!</span>")
				return
