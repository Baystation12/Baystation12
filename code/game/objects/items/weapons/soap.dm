/obj/item/soap
	name = "soap"
	desc = "A cheap bar of soap. Smells of lye."
	gender = PLURAL
	icon = 'icons/obj/soap.dmi'
	icon_state = "soap"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	w_class = ITEM_SIZE_SMALL
	throwforce = 0
	throw_speed = 4
	throw_range = 20
	var/key_data

	var/list/valid_colors = list(COLOR_GREEN_GRAY, COLOR_RED_GRAY, COLOR_BLUE_GRAY, COLOR_BROWN, COLOR_PALE_PINK, COLOR_PALE_BTL_GREEN, COLOR_OFF_WHITE, COLOR_GRAY40, COLOR_GOLD)
	var/list/valid_scents = list("fresh air", "cinnamon", "mint", "cocoa", "lavender", "an ocean breeze", "a summer garden", "vanilla", "cheap perfume")
	var/list/scent_intensity = list("faintly", "strongly", "overbearingly")
	var/decal_name
	var/list/decals = list("diamond", "heart", "circle")

/obj/item/soap/New()
	..()
	create_reagents(30)
	wet()
/obj/item/soap/random
	icon_state = "soap"

/obj/item/soap/random/Initialize()
	. = ..()
	var/scent = pick(valid_scents)
	var/smelly = pick(scent_intensity)
	color = pick(valid_colors)
	decal_name = pick(decals)
	desc = "A bar of soap. It smells [smelly] of [scent]."
	update_icon()

/obj/item/soap/space_soap
	desc = "Smells like hot metal and walnuts."
	icon_state = "space_soap"

/obj/item/soap/water_soap
	desc = "Smells like chlorine."
	icon_state = "water_soap"

/obj/item/soap/fire_soap
	desc = "Smells like a campfire."
	icon_state = "fire_soap"

/obj/item/soap/rainbow_soap
	desc = "Smells sickly sweet."
	icon_state = "rainbow_soap"

/obj/item/soap/diamond_soap
	desc = "Smells like saffron and vanilla."
	icon_state = "diamond_soap"

/obj/item/soap/uranium_soap
	desc = "Smells not great... Not terrible."
	icon_state = "uranium_soap"

/obj/item/soap/silver_soap
	desc = "Smells like birch and amaranth."
	icon_state = "silver_soap"

/obj/item/soap/brown_soap
	desc = "Smells like cinnamon and cognac."
	icon_state = "brown_soap"

/obj/item/soap/white_soap
	desc = "Smells like nutmeg and oats."
	icon_state = "white_soap"

/obj/item/soap/grey_soap
	desc = "Smells like bergamot and lilies."
	icon_state = "grey_soap"

/obj/item/soap/pink_soap
	desc = "Smells like bubblegum."
	icon_state = "pink_soap"

/obj/item/soap/purple_soap
	desc = "Smells like lavender."
	icon_state = "purple_soap"

/obj/item/soap/blue_soap
	desc = "Smells like cardamom."
	icon_state = "blue_soap"

/obj/item/soap/cyan_soap
	desc = "Smells like bluebells and peaches."
	icon_state = "cyan_soap"

/obj/item/soap/green_soap
	desc = "Smells like a freshly mowed lawn."
	icon_state = "green_soap"

/obj/item/soap/yellow_soap
	desc = "Smells like citron and ginger."
	icon_state = "yellow_soap"

/obj/item/soap/orange_soap
	desc = "Smells like oranges and dark chocolate."
	icon_state = "orange_soap"

/obj/item/soap/red_soap
	desc = "Smells like cherries."
	icon_state = "red_soap"

/obj/item/soap/golden_soap
	desc = "Smells like honey."
	icon_state = "golden_soap"

/obj/item/soap/proc/wet()
	reagents.add_reagent(/datum/reagent/space_cleaner, 15)

/obj/item/soap/Crossed(mob/living/AM)
	if (istype(AM))
		if(AM.pulledby)
			return
		AM.slip("the [src.name]",3)

/obj/item/soap/use_after(atom/target, mob/living/user, click_parameters)
	//I couldn't feasibly  fix the overlay bugs caused by cleaning items we are wearing.
	//So this is a workaround. This also makes more sense from an IC standpoint. ~Carn
	var/cleaned = FALSE
	if(user.client && (target in user.client.screen))
		to_chat(user, SPAN_NOTICE("You need to take that [target.name] off before cleaning it."))
	else if(istype(target,/obj/decal/cleanable/blood))
		to_chat(user, SPAN_NOTICE("You scrub \the [target.name] out."))
		target.clean_blood() //Blood is a cleanable decal, therefore needs to be accounted for before all cleanable decals.
		cleaned = TRUE
	else if(istype(target,/obj/decal/cleanable))
		to_chat(user, SPAN_NOTICE("You scrub \the [target.name] out."))
		qdel(target)
		cleaned = TRUE
	else if(istype(target,/turf) || istype(target, /obj/structure/catwalk))
		var/turf/T = get_turf(target)
		if(!T)
			return TRUE
		user.visible_message(SPAN_WARNING("[user] starts scrubbing \the [T]."))
		T.clean(src, user, 80, SPAN_NOTICE("You scrub \the [target.name] clean."))
		cleaned = TRUE
	else if(istype(target,/obj/structure/hygiene/sink))
		to_chat(user, SPAN_NOTICE("You wet \the [src] in the sink."))
		wet()
	else if(ishuman(target))
		to_chat(user, SPAN_NOTICE("You clean \the [target.name]."))
		if(reagents)
			reagents.trans_to(target, reagents.total_volume / 8)
		target.clean_blood() //Clean bloodied atoms. Blood decals themselves need to be handled above.
		cleaned = TRUE
	else
		to_chat(user, SPAN_NOTICE("You clean \the [target.name]."))
		target.clean_blood() //Clean bloodied atoms. Blood decals themselves need to be handled above.
		cleaned = TRUE

	if(cleaned)
		user.update_personal_goal(/datum/goal/clean, 1)
	return TRUE

//attack_as_weapon
/obj/item/soap/use_before(mob/living/target, mob/living/user)
	. = FALSE
	if (target && user && ishuman(target) && ishuman(user) && !target.stat && !user.stat && user.zone_sel.selecting == BP_MOUTH)
		user.visible_message(SPAN_DANGER("\The [user] washes \the [target]'s mouth out with soap!"))
		if (reagents)
			reagents.trans_to_mob(target, reagents.total_volume / 2, CHEM_INGEST)
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN) //prevent spam
		return TRUE

/obj/item/soap/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/key))
		if(!key_data)
			to_chat(user, SPAN_NOTICE("You imprint \the [I] into \the [src]."))
			var/obj/item/key/K = I
			key_data = K.key_data
			update_icon()
		return
	..()

/obj/item/soap/on_update_icon()
	ClearOverlays()
	if(key_data)
		AddOverlays(image('icons/obj/soap.dmi', icon_state = "soap_key_overlay"))
	else if(decal_name)
		AddOverlays(overlay_image(icon, "decal-[decal_name]"))
