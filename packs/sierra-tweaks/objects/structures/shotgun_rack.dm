/obj/structure/shotgun_rack
	name = "shotgun rack"
	desc = "A wooden rack designated to store shotguns."
	icon = 'packs/sierra-tweaks/icons/obj/shotgunrack.dmi'
	icon_state = "shotgun_rack"
	anchored = TRUE
	density = FALSE
	var/locked = FALSE

	var/obj/item/gun/projectile/shotgun/rack_shotgun

/obj/structure/shotgun_rack/use_tool(obj/item/tool, mob/user, list/click_params)
	if(isrobot(user))
		return ..()

	if(istype(tool, /obj/item/card/id))
		if(allowed(usr))
			locked = !locked
			to_chat(user, "[src]'s lock was [locked ? "enabled" : "disabled"].")
		else
			to_chat(user, "[src]'s card reader denied you.")
		return TRUE

	if(istype(tool, /obj/item/gun/projectile/shotgun) && tool.w_class != ITEM_SIZE_NORMAL) //w_class check is to stop people from placing a sawn off shotgun here
		if(!locked)
			if(!rack_shotgun)
				user.unEquip(tool)
				tool.forceMove(src)
				rack_shotgun = tool
				to_chat(user, SPAN_NOTICE("You place \the [tool] in \the [src]."))
				icon_state = "shotgun_rack_[tool.icon_state]"
				return TRUE
	return ..()

/obj/structure/shotgun_rack/attack_hand(mob/user)
	add_fingerprint(user)
	if(isrobot(user))
		return

	if(!locked)
		if(rack_shotgun)
			user.put_in_hands(rack_shotgun)
			to_chat(user, SPAN_NOTICE("You take \the [rack_shotgun] from \the [src]."))
			rack_shotgun = null
			icon_state = "shotgun_rack"
	else
		to_chat(user, "[rack_shotgun] is locked.")


/obj/structure/shotgun_rack/do_simple_ranged_interaction(mob/user)
	if(!locked)
		if(rack_shotgun)
			rack_shotgun.forceMove(loc)
			to_chat(user, SPAN_NOTICE("You telekinetically remove \the [rack_shotgun] from \the [src]."))
			rack_shotgun = null
			icon_state = "shotgun_rack"
	else
		to_chat(user, "[rack_shotgun] is locked.")

/obj/structure/shotgun_rack/double
	icon_state = "shotgun_rack_dshotgun"

/obj/structure/shotgun_rack/double/Initialize()
	. = ..()
	rack_shotgun = new/obj/item/gun/projectile/shotgun/doublebarrel(src)

/obj/structure/shotgun_rack/double_pellet
	icon_state = "shotgun_rack_dshotgun"

/obj/structure/shotgun_rack/double_pellet/Initialize()
	. = ..()
	rack_shotgun = new/obj/item/gun/projectile/shotgun/doublebarrel/pellet(src)

/obj/structure/shotgun_rack/pump
	icon_state = "shotgun_rack_shotgun"

/obj/structure/shotgun_rack/pump/Initialize()
	. = ..()
	rack_shotgun = new /obj/item/gun/projectile/shotgun/pump(src)

/obj/structure/shotgun_rack/combat
	icon_state = "shotgun_rack_cshotgun"

/obj/structure/shotgun_rack/combat/Initialize()
	. = ..()
	rack_shotgun = new /obj/item/gun/projectile/shotgun/pump/combat(src)
