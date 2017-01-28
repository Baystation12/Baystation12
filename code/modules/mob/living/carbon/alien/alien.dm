/mob/living/carbon/alien

	name = "alien"
	desc = "What IS that?"
	icon = 'icons/mob/alien.dmi'
	icon_state = "alien"
	pass_flags = PASSTABLE
	health = 100
	maxHealth = 100
	mob_size = 4
	species_language = "Xenomorph"

	var/adult_form
	var/dead_icon
	var/amount_grown = 0
	var/max_grown = 200
	var/time_of_birth
	var/language
	var/death_msg = "lets out a waning guttural screech, green blood bubbling from its maw."
	var/can_namepick_as_adult = 0
	var/adult_name
	var/instance_num

/mob/living/carbon/alien/New()

	time_of_birth = world.time

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	instance_num = rand(1, 1000)
	name = "[initial(name)] ([instance_num])"
	real_name = name
	regenerate_icons()

	if(language)
		add_language(language)

	gender = NEUTER

	..()

/mob/living/carbon/alien/u_equip(obj/item/W as obj)
	return

/mob/living/carbon/alien/Stat()
	. = ..()
	stat(null, "Progress: [amount_grown]/[max_grown]")

/mob/living/carbon/alien/restrained()
	return 0

/mob/living/carbon/alien/show_inv(mob/user as mob)
	return //Consider adding cuffs and hats to this, for the sake of fun.