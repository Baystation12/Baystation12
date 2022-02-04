//wip wip wup
/obj/item/storage/mirror
	name = "mirror"
	desc = "A SalonPro Nano-Mirror! The leading brand in hair salon products, utilizing nano-machinery to style your hair just right."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror"
	density = FALSE
	anchored = TRUE
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_LARGEBOX_STORAGE
	use_sound = 'sound/effects/closet_open.ogg'
	startswith = list(
		/obj/item/haircomb/random,
		/obj/item/haircomb/brush,
		/obj/random/medical/lite,
		/obj/item/lipstick/random,
		/obj/random/soap,
		/obj/item/reagent_containers/spray/cleaner/deodorant,
		/obj/item/towel/random
	)
	var/shattered = FALSE
	var/list/ui_cache

	/// Visual object for handling the viscontents
	var/obj/effect/reflection/reflection = null
	vis_flags = VIS_HIDE

/obj/item/storage/mirror/proc/on_moved()
	if(istype(reflection))
		reflection.forceMove(loc)
		reflection.update_mirror_filters() //Mirrors shouldnt move but if they do so should reflection

/obj/item/storage/mirror/Destroy()
	clear_mirror_ui_cache(ui_cache)
	QDEL_NULL(reflection)
	GLOB.moved_event.unregister(src, src, .proc/on_moved)
	. = ..()

/obj/item/storage/mirror/Initialize()
	. = ..()
	reflection = new(loc)
	reflection.setup_visuals(src)
	GLOB.moved_event.register(src, src, .proc/on_moved)

/obj/item/storage/mirror/proc/on_flick() //Have to hide the effect
	if(istype(reflection))
		reflection.alpha = 0
		addtimer(CALLBACK(reflection, /obj/effect/reflection/.proc/reset_alpha), 15, TIMER_CLIENT_TIME | TIMER_UNIQUE | TIMER_OVERRIDE)

/obj/item/storage/mirror/MouseDrop(obj/over)
	. = ..()
	if (!.)
		return
	flick("mirror_open", src)
	on_flick()

/obj/item/storage/mirror/attack_hand(mob/living/carbon/human/user)
	if (shattered)
		to_chat(user, SPAN_WARNING("\The [src] is ruined - you can't get your strut on."))
		return
	open_mirror_ui(src, user, ui_cache)

/obj/item/storage/mirror/proc/shatter()
	if (shattered)
		playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return
	shattered = TRUE
	icon_state = "mirror_broke"
	playsound(src, "shatter", 70, 1)
	desc = "Oh no, seven years of bad luck!"

	if(istype(reflection))
		reflection.alpha_icon_state = "mirror_mask_broken"
		reflection.update_mirror_filters()

/obj/item/storage/mirror/bullet_act(obj/item/projectile/P)
	if (prob(P.get_structure_damage() * 2))
		shatter()
	..()

/obj/item/storage/mirror/attackby(obj/item/I, mob/user)
	if (prob(I.force) && user.a_intent == I_HURT)
		user.visible_message(
			SPAN_WARNING("\The [user] smashes \the [src] with \the [I]!"),
			SPAN_WARNING("You smash \the [src] with \the [I]!")
		)
		shatter()
		return TRUE
	. = ..()
	if (!.)
		return
	flick("mirror_open", src)
	on_flick()

/obj/item/mirror
	name = "mirror"
	desc = "A SalonPro Nano-Mirror(TM) brand mirror! Now a portable version."
	icon = 'icons/obj/items.dmi'
	icon_state = "mirror"
	var/list/ui_cache

/obj/item/mirror/Destroy()
	clear_mirror_ui_cache(ui_cache)
	. = ..()

/obj/item/mirror/attack_self(mob/user)
	open_mirror_ui(src, user, ui_cache)


/proc/open_mirror_ui(obj/item/mirror, mob/living/carbon/human/user, list/ui_cache)
	if (!istype(mirror) || !istype(user))
		return
	var/W = weakref(user)
	var/datum/nano_module/appearance_changer/changer = LAZYACCESS(ui_cache, W)
	if (!changer)
		changer = new(user, APPEARANCE_HEAD|APPEARANCE_FACE)
		changer.name = "SalonPro Nano-Mirror"
		LAZYSET(ui_cache, W, changer)
	changer.ui_interact(user)

/proc/clear_mirror_ui_cache(list/ui_cache)
	for(var/W in ui_cache)
		var/changer = ui_cache[W]
		qdel(changer)
	LAZYCLEARLIST(ui_cache)

/obj/effect/reflection
	name = "reflection"
	appearance_flags = KEEP_TOGETHER|TILE_BOUND|PIXEL_SCALE
	mouse_opacity = 0
	vis_flags = VIS_HIDE
	layer = ABOVE_OBJ_LAYER
	var/alpha_icon = 'icons/obj/watercloset.dmi'
	var/alpha_icon_state = "mirror_mask"
	var/obj/mirror
	desc = "Why are you locked in the bathroom?"
	anchored = TRUE
	unacidable = TRUE

/obj/effect/reflection/proc/setup_visuals(target)
	mirror = target

	if(mirror.pixel_x > 0)
		dir = WEST
	else if (mirror.pixel_x < 0)
		dir = EAST

	if(mirror.pixel_y > 0)
		dir = SOUTH
	else if (mirror.pixel_y < 0)
		dir = NORTH

	pixel_x = mirror.pixel_x
	pixel_y = mirror.pixel_y

	update_mirror_filters()

/obj/effect/reflection/proc/reset_visuals()
	mirror = null
	update_mirror_filters()

/obj/effect/reflection/proc/reset_alpha()
	alpha = initial(alpha)

/obj/effect/reflection/proc/update_mirror_filters()
	filters = null

	vis_contents = null

	if(!mirror)
		return
	var/additional_y_offset = 0
	var/matrix/M = matrix()
	if(dir == WEST || dir == EAST)
		M.Scale(-1, 1)
	else if(dir == SOUTH|| dir == NORTH)
		M.Scale(1, -1)
		//Center of mirror sprite is at 19, meaning we will be some pixels off when pointing down
		additional_y_offset = -5

	transform = M

	filters += filter("type" = "alpha", "icon" = icon(alpha_icon, alpha_icon_state), "x" = 0, "y" = additional_y_offset)

	vis_contents += get_turf(mirror)
