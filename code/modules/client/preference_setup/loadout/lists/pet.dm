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

/obj/item/holder/gear/mouse_rat
	pet = /mob/living/simple_animal/passive/mouse/rat/chill
	w_class = ITEM_SIZE_TINY

/obj/item/holder/gear/nymph
	pet = /mob/living/carbon/alien/diona
	w_class = ITEM_SIZE_NORMAL

/obj/item/holder/gear/puppy
	pet = /mob/living/simple_animal/passive/corgi/puppy
	w_class = ITEM_SIZE_TINY

/obj/item/holder/gear/opossum
	pet = /mob/living/simple_animal/passive/opossum
	w_class = ITEM_SIZE_NORMAL

/obj/item/holder/gear/snake
	pet = /mob/living/simple_animal/passive/snake
	w_class = ITEM_SIZE_NORMAL

/datum/gear/pet
	display_name = "pet selection"
	description = "A variety of small creatures indentured for comfort and amusement. Usually considered pests, most of the lower echelon of the crew have been silently allowed to keep them."
	path = /obj/item/holder/gear
	custom_setup_proc = /obj/item/holder/gear/proc/LoadoutCustomSetup
	cost = 5

/datum/gear/pet/New()
	..()
	var/list/options = list()
	options["lizard"] = /obj/item/holder/gear/lizard
	options["mouse, brown"] = /obj/item/holder/gear/mouse_brown
	options["mouse, grey"] = /obj/item/holder/gear/mouse_gray
	options["mouse, white"] = /obj/item/holder/gear/mouse_white
	options["rat"]	= /obj/item/holder/gear/mouse_rat
	options["diona nymph"] = /obj/item/holder/gear/nymph

	gear_tweaks += new /datum/gear_tweak/path (options)

/datum/gear/rpet
	display_name = "pet selection, restricted"
	description = "A variety of creatures indentured for comfort and amusement. These are pets considered common on planets, however, only allowed to the higher echelons of the crew on this vessel."
	path = /obj/item/holder/gear
	custom_setup_proc = /obj/item/holder/gear/proc/LoadoutCustomSetup
	cost = 5
	allowed_roles = list(
		/datum/job/captain,
		/datum/job/hop,
		/datum/job/rd,
		/datum/job/cmo,
		/datum/job/chief_engineer,
		/datum/job/hos,
		/datum/job/liaison,
		/datum/job/representative,
		/datum/job/assistant,
		/datum/job/merchant,
		/datum/job/submap/colonist,
		/datum/job/submap/colonist2,
		/datum/job/submap/scavver_pilot,
		/datum/job/submap/scavver_doctor,
		/datum/job/submap/scavver_engineer,
		/datum/job/submap/bearcat_captain,
		/datum/job/submap/pod
	)

/datum/gear/rpet/New()
	..()
	var/list/options = list()
	options["kitten"] = /obj/item/holder/gear/kitten
	options["puppy"] = /obj/item/holder/gear/puppy
	options["opossum"] = /obj/item/holder/gear/opossum
	options["snake"] = /obj/item/holder/gear/snake

	gear_tweaks += new /datum/gear_tweak/path (options)
