#define DRYING_TIME 5 * 60*10 //for 1 unit of depth in puddle (amount var)
#define BLOOD_SIZE_SMALL     1
#define BLOOD_SIZE_MEDIUM    2
#define BLOOD_SIZE_BIG       3
#define BLOOD_SIZE_NO_MERGE -1

var/global/list/image/splatter_cache=list()

/obj/effect/decal/cleanable/blood
	name = "blood"
	desc = "It's some blood. That's not supposed to be there."
	gender = PLURAL
	icon = 'icons/effects/blood.dmi'
	icon_state = "mfloor1"
	random_icon_states = list("mfloor1", "mfloor2", "mfloor3", "mfloor4", "mfloor5", "mfloor6", "mfloor7", "dir_splatter_1", "dir_splatter_2")
	blood_DNA = list()
	generic_filth = TRUE
	persistent = TRUE
	appearance_flags = DEFAULT_APPEARANCE_FLAGS | NO_CLIENT_COLOR
	cleanable_scent = "blood"
	scent_descriptor = SCENT_DESC_ODOR

	var/base_icon = 'icons/effects/blood.dmi'
	var/basecolor=COLOR_BLOOD_HUMAN // Color when wet.
	var/amount = 5
	var/drytime
	var/dryname = "dried blood"
	var/drydesc = "It's dry and crusty. Someone isn't doing their job."
	var/blood_size = BLOOD_SIZE_MEDIUM // A relative size; larger-sized blood will not override smaller-sized blood, except maybe at mapload.

/obj/effect/decal/cleanable/blood/reveal_blood()
	if(!fluorescent)
		fluorescent = 1
		basecolor = COLOR_LUMINOL
		update_icon()

/obj/effect/decal/cleanable/blood/clean_blood()
	fluorescent = 0
	if(invisibility != 100)
		set_invisibility(100)
		amount = 0
		STOP_PROCESSING(SSobj, src)
		remove_extension(src, /datum/extension/scent)
	..(ignore=1)

/obj/effect/decal/cleanable/blood/hide()
	return

/obj/effect/decal/cleanable/blood/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/decal/cleanable/blood/Initialize(mapload)
	. = ..()
	if(merge_with_blood(!mapload))
		return INITIALIZE_HINT_QDEL
	start_drying()

// Returns true if overriden and needs deletion. If the argument is false, we will merge into any existing blood.
/obj/effect/decal/cleanable/blood/proc/merge_with_blood(var/override = TRUE)
	. = FALSE
	if(blood_size == BLOOD_SIZE_NO_MERGE)
		return
	if(isturf(loc))
		for(var/obj/effect/decal/cleanable/blood/B in loc)
			if(B == src)
				continue
			if(B.blood_size == BLOOD_SIZE_NO_MERGE)
				continue
			if(override && blood_size >= B.blood_size)
				if (B.blood_DNA)
					blood_DNA |= B.blood_DNA.Copy()
				qdel(B)
				continue
			if(B.blood_DNA)
				B.blood_DNA |= blood_DNA.Copy()
			. = TRUE

/obj/effect/decal/cleanable/blood/proc/start_drying()
	drytime = world.time + DRYING_TIME * (amount+1)
	update_icon()
	START_PROCESSING(SSobj, src)

/obj/effect/decal/cleanable/blood/Process()
	if(world.time > drytime)
		dry()

/obj/effect/decal/cleanable/blood/on_update_icon()
	if(basecolor == "rainbow") basecolor = get_random_colour(1)
	color = basecolor
	if(basecolor == SYNTH_BLOOD_COLOUR)
		SetName("oil")
		desc = "It's black and greasy."
	else
		SetName(initial(name))
		desc = initial(desc)

/obj/effect/decal/cleanable/blood/Crossed(mob/living/carbon/human/perp)
	if (!istype(perp))
		return
	if(amount < 1)
		return

	var/obj/item/organ/external/l_foot = perp.get_organ(BP_L_FOOT)
	var/obj/item/organ/external/r_foot = perp.get_organ(BP_R_FOOT)
	var/hasfeet = 1
	if((!l_foot || l_foot.is_stump()) && (!r_foot || r_foot.is_stump()))
		hasfeet = 0
	if(perp.shoes && !perp.buckled)//Adding blood to shoes
		var/obj/item/clothing/shoes/S = perp.shoes
		if(istype(S))
			S.blood_color = basecolor
			S.track_blood = max(amount,S.track_blood)
			if(!S.blood_overlay)
				S.generate_blood_overlay()
			if(!S.blood_DNA)
				S.blood_DNA = list()
				S.blood_overlay.color = basecolor
				S.overlays += S.blood_overlay
			if(S.blood_overlay && S.blood_overlay.color != basecolor)
				S.blood_overlay.color = basecolor
				S.overlays.Cut()
				S.overlays += S.blood_overlay
			S.blood_DNA |= blood_DNA.Copy()

	else if (hasfeet)//Or feet
		perp.feet_blood_color = basecolor
		perp.track_blood = max(amount,perp.track_blood)
		if(!perp.feet_blood_DNA)
			perp.feet_blood_DNA = list()
		perp.feet_blood_DNA |= blood_DNA.Copy()
	else if (perp.buckled && istype(perp.buckled, /obj/structure/bed/chair/wheelchair))
		var/obj/structure/bed/chair/wheelchair/W = perp.buckled
		W.bloodiness = 4

	perp.update_inv_shoes(1)
	amount--

/obj/effect/decal/cleanable/blood/proc/dry()
	name = dryname
	desc = drydesc
	color = adjust_brightness(color, -50)
	amount = 0
	remove_extension(src, /datum/extension/scent)
	STOP_PROCESSING(SSobj, src)

/obj/effect/decal/cleanable/blood/attack_hand(mob/living/carbon/human/user)
	..()
	if (amount && istype(user))
		if (user.gloves)
			return
		var/taken = rand(1,amount)
		amount -= taken
		to_chat(user, "<span class='notice'>You get some of \the [src] on your hands.</span>")
		if (!user.blood_DNA)
			user.blood_DNA = list()
		user.blood_DNA |= blood_DNA.Copy()
		user.bloody_hands = taken
		user.hand_blood_color = basecolor
		user.update_inv_gloves(1)
		user.verbs += /mob/living/carbon/human/proc/bloody_doodle

/obj/effect/decal/cleanable/blood/splatter
	random_icon_states = list("mgibbl1", "mgibbl2", "mgibbl3", "mgibbl4", "mgibbl5")
	amount = 2
	blood_size = BLOOD_SIZE_BIG
	scent_intensity = /decl/scent_intensity/strong
	scent_range = 3

/obj/effect/decal/cleanable/blood/drip
	name = "drips of blood"
	desc = "Drips and drops of blood."
	gender = PLURAL
	icon = 'icons/effects/drip.dmi'
	icon_state = "1"
	random_icon_states = list("1","2","3","4","5")
	amount = 0
	blood_size = BLOOD_SIZE_SMALL
	scent_intensity = /decl/scent_intensity
	scent_range = 1

	var/list/drips

/obj/effect/decal/cleanable/blood/drip/Initialize()
	. = ..()
	drips = list(icon_state)

/obj/effect/decal/cleanable/blood/writing
	icon = 'icons/effects/writing.dmi'
	icon_state = "writing"
	desc = "It looks like a writing in blood."
	gender = NEUTER
	random_icon_states = list("writing1","writing2","writing3","writing4","writing5")
	amount = 0
	var/message
	blood_size = BLOOD_SIZE_BIG
	scent_intensity = /decl/scent_intensity
	scent_range = 1

/obj/effect/decal/cleanable/blood/writing/New()
	..()
	if(LAZYLEN(random_icon_states))
		for(var/obj/effect/decal/cleanable/blood/writing/W in loc)
			random_icon_states.Remove(W.icon_state)
		icon_state = pick(random_icon_states)
	else
		icon_state = "writing1"

/obj/effect/decal/cleanable/blood/writing/examine(mob/user)
	. = ..()
	to_chat(user, "It reads: <font color='[basecolor]'>\"[message]\"</font>")

/obj/effect/decal/cleanable/blood/gibs
	name = "gibs"
	desc = "They look bloody and gruesome."
	gender = PLURAL
	icon = 'icons/effects/blood.dmi'
	icon_state = "gibbl5"
	random_icon_states = list("gib1", "gib2", "gib3", "gib5", "gib6")
	var/fleshcolor = "#ffffff"
	blood_size = BLOOD_SIZE_NO_MERGE
	cleanable_scent = "viscera"
	scent_intensity = /decl/scent_intensity/strong
	scent_range = 4

/obj/effect/decal/cleanable/blood/gibs/on_update_icon()

	var/image/giblets = new(base_icon, "[icon_state]_flesh", dir)
	if(!fleshcolor || fleshcolor == "rainbow")
		fleshcolor = get_random_colour(1)
	giblets.color = fleshcolor

	var/icon/blood = new(base_icon,"[icon_state]",dir)
	if(basecolor == "rainbow") basecolor = get_random_colour(1)
	blood.Blend(basecolor,ICON_MULTIPLY)

	icon = blood
	overlays.Cut()
	overlays += giblets

/obj/effect/decal/cleanable/blood/gibs/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")

/obj/effect/decal/cleanable/blood/gibs/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")

/obj/effect/decal/cleanable/blood/gibs/body
	random_icon_states = list("gibhead", "gibtorso")

/obj/effect/decal/cleanable/blood/gibs/limb
	random_icon_states = list("gibleg", "gibarm")

/obj/effect/decal/cleanable/blood/gibs/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")


/obj/effect/decal/cleanable/blood/gibs/proc/streak(var/list/directions)
	var/direction = pick(directions)
	for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
		sleep(3)
		if (i > 0)
			var/obj/effect/decal/cleanable/blood/b = new /obj/effect/decal/cleanable/blood/splatter(loc)
			b.basecolor = src.basecolor
			b.update_icon()
		if (step_to(src, get_step(src, direction), 0))
			break

/obj/effect/decal/cleanable/blood/gibs/start_drying()
	return

/obj/effect/decal/cleanable/blood/gibs/merge_with_blood()
	return FALSE

/obj/effect/decal/cleanable/mucus
	name = "mucus"
	desc = "Disgusting mucus."
	gender = PLURAL
	icon = 'icons/effects/blood.dmi'
	icon_state = "mucus"
	generic_filth = TRUE
	persistent = TRUE
	var/dry = FALSE

/obj/effect/decal/cleanable/mucus/Initialize()
	. = ..()
	addtimer(CALLBACK(src, .proc/set_dry), DRYING_TIME * 2)

/obj/effect/decal/cleanable/mucus/proc/set_dry()
	dry = TRUE

#undef BLOOD_SIZE_SMALL
#undef BLOOD_SIZE_MEDIUM
#undef BLOOD_SIZE_BIG
#undef BLOOD_SIZE_NO_MERGE
