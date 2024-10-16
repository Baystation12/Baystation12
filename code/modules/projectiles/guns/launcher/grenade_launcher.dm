/obj/item/gun/launcher/grenade
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
	combustion = 1

	var/obj/item/grenade/chambered
	var/list/grenades = list()
	var/max_grenades = 5 //holds this + one in the chamber
	var/whitelisted_grenades = list(
		/obj/item/grenade/frag/shell)

	var/blacklisted_grenades = list(
		/obj/item/grenade/flashbang/clusterbang,
		/obj/item/grenade/frag)

	matter = list(MATERIAL_STEEL = 2000)

//revolves the magazine, allowing players to choose between multiple grenade types
/obj/item/gun/launcher/grenade/proc/pump(mob/M as mob)
	playsound(M, 'sound/weapons/guns/interaction/shotgunpump.ogg', 60, 1)

	var/obj/item/grenade/next
	if(length(grenades))
		next = grenades[1] //get this first, so that the chambered grenade can still be removed if the grenades list is empty
	if(chambered)
		grenades += chambered //rotate the revolving magazine
		chambered = null
	if(next)
		grenades -= next //Remove grenade from loaded list.
		chambered = next
		to_chat(M, SPAN_WARNING("You pump [src], loading \a [next] into the chamber."))
	else
		to_chat(M, SPAN_WARNING("You pump [src], but the magazine is empty."))
	update_icon()

/obj/item/gun/launcher/grenade/examine(mob/user, distance)
	. = ..()
	if(distance <= 2)
		var/grenade_count = length(grenades) + (chambered? 1 : 0)
		to_chat(user, "Has [grenade_count] grenade\s remaining.")
		if(chambered)
			to_chat(user, "\A [chambered] is chambered.")

/obj/item/gun/launcher/grenade/proc/load(obj/item/grenade/G, mob/user)
	if(!can_load_grenade_type(G, user))
		return

	if(length(grenades) >= max_grenades)
		to_chat(user, SPAN_WARNING("\The [src] is full."))
		return
	if(!user.unEquip(G, src))
		return
	grenades.Insert(1, G) //add to the head of the list, so that it is loaded on the next pump
	user.visible_message("\The [user] inserts \a [G] into \the [src].", SPAN_NOTICE("You insert \a [G] into \the [src]."))

/obj/item/gun/launcher/grenade/proc/unload(mob/user)
	if(length(grenades))
		var/obj/item/grenade/G = grenades[length(grenades)]
		LIST_DEC(grenades)
		user.put_in_hands(G)
		user.visible_message("\The [user] removes \a [G] from [src].", SPAN_NOTICE("You remove \a [G] from \the [src]."))
	else
		to_chat(user, SPAN_WARNING("\The [src] is empty."))

/obj/item/gun/launcher/grenade/attack_self(mob/user)
	pump(user)


/obj/item/gun/launcher/grenade/use_tool(obj/item/tool, mob/user, list/click_params)
	// Grenade - Load ammo
	if (istype(tool, /obj/item/grenade))
		load(tool, user)
		return TRUE

	return ..()


/obj/item/gun/launcher/grenade/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		unload(user)
	else
		..()

/obj/item/gun/launcher/grenade/consume_next_projectile()
	if(chambered)
		chambered.det_time = 10
		chambered.activate(null)
	return chambered

/obj/item/gun/launcher/grenade/handle_post_fire(mob/user)
	log_and_message_admins("fired a grenade ([chambered.name]) from a grenade launcher.", user)

	chambered = null
	..()

/obj/item/gun/launcher/grenade/proc/can_load_grenade_type(obj/item/grenade/G, mob/user)
	if(is_type_in_list(G, blacklisted_grenades) && ! is_type_in_list(G, whitelisted_grenades))
		to_chat(user, SPAN_WARNING("\The [G] doesn't seem to fit in \the [src]!"))
		return FALSE
	return TRUE

// For uplink purchase, comes loaded with a random assortment of grenades
/obj/item/gun/launcher/grenade/loaded/Initialize()
	. = ..()

	var/list/grenade_types = list(
		/obj/item/grenade/anti_photon = 2,
		/obj/item/grenade/smokebomb = 2,
		/obj/item/grenade/chem_grenade/teargas = 2,
		/obj/item/grenade/flashbang = 3,
		/obj/item/grenade/empgrenade = 3,
		/obj/item/grenade/frag/shell = 1,
		)

	var/grenade_type = pickweight(grenade_types)
	chambered = new grenade_type(src)
	for(var/i in 1 to max_grenades)
		grenade_type = pickweight(grenade_types)
		grenades += new grenade_type(src)

//Underslung grenade launcher to be used with the Z8
/obj/item/gun/launcher/grenade/underslung
	name = "underslung grenade launcher"
	desc = "Not much more than a tube and a firing mechanism, this grenade launcher is designed to be fitted to a rifle."
	w_class = ITEM_SIZE_NORMAL
	force = 5
	max_grenades = 0

/obj/item/gun/launcher/grenade/underslung/attack_self()
	return

//load and unload directly into chambered
/obj/item/gun/launcher/grenade/underslung/load(obj/item/grenade/G, mob/user)
	if(!can_load_grenade_type(G, user))
		return

	if(chambered)
		to_chat(user, SPAN_WARNING("\The [src] is already loaded."))
		return
	if(!user.unEquip(G, src))
		return
	chambered = G
	user.visible_message("\The [user] load \a [G] into \the [src].", SPAN_NOTICE("You load \a [G] into \the [src]."))

/obj/item/gun/launcher/grenade/underslung/unload(mob/user)
	if(chambered)
		user.put_in_hands(chambered)
		user.visible_message("\The [user] removes \a [chambered] from \the[src].", SPAN_NOTICE("You remove \a [chambered] from \the [src]."))
		chambered = null
	else
		to_chat(user, SPAN_WARNING("\The [src] is empty."))


/obj/item/gun/launcher/grenade/foam/Initialize()
	. = ..()

	chambered = new /obj/item/grenade/chem_grenade/metalfoam(src)
	for (var/i in 1 to max_grenades)
		grenades += new /obj/item/grenade/chem_grenade/metalfoam(src)
