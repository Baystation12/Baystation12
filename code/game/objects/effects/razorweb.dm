/obj/item/razorweb
	name = "razorweb wad"
	desc = "A wad of crystalline monofilament."
	icon = 'icons/effects/razorweb.dmi'
	icon_state = "wad"

	var/web_type = /obj/effect/razorweb

/obj/item/razorweb/throw_impact(var/atom/hit_atom)
	var/obj/effect/razorweb/web = new web_type(get_turf(hit_atom))
	. = ..()
	if(isliving(hit_atom))
		web.buckle_mob(hit_atom)
		web.visible_message(SPAN_DANGER("\The [hit_atom] is tangled in \the [web]!"))
	web.entangle(hit_atom, TRUE)
	qdel(src)

// Hey, did you ever see The Cube (1997) directed by Vincenzo Natali?
/obj/effect/razorweb
	name = "razorweb"
	desc = "A glimmering web of razor-sharp crystalline strands. Probably not something you want to sprint through."
	icon = 'icons/effects/razorweb.dmi'
	icon_state = "razorweb"
	anchored = TRUE

	var/break_chance = 100
	var/last_light
	var/image/gleam
	var/image/web
	var/global/species_immunity_list = list()

/obj/effect/razorweb/tough
	name = "tough razorweb"
	break_chance = 33

/obj/effect/razorweb/Initialize(var/mapload)

	. = ..(mapload)

	for(var/obj/effect/razorweb/otherweb in loc)
		if(otherweb != src)
			return INITIALIZE_HINT_QDEL

	web = image(icon = icon, icon_state = "razorweb")
	gleam = image(icon = icon, icon_state = "razorweb-gleam")
	gleam.layer = EYE_GLOW_LAYER
	gleam.plane = EFFECTS_ABOVE_LIGHTING_PLANE
	var/turf/T = get_turf(src)
	if(T) last_light = T.get_lumcount()
	icon_state = ""
	update_icon()
	START_PROCESSING(SSobj, src)

/obj/effect/razorweb/attackby(var/obj/item/thing, var/mob/user)

	var/destroy_self
	if(thing.force)
		visible_message(SPAN_DANGER("\The [user] breaks \the [src] with \the [thing]!"))
		destroy_self = TRUE

	if(user.unEquip(thing))
		visible_message(SPAN_DANGER("\The [thing] is sliced apart!"))
		qdel(thing)

	if(destroy_self)
		qdel(src)

/obj/effect/razorweb/on_update_icon()
	overlays.Cut()
	web.alpha = 255 * last_light
	overlays = list(web, gleam)

/obj/effect/razorweb/Process()
	var/turf/T = get_turf(src)
	if(T)
		var/current_light = T.get_lumcount()
		if(current_light != last_light)
			last_light = current_light
			update_icon()

/obj/effect/razorweb/user_unbuckle_mob(var/mob/user)
	var/mob/living/M = unbuckle_mob()
	if(M)
		if(M != user)
			visible_message(SPAN_NOTICE("\The [user] drags \the [M] free of \the [src]!"))
			entangle(user, silent = TRUE)
		else
			visible_message(SPAN_NOTICE("\The [M] writhes free of \the [src]!"))
		entangle(M, silent = TRUE)
		add_fingerprint(user)
	return M

/obj/effect/razorweb/Crossed(var/mob/living/L)
	. = ..()
	entangle(L)

/obj/effect/razorweb/proc/entangle(var/mob/living/L, var/silent)

	if(istype(L, /obj/mecha))
		var/obj/mecha/mech = L
		visible_message(SPAN_DANGER("\The [mech] stomps through \the [src], breaking it apart!"))
		mech.take_damage(rand(30, 50))
		qdel(src)
		return

	if(!istype(L) || !L.simulated || L.lying || (MOVING_DELIBERATELY(L) && prob(25)))
		return

	var/mob/living/carbon/human/H
	if(ishuman(L))
		H = L
		if(species_immunity_list[H.species.name])
			return

	if(!silent)
		visible_message(SPAN_DANGER("\The [L] blunders into \the [src]!"))

	var/severed
	if(H)
		var/obj/item/organ/external/E
		for(var/thing in shuffle(H.organs_by_name))
			var/obj/item/organ/external/limb = H.organs_by_name[thing]
			if(!istype(limb) || limb.is_stump() || !(limb.limb_flags & ORGAN_FLAG_CAN_AMPUTATE))
				continue
			var/is_vital = FALSE
			for(var/obj/item/organ/internal/I in limb.internal_organs)
				if(I.vital)
					is_vital = TRUE
					break
			if(!is_vital)
				E = thing
				break

		if(E && !prob(100 * L.get_blocked_ratio(null, BRUTE)))
			E = H.organs_by_name[E]
			visible_message(SPAN_DANGER("The crystalline strands slice straight through \the [H]'s [E.amputation_point || E.name]!"))
			E.droplimb()
			severed = TRUE

	if(!severed && !prob(100 * L.get_blocked_ratio(null, BRUTE)))
		L.apply_damage(rand(25, 50), used_weapon = src)
		visible_message(SPAN_DANGER("The crystalline strands cut deeply into \the [L]!"))

	if(prob(break_chance))
		visible_message(SPAN_DANGER("\The [src] breaks apart!"))
		qdel(src)
	else
		break_chance = min(break_chance+10, 100)