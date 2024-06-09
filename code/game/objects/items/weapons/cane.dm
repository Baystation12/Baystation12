/obj/item/cane
	name = "cane"
	desc = "A cane used by a true gentlemen. Or a clown."
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "cane"
	item_state = "stick"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 5.0
	throwforce = 7.0
	matter = list(MATERIAL_ALUMINIUM = 50)
	attack_verb = list("bludgeoned", "whacked", "disciplined", "thrashed")
	base_parry_chance = 30
	/// Should it support you while moving with injuries?
	var/can_support = TRUE

/obj/item/cane/staff
	name = "wooden staff"
	desc = "A long, polished staff with a curved hook at the end, suitable for leaning on."
	icon_state = "woodstaff"
	item_state = "woodstaff"
	force = 10.0
	matter = null
	w_class = ITEM_SIZE_LARGE

/obj/item/cane/white
	name = "white guide cane"
	desc = "A white-and-red guide cane to aid the visually impaired."
	icon_state = "whitecane"
	item_state = "whitecane"
	can_support = FALSE

/obj/item/cane/crutch
	name = "crutch"
	desc = "A long stick with a forked crosspiece, used to aid in walking."
	icon_state = "crutch"
	item_state = "crutch"

/obj/item/cane/telescopic
	name = "telescopic cane"
	desc = "A sturdy, compact cane that can retract into the handle when not in use."
	icon_state = "telecane"
	item_state = "telecane"
	w_class = ITEM_SIZE_SMALL
	var/extended = FALSE

/obj/item/cane/telescopic/attack_self(mob/user)
	if(!extended)
		user.visible_message(SPAN_NOTICE("[user] extends \the [src] with a flick of their wrist."))
		icon_state = "[initial(icon_state)]_active"
		item_state = "[initial(item_state)]_active"
		w_class = ITEM_SIZE_LARGE
		extended = TRUE
		can_support = TRUE
	else
		user.visible_message(SPAN_NOTICE("[user] retracts \the [src] back into its handle."))
		icon_state = "[initial(icon_state)]"
		item_state = "[initial(item_state)]"
		w_class = initial(w_class)
		extended = FALSE
		can_support = FALSE
	playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
	update_held_icon()

/obj/item/cane/telescopic/holocane
	name = "holo-cane"
	desc = "A high-tech energy cane that projects a hardlight hologram, for the sophisticated scientist."
	icon_state = "holocane"
	item_state = "holocane"

/obj/item/cane/concealed
	var/concealed_blade

/obj/item/cane/concealed/New()
	..()
	var/obj/item/material/knife/folding/combat/switchblade/temp_blade = new(src)
	concealed_blade = temp_blade

/obj/item/cane/concealed/attack_self(mob/user)
	if(concealed_blade)
		user.visible_message(SPAN_WARNING("[user] has unsheathed \a [concealed_blade] from [src]!"), "You unsheathe \the [concealed_blade] from [src].")
		// Calling drop/put in hands to properly call item drop/pickup procs
		playsound(user.loc, 'sound/weapons/flipblade.ogg', 50, 1)
		user.drop_from_inventory(src)
		user.put_in_hands(concealed_blade)
		user.put_in_hands(src)
		concealed_blade = null
		update_icon()
		user.update_inv_l_hand()
		user.update_inv_r_hand()
	else
		..()

/obj/item/cane/concealed/use_tool(obj/item/item, mob/living/user, list/click_params)
	if (istype(item, /obj/item/material/knife/folding))
		var/obj/item/material/knife/folding/blade = item
		if (concealed_blade)
			to_chat(user, SPAN_WARNING("\The [src] already contains a blade."))
			return TRUE
		if (!user.unEquip(blade, src))
			FEEDBACK_UNEQUIP_FAILURE(user, blade)
			return TRUE

		user.visible_message(
			SPAN_WARNING("\The [user] has sheathed \a [blade] into \the [src]!"),
			"You sheathe \the [blade] into \the [src]."
			)
		concealed_blade = blade
		update_icon()
		user.update_inv_l_hand()
		user.update_inv_r_hand()
		return TRUE

	return ..()

/obj/item/cane/concealed/on_update_icon()
	if(concealed_blade)
		SetName(initial(name))
		icon_state = initial(icon_state)
		item_state = initial(item_state)
	else
		SetName("cane shaft")
		icon_state = "cane_noknife"
		item_state = "foldcane"

/obj/item/gun/projectile/shotgun/cane
	name = "cane"
	desc = "A cane used by true gentlemen. Or a clown."
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "cane"
	item_icons = list(
		slot_r_hand_str = 'icons/mob/onmob/items/righthand.dmi',
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand.dmi'
	)
	item_state_slots = list(
		slot_r_hand_str = "stick",
		slot_l_hand_str = "stick"
	)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 5.0
	throwforce = 7.0
	w_class = ITEM_SIZE_LARGE
	matter = list(MATERIAL_ALUMINIUM = 50)
	attack_verb = list("bludgeoned", "whacked", "disciplined", "thrashed")
	base_parry_chance = 30
	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = CYCLE_CASINGS
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	caliber = CALIBER_SHOTGUN
	one_hand_penalty = 5
	accuracy = -3
	serial = EMPTY_BITFIELD

/obj/item/gun/projectile/shotgun/cane/examine(mob/user, distance)
	. = ..()
	if (distance <= 1 && !safety_state && user.skill_check(SKILL_WEAPONS, SKILL_BASIC))
		to_chat(user, SPAN_NOTICE("You notice a small trigger sticking out from the bottom of \the [src]."))

/obj/item/gun/projectile/shotgun/cane/on_update_icon()
	return

/obj/item/gun/projectile/shotgun/cane/Fire(atom/target, mob/living/user, clickparams, pointblank, reflex)
	if (safety_state)
		to_chat(user, SPAN_WARNING("You can't fire \the [src] without readying it!"))
		return
	..()

/obj/item/gun/projectile/shotgun/cane/CtrlClick(mob/user)
	if (src == user.get_active_hand() || src == user.get_inactive_hand())
		to_chat(user, SPAN_NOTICE("You [safety_state ? "flick out a hidden trigger on \the [src] and shift your grip" : "flick back the hidden trigger and relax your grip"]."))
		return ..()
	return FALSE

/obj/item/gun/projectile/shotgun/cane/get_antag_info()
	. = ..()
	. += "<p>This cane conceals a single-shot shotgun! Inaccurate, so you'll want to be close to your victim.</p>"

/obj/item/gun/projectile/shotgun/cane/get_antag_interactions_info()
	. = ..()
	.["CTRL+CLICK"] = "<p>Toggles the concealed trigger, acting in place of a safety.</p>"
