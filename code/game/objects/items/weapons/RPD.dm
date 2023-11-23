GLOBAL_LIST_INIT(rpd_pipe_selection, list(
	new /datum/pipe/pipe_dispenser/simple() = list(
		new /datum/pipe/pipe_dispenser/simple/straight(),
		new /datum/pipe/pipe_dispenser/simple/bent(),
		new /datum/pipe/pipe_dispenser/simple/manifold(),
		new /datum/pipe/pipe_dispenser/simple/manifold4w(),
		new /datum/pipe/pipe_dispenser/simple/cap()),
	new /datum/pipe/pipe_dispenser/supply() = list(
		new /datum/pipe/pipe_dispenser/supply/straight(),
		new /datum/pipe/pipe_dispenser/supply/bent(),
		new /datum/pipe/pipe_dispenser/supply/manifold(),
		new /datum/pipe/pipe_dispenser/supply/manifold4w(),
		new /datum/pipe/pipe_dispenser/supply/cap()),
	new /datum/pipe/pipe_dispenser/scrubber() = list(
		new /datum/pipe/pipe_dispenser/scrubber/straight(),
		new /datum/pipe/pipe_dispenser/scrubber/bent(),
		new /datum/pipe/pipe_dispenser/scrubber/manifold(),
		new /datum/pipe/pipe_dispenser/scrubber/manifold4w(),
		new /datum/pipe/pipe_dispenser/scrubber/cap()),
	))

GLOBAL_LIST_INIT(rpd_pipe_selection_skilled, list(
	new /datum/pipe/pipe_dispenser/simple() = list(
		new /datum/pipe/pipe_dispenser/simple/straight(),
		new /datum/pipe/pipe_dispenser/simple/bent(),
		new /datum/pipe/pipe_dispenser/simple/manifold(),
		new /datum/pipe/pipe_dispenser/simple/manifold4w(),
		new /datum/pipe/pipe_dispenser/simple/cap(),
		new /datum/pipe/pipe_dispenser/simple/up(),
		new /datum/pipe/pipe_dispenser/simple/down()
		),
	new /datum/pipe/pipe_dispenser/supply() = list(
		new /datum/pipe/pipe_dispenser/supply/straight(),
		new /datum/pipe/pipe_dispenser/supply/bent(),
		new /datum/pipe/pipe_dispenser/supply/manifold(),
		new /datum/pipe/pipe_dispenser/supply/manifold4w(),
		new /datum/pipe/pipe_dispenser/supply/cap(),
		new /datum/pipe/pipe_dispenser/supply/up(),
		new /datum/pipe/pipe_dispenser/supply/down()
		),
	new /datum/pipe/pipe_dispenser/scrubber() = list(
		new /datum/pipe/pipe_dispenser/scrubber/straight(),
		new /datum/pipe/pipe_dispenser/scrubber/bent(),
		new /datum/pipe/pipe_dispenser/scrubber/manifold(),
		new /datum/pipe/pipe_dispenser/scrubber/manifold4w(),
		new /datum/pipe/pipe_dispenser/scrubber/cap(),
		new /datum/pipe/pipe_dispenser/scrubber/up(),
		new /datum/pipe/pipe_dispenser/scrubber/down()
		),
	new /datum/pipe/pipe_dispenser/fuel() = list(
		new /datum/pipe/pipe_dispenser/fuel/straight(),
		new /datum/pipe/pipe_dispenser/fuel/bent(),
		new /datum/pipe/pipe_dispenser/fuel/manifold(),
		new /datum/pipe/pipe_dispenser/fuel/manifold4w(),
		new /datum/pipe/pipe_dispenser/fuel/cap(),
		new /datum/pipe/pipe_dispenser/fuel/up(),
		new /datum/pipe/pipe_dispenser/fuel/down()
		),
	new /datum/pipe/pipe_dispenser/device() = list(
		new /datum/pipe/pipe_dispenser/device/universaladapter(),
		new /datum/pipe/pipe_dispenser/device/gaspump(),
		new /datum/pipe/pipe_dispenser/device/manualvalve()
		)
	))

/obj/item/rpd
	name = "rapid piping device"
	desc = "Portable, complex and deceptively heavy, it's the cousin of the RCD, use to dispense piping on the move."
	icon = 'icons/obj/tools/rpd.dmi'//Needs proper icon
	icon_state = "rpd"
	force = 12
	throwforce = 15
	throw_speed = 1
	throw_range = 3
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 5, TECH_MATERIAL = 4)

	var/datum/effect/spark_spread/spark_system
	var/datum/pipe/P
	var/pipe_color = "white"
	var/datum/browser/popup

/obj/item/rpd/Initialize()
	. = ..()
	spark_system = new /datum/effect/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	var/list/L = GLOB.rpd_pipe_selection[GLOB.rpd_pipe_selection[1]]
	P = L[1]
	//if there's no pipe selected randomize it

/obj/item/rpd/Destroy()
	QDEL_NULL(spark_system)
	return ..()

/obj/item/rpd/proc/get_console_data(list/pipe_categories, color_options = FALSE)
	. = list()
	. += "<table>"
	if(color_options)
		. += "<tr><td>Color</td><td><a href='?src=\ref[src];color=\ref[src]'>[SPAN_COLOR(pipe_color, pipe_color)]</a></td></tr>"
	for(var/category in pipe_categories)
		var/datum/pipe/cat = category
		. += "<tr><td>[SPAN_COLOR("#517087", "<strong>[initial(cat.category)]</strong>")]</td></tr>"
		for(var/datum/pipe/pipe in pipe_categories[category])
			. += "<tr><td>[pipe.name]</td><td>[P.type == pipe.type ? SPAN_CLASS("linkOn", "Select") : "<a href='?src=\ref[src];select=\ref[pipe]'>Select</a>"]</td></tr>"
	.+= "</table>"
	. = JOINTEXT(.)

/obj/item/rpd/interact(mob/user)
	popup = new (user, "Pipe List", "[src] menu")
	popup.set_content(get_console_data(user.skill_check(SKILL_ATMOS,SKILL_EXPERIENCED) ? GLOB.rpd_pipe_selection_skilled : GLOB.rpd_pipe_selection, TRUE))
	popup.open()

/obj/item/rpd/OnTopic(user, list/href_list)
	if(href_list["select"])
		P = locate(href_list["select"])
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		interact(user)
		if(prob(10)) src.spark_system.start()
		return TOPIC_HANDLED
	if(href_list["color"])
		var/choice = input(user, "What color do you want pipes to have?") as null|anything in pipe_colors
		if(!choice || !CanPhysicallyInteract(user))
			return TOPIC_HANDLED
		pipe_color = choice
		interact(user)
		return TOPIC_HANDLED

/obj/item/rpd/dropped(mob/user)
	..()
	if(popup)
		popup.close()

/obj/item/rpd/use_after(atom/A, mob/living/user, click_parameters)
	if (istype(A, /obj/item/pipe))
		recycle(A,user)
		return TRUE
	else
		if (user.skill_fail_prob(SKILL_ATMOS, 80, SKILL_TRAINED))
			var/C = pick(GLOB.rpd_pipe_selection)
			P = pick(GLOB.rpd_pipe_selection[C])
			user.visible_message(SPAN_WARNING("\The [user] cluelessly fumbles with \the [src]."))
		var/turf/T = get_turf(A)
		if (!T.Adjacent(loc))
			return TRUE

		playsound(get_turf(user), 'sound/machines/click.ogg', 50, 1)
		if (T.is_wall())
			if (!do_after(user, 3 SECONDS, T, DO_PUBLIC_UNIQUE))
				return TRUE
			playsound (get_turf(user), 'sound/items/Deconstruct.ogg', 50, 1)

		P.Build(P, T, pipe_colors[pipe_color])
		if (prob(20))
			spark_system.start()
		return TRUE

/obj/item/rpd/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		if(user.skill_check(SKILL_ATMOS,SKILL_BASIC))
			to_chat(user, "[SPAN_NOTICE("Current selection reads:")] [P]")
		else
			to_chat(user, SPAN_WARNING("The readout is flashing some atmospheric jargon, you can't understand."))

/obj/item/rpd/attack_self(mob/user)
	interact(user)
	add_fingerprint(user)

/obj/item/rpd/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/pipe))
		if(!user.unEquip(W))
			return
		recycle(W,user)
		return
	..()

/obj/item/rpd/proc/recycle(obj/item/W,mob/user)
	if(!user.skill_check(SKILL_ATMOS,SKILL_BASIC))
		user.visible_message("[user] struggles with \the [src], as they futilely jam \the [W] against it")
		return
	playsound(src.loc, 'sound/effects/pop.ogg', 50, 1)
	qdel(W)
