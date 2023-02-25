/obj/item/gun/projectile/revolver
	name = "revolver"
	desc = "The al-Maliki & Mosley Magnum Double Action is a choice revolver for when you absolutely, positively need to put a hole in the other guy. You feelin' lucky punk?"
	icon = 'icons/obj/guns/revolvers.dmi'
	icon_state = "revolver"
	item_state = "revolver"
	caliber = CALIBER_PISTOL_MAGNUM
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	handle_casings = CYCLE_CASINGS
	max_shells = 6
	fire_delay = 12 //Revolvers are naturally slower-firing
	ammo_type = /obj/item/ammo_casing/pistol/magnum
	var/chamber_offset = 0 //how many empty chambers in the cylinder until you hit a round
	mag_insert_sound = 'sound/weapons/guns/interaction/rev_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/rev_magout.ogg'
	accuracy = 2
	accuracy_power = 8
	one_hand_penalty = 2
	bulk = 3

/obj/item/gun/projectile/revolver/AltClick()
	if(CanPhysicallyInteract(usr))
		spin_cylinder()

/obj/item/gun/projectile/revolver/verb/spin_cylinder()
	set name = "Spin cylinder"
	set desc = "Fun when you're bored out of your skull."
	set category = "Object"

	chamber_offset = 0
	visible_message(SPAN_WARNING("\The [usr] spins the cylinder of \the [src]!"), \
	SPAN_NOTICE("You hear something metallic spin and click."))
	playsound(src.loc, 'sound/weapons/revolver_spin.ogg', 100, 1)
	loaded = shuffle(loaded)
	if(rand(1,max_shells) > length(loaded))
		chamber_offset = rand(0,max_shells - length(loaded))

/obj/item/gun/projectile/revolver/consume_next_projectile()
	if(chamber_offset)
		chamber_offset--
		return
	return ..()

/obj/item/gun/projectile/revolver/load_ammo(obj/item/A, mob/user)
	chamber_offset = 0
	return ..()

/obj/item/gun/projectile/revolver/medium
	name = "revolver"
	icon_state = "medium"
	safety_icon = "medium_safety"
	caliber = CALIBER_PISTOL
	ammo_type = /obj/item/ammo_casing/pistol
	desc = "The Lumoco Arms' Solid is a rugged revolver for people who don't keep their guns well-maintained."
	accuracy = 1
	bulk = 0
	fire_delay = 9

/obj/item/gun/projectile/revolver/holdout
	name = "holdout revolver"
	desc = "The al-Maliki & Mosley Partner is a concealed-carry revolver made for people who do not trust automatic pistols any more than the people they're dealing with."
	icon_state = "holdout"
	item_state = "pen"
	caliber = CALIBER_PISTOL_SMALL
	ammo_type = /obj/item/ammo_casing/pistol/small
	w_class = ITEM_SIZE_SMALL
	accuracy = 1
	one_hand_penalty = 0
	bulk = 0
	fire_delay = 7

/obj/item/gun/projectile/revolver/capgun
	name = "cap gun"
	desc = "Looks almost like the real thing! Ages 8 and up."
	icon_state = "revolver-toy"
	caliber = CALIBER_CAPS
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	ammo_type = /obj/item/ammo_casing/cap
	/// Boolean. If set, the toy markings have been cut off.
	var/markings_cut = FALSE


/obj/item/gun/projectile/revolver/capgun/on_update_icon()
	icon_state = markings_cut ? "revolver" : "revolver-toy"


/obj/item/gun/projectile/revolver/capgun/get_interactions_info()
	. = ..()
	.[CODEX_INTERACTION_WIRECUTTERS] = "<p>Cuts off the toy markings, making it look like a real revolver.</p>"


/obj/item/gun/projectile/revolver/capgun/use_tool(obj/item/tool, mob/user, list/click_params)
	// Wirecutters - Cut off toy markings
	if (isWirecutter(tool))
		if (markings_cut)
			to_chat(user, SPAN_WARNING("\The [src]'s tip has already been cut off."))
			return TRUE
		markings_cut = TRUE
		SetName("revolver")
		desc += " Someone snipped off the barrel's toy mark. How dastardly, this could get someone shot."
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] snips off \the [src]'s toy markings with \a [tool]."),
			SPAN_NOTICE("You snip off \the [src]'s toy markings with \a [tool]."),
			range = 3
		)
		return TRUE

	return ..()
