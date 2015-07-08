
/mob/living/simple_animal/bee
	name = "bees"
	icon = 'icons/obj/apiary_bees_etc.dmi'
	icon_state = "bees1"
	icon_dead = "bees1"
	mob_size = 1
	var/strength = 1
	var/feral = 0
	var/mut = 0
	var/toxic = 0
	var/turf/target_turf
	var/mob/target_mob
	var/obj/machinery/apiary/parent
	pass_flags = PASSTABLE
	turns_per_move = 6
	var/obj/machinery/portable_atmospherics/hydroponics/my_hydrotray

/mob/living/simple_animal/bee/New(loc, var/obj/machinery/apiary/new_parent)
	..()
	parent = new_parent

/mob/living/simple_animal/bee/Destroy()
	if(parent)
		parent.owned_bee_swarms.Remove(src)
	..()
