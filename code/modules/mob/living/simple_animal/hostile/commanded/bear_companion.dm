/mob/living/simple_animal/hostile/commanded/bear
	name = "bear"
	desc = "A large brown bear."

	icon_state = "brownbear"
	icon_living = "brownbear"
	icon_dead = "brownbear_dead"
	icon_gib = "brownbear_gib"

	health = 75
	maxHealth = 75

	density = 1

	attacktext = "swatted"
	melee_damage_lower = 10
	melee_damage_upper = 10

	max_gas = list("phoron" = 2, "carbon_dioxide" = 5)

	response_help = "pets"
	response_harm = "hits"
	response_disarm = "pushes"

	known_commands = list("stay", "stop", "attack", "follow", "dance", "boogie", "boogy")

/mob/living/simple_animal/hostile/commanded/bear/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)
	. = ..()
	if(!.)
		src.emote("roars in rage!")

/mob/living/simple_animal/hostile/commanded/bear/attack_hand(mob/living/carbon/human/M as mob)
	..()
	if(M.a_intent == I_HURT)
		src.emote("roars in rage!")

/mob/living/simple_animal/hostile/commanded/bear/listen()
	if(stance != COMMANDED_MISC) //cant listen if its booty shakin'
		..()

//WE DANCE!
/mob/living/simple_animal/hostile/commanded/bear/misc_command(var/mob/speaker,var/text)
	stay_command()
	stance = COMMANDED_MISC //nothing can stop this ride
	spawn(0)
		src.visible_message("\The [src] starts to dance!.")
		var/datum/gender/G = gender_datums[gender]
		for(var/i in 1 to 10)
			if(stance != COMMANDED_MISC || incapacitated()) //something has stopped this ride.
				return
			var/message = pick(\
							"moves [G.his] head back and forth!",\
							"bobs [G.his] booty!",\
							"shakes [G.his] paws in the air!",\
							"wiggles [G.his] ears!",\
							"taps [G.his] foot!",\
							"shrugs [G.his] shoulders!",\
							"dances like you've never seen!")
			if(dir != WEST)
				set_dir(WEST)
			else
				set_dir(EAST)
			src.visible_message("\The [src] [message]")
			sleep(30)
		stance = COMMANDED_STOP
		set_dir(SOUTH)
		src.visible_message("\The [src] bows, finished with [G.his] dance.")