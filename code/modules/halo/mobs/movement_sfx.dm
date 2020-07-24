
/mob/living/proc/get_move_sound()
	if(elevation > BASE_ELEVATION)
		return null
	return 'code/modules/halo/sounds/walk_sounds/generic_walk.ogg'

/mob/living/proc/movement_sfx()
	var/move_sfx = get_move_sound()
	if(move_sfx && world.time % 2 == 0)
		playsound(loc,move_sfx, 20, 1,1,1)

/mob/living/Move()
	. = ..()
	movement_sfx()

/mob/living/carbon/human/get_move_sound()
	. = null
	var/obj/item/flight_item/flightpack = back
	if(istype(flightpack) && flightpack.active)
		return flightpack.flight_sound
	var/obj/item/clothing/shoes/shoe_item = shoes
	if(istype(shoe_item) && m_intent == "run")
		return shoe_item.stepsound