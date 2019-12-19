/obj/item/weapon/gun/launcher/net
	name = "net gun"
	desc = "Specially made-to-order by Xenonomix, the XX-1 \"Varmint Catcher\" is designed to trap even the most unruly of creatures for safe transport."
	icon_state = "netgun"
	item_state = "netgun"
	fire_sound = 'sound/weapons/empty.ogg'
	fire_sound_text = "a metallic thunk"
	var/obj/item/weapon/net_shell/chambered

/obj/item/weapon/net_shell
	name = "net gun shell"
	desc = "A casing containing an autodeploying net for use in a net gun. Kind of looks like a flash light."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "netshell"

/obj/item/weapon/net_shell/attackby(obj/item/weapon/gun/launcher/net/I, mob/user)
	if(istype(I) && I.can_load(src, user))
		I.load(src, user)
		to_chat(usr, "You load \the [src] into \the [I].")
	else
		..()

/obj/item/weapon/gun/launcher/net/examine(mob/user, distance)
	. = ..()
	if(distance <= 2 && chambered)
		to_chat(user, "\A [chambered] is chambered.")

/obj/item/weapon/gun/launcher/net/proc/can_load(var/obj/item/weapon/net_shell/S, var/mob/user)
	if(chambered)
		to_chat(user, SPAN_WARNING("\The [src] already has a shell loaded."))
		return FALSE
	return TRUE

/obj/item/weapon/gun/launcher/net/proc/finish_loading(var/obj/item/weapon/net_shell/S, var/mob/user)
	chambered = S
	if(user) 
		user.visible_message("\The [user] inserts \a [S] into \the [src].", SPAN_NOTICE("You insert \a [S] into \the [src]."))

/obj/item/weapon/gun/launcher/net/proc/load(obj/item/weapon/net_shell/S, mob/user)
	if(!can_load(S, user))
		return
	if(user && !user.unEquip(S, src))
		return
	finish_loading(S, user)

/obj/item/weapon/gun/launcher/net/proc/unload(mob/user)
	if(chambered)
		user.visible_message("\The [user] removes \the [chambered] from \the [src].", "<span class='notice'>You remove \the [chambered] from \the [src].</span>")
		user.put_in_hands(chambered)
		chambered = null
	else
		to_chat(user, "<span class='warning'>\The [src] is empty.</span>")

/obj/item/weapon/gun/launcher/net/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/weapon/net_shell)))
		load(I, user)
	else
		..()

/obj/item/weapon/gun/launcher/net/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		unload(user)
	else
		..()

/obj/item/weapon/gun/launcher/net/consume_next_projectile()
	if(chambered)
		qdel(chambered)
		chambered = null
		return new /obj/item/weapon/energy_net/safari(src)

/obj/item/weapon/gun/launcher/net/borg
	var/list/shells
	var/list/max_shells = 3

/obj/item/weapon/gun/launcher/net/borg/can_load(var/obj/item/weapon/net_shell/S, var/mob/user)
	if(LAZYLEN(shells) >= 3)
		to_chat(user, SPAN_WARNING("\The [src] already has the maximum number of shells loaded."))
		return FALSE
	return TRUE

/obj/item/weapon/gun/launcher/net/borg/proc/update_chambered_shell()
	if(!chambered && LAZYLEN(shells))
		chambered = shells[1]
		LAZYREMOVE(shells, chambered)

/obj/item/weapon/gun/launcher/net/borg/finish_loading(var/obj/item/weapon/net_shell/S, var/mob/user)
	LAZYDISTINCTADD(shells, S)
	update_chambered_shell()

/obj/item/weapon/gun/launcher/net/borg/unload(var/mob/user)
	. = ..()
	update_chambered_shell()

/obj/item/weapon/gun/launcher/net/borg/consume_next_projectile()
	update_chambered_shell()
	. = ..()

/obj/item/weapon/gun/launcher/net/borg/examine(mob/user)
	. = ..()
	to_chat(user, "There are [LAZYLEN(shells)] shell\s loaded.")
