#define JAR_CONTAINS_MONEY 1
#define JAR_CONTAINS_ANIMAL 2
#define JAR_CONTAINS_SPIDERS 3


/obj/item/material/jar
	name = "jar"
	desc = "A small jar."
	icon = 'icons/obj/items.dmi'
	icon_state = "jar"
	w_class = ITEM_SIZE_SMALL
	item_flags = ITEM_FLAG_NO_BLUDGEON
	var/list/accept_mobs = list(
		/mob/living/simple_animal/passive/lizard,
		/mob/living/simple_animal/passive/mouse,
		/mob/living/simple_animal/borer
	)

	/// null, or one of JAR_CONTAINS_*
	var/contains

	/// When MONEY or SPIDERS, the count of those things
	var/worth = 0

	/// The maximum number of spiders this jar can contain.
	var/maximum_spiders = 6


/obj/item/material/jar/Initialize()
	. = ..()
	INIT_DISALLOW_TYPE(/obj/item/material/jar)


// While behavior is complete for non-glass jars, I'm not adding more sprites.
/obj/item/material/jar/glass/default_material = MATERIAL_GLASS


/obj/item/material/jar/glass/on_update_icon()
	if (material.opacity < 1)
		underlays.Cut()
		overlays.Cut()
		if (!contains)
			return
		else if (contains == JAR_CONTAINS_MONEY)
			var/list/images = list()
			for (var/obj/item/spacecash/spacecash in contents)
				images += spacecash.build_image_list()
			for (var/state in images)
				var/image/underlay = image('icons/obj/items.dmi', state)
				underlay.pixel_x = rand(-2, 3)
				underlay.pixel_y = rand(-6, 6)
				underlay.transform *= 0.6
				underlays += underlay
		else if (contains == JAR_CONTAINS_ANIMAL)
			for (var/mob/living/living in contents)
				var/image/underlay = image(living.icon, living.icon_state)
				underlay.pixel_y = 6
				underlays += underlay
				break
		else if (contains == JAR_CONTAINS_SPIDERS)
			for (var/obj/item/spider/spider in contents)
				var/image/underlay = image(spider.icon, spider.icon_state)
				underlay.pixel_x = rand(-4, 4)
				underlay.pixel_y = rand(-2, 4)
				underlays += underlay
			for (var/obj/item/spiderling/spiderling in contents)
				var/image/underlay = image(spiderling.icon, spiderling.icon_state)
				underlay.pixel_x = rand(-4, 4)
				underlay.pixel_y = rand(-2, 4)
				underlays += underlay


/obj/item/material/jar/throw_impact(atom/hit_atom)
	..()
	if (material.flags & MATERIAL_BRITTLE)
		drop_contents()
		shatter()


/obj/item/material/jar/afterattack(atom/movable/target, mob/living/user, adjacent)
	if (!adjacent)
		return
	if (QDELETED(target))
		return
	if (!contains && ismob(target))
		if (!is_type_in_list(target, accept_mobs))
			to_chat(user, SPAN_WARNING("\The [target] won't fit in \the [src]."))
			return
		user.visible_message(
			SPAN_ITALIC("\The [user] scoops up \a [target] with \a [src]."),
			SPAN_ITALIC("You scoop up \the [target] with \the [src].")
		)
		contains = JAR_CONTAINS_ANIMAL
		target.forceMove(src)
		queue_icon_update()
		return
	if ((!contains || contains == JAR_CONTAINS_SPIDERS) && (istype(target, /obj/item/spiderling) || istype(target, /obj/item/spider)))
		if (worth >= maximum_spiders)
			to_chat(user, SPAN_WARNING("That's too many spiders - even for you."))
			return
		user.visible_message(
			SPAN_ITALIC("\The [user] scoops up \a [target] with \a [src]."),
			SPAN_ITALIC("You scoop up \the [target] with \the [src].")
		)
		contains = JAR_CONTAINS_SPIDERS
		STOP_PROCESSING(SSobj, target)
		target.forceMove(src)
		++worth
		queue_icon_update()
		return
	if (!contains && istype(target, /obj/item/holder))
		to_chat(user, SPAN_WARNING("Put \the [target] down first."))


/obj/item/material/jar/attack_self(mob/living/user)
	drop_contents(user)


/obj/item/material/jar/proc/drop_contents(mob/living/user)
	if (!contains)
		return
	var/list/dropped = list()
	var/atom/target = get_turf(src)
	if (!target)
		return
	for (var/atom/movable/movable in contents)
		movable.dropInto(target)
		dropped += movable
	if (dropped.len) // some mobs may not respect the jar
		if (contains == JAR_CONTAINS_MONEY)
			if (user)
				user.visible_message(
					SPAN_ITALIC("\The [user] dumps money out of \a [src]."),
					SPAN_ITALIC("You make it rain!")
				)
		else if (contains == JAR_CONTAINS_ANIMAL)
			if (user)
				user.visible_message(
					SPAN_ITALIC("\The [user] releases \a [dropped[1]] from \a [src]."),
					SPAN_ITALIC("You free \the [dropped[1]] from \his captivity.")
				)
		else if (contains == JAR_CONTAINS_SPIDERS)
			for (var/obj/item/spider/spider in dropped)
				spider.active = TRUE
			for (var/obj/item/spiderling/spiderling in dropped)
				spiderling.active = TRUE
			if (user)
				user.visible_message(
					SPAN_WARNING("\The [user] [dropped.len > 1 ? "showers spiders" : "releases a spider"] from \a [src]!"),
					SPAN_WARNING("You unleash [dropped.len > 1 ? "spiders" : "a spider"] from \the [src]!")
				)
	contains = null
	worth = 0
	queue_icon_update()


/obj/item/material/jar/attackby(obj/item/item, mob/living/user)
	if ((!contains || contains == JAR_CONTAINS_MONEY) && istype(item, /obj/item/spacecash))
		if (!user.unEquip(item, src))
			return
		contains = JAR_CONTAINS_MONEY
		user.visible_message(
			SPAN_ITALIC("\The [user] [user.a_intent == I_HURT ? "stuffs" : "drops"] some cash into \the [src]."),
			SPAN_ITALIC("You [user.a_intent == I_HURT ? "stuff" : "drop"] some cash into \the [src]."),
		)
		var/obj/item/spacecash/cash = item
		worth += cash
		queue_icon_update()
		return
	..()


/obj/item/material/jar/examine(mob/user, distance)
	. = ..()
	var/observer = isobserver(user)
	if (distance > 5 && !observer)
		return
	if (!contains)
		to_chat(user, "It is empty.")
	else if (contains == JAR_CONTAINS_MONEY)
		var/display = observer ? SKILL_MAX : user.get_skill_value(SKILL_FINANCE)
		if (display < SKILL_BASIC)
			display = "some cash"
		else if (display < SKILL_EXPERT)
			if (worth > 500)
				display = "lots of cash"
			else
				display = "some cash"
		else
			display = "[worth] [worth > 1 ? GLOB.using_map.local_currency_name : GLOB.using_map.local_currency_name_singular]"
		to_chat(user, "It contains [display].")
	else if (contains == JAR_CONTAINS_ANIMAL)
		to_chat(user, "It contains \a [contents[1]].")
	else if (contains == JAR_CONTAINS_SPIDERS)
		to_chat(user, "It [contents.len > 1 ? "is brimming with spiders" : "contains a spider"].")


/mob/living/simple_animal/passive/mouse/algernon
	name = "Algernon"
	body_color = "white"
	icon_state = "mouse_white"
	desc = "Always looking at life through a window."
	gender = MALE


/obj/item/material/jar/glass/algernon/Initialize()
	. = ..()
	contains = JAR_CONTAINS_ANIMAL
	new /mob/living/simple_animal/passive/mouse/algernon (src)
	queue_icon_update()


/obj/item/material/jar/glass/spiders/var/list/spider_spawn_limits = list(2, 4)


/obj/item/material/jar/glass/spiders/Initialize()
	. = ..()
	contains = JAR_CONTAINS_SPIDERS
	for (var/i = rand(spider_spawn_limits[1], spider_spawn_limits[2]) to 1 step -1)
		var/obj/effect/spider/spiderling/growing/spiderling = new (src)
		spiderling.amount_grown = rand(90, 95)
		STOP_PROCESSING(SSobj, spiderling)
	queue_icon_update()


/obj/item/material/jar/glass/spiders/more/spider_spawn_limits = list(10, 20)


/datum/uplink_item/item/grenades/spiders
	name = "1x Spider Jar"
	desc = "A jar containing 2 to 4 spiderlings. Ready to grow in moments, guaranteed!"
	item_cost = 15
	path = /obj/item/material/jar/glass/spiders


#undef JAR_CONTAINS_SPIDERS
#undef JAR_CONTAINS_ANIMAL
#undef JAR_CONTAINS_MONEY
