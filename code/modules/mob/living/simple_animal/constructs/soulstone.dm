#define SOULSTONE_CRACKED -1
#define SOULSTONE_EMPTY 0
#define SOULSTONE_ESSENCE 1

/obj/item/device/soulstone
	name = "soul stone shard"
	icon = 'icons/obj/cult.dmi'
	icon_state = "soulstone"
	item_state = "electronic"
	desc = "A strange, ridged chunk of some glassy red material. Achingly cold to the touch."
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 4)

	var/full = SOULSTONE_EMPTY
	/// String. One of `SOULSTONE_OWNER_*`. Defines who or what 'owns' the soulstone, which affects the soul within and any created constructs.
	var/owner_flag = SOULSTONE_OWNER_CULT
	var/mob/living/simple_animal/shade = null
	var/smashing = 0
	var/soulstatus = null

/obj/item/device/soulstone/Initialize(mapload)
	shade = new /mob/living/simple_animal/shade(src)
	. = ..(mapload)

/obj/item/device/soulstone/disrupts_psionics()
	return (full == SOULSTONE_ESSENCE) ? src : FALSE

/obj/item/device/soulstone/proc/shatter()
	playsound(loc, "shatter", 70, 1)
	for(var/i=1 to rand(2,5))
		new /obj/item/material/shard(get_turf(src), MATERIAL_NULLGLASS)
	qdel(src)

/obj/item/device/soulstone/withstand_psi_stress(stress, atom/source)
	. = ..(stress, source)
	if(. > 0)
		. = max(0, . - rand(2,5))
		shatter()

/obj/item/device/soulstone/full
	full = SOULSTONE_ESSENCE
	icon_state = "soulstone2"

/obj/item/device/soulstone/Destroy()
	QDEL_NULL(shade)
	return ..()

/obj/item/device/soulstone/examine(mob/user)
	. = ..()
	if(full == SOULSTONE_EMPTY)
		to_chat(user, "The shard still flickers with a fraction of the full artifact's power, but it needs to be filled with the essence of someone's life before it can be used.")
	if(full == SOULSTONE_ESSENCE)
		to_chat(user,"The shard has gone transparent, a seeming window into a dimension of unspeakable horror.")
	if(full == SOULSTONE_CRACKED)
		to_chat(user, "This one is cracked and useless.")

/obj/item/device/soulstone/on_update_icon()
	. = ..()
	if(full == SOULSTONE_EMPTY)
		icon_state = "soulstone"
	if(full == SOULSTONE_ESSENCE)
		icon_state = "soulstone2" //TODO: A spookier sprite. Also unique sprites.
	if(full == SOULSTONE_CRACKED)
		icon_state = "soulstone"//TODO: cracked sprite
		SetName("cracked soulstone")


/obj/item/device/soulstone/use_weapon(obj/item/weapon, mob/user, list/click_params)
	if (weapon.force < 5)
		return ..()

	if (full == SOULSTONE_CRACKED)
		user.visible_message(
			SPAN_WARNING("\The [user] shatters \a [src] with \a [weapon]!"),
			SPAN_DANGER("You shatter \the [src] with \the [weapon]!")
		)
		shatter()
		return TRUE

	playsound(src, 'sound/effects/Glasshit.ogg', 75, TRUE)
	set_full(SOULSTONE_CRACKED)
	var/scream = ""
	if (shade?.client)
		scream = "You hear a terrible scream!"
	user.visible_message(
		SPAN_WARNING("\The [user] hits \a [src] with \a [weapon], and it cracks. [scream]"),
		SPAN_WARNING("You hit \the [src] with \the [weapon], and it cracks. [scream]")
	)
	return TRUE


/obj/item/device/soulstone/use_tool(obj/item/tool, mob/user, list/click_params)
	// Null Rod - Purify stone
	if (istype(tool, /obj/item/nullrod))
		if (owner_flag == SOULSTONE_OWNER_PURE)
			USE_FEEDBACK_FAILURE("\The [src] is already pure.")
			return TRUE
		owner_flag = SOULSTONE_OWNER_PURE
		user.visible_message(
			SPAN_NOTICE("\The [user] waves \a [tool] over \a [src]."),
			SPAN_NOTICE("You cleanse \the [src] of taint with \the [tool], purging its shackles to its creator...")
		)
		return TRUE

	return ..()


/obj/item/device/soulstone/use_before(mob/living/simple_animal/M, mob/user)
	. = FALSE
	if (!istype(M))
		return FALSE

	if (M == shade)
		to_chat(user, SPAN_NOTICE("You recapture \the [M]."))
		M.forceMove(src)
		return TRUE
	if (full == SOULSTONE_ESSENCE)
		to_chat(user, SPAN_NOTICE("\The [src] is already full."))
		return TRUE
	if (M.stat != DEAD && !M.is_asystole())
		to_chat(user, SPAN_NOTICE("Kill or maim the victim first."))
		return TRUE
	for (var/obj/item/W in M)
		M.drop_from_inventory(W)
	M.dust()
	set_full(SOULSTONE_ESSENCE)
	return TRUE

/obj/item/device/soulstone/attack_self(mob/user)
	if(full != SOULSTONE_ESSENCE) // No essence - no shade
		to_chat(user, SPAN_NOTICE("This [src] has no life essence."))
		return

	if(!shade.key) // No key = hasn't been used
		to_chat(user, SPAN_NOTICE("You cut your finger and let the blood drip on \the [src]."))
		user.remove_blood_simple(1)
		var/datum/ghosttrap/cult/shade/S = get_ghost_trap("soul stone")
		S.request_player(shade, "The soul stone shade summon ritual has been performed. ")
	else if(!shade.client) // Has a key but no client - shade logged out
		to_chat(user, SPAN_NOTICE("\The [shade] in \the [src] is dormant."))
		return
	else if(shade.loc == src)
		var/choice = alert("Would you like to invoke the spirit within?",,"Yes","No")
		if(choice == "Yes")
			shade.dropInto(loc)
			to_chat(user, SPAN_NOTICE("You summon \the [shade]."))
		if(choice == "No")
			return

/obj/item/device/soulstone/proc/set_full(f)
	full = f
	update_icon()

/obj/structure/constructshell
	name = "empty shell"
	icon = 'icons/obj/cult.dmi'
	icon_state = "construct"
	desc = "A wicked machine used by those skilled in magical arts. It is inactive."

/obj/structure/constructshell/cult
	icon_state = "construct-cult"
	desc = "This eerie contraption looks like it would come alive if supplied with a missing ingredient."


/obj/structure/constructshell/use_tool(obj/item/tool, mob/user, list/click_params)
	// Soul Stone - Create construct
	if (istype(tool, /obj/item/device/soulstone))
		var/obj/item/device/soulstone/soulstone = tool
		if (!soulstone.shade)
			USE_FEEDBACK_FAILURE("\The [soulstone] has no essence.")
			return TRUE
		if (!soulstone.shade.client)
			USE_FEEDBACK_FAILURE("\The [soulstone] has essence, but no soul. Activate it in your hand to find a soul for it first.")
			return TRUE
		if (soulstone.shade.loc != soulstone)
			USE_FEEDBACK_FAILURE("\The [soulstone]'s shade must be within the stone to use it with \the [src].")
			return TRUE
		if (!user.canUnEquip(tool))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		var/input = input(user, "Please choose which type of construct you wish to create.", "[src] Construct Selection") as null|anything in list("Artificer", "Juggernaut", "Wraith")
		if (!input || !user.use_sanity_check(src, tool, SANITY_CHECK_DEFAULT | SANITY_CHECK_TOOL_UNEQUIP))
			return TRUE
		if (!soulstone.shade)
			USE_FEEDBACK_FAILURE("\The [soulstone] has no essence.")
			return TRUE
		if (!soulstone.shade.client)
			USE_FEEDBACK_FAILURE("\The [soulstone] has essence, but no soul. Activate it in your hand to find a soul for it first.")
			return TRUE
		if (soulstone.shade.loc != soulstone)
			USE_FEEDBACK_FAILURE("\The [soulstone]'s shade must be within the stone to use it with \the [src].")
			return TRUE
		var/construct_type
		switch (input)
			if ("Artificer")
				construct_type = /mob/living/simple_animal/construct/builder
			if ("Wraith")
				construct_type = /mob/living/simple_animal/construct/wraith
			if ("Juggernaut")
				construct_type = /mob/living/simple_animal/construct/armoured
		var/mob/living/simple_animal/construct/construct = new construct_type(loc)
		user.visible_message(
			SPAN_WARNING("\The [user] presses \a [tool] against \the [src]. It twists and warps into the shape of \a [initial(construct.name)]!"),
			SPAN_WARNING("You press \the [tool] against \the [src], summoning forth a loyal [initial(construct.name)]!")
		)
		construct.key = soulstone.shade.key
		transfer_languages(user, construct, RESTRICTED | HIVEMIND)
		if (soulstone.owner_flag == SOULSTONE_OWNER_CULT)
			GLOB.cult.add_antagonist(construct.mind)
		else
			construct.remove_language(LANGUAGE_CULT)
			construct.remove_language(LANGUAGE_CULT_GLOBAL)
		qdel(soulstone)
		qdel_self()
		return TRUE

	return ..()


#undef SOULSTONE_CRACKED
#undef SOULSTONE_EMPTY
#undef SOULSTONE_ESSENCE
