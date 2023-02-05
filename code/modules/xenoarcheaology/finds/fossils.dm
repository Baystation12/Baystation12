
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// fossils

/obj/item/fossil
	name = "Fossil"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "bone"
	desc = "It's a fossil."
	var/animal = 1

/obj/item/fossil/base/Initialize()
	. = ..()
	if (. == INITIALIZE_HINT_QDEL)
		return
	var/list/fossil_weights = list(
		/obj/item/fossil/bone = 9,
		/obj/item/fossil/skull = 3,
		/obj/item/fossil/skull/horned = 2
	)
	var/fossil_type = pickweight(fossil_weights)
	var/obj/item/I = new fossil_type (loc)
	var/turf/simulated/mineral/T = get_turf(src)
	if (istype(T))
		T.last_find = I
	qdel(src)

/obj/item/fossil/bone
	name = "fossilised bone"
	icon_state = "bone"
	desc = "A fossilised part of an alien, long dead."

/obj/item/fossil/skull
	name = "fossilised skull"
	icon_state = "skull"

/obj/item/fossil/skull/horned
	icon_state = "hskull"

/obj/item/fossil/skull/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/fossil/bone))
		if(!user.canUnEquip(W))
			return
		var/mob/M = get_holder_of_type(src, /mob)
		if(M && !M.unEquip(src))
			return
		var/obj/o = new /obj/skeleton(get_turf(src))
		user.unEquip(W, o)
		forceMove(o)

/obj/skeleton
	name = "Incomplete skeleton"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "uskel"
	desc = "Incomplete skeleton."
	var/bnum = 1
	var/breq
	var/bstate = 0
	var/plaque_contents = "Unnamed alien creature"

/obj/skeleton/Initialize()
	. = ..()
	breq = rand(6) + 3
	desc = "An incomplete skeleton."


/obj/skeleton/examine(mob/user)
	. = ..()

	if (bnum < breq)
		to_chat(user, SPAN_WARNING("Looks like it could use [breq - bnum] more bone\s."))
	else
		var/skull_type = contents.Find(/obj/item/fossil/skull/horned) ? "horned skull" : "skull"
		to_chat(user, SPAN_NOTICE("It is composed of [bnum] assorted bone\s and \a [skull_type]."))

	if (plaque_contents)
		to_chat(user, SPAN_NOTICE("The plaque reads: '[plaque_contents].'"))


/obj/skeleton/get_interactions_info()
	. = ..()
	.["Fossilized Bone"] = "<p>Adds the bone to \the [initial(name)], if it isn't yet complete.</p>"
	.["Pen"] = "<p>Changes the text on \the [initial(name)]'s plaque.</p>"


/obj/skeleton/use_tool(obj/item/tool, mob/user, list/click_params)
	// Fossilized Bone - Add bone to skeleton
	if (istype(tool, /obj/item/fossil/bone))
		if (bstate)
			to_chat(user, SPAN_WARNING("\The [src] does not need anymore bones."))
			return TRUE
		if (!user.unEquip(tool, src))
			to_chat(user, SPAN_WARNING("You can't drop \the [tool]."))
			return TRUE
		bnum++
		user.visible_message(
			SPAN_NOTICE("\The [user] adds \a [tool] to \the [src]."),
			SPAN_NOTICE("You add \the [tool] to \the [src].")
		)
		if (bnum >= breq)
			icon_state = "skel"
			bstate = TRUE
			set_density(TRUE)
			SetName("alien skeleton display")
			desc = "A complete skeleton"
		return TRUE

	// Pen - Change plaque label
	if (istype(tool, /obj/item/pen))
		var/input = input(user, "What would you like to write on the plaque?", "[src]'s Plaque", plaque_contents) as text|null
		input = sanitize(input)
		if (isnull(input) || !user.use_sanity_check(src, tool))
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] writes something on \the [src]'s plaque."),
			SPAN_NOTICE("You relabel \the [src]'s plaque to '[input].'")
		)
		plaque_contents = input
		return TRUE

	return ..()


//shells and plants do not make skeletons
/obj/item/fossil/shell
	name = "fossilised shell"
	icon_state = "shell"
	desc = "A fossilised, pre-Stygian alien crustacean."

/obj/item/fossil/plant
	name = "fossilised plant"
	icon_state = "plant1"
	desc = " A fossilised shred of alien plant matter."
	animal = 0

/obj/item/fossil/plant/Initialize()
	. = ..()
	icon_state = "plant[rand(1,4)]"
