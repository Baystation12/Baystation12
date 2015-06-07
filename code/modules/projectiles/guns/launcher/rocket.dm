/obj/item/weapon/gun/launcher/rocket
	name = "rocket launcher"
	desc = "MAGGOT."
	icon_state = "rocket"
	item_state = "rocket"
	w_class = 4.0
	throw_speed = 2
	throw_range = 10
	force = 5.0
	flags =  CONDUCT
	slot_flags = 0
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 5)
	fire_sound = 'sound/effects/bang.ogg'
	
	release_force = 15
	throw_distance = 30
	var/max_rockets = 1
	var/list/rockets = new/list()

/obj/item/weapon/gun/launcher/rocket/examine(mob/user)
	if(!..(user, 2))
		return
	user << "\blue [rockets.len] / [max_rockets] rockets."

/obj/item/weapon/gun/launcher/rocket/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/ammo_casing/rocket))
		if(rockets.len < max_rockets)
			user.drop_item()
			I.loc = src
			rockets += I
			user << "\blue You put the rocket in [src]."
			user << "\blue [rockets.len] / [max_rockets] rockets."
		else
			usr << "\red [src] cannot hold more rockets."

/obj/item/weapon/gun/launcher/rocket/consume_next_projectile()
	if(rockets.len)
		var/obj/item/ammo_casing/rocket/I = rockets[1]
		var/obj/item/missile/M = new (src)
		M.primed = 1
		rockets -= I
		return M
	return null

/obj/item/weapon/gun/launcher/rocket/handle_post_fire(mob/user, atom/target)
	message_admins("[key_name_admin(user)] fired a rocket from a rocket launcher ([src.name]) at [target].")
	log_game("[key_name_admin(user)] used a rocket launcher ([src.name]) at [target].")
	..()
