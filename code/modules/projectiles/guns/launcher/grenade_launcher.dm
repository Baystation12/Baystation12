/obj/item/weapon/gun/launcher/grenade
	name = "grenade launcher"
	desc = "A bulky pump-action grenade launcher. Holds up to 6 grenades in a revolving magazine."
	icon_state = "riotgun"
	item_state = "riotgun"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)
	w_class = ITEM_SIZE_HUGE
	force = 10

	fire_sound = 'sound/weapons/empty.ogg'
	fire_sound_text = "a metallic thunk"
	screen_shake = 0
	throw_distance = 7
	release_force = 5

	var/obj/item/weapon/grenade/chambered
	var/list/grenades = new/list()
	var/max_grenades = 5 //holds this + one in the chamber
	var/whitelisted_grenades = list(
		/obj/item/weapon/grenade/frag/shell)

	var/blacklisted_grenades = list(
		/obj/item/weapon/grenade/flashbang/clusterbang,
		/obj/item/weapon/grenade/frag)

	matter = list(DEFAULT_WALL_MATERIAL = 2000)

//revolves the magazine, allowing players to choose between multiple grenade types
/obj/item/weapon/gun/launcher/grenade/proc/pump(mob/M as mob)
	playsound(M, 'sound/weapons/shotgunpump.ogg', 60, 1)

	var/obj/item/weapon/grenade/next
	if(grenades.len)
		next = grenades[1] //get this first, so that the chambered grenade can still be removed if the grenades list is empty
	if(chambered)
		grenades += chambered //rotate the revolving magazine
		chambered = null
	if(next)
		grenades -= next //Remove grenade from loaded list.
		chambered = next
		to_chat(M, "<span class='warning'>You pump [src], loading \a [next] into the chamber.</span>")
	else
		to_chat(M, "<span class='warning'>You pump [src], but the magazine is empty.</span>")
	update_icon()

/obj/item/weapon/gun/launcher/grenade/examine(mob/user)
	if(..(user, 2))
		var/grenade_count = grenades.len + (chambered? 1 : 0)
		to_chat(user, "Has [grenade_count] grenade\s remaining.")
		if(chambered)
			to_chat(user, "\A [chambered] is chambered.")

/obj/item/weapon/gun/launcher/grenade/proc/load(obj/item/weapon/grenade/G, mob/user)
	if(!can_load_grenade_type(G, user))
		return

	if(grenades.len >= max_grenades)
		to_chat(user, "<span class='warning'>\The [src] is full.</span>")
		return
	user.drop_from_inventory(G, src)
	grenades.Insert(1, G) //add to the head of the list, so that it is loaded on the next pump
	user.visible_message("\The [user] inserts \a [G] into \the [src].", "<span class='notice'>You insert \a [G] into \the [src].</span>")

/obj/item/weapon/gun/launcher/grenade/proc/unload(mob/user)
	if(grenades.len)
		var/obj/item/weapon/grenade/G = grenades[grenades.len]
		grenades.len--
		user.put_in_hands(G)
		user.visible_message("\The [user] removes \a [G] from [src].", "<span class='notice'>You remove \a [G] from \the [src].</span>")
	else
		to_chat(user, "<span class='warning'>\The [src] is empty.</span>")

/obj/item/weapon/gun/launcher/grenade/attack_self(mob/user)
	pump(user)

/obj/item/weapon/gun/launcher/grenade/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/weapon/grenade)))
		load(I, user)
	else
		..()

/obj/item/weapon/gun/launcher/grenade/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		unload(user)
	else
		..()

/obj/item/weapon/gun/launcher/grenade/consume_next_projectile()
	if(chambered)
		chambered.det_time = 10
		chambered.activate(null)
	return chambered

/obj/item/weapon/gun/launcher/grenade/handle_post_fire(mob/user)
	message_admins("[key_name_admin(user)] fired a grenade ([chambered.name]) from a grenade launcher ([src.name]).")
	log_game("[key_name_admin(user)] used a grenade ([chambered.name]).")
	chambered = null
	..()

/obj/item/weapon/gun/launcher/grenade/proc/can_load_grenade_type(obj/item/weapon/grenade/G, mob/user)
	if(is_type_in_list(G, blacklisted_grenades) && ! is_type_in_list(G, whitelisted_grenades))
		to_chat(user, "<span class='warning'>\The [G] doesn't seem to fit in \the [src]!</span>")
		return FALSE
	return TRUE

// For uplink purchase, comes loaded with a random assortment of grenades
/obj/item/weapon/gun/launcher/grenade/loaded/New()
	..()

	var/list/grenade_types = list(
		/obj/item/weapon/grenade/anti_photon = 2,
		/obj/item/weapon/grenade/smokebomb = 2,
		/obj/item/weapon/grenade/chem_grenade/teargas = 2,
		/obj/item/weapon/grenade/flashbang = 3,
		/obj/item/weapon/grenade/empgrenade = 3,
		/obj/item/weapon/grenade/frag/shell = 1,
		)

	var/grenade_type = pickweight(grenade_types)
	chambered = new grenade_type(src)
	for(var/i in 1 to max_grenades)
		grenade_type = pickweight(grenade_types)
		grenades += new grenade_type(src)

//Underslung grenade launcher to be used with the Z8
/obj/item/weapon/gun/launcher/grenade/underslung
	name = "underslung grenade launcher"
	desc = "Not much more than a tube and a firing mechanism, this grenade launcher is designed to be fitted to a rifle."
	w_class = ITEM_SIZE_NORMAL
	force = 5
	max_grenades = 0

/obj/item/weapon/gun/launcher/grenade/underslung/attack_self()
	return

//load and unload directly into chambered
/obj/item/weapon/gun/launcher/grenade/underslung/load(obj/item/weapon/grenade/G, mob/user)
	if(!can_load_grenade_type(G, user))
		return

	if(chambered)
		to_chat(user, "<span class='warning'>\The [src] is already loaded.</span>")
		return
	user.drop_from_inventory(G, src)
	chambered = G
	user.visible_message("\The [user] load \a [G] into \the [src].", "<span class='notice'>You load \a [G] into \the [src].</span>")

/obj/item/weapon/gun/launcher/grenade/underslung/unload(mob/user)
	if(chambered)
		user.put_in_hands(chambered)
		user.visible_message("\The [user] removes \a [chambered] from \the[src].", "<span class='notice'>You remove \a [chambered] from \the [src].</span>")
		chambered = null
	else
		to_chat(user, "<span class='warning'>\The [src] is empty.</span>")
