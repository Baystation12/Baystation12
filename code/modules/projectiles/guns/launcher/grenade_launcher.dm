/obj/item/weapon/gun/launcher/grenade
	name = "grenade launcher"
	desc = "A bulky pump-action grenade launcher. Holds up to 5 grenades in a revolving magazine."
	icon = 'icons/obj/gun.dmi'
	icon_state = "riotgun"
	item_state = "riotgun"
	w_class = 4
	force = 10

	fire_sound = 'sound/weapons/empty.ogg'
	fire_sound_text = "a metallic thunk"
	recoil = 0
	throw_distance = 7
	release_force = 5

	var/obj/item/weapon/grenade/chambered
	var/list/grenades = new/list()
	var/max_grenades = 4 //holds this + one in the chamber
	matter = list("metal" = 2000)

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
		M << "<span class='warning'>You pump [src], loading \a [next] into the chamber.</span>"
	else
		M << "<span class='warning'>You pump [src], but the magazine is empty.</span>"
	update_icon()

/obj/item/weapon/gun/launcher/grenade/examine(mob/user)
	if(..(user, 2))
		var/grenade_count = grenades.len + (chambered? 1 : 0)
		user << "Has [grenade_count] grenade\s remaining."
		if(chambered)
			user << "\A [chambered] is chambered."

/obj/item/weapon/gun/launcher/grenade/attack_self(mob/user)
	pump(user)

/obj/item/weapon/gun/launcher/grenade/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/weapon/grenade)))
		if(grenades.len >= max_grenades)
			user << "<span class='warning'>[src] is full.</span>"
			return
		user.remove_from_mob(I)
		I.loc = src
		grenades.Insert(1, I) //add to the head of the list, so that it is loaded on the next pump
		user.visible_message("[user] inserts \a [I] into [src].", "<span class='notice'>You insert \a [I] into [src].</span>")
	else
		..()

/obj/item/weapon/gun/launcher/grenade/attack_hand(mob/user)
	if(loc == user)
		if(grenades.len)
			var/obj/item/weapon/grenade/G = grenades[grenades.len]
			grenades.len--
			user.put_in_hands(G)
			user.visible_message("[user] removes \a [G] from [src].", "<span class='notice'>You remove \a [G] from [src].</span>")
		else
			user << "<span class='warning'>[src] is empty.</span>"
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
