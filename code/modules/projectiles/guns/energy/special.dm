/obj/item/weapon/gun/energy/ionrifle
	name = "ion rifle"
	desc = "A man portable anti-armor weapon designed to disable mechanical threats"
	icon_state = "ionrifle"
	fire_sound = 'Laser.ogg'
	origin_tech = "combat=2;magnets=4"
	w_class = 4.0
	flags =  FPRINT | TABLEPASS | CONDUCT | USEDELAY | ONBACK
	charge_cost = 100
	projectile_type = "/obj/item/projectile/ion"



/obj/item/weapon/gun/energy/decloner
	name = "biological demolecularisor"
	desc = "A gun that discharges high amounts of controlled radiation to slowly break a target into component elements."
	icon_state = "decloner"
	fire_sound = 'pulse3.ogg'
	origin_tech = "combat=5;materials=4;powerstorage=3"
	charge_cost = 100
	projectile_type = "/obj/item/projectile/energy/declone"

obj/item/weapon/gun/energy/staff
	name = "staff of change"
	desc = "an artefact that spits bolts of coruscating energy which cause the target's very form to reshape itself"
	icon = 'gun.dmi'
	icon_state = "staffofchange"
	item_state = "staffofchange"
	fire_sound = 'emitter.ogg'
	flags =  FPRINT | TABLEPASS | CONDUCT | USEDELAY | ONBACK
	w_class = 4.0
	charge_cost = 200
	projectile_type = "/obj/item/projectile/change"
	origin_tech = null
	var/charge_tick = 0


	New()
		..()
		processing_objects.Add(src)


	Del()
		processing_objects.Remove(src)
		..()


	process()
		charge_tick++
		if(charge_tick < 4) return 0
		charge_tick = 0
		if(!power_supply) return 0
		power_supply.give(200)
		update_icon()
		return 1