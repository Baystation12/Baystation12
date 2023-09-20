/obj/item/device/dna_sampler
	name = "dna sampler"
	desc = "An all in one DNA sampling and sequencing device which can be used to deliver a genetic payload to a mimic cube. Requires a DNA sample from the target."
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_BIO = 5, TECH_MATERIAL = 2)
	icon = 'icons/obj/tools/implanter.dmi'
	icon_state = "dnainjector0"
	item_state = "syringe_0"
	force = 1
	var/loaded = FALSE
	var/src_name = ""
	var/src_pronouns = ""
	var/src_faction = ""
	var/src_dna = null
	var/src_species = ""
	var/src_flavor = ""

/obj/item/device/dna_sampler/examine(mob/user)
	. = ..()
	if(loaded == TRUE)
		to_chat(user, SPAN_WARNING("\The [src] is currently loaded with a DNA sample of [src_name]"))
	else
		to_chat(user, SPAN_WARNING("\The [src] is currently empty"))

/obj/item/device/dna_sampler/attack_self(mob/user)
	if(loaded == TRUE && alert("Are you sure you wish to flush the current DNA sequence?",,"Yes","No") == "Yes")
		loaded = FALSE
		icon_state = "dnainjector0"
		to_chat(user, "You flush \the [src]'s currently loaded DNA sequence")
		src_dna = null
		src_pronouns = ""
		src_faction = ""
		src_name = ""
		src_species = ""
		src_flavor = ""

/obj/item/device/dna_sampler/use_before(mob/living/carbon/human/L, mob/user)
	. = FALSE
	if (istype(L) && L.can_inject(user, check_zone(user.zone_sel.selecting)))
		if (loaded)
			user.visible_message("\The [src]'s DNA buffer is already full, please flush the existing DNA buffer first")
			return TRUE
		user.visible_message("\The [user] jams \the [src] into \the [L], extracting a viscous orange fluid!")
		icon_state = "dnainjector"
		loaded = TRUE
		src_name = L.real_name
		src_dna = L.dna
		src_pronouns = L.pronouns
		src_faction = L.faction
		src_species = L.species.name
		src_flavor = L.flavor_texts
		return TRUE
