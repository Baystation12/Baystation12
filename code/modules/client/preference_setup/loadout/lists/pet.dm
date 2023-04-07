/obj/item/holder/gear
	abstract_type = /obj/item/holder/gear
	icon = 'icons/mob/simple_animal/animal.dmi'
	icon_state = "kitten"
	name = ""
	desc = ""

	/// The path of living mob this holder should create on initialization.
	var/mob/living/pet


/obj/item/holder/gear/Destroy()
	pet = null
	return ..()


/obj/item/holder/gear/proc/LoadoutCustomSetup(mob/living/user)
	if (!ispath(pet, /mob/living))
		return
	pet = new pet (src)
	if (name)
		pet.SetName(name)
	else
		name = pet.name
	if (desc)
		pet.desc = desc
	else
		desc = pet.desc
	sync(pet)


/obj/item/holder/gear/kitten
	pet = /mob/living/simple_animal/passive/cat/kitten
	w_class = ITEM_SIZE_SMALL

/obj/item/holder/gear/cat_three_color
	pet = /mob/living/simple_animal/passive/cat
	w_class = ITEM_SIZE_NORMAL

/obj/item/holder/gear/cat_black
	pet = /mob/living/simple_animal/passive/cat/fluff/bones
	w_class = ITEM_SIZE_NORMAL

/obj/item/holder/gear/puppy
	pet = /mob/living/simple_animal/passive/corgi/puppy
	w_class = ITEM_SIZE_SMALL

/obj/item/holder/gear/corgi
	pet = /mob/living/simple_animal/passive/corgi
	w_class = ITEM_SIZE_NORMAL

/obj/item/holder/gear/lizard
	pet = /mob/living/simple_animal/passive/lizard
	w_class = ITEM_SIZE_TINY


/obj/item/holder/gear/mouse_brown
	pet = /mob/living/simple_animal/passive/mouse/brown
	w_class = ITEM_SIZE_TINY


/obj/item/holder/gear/mouse_gray
	pet = /mob/living/simple_animal/passive/mouse/gray
	w_class = ITEM_SIZE_TINY


/obj/item/holder/gear/mouse_white
	pet = /mob/living/simple_animal/passive/mouse/white
	w_class = ITEM_SIZE_TINY

/obj/item/holder/gear/slugcat

	pet = /mob/living/simple_animal/passive/cat/fluff/slugcat

	w_class = ITEM_SIZE_NORMAL

/*
/obj/item/holder/gear/mouse_rat
	pet = /mob/living/simple_animal/passive/mouse/rat/chill
	w_class = ITEM_SIZE_TINY
*/

/obj/item/holder/gear/nymph
	pet = /mob/living/carbon/alien/diona
	w_class = ITEM_SIZE_NORMAL

/datum/gear/pet
	display_name = "pet selection"
	description = "A variety of creatures indentured for comfort and amusement."
	path = /obj/item/holder/gear
	custom_setup_proc = /obj/item/holder/gear/proc/LoadoutCustomSetup
	cost = 5


/datum/gear/pet/New()
	..()
	var/list/options = list()
	options["black cat"] = /obj/item/holder/gear/cat_black
	options["calico cat"] = /obj/item/holder/gear/cat_three_color
	options["corgi"] = /obj/item/holder/gear/corgi
	options["corgi puppy"] = /obj/item/holder/gear/puppy
	options["diona nymph"] = /obj/item/holder/gear/nymph
	options["lizard"] = /obj/item/holder/gear/lizard
	options["kitten"] = /obj/item/holder/gear/kitten
	options["brown mouse"] = /obj/item/holder/gear/mouse_brown
	options["grey mouse"] = /obj/item/holder/gear/mouse_gray
	options["white mouse"] = /obj/item/holder/gear/mouse_white
	//options["rat"]	= /obj/item/holder/gear/mouse_rat
	options["slugcat"] = /obj/item/holder/gear/slugcat
	gear_tweaks += new /datum/gear_tweak/path (options)
