/mob/living/simple_animal/hostile/carp/shark
	name = "cosmoshark"
	desc = "Enormous creature that resembles a shark with magenta glowing lines along its body and set of long deep-purple teeth."
	icon = 'icons/mob/simple_animal/space_shark.dmi'
	icon_state = "shark"
	icon_living = "shark"
	icon_dead = "shark_dead"
	icon_gib = "shark_dead"
	turns_per_move = 5
	meat_type = /obj/item/reagent_containers/food/snacks/fish/space_shark
	speed = 2
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	natural_weapon = /obj/item/natural_weapon/bite/strong
	break_stuff_probability = 35
	faction = "shark"
	ai_holder = /datum/ai_holder/simple_animal/melee/carp/shark


/datum/ai_holder/simple_animal/melee/carp/shark/engage_target()
	set waitfor = 0//to deal with sleep() possibly stalling other procs
	. = ..()
	var/mob/living/simple_animal/hostile/carp/shark/S = holder
	var/mob/living/L = .
	if(istype(L))
		if(prob(25))//if one is unlucky enough, they get tackled few tiles away
			L.visible_message("<span class='danger'>\The [src] tackles [L]!</span>")
			var/tackle_length = rand(3,5)
			for (var/i = 1 to tackle_length)
				var/turf/T = get_step(L.loc, S.dir)//on a first step of tackling standing mob would block movement so let's check if there's something behind it. Works for consequent moves too
				if (T.density || LinkBlocked(L.loc, T) || TurfBlockedNonWindow(T) || DirBlocked(T, GLOB.flip_dir[S.dir]))
					break
				sleep(2)
				S.forceMove(T)//maybe there's better manner then just forceMove() them
				L.forceMove(T)
			S.visible_message("<span class='danger'>\The [S] releases [L].</span>")


/mob/living/simple_animal/hostile/carp/shark/carp_randomify()
	return


/mob/living/simple_animal/hostile/carp/shark/on_update_icon()
	return


/mob/living/simple_animal/hostile/carp/shark/death()
	..()
	var/datum/gas_mixture/environment = loc?.return_air()
	if (environment)
		var/datum/gas_mixture/sharkmaw_phoron = new
		sharkmaw_phoron.adjust_gas(GAS_PHORON,  10)
		environment.merge(sharkmaw_phoron)
		visible_message("<span class='warning'>\The [src]'s body releases some gas from the gills with a quiet fizz!</span>")
