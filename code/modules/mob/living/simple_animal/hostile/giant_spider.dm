#define SPINNING_WEB 1
#define LAYING_EGGS 2
#define MOVING_TO_TARGET 3
#define SPINNING_COCOON 4

//basic spider mob, these generally guard nests (not really) and are pretty tough all-rounders
/mob/living/simple_animal/hostile/giant_spider
	name = "giant spider"
	desc = "A monstrously huge brown spider with shimmering eyes."
	icon = 'icons/mob/spider.dmi'
	icon_state = "brown"
	icon_living = "brown"
	icon_dead = "brown_dead"
	speak_emote = list("chitters")
	emote_hear = list("chitters")
	emote_see = list("rubs its forelegs together", "wipes its fangs", "stops suddenly")
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 10
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/spider
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"
	stop_automated_movement_when_pulled = 0
	maxHealth = 200
	health = 200
	melee_damage_lower = 10
	melee_damage_upper = 15
	heat_damage_per_tick = 20
	cold_damage_per_tick = 20
	faction = "spiders"
	pass_flags = PASS_FLAG_TABLE
	move_to_delay = 3
	speed = 1
	max_gas = list("phoron" = 1, "carbon_dioxide" = 5, "methyl_bromide" = 1)
	mob_size = MOB_LARGE
	bleed_colour = "#0d5a71"
	can_escape = TRUE
	break_stuff_probability = 25

	var/poison_per_bite = 5
	var/poison_type = /datum/reagent/toxin/venom
	var/busy = 0
	var/eye_colour
	var/allowed_eye_colours = list(COLOR_RED, COLOR_ORANGE, COLOR_YELLOW, COLOR_LIME, COLOR_DEEP_SKY_BLUE, COLOR_INDIGO, COLOR_VIOLET, COLOR_PINK)

//nursemaids - these create webs and eggs - the weakest and least threatening, and the only ones that can be captured for study
/mob/living/simple_animal/hostile/giant_spider/nurse
	desc = "A monstrously huge beige spider with shimmering eyes."
	icon_state = "beige"
	icon_living = "beige"
	icon_dead = "beige_dead"
	maxHealth = 80
	health = 80
	melee_damage_lower = 8
	melee_damage_upper = 12
	poison_per_bite = 15
	speed = 0
	poison_type = /datum/reagent/soporific
	can_escape = FALSE

	var/atom/cocoon_target
	var/fed = 0
	var/infest_chance = 8

//hunters have the most poison and move the fastest, so they can find prey. hunters should be terrifying to fight 1v1
/mob/living/simple_animal/hostile/giant_spider/hunter
	desc = "A monstrously huge black spider with shimmering eyes."
	icon_state = "black"
	icon_living = "black"
	icon_dead = "black_dead"
	maxHealth = 150
	health = 150
	melee_damage_lower = 15
	melee_damage_upper = 20
	poison_per_bite = 15
	speed = -1
	move_to_delay = 2
	break_stuff_probability = 30

/mob/living/simple_animal/hostile/giant_spider/Initialize(var/mapload, var/atom/parent)
	get_light_and_color(parent)
	spider_randomify()
	update_icon()
	. = ..()

/mob/living/simple_animal/hostile/giant_spider/proc/spider_randomify() //random math nonsense to get their damage, health and venomness values
	melee_damage_lower = rand(0.8 * initial(melee_damage_lower), initial(melee_damage_lower))
	melee_damage_upper = rand(initial(melee_damage_upper), (1.2 * initial(melee_damage_upper)))
	poison_per_bite = rand(0.5 * initial(poison_per_bite), (1.2 * initial(poison_per_bite)))
	maxHealth = rand(initial(maxHealth), (1.5 * initial(maxHealth)))
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
		custom_emote(1,"raises its forelegs at [.]")

/mob/living/simple_animal/hostile/giant_spider/AttackingTarget()
	. = ..()
	if(isliving(.))
		if(health < maxHealth)
			health += (0.3 * rand(melee_damage_lower, melee_damage_upper)) //heal a bit on hit
		var/mob/living/L = .
		if(L.reagents)
			L.reagents.add_reagent(/datum/reagent/toxin, poison_per_bite)
			if(prob(poison_per_bite))
				to_chat(L, "<span class='warning'>You feel a tiny prick.</span>")
				L.reagents.add_reagent(poison_type, 5)

/mob/living/simple_animal/hostile/giant_spider/nurse/AttackingTarget()
	. = ..()
	if(ishuman(.))
		var/mob/living/carbon/human/H = .
		if(prob(infest_chance))
			var/obj/item/organ/external/O = pick(H.organs)
			if(!BP_IS_ROBOTIC(O))
				var/eggs = new /obj/effect/spider/eggcluster(O, src)
				O.implants += eggs

/mob/living/simple_animal/hostile/giant_spider/Life()
	..()
	if(!stat)
		if(stance == HOSTILE_STANCE_IDLE)
			//1% chance to skitter madly away
			if(!busy && prob(1))
				/*var/list/move_targets = list()
				for(var/turf/T in orange(20, src))
					move_targets.Add(T)*/
				stop_automated_movement = 1
				walk_to(src, pick(orange(20, src)), 1, move_to_delay)
				spawn(50)
					stop_automated_movement = 0
					walk(src,0)

/mob/living/simple_animal/hostile/giant_spider/nurse/proc/GiveUp(var/C)
	spawn(100)
		if(busy == MOVING_TO_TARGET)
			if(cocoon_target == C && get_dist(src,cocoon_target) > 1)
				cocoon_target = null
			busy = 0
			stop_automated_movement = 0

/mob/living/simple_animal/hostile/giant_spider/nurse/Life()
	..()
	if(!stat)
		if(stance == HOSTILE_STANCE_IDLE)
			var/list/can_see = view(src, 10)
			//30% chance to stop wandering and do something
			if(!busy && prob(30))
				//first, check for potential food nearby to cocoon
				for(var/mob/living/C in can_see)
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
					if(!E && fed > 0)
						busy = LAYING_EGGS
						src.visible_message("<span class='notice'>\The [src] begins to lay a cluster of eggs.</span>")
						stop_automated_movement = 1
						spawn(50)
							if(busy == LAYING_EGGS)
								E = locate() in get_turf(src)
								if(!E)
									new /obj/effect/spider/eggcluster(loc, src)
									fed--
								busy = 0
								stop_automated_movement = 0
					else
						//fourthly, cocoon any nearby items so those pesky pinkskins can't use them
						for(var/obj/O in can_see)

							if(O.anchored)
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
									if(istype(M, /mob/living/simple_animal/hostile/giant_spider))
										continue
									large_cocoon = 1
									fed++
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
										large_cocoon = 1
								for(var/obj/machinery/M in C.loc)
									if(!M.anchored)
										M.forceMove(C)
										large_cocoon = 1
								if(large_cocoon)
									C.icon_state = pick("cocoon_large1","cocoon_large2","cocoon_large3")
							busy = 0
							stop_automated_movement = 0

		else
			busy = 0
			stop_automated_movement = 0

#undef SPINNING_WEB
#undef LAYING_EGGS
#undef MOVING_TO_TARGET
#undef SPINNING_COCOON
