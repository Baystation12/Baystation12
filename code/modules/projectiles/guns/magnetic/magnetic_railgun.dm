/obj/item/weapon/gun/magnetic/railgun
	name = "railgun"
	desc = "The Mars Military Industries MI-76 Thunderclap. A man-portable mass driver for squad support anti-armour and destruction of fortifications and emplacements."
	gun_unreliable = 0
	icon_state = "railgun"
	removable_components = FALSE
	load_type = /obj/item/weapon/rcd_ammo
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4, TECH_MAGNET = 4)
	projectile_type = /obj/item/projectile/bullet/magnetic/slug
	power_cost = 300
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BELT

	var/initial_cell_type = /obj/item/weapon/cell/hyper
	var/initial_capacitor_type = /obj/item/weapon/stock_parts/capacitor/adv
	var/slowdown_held = 2
	var/slowdown_worn = 1

/obj/item/weapon/gun/magnetic/railgun/initialize()

	capacitor = new initial_capacitor_type(src)
	capacitor.charge = capacitor.max_charge

	cell = new initial_cell_type(src)
	loaded = new /obj/item/weapon/rcd_ammo/large(src)

	slowdown_per_slot[slot_l_hand] =  slowdown_held
	slowdown_per_slot[slot_r_hand] =  slowdown_held
	slowdown_per_slot[slot_back] =    slowdown_worn
	slowdown_per_slot[slot_belt] =    slowdown_worn
	slowdown_per_slot[slot_s_store] = slowdown_worn

	..()

// Not going to check type repeatedly, if you code or varedit
// load_type and get runtime errors, don't come crying to me.
/obj/item/weapon/gun/magnetic/railgun/show_ammo(var/mob/user)
	var/obj/item/weapon/rcd_ammo/ammo = loaded
	to_chat(user, "<span class='notice'>There are [ammo.remaining] shot\s remaining in \the [loaded].</span>")

/obj/item/weapon/gun/magnetic/railgun/check_ammo()
	var/obj/item/weapon/rcd_ammo/ammo = loaded
	return ammo && ammo.remaining

/obj/item/weapon/gun/magnetic/railgun/use_ammo()
	var/obj/item/weapon/rcd_ammo/ammo = loaded
	ammo.remaining--
	if(ammo.remaining <= 0)
		qdel(loaded)
		loaded = null
		spawn(3)
			playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
			loc.visible_message("<span class='warning'>\The [src] beeps and ejects its empty cartridge.</span>")

/obj/item/weapon/gun/magnetic/railgun/automatic // Adminspawn only, this shit is absurd.
	name = "\improper RHR accelerator"
	desc = "The Mars Military Industries MI-227 Meteor. Originally a vehicle-mounted turret weapon for heavy anti-vehicular and anti-structural fire, the fact that it was made man-portable is mindboggling in itself."
	icon_state = "heavy_railgun"

	initial_cell_type = /obj/item/weapon/cell/infinite
	initial_capacitor_type = /obj/item/weapon/stock_parts/capacitor/super

	slowdown_held = 3
	slowdown_worn = 2

	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_NO_CONTAINER

	firemodes = list(
		list(mode_name="semiauto",    burst=1, fire_delay=0,    move_delay=null, requires_two_hands=1, burst_accuracy=null, dispersion=null),
		list(mode_name="short bursts", burst=3, fire_delay=null, move_delay=5,    requires_two_hands=2, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="long bursts",  burst=6, fire_delay=null, move_delay=10,    requires_two_hands=2, burst_accuracy=list(0,-1,-1,-1,-2), dispersion=list(0.6, 0.6, 1.0, 1.0, 1.2)),
		)

/obj/item/weapon/gun/magnetic/railgun/automatic/examine(var/mob/user)
	. = ..(user,1)
	if(.)
		to_chat(user, "<span class='notice'>Someone has scratched <i>Ultima Ratio Regum</i> onto the side of the barrel.</span>")

