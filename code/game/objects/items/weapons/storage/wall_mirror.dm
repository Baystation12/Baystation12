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

/obj/item/weapon/storage/mirror/MouseDrop(obj/over_object as obj)
	if(!(. = ..()))
		return
	flick("mirror_open",src)

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

/obj/item/weapon/storage/mirror/bullet_act(var/obj/item/projectile/Proj)

	if(prob(Proj.get_structure_damage() * 2))
		if(!shattered)
			shatter()
		else
			playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
	..()

/obj/item/weapon/storage/mirror/attackby(obj/item/W as obj, mob/user as mob)
	if(!(. = ..()))
		return
	flick("mirror_open",src)
	if(prob(W.force) && (user.a_intent == I_HURT))
		visible_message("<span class='warning'>[user] smashes [src] with \the [W]!</span>")
		if(!shattered)
			shatter()

/obj/item/weapon/storage/mirror/attack_generic(var/mob/user, var/damage)
	attack_animation(user)
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return 0

	if(damage)
		user.visible_message("<span class='danger'>[user] smashes [src]!</span>")
		shatter()
	else
		user.visible_message("<span class='danger'>[user] hits [src] and bounces off!</span>")
	return 1

/obj/item/weapon/storage/mirror/Destroy()
	clear_ui_users(ui_users)
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
