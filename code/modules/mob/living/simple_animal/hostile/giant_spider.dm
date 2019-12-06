#define SPINNING_WEB 1
#define LAYING_EGGS 2
#define MOVING_TO_TARGET 3
#define SPINNING_COCOON 4

//base type, generic 'worker' type spider with no defining gimmick
/mob/living/simple_animal/hostile/giant_spider
	name = "giant spider"
	desc = "A monstrously huge green spider with shimmering eyes."
	icon = 'icons/mob/simple_animal/spider.dmi'
	icon_state = "green"
	icon_living = "green"
	icon_dead = "green_dead"
	speak_emote = list("chitters")
	emote_hear = list("chitters")
	emote_see = list("rubs its forelegs together", "wipes its fangs", "stops suddenly")
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 10
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"
	maxHealth = 125
	health = 125
	melee_damage_lower = 10
	melee_damage_upper = 15
	melee_damage_flags = DAM_SHARP
	heat_damage_per_tick = 20
	cold_damage_per_tick = 20
	faction = "spiders"
	pass_flags = PASS_FLAG_TABLE
	move_to_delay = 3
	speed = 1
	max_gas = list(GAS_PHORON = 1, GAS_CO2 = 5, GAS_METHYL_BROMIDE = 1)
	bleed_colour = "#0d5a71"
	break_stuff_probability = 25
	pry_time = 8 SECONDS
	pry_desc = "clawing"

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/spider
	meat_amount = 3
	bone_material = null
	bone_amount =   0
	skin_material = MATERIAL_SKIN_CHITIN
	skin_amount =   5

	var/poison_per_bite = 6
	var/poison_type = /datum/reagent/toxin/venom
	var/busy = 0
	var/eye_colour
	var/allowed_eye_colours = list(COLOR_RED, COLOR_ORANGE, COLOR_YELLOW, COLOR_LIME, COLOR_DEEP_SKY_BLUE, COLOR_INDIGO, COLOR_VIOLET, COLOR_PINK)
	var/hunt_chance = 1 //percentage chance the mob will run to a random nearby tile

/mob/living/simple_animal/hostile/giant_spider/can_do_maneuver(var/decl/maneuver/maneuver, var/silent = FALSE)
	. = ..() && can_act()

//guards - less venomous, tanky, slower, prioritises protecting nurses
/mob/living/simple_animal/hostile/giant_spider/guard
	desc = "A monstrously huge brown spider with shimmering eyes."
	icon_state = "brown"
	icon_living = "brown"
	icon_dead = "brown_dead"
	meat_amount = 4
	maxHealth = 200
	health = 200
	melee_damage_lower = 13
	melee_damage_upper = 18
	poison_per_bite = 5
	speed = 2
	move_to_delay = 4
	break_stuff_probability = 15
	pry_time = 6 SECONDS

	var/vengance
	var/berserking
	var/mob/living/simple_animal/hostile/giant_spider/nurse/paired_nurse

//nursemaids - these create webs and eggs - the weakest and least threatening
/mob/living/simple_animal/hostile/giant_spider/nurse
	desc = "A monstrously huge beige spider with shimmering eyes."
	icon_state = "beige"
	icon_living = "beige"
	icon_dead = "beige_dead"
	maxHealth = 80
	health = 80
	melee_damage_lower = 10
	melee_damage_upper = 14
	harm_intent_damage = 6 //soft
	poison_per_bite = 5
	speed = 0
	poison_type = /datum/reagent/soporific
	break_stuff_probability = 10
	pry_time = 9 SECONDS

	var/atom/cocoon_target
	var/fed = 0
	var/max_eggs = 8
	var/infest_chance = 8
	var/mob/living/simple_animal/hostile/giant_spider/guard/paired_guard

	//things we can't encase in a cocoon
	var/list/cocoon_blacklist = list(/mob/living/simple_animal/hostile/giant_spider,
									 /obj/structure/closet)

//hunters - the most damage, fast, average health and the only caste tenacious enough to break out of nets
/mob/living/simple_animal/hostile/giant_spider/hunter
	desc = "A monstrously huge black spider with shimmering eyes."
	icon_state = "black"
	icon_living = "black"
	icon_dead = "black_dead"
	maxHealth = 150
	health = 150
	melee_damage_lower = 17
	melee_damage_upper = 20
	poison_per_bite = 10
	speed = -1
	move_to_delay = 2
	break_stuff_probability = 30
	hunt_chance = 25
	can_escape = TRUE
	pry_time = 5 SECONDS
	flash_vulnerability = 2 //sensitive eyes for stalking prey
	does_spin = FALSE
	available_maneuvers = list(/decl/maneuver/leap/spider)
	ability_cooldown = 3 MINUTES

	var/leap_range = 5

//spitters - fast, comparatively weak, very venomous; projectile attacks but will resort to melee once out of ammo
/mob/living/simple_animal/hostile/giant_spider/spitter
	desc = "A monstrously huge iridescent spider with shimmering eyes."
	icon_state = "purple"
	icon_living = "purple"
	icon_dead = "purple_dead"
	maxHealth = 90
	health = 90
	melee_damage_lower = 10
	melee_damage_upper = 14
	poison_per_bite = 15
	ranged = TRUE
	move_to_delay = 2
	projectiletype = /obj/item/projectile/venom
	projectilesound = 'sound/effects/hypospray.ogg'
	fire_desc = "spits venom"
	ranged_range = 6
	pry_time = 7 SECONDS
	flash_vulnerability = 2

	var/venom_charge = 16

//General spider procs
/mob/living/simple_animal/hostile/giant_spider/Initialize(var/mapload, var/atom/parent)
	get_light_and_color(parent)
	spider_randomify()
	update_icon()
	. = ..()

/mob/living/simple_animal/hostile/giant_spider/proc/spider_randomify() //random math nonsense to get their damage, health and venomness values
	melee_damage_lower = rand(0.8 * initial(melee_damage_lower), initial(melee_damage_lower))
	melee_damage_upper = rand(initial(melee_damage_upper), (1.2 * initial(melee_damage_upper)))
	maxHealth = rand(initial(maxHealth), (1.4 * initial(maxHealth)))
	health = maxHealth
	eye_colour = pick(allowed_eye_colours)
	if(eye_colour)
		var/image/I = image(icon = icon, icon_state = "[icon_state]_eyes", layer = EYE_GLOW_LAYER)
		I.color = eye_colour
		I.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		I.appearance_flags = RESET_COLOR
		overlays += I

/mob/living/simple_animal/hostile/giant_spider/on_update_icon()
	if(stat == DEAD)
		overlays.Cut()
		var/image/I = image(icon = icon, icon_state = "[icon_dead]_eyes")
		I.color = eye_colour
		I.appearance_flags = RESET_COLOR
		overlays += I

/mob/living/simple_animal/hostile/giant_spider/FindTarget()
	. = ..()
	if(.)
		if(!ranged) //ranged mobs find target after each shot, dont need this spammed quite so much
			custom_emote(1,"raises its forelegs at [.]")
		else
			if(prob(15))
				custom_emote(1,"locks its eyes on [.]")

/mob/living/simple_animal/hostile/giant_spider/AttackingTarget()
	. = ..()
	if(isliving(.))
		if(health < maxHealth)
			health += (0.2 * rand(melee_damage_lower, melee_damage_upper)) //heal a bit on hit
		if(ishuman(.))
			var/mob/living/carbon/human/H = .
			var/obj/item/clothing/suit/space/S = H.get_covering_equipped_item_by_zone(BP_CHEST)
			if(istype(S) && !length(S.breaches))
				return
		var/mob/living/L = .
		if(L.reagents)
			L.reagents.add_reagent(poison_type, rand(0.5 * poison_per_bite, poison_per_bite))
			if(prob(poison_per_bite))
				to_chat(L, "<span class='warning'>You feel a tiny prick.</span>")

/mob/living/simple_animal/hostile/giant_spider/Life()
	. = ..()
	if(!.)
		return FALSE
	if(stance == HOSTILE_STANCE_IDLE)
		//chance to skitter madly away
		if(!busy && prob(hunt_chance))
			stop_automated_movement = 1
			walk_to(src, pick(orange(20, src)), 1, move_to_delay)
			addtimer(CALLBACK(src, .proc/disable_stop_automated_movement), 5 SECONDS)

/mob/living/simple_animal/hostile/giant_spider/proc/disable_stop_automated_movement()
	stop_automated_movement = 0
	walk(src,0)
	kick_stance()

/mob/living/simple_animal/hostile/giant_spider/proc/divorce()
	return

/****************
Guard caste procs
****************/
/mob/living/simple_animal/hostile/giant_spider/guard/Life()
	. = ..()
	if(!.)
		return FALSE
	if(berserking)
		return FALSE
	if(!paired_nurse)
		find_nurse()
	if(paired_nurse && !busy && stance == HOSTILE_STANCE_IDLE)
		protect(paired_nurse)

/mob/living/simple_animal/hostile/giant_spider/guard/death()
	. = ..()
	divorce()

/mob/living/simple_animal/hostile/giant_spider/guard/Destroy()
	. = ..()
	divorce()

/mob/living/simple_animal/hostile/giant_spider/guard/divorce()
	if(paired_nurse)
		if(paired_nurse.paired_guard)
			paired_nurse.paired_guard = null
		paired_nurse = null

/mob/living/simple_animal/hostile/giant_spider/guard/proc/find_nurse()
	for(var/mob/living/simple_animal/hostile/giant_spider/nurse/N in ListTargets(10))
		if(N.stat || N.paired_guard)
			continue
		paired_nurse = N
		paired_nurse.paired_guard = src
		return 1

/mob/living/simple_animal/hostile/giant_spider/guard/proc/protect(mob/nurse)
	stop_automated_movement = 1
	walk_to(src, nurse, 2, move_to_delay)
	addtimer(CALLBACK(src, .proc/disable_stop_automated_movement), 5 SECONDS)

/mob/living/simple_animal/hostile/giant_spider/guard/proc/go_berserk()
	audible_message("<span class='danger'>\The [src] chitters wildly!</span>")
	melee_damage_lower +=5
	melee_damage_upper +=5
	move_to_delay--
	break_stuff_probability = 45
	addtimer(CALLBACK(src, .proc/calm_down), 3 MINUTES)

/mob/living/simple_animal/hostile/giant_spider/guard/proc/calm_down()
	berserking = FALSE
	visible_message("<span class='notice'>\The [src] calms down and surveys the area.</span>")
	melee_damage_lower -= 5
	melee_damage_upper -= 5
	move_to_delay++
	break_stuff_probability = 10

/****************
Nurse caste procs
****************/
/mob/living/simple_animal/hostile/giant_spider/nurse/divorce()
	if(paired_guard)
		if(paired_guard.paired_nurse)
			paired_guard.paired_nurse = null
	paired_guard = null

/mob/living/simple_animal/hostile/giant_spider/nurse/death()
	. = ..()
	if(paired_guard)
		paired_guard.vengance = rand(50,100)
		if(prob(paired_guard.vengance))
			paired_guard.berserking = TRUE
			paired_guard.go_berserk()
	divorce()

/mob/living/simple_animal/hostile/giant_spider/nurse/Destroy()
	. = ..()
	divorce()

/mob/living/simple_animal/hostile/giant_spider/nurse/AttackingTarget()
	. = ..()
	if(ishuman(.))
		var/mob/living/carbon/human/H = .
		if(prob(infest_chance) && max_eggs)
			var/obj/item/organ/external/O = pick(H.organs)
			if(!BP_IS_ROBOTIC(O) && !BP_IS_CRYSTAL(O) && (LAZYLEN(O.implants) < 2))
				var/eggs = new /obj/effect/spider/eggcluster(O, src)
				O.implants += eggs
				max_eggs--

/mob/living/simple_animal/hostile/giant_spider/nurse/proc/GiveUp(var/C)
	spawn(100)
		if(busy == MOVING_TO_TARGET)
			if(cocoon_target == C && get_dist(src,cocoon_target) > 1)
				cocoon_target = null
			busy = 0
			stop_automated_movement = 0

/mob/living/simple_animal/hostile/giant_spider/nurse/Life()
	. = ..()
	if(!.)
		return FALSE
	if(stance == HOSTILE_STANCE_IDLE)
		var/list/can_see = view(src, 10)
		//30% chance to stop wandering and do something
		if(!busy && prob(30))
			//first, check for potential food nearby to cocoon
			for(var/mob/living/C in can_see)
				if(is_type_in_list(C, cocoon_blacklist))
					continue
				if(C.stat)
					cocoon_target = C
					busy = MOVING_TO_TARGET
					walk_to(src, C, 1, move_to_delay)
					//give up if we can't reach them after 10 seconds
					GiveUp(C)
					return

			//second, spin a sticky spiderweb on this tile
			var/obj/effect/spider/stickyweb/W = locate() in get_turf(src)
			if(!W)
				busy = SPINNING_WEB
				src.visible_message("<span class='notice'>\The [src] begins to secrete a sticky substance.</span>")
				stop_automated_movement = 1
				spawn(40)
					if(busy == SPINNING_WEB)
						new /obj/effect/spider/stickyweb(src.loc)
						busy = 0
						stop_automated_movement = 0
			else
				//third, lay an egg cluster there
				var/obj/effect/spider/eggcluster/E = locate() in get_turf(src)
				if(!E && fed > 0 && max_eggs)
					busy = LAYING_EGGS
					src.visible_message("<span class='notice'>\The [src] begins to lay a cluster of eggs.</span>")
					stop_automated_movement = 1
					spawn(50)
						if(busy == LAYING_EGGS)
							E = locate() in get_turf(src)
							if(!E)
								new /obj/effect/spider/eggcluster(loc, src)
								max_eggs--
								fed--
							busy = 0
							stop_automated_movement = 0
				else
					//fourthly, cocoon any nearby items so those pesky pinkskins can't use them
					for(var/obj/O in can_see)

						if(O.anchored)
							continue
						
						if(is_type_in_list(O, cocoon_blacklist))
							continue

						if(istype(O, /obj/item) || istype(O, /obj/structure) || istype(O, /obj/machinery))
							cocoon_target = O
							busy = MOVING_TO_TARGET
							stop_automated_movement = 1
							walk_to(src, O, 1, move_to_delay)
							//give up if we can't reach them after 10 seconds
							GiveUp(O)

		else if(busy == MOVING_TO_TARGET && cocoon_target)
			if(get_dist(src, cocoon_target) <= 1)
				busy = SPINNING_COCOON
				src.visible_message("<span class='notice'>\The [src] begins to secrete a sticky substance around \the [cocoon_target].</span>")
				stop_automated_movement = 1
				walk(src,0)
				spawn(50)
					if(busy == SPINNING_COCOON)
						if(cocoon_target && istype(cocoon_target.loc, /turf) && get_dist(src,cocoon_target) <= 1)
							var/obj/effect/spider/cocoon/C = new(cocoon_target.loc)
							var/large_cocoon = 0
							C.pixel_x = cocoon_target.pixel_x
							C.pixel_y = cocoon_target.pixel_y
							for(var/mob/living/M in C.loc)
								large_cocoon = 1
								fed++
								max_eggs++
								src.visible_message("<span class='warning'>\The [src] sticks a proboscis into \the [cocoon_target] and sucks a viscous substance out.</span>")
								M.forceMove(C)
								C.pixel_x = M.pixel_x
								C.pixel_y = M.pixel_y
								break
							for(var/obj/item/I in C.loc)
								I.forceMove(C)
							for(var/obj/structure/S in C.loc)
								if(!S.anchored)
									S.forceMove(C)
							for(var/obj/machinery/M in C.loc)
								if(!M.anchored)
									M.forceMove(C)
							if(large_cocoon)
								C.icon_state = pick("cocoon_large1","cocoon_large2","cocoon_large3")
						busy = 0
						stop_automated_movement = 0

	else
		busy = 0
		stop_automated_movement = 0

/*****************
Hunter caste procs
*****************/
/mob/living/simple_animal/hostile/giant_spider/hunter/MoveToTarget()
	if(!can_act() || perform_maneuver(/decl/maneuver/leap/spider, target_mob))
		return
	..()

/mob/living/simple_animal/hostile/giant_spider/hunter/get_jump_distance()
	return leap_range

/mob/living/simple_animal/hostile/giant_spider/hunter/perform_maneuver(var/maneuver, var/atom/target)
	if(!isliving(target) || get_dist(src, target) <= 3)
		return FALSE
	walk(src,0)
	var/first_stop_automation
	if(stop_automation)
		first_stop_automation = stop_automation
		stop_automation = TRUE
	. = ..()
	if(!isnull(first_stop_automation))
		stop_automation = first_stop_automation
	
/mob/living/simple_animal/hostile/giant_spider/hunter/throw_impact(atom/hit_atom)
	if(isliving(hit_atom))
		var/mob/living/target = hit_atom
		stop_automation = FALSE
		visible_message(SPAN_DANGER("\The [src] slams into \the [target], knocking them over!"))
		target.Weaken(1)
		MoveToTarget()
	. = ..()

/******************
Spitter caste procs
******************/
/mob/living/simple_animal/hostile/giant_spider/spitter/Life()
	. = ..()
	if(!.)
		return FALSE
	if(venom_charge <= 0)
		ranged = FALSE
		if(prob(25))
			venom_charge++
			if(venom_charge >= 8)
				ranged = TRUE

/mob/living/simple_animal/hostile/giant_spider/spitter/Shoot()
	..()
	venom_charge--

#undef SPINNING_WEB
#undef LAYING_EGGS
#undef MOVING_TO_TARGET
#undef SPINNING_COCOON
