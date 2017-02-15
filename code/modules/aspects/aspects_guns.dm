/decl/aspect/person_of_caliber
	name = ASPECT_BASICGUNS
	desc = "You know your way around the use and maintenance of a firearm."
	use_icon_state = "guns_1"
	category = "Ranged Combat"
	aspect_cost = 1

/decl/aspect/gunplay
	name = ASPECT_GUNPLAY
	desc = "Fastest gun on Mars."
	use_icon_state = "guns_2"
	category = "Ranged Combat"
	parent_name = ASPECT_BASICGUNS
	aspect_cost = 3
	var/has_holster = TRUE
	var/list/gun_types = list(
		/obj/item/weapon/gun/projectile/colt,
		/obj/item/weapon/gun/projectile/pistol
		)

/decl/aspect/gunplay/do_post_spawn(var/mob/living/carbon/human/holder)
	if(!istype(holder))
		return
	// Already have a gun.
	if(locate(/obj/item/weapon/gun) in holder.contents)
		return
	var/gun_type = pick(gun_types)
	var/obj/item/gun = new gun_type(holder)
	if(has_holster && !(locate(/obj/item/clothing/accessory/holster) in holder.w_uniform))
		var/obj/item/clothing/accessory/holster/W = new (holder)
		holder.w_uniform.attackby(W, holder)
		W.holster(gun, holder)
		if(W.loc != holder.w_uniform)
			W.forceMove(get_turf(holder))
			holder.put_in_hands(W)
	if(!istype(gun.loc, /obj/item/clothing/accessory/holster))
		gun.forceMove(get_turf(holder))
		holder.put_in_hands(gun)
	..()

/decl/aspect/taser
	name = ASPECT_TASER
	desc = "You have invested in a small taser."
	use_icon_state = "guns_1"
	category = "Ranged Combat"
	aspect_cost = 2

/decl/aspect/taser/do_post_spawn(var/mob/living/carbon/human/holder)
	if(istype(holder) && !(locate(/obj/item/weapon/gun/energy/taser) in holder.contents))
		holder.put_in_hands(new /obj/item/weapon/gun/energy/taser(get_turf(holder)))
	..()

/decl/aspect/gunsmith
	name = ASPECT_GUNSMITH
	desc = "The inner workings of firearms of all types are no mystery to you."
	parent_name = ASPECT_BASICGUNS
	use_icon_state = "guns_3"
	category = "Ranged Combat"
	aspect_cost = 1

/decl/aspect/marksman
	name = ASPECT_MARKSMAN
	desc = "Steady hand, steady eye."
	parent_name = ASPECT_BASICGUNS
	use_icon_state = "guns_3"
	category = "Ranged Combat"
	aspect_cost = 1

/decl/aspect/guns_akimbo
	name = ASPECT_DUALWIELD
	desc = "Two-handing is for nerds and children."
	parent_name = ASPECT_BASICGUNS
	use_icon_state = "guns_3"
	category = "Ranged Combat"
	aspect_cost = 1
