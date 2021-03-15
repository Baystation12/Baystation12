//wip wip wup
/obj/item/weapon/storage/mirror
	name = "mirror"
	desc = "A SalonPro Nano-Mirror(TM) mirror! The leading brand in hair salon products, utilizing nano-machinery to style your hair just right. The black box inside warns against attempting to release the nanomachines."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror"
	density = 0
	anchored = 1
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_LARGEBOX_STORAGE
	use_sound = 'sound/effects/closet_open.ogg'
	var/shattered = 0
	var/list/ui_users

	startswith = list(
		/obj/item/weapon/haircomb/random,
		/obj/item/weapon/haircomb/brush,
		/obj/random/medical/lite,
		/obj/item/weapon/lipstick/random,
		/obj/random/soap,
		/obj/item/weapon/reagent_containers/spray/cleaner/deodorant,
		/obj/item/weapon/towel/random)

	/// Visual object for handling the viscontents
	var/weakref/ref
	vis_flags = VIS_HIDE
	var/timerid = null

/obj/item/weapon/storage/mirror/Initialize()
	. = ..()
	var/obj/effect/reflection/reflection = new(src.loc)
	reflection.setup_visuals(src)
	ref = weakref(reflection)

/obj/item/weapon/storage/mirror/moved(mob/user, old_loc)
	. = ..()
	var/obj/effect/reflection/reflection = ref.resolve()
	if(istype(reflection))
		reflection.forceMove(loc)
		reflection.update_mirror_filters() //Mirrors shouldnt move but if they do so should reflection

/obj/item/weapon/storage/mirror/proc/on_flick() //Have to hide the effect
	var/obj/effect/reflection/reflection = ref.resolve()
	if(istype(reflection))
		reflection.alpha = 0
		if(timerid)
			deltimer(timerid)
			timerid = null
		timerid = addtimer(CALLBACK(reflection, /obj/effect/reflection/.proc/reset_alpha), 15, TIMER_CLIENT_TIME)

/obj/item/weapon/storage/mirror/MouseDrop(obj/over_object as obj)
	if(!(. = ..()))
		return
	
	flick("mirror_open",src)
	on_flick()

/obj/item/weapon/storage/mirror/attack_hand(var/mob/living/carbon/human/user)
	use_mirror(user)

/obj/item/weapon/storage/mirror/proc/use_mirror(var/mob/living/carbon/human/user)
	if(shattered)
		to_chat(user, "<spawn class='notice'>You enter the key combination for the style you want on the panel, but the nanomachines inside \the [src] refuse to come out.")
		return
	open_mirror_ui(user, ui_users, "SalonPro Nano-Mirror&trade;", mirror = src)

/obj/item/weapon/storage/mirror/proc/shatter()
	if(shattered)	return
	shattered = 1
	icon_state = "mirror_broke"
	playsound(src, "shatter", 70, 1)
	desc = "Oh no, seven years of bad luck!"

	var/obj/effect/reflection/reflection = ref.resolve()
	if(istype(reflection))
		reflection.alpha_icon_state = "mirror_mask_broken"
		reflection.update_mirror_filters()


/obj/item/weapon/storage/mirror/bullet_act(var/obj/item/projectile/Proj)

	if(prob(Proj.get_structure_damage() * 2))
		if(!shattered)
			shatter()
		else
			playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
	..()

/obj/item/weapon/storage/mirror/attackby(obj/item/W as obj, mob/user as mob)
	if(prob(W.force) && (user.a_intent == I_HURT))
		visible_message("<span class='warning'>[user] smashes [src] with \the [W]!</span>")
		if(!shattered)
			shatter()
		return
	if(!(. = ..()))
		return
	flick("mirror_open",src)
	on_flick()

/obj/item/weapon/storage/mirror/Destroy()
	clear_ui_users(ui_users)
	var/obj/effect/reflection/reflection = ref.resolve()
	if(istype(reflection))
		QDEL_NULL(reflection)
	. = ..()

/obj/item/weapon/mirror
	name = "mirror"
	desc = "A SalonPro Nano-Mirror(TM) brand mirror! Now a portable version."
	icon = 'icons/obj/items.dmi'
	icon_state = "mirror"
	var/list/ui_users

/obj/item/weapon/mirror/attack_self(mob/user as mob)
	open_mirror_ui(user, ui_users, "SalonPro Nano-Mirror&trade;", APPEARANCE_HAIR, src)

/obj/item/weapon/mirror/Destroy()
	clear_ui_users(ui_users)
	. = ..()

/proc/open_mirror_ui(var/mob/user, var/ui_users, var/title, var/flags, var/obj/item/mirror)
	if(!ishuman(user))
		return

	var/W = weakref(user)
	var/datum/nano_module/appearance_changer/AC = LAZYACCESS(ui_users, W)
	if(!AC)
		AC = new(mirror, user)
		AC.name = title
		if(flags)
			AC.flags = flags
		LAZYSET(ui_users, W, AC)
	AC.ui_interact(user)

/proc/clear_ui_users(var/list/ui_users)
	for(var/W in ui_users)
		var/AC = ui_users[W]
		qdel(AC)
	LAZYCLEARLIST(ui_users)

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

	var/matrix/M = matrix()
	if(dir == WEST || dir == EAST)
		M.Scale(-1, 1)
	else if(dir == SOUTH|| dir == NORTH)
		M.Scale(1, -1)

	transform = M

	filters += filter("type" = "alpha", "icon" = icon(alpha_icon, alpha_icon_state), "x" = 0, "y" = 0)

	vis_contents += get_turf(mirror)