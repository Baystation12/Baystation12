/obj/item/weapon/gun/magic
	name = "staff of nothing"
	desc = "This staff is boring to watch because even though it came first you've seen everything it can do in other staves for years."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "staff"
	item_state = "staff"
	fire_sound = 'sound/weapons/emitter.ogg'
	flags =  CONDUCT
	w_class = 5
	var/max_charges = 6
	var/charges = 0
	var/recharge_rate = 4
	var/charge_tick = 0
	var/can_charge = 1
	var/ammo_type = /obj/item/ammo_casing/magic
	origin_tech = null
	clumsy_check = 0

/obj/item/weapon/gun/magic/afterattack(atom/target as mob, mob/living/user as mob, flag)
	newshot()
	var/area/A = get_area(user)
	if(user.mind.special_role != "Wizard")
		user << "<span class='warning'>You have no idea how to use [src].<span>"
		return
	if(istype(A, /area/wizard_station))
		user << "<span class='warning'>You know better than to violate the security of The Den, best wait until you leave to use [src].<span>"
		return
	..()

/obj/item/weapon/gun/magic/proc/newshot()
	if (charges && chambered)
		chambered.newshot()
		charges--
	return

/obj/item/weapon/gun/magic/New()
	..()
	charges = max_charges
	chambered = new ammo_type(src)
	if(can_charge)	processing_objects.Add(src)


/obj/item/weapon/gun/magic/Del()
	if(can_charge)	processing_objects.Remove(src)
	..()


/obj/item/weapon/gun/magic/process()
	charge_tick++
	if(charge_tick < recharge_rate || charges >= max_charges) return 0
	charge_tick = 0
	charges++
	return 1

/obj/item/weapon/gun/magic/update_icon()
	return

/obj/item/weapon/gun/magic/shoot_with_empty_chamber(mob/living/user as mob|obj)
	user << "<span class='warning'>The [name] whizzles quietly.<span>"
	return