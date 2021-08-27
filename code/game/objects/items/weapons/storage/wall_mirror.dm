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

/obj/item/storage/mirror/Destroy()
	clear_mirror_ui_cache(ui_cache)
	. = ..()

/obj/item/storage/mirror/MouseDrop(obj/over)
	. = ..()
	if (!.)
		return
	flick("mirror_open", src)

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

/obj/item/storage/mirror/bullet_act(obj/item/projectile/P)
	if (prob(P.get_structure_damage() * 2))
		shatter()
	..()

/obj/item/storage/mirror/attackby(obj/item/I, mob/user)
	. = ..()
	if (!.)
		return
	flick("mirror_open", src)
	if (prob(I.force) && user.a_intent == I_HURT)
		user.visible_message(SPAN_WARNING("\The [user] smashes \the [src] with \the [I]!"))
		shatter()


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
