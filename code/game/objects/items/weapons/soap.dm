/obj/item/soap
	name = "soap"
	desc = "A cheap bar of soap. Doesn't smell."
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
	var/list/valid_shapes = list("oval", "circular", "rectangular", "square")
	var/decal_name
	var/list/decals = list("diamond", "heart", "circle", "triangle", "")

/obj/item/soap/New()
	..()
	create_reagents(30)
	wet()

/obj/item/soap/Initialize()
	. = ..()
	var/shape = pick(valid_shapes)
	var/scent = pick(valid_scents)
	var/smelly = pick(scent_intensity)
	icon_state = "soap-[shape]"
	color = pick(valid_colors)
	decal_name = pick(decals)
	desc = "\A [shape] bar of soap. It smells [smelly] of [scent]."
	update_icon()

/obj/item/soap/proc/wet()
	reagents.add_reagent(/datum/reagent/space_cleaner, 15)

/obj/item/soap/Crossed(var/mob/living/AM)
	if (istype(AM))
		if(AM.pulledby)
			return
		AM.slip("the [src.name]",3)

/obj/item/soap/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	//I couldn't feasibly  fix the overlay bugs caused by cleaning items we are wearing.
	//So this is a workaround. This also makes more sense from an IC standpoint. ~Carn
	var/cleaned = FALSE
	if(user.client && (target in user.client.screen))
		to_chat(user, "<span class='notice'>You need to take that [target.name] off before cleaning it.</span>")
	else if(istype(target,/obj/effect/decal/cleanable/blood))
		to_chat(user, "<span class='notice'>You scrub \the [target.name] out.</span>")
		target.clean_blood() //Blood is a cleanable decal, therefore needs to be accounted for before all cleanable decals.
		cleaned = TRUE
	else if(istype(target,/obj/effect/decal/cleanable))
		to_chat(user, "<span class='notice'>You scrub \the [target.name] out.</span>")
		qdel(target)
		cleaned = TRUE
	else if(istype(target,/turf) || istype(target, /obj/structure/catwalk))
		var/turf/T = get_turf(target)
		if(!T)
			return
		user.visible_message("<span class='warning'>[user] starts scrubbing \the [T].</span>")
		T.clean(src, user, 80, "<span class='notice'>You scrub \the [target.name] clean.</span>")
		cleaned = TRUE
	else if(istype(target,/obj/structure/hygiene/sink))
		to_chat(user, "<span class='notice'>You wet \the [src] in the sink.</span>")
		wet()
	else if(ishuman(target))
		to_chat(user, "<span class='notice'>You clean \the [target.name].</span>")
		if(reagents)
			reagents.trans_to(target, reagents.total_volume / 8)
		target.clean_blood() //Clean bloodied atoms. Blood decals themselves need to be handled above.
		cleaned = TRUE
	else 
		to_chat(user, "<span class='notice'>You clean \the [target.name].</span>")
		target.clean_blood() //Clean bloodied atoms. Blood decals themselves need to be handled above.
		cleaned = TRUE

	if(cleaned)
		user.update_personal_goal(/datum/goal/clean, 1)

//attack_as_weapon
/obj/item/soap/attack(mob/living/target, mob/living/user, var/target_zone)
	if(target && user && ishuman(target) && ishuman(user) && !target.stat && !user.stat && user.zone_sel &&user.zone_sel.selecting == BP_MOUTH)
		user.visible_message("<span class='danger'>\The [user] washes \the [target]'s mouth out with soap!</span>")
		if(reagents)
			reagents.trans_to_mob(target, reagents.total_volume / 2, CHEM_INGEST)
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN) //prevent spam
		return
	..()

/obj/item/soap/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/key))
		if(!key_data)
			to_chat(user, "<span class='notice'>You imprint \the [I] into \the [src].</span>")
			var/obj/item/key/K = I
			key_data = K.key_data
			update_icon()
		return
	..()

/obj/item/soap/on_update_icon()
	overlays.Cut()
	if(key_data)
		overlays += image('icons/obj/items.dmi', icon_state = "soap_key_overlay")
	else if(decal_name)
		overlays +=	overlay_image(icon, "decal-[decal_name]")