/obj/item/weapon/gun/magnetic/railgun
	name = "railgun"
	desc = "The HelTek Arms LM-76 Thunderclap. A portable linear motor cannon produced during the Gaia Conflict for anti-armour and anti-fortification operations. Today, it sees wide use among private militaries, and is a staple on the black market."
	gun_unreliable = 1 // 1% chance to explode >:D
	icon_state = "railgun"
	removable_components = TRUE // Can swap out the capacitor for more shots, or cell for longer usage before recharge
	load_type = /obj/item/weapon/rcd_ammo
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4, TECH_MAGNET = 4)
	projectile_type = /obj/item/projectile/bullet/magnetic/slug
	power_cost = 300
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BELT
	loaded = /obj/item/weapon/rcd_ammo/large // ~30 shots

	var/initial_cell_type = /obj/item/weapon/cell/hyper
	var/initial_capacitor_type = /obj/item/weapon/stock_parts/capacitor/adv // 6-8 shots
	var/slowdown_held = 2
	var/slowdown_worn = 1

/obj/item/weapon/gun/magnetic/railgun/Initialize()

	capacitor = new initial_capacitor_type(src)
	capacitor.charge = capacitor.max_charge

	cell = new initial_cell_type(src)
	if (ispath(loaded))
		if(load_sheet_max > 1)
			loaded = new loaded(src,load_sheet_max)
		loaded = new loaded
	slowdown_per_slot[slot_l_hand] =  slowdown_held
	slowdown_per_slot[slot_r_hand] =  slowdown_held
	slowdown_per_slot[slot_back] =    slowdown_worn
	slowdown_per_slot[slot_belt] =    slowdown_worn
	slowdown_per_slot[slot_s_store] = slowdown_worn

	. = ..()

// Not going to check type repeatedly, if you code or varedit
// load_type and get runtime errors, don't come crying to me.
/obj/item/weapon/gun/magnetic/railgun/show_ammo(var/mob/user)
	var/obj/item/weapon/rcd_ammo/ammo = loaded
	if (ammo)
		to_chat(user, "<span class='notice'>There are [ammo.remaining] shot\s remaining in \the [loaded].</span>")
	else
		to_chat(user, "<span class='notice'>There is nothing loaded.</span>")

/obj/item/weapon/gun/magnetic/railgun/check_ammo()
	var/obj/item/weapon/rcd_ammo/ammo = loaded
	return ammo && ammo.remaining

/obj/item/weapon/gun/magnetic/railgun/use_ammo()
	var/obj/item/weapon/rcd_ammo/ammo = loaded
	ammo.remaining--
	if(ammo.remaining <= 0)
		spawn(3)
			playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
		out_of_ammo()

/obj/item/weapon/gun/magnetic/railgun/proc/out_of_ammo()
	qdel(loaded)
	loaded = null
	visible_message("<span class='warning'>\The [src] beeps and ejects its empty cartridge.</span>")

/obj/item/weapon/gun/magnetic/railgun/tcc // Oppa! Should only be available to TCC shock troops or high-budget mercs.
	name = "advanced railgun"
	desc = "The HelTek Arms HR-22 Hammerhead. A man-portable helical rail cannon; favorite weapon of Terran shock troops and anti-tank personnel."
	icon_state = "railgun-tcc"
	removable_components = TRUE // Railgunners are expected to be able to completely disassemble and reassemble their weapons in the field. But we don't have that mechanic, so the cell and capacitor will do.
	gun_unreliable = 0 // Quality engineering, and not 15 years old

	initial_cell_type = /obj/item/weapon/cell/hyper // Standard power
	initial_capacitor_type = /obj/item/weapon/stock_parts/capacitor/adv // 6-8 shots
	power_cost = 280 // Same number of shots, but it'll seem to recharge slightly faster

	loaded = /obj/item/stack/rods
	load_type = /obj/item/stack/rods // The Confederation learned that chunks of metal work just as well as fancy matter cartridges
	load_sheet_max = 10 // Fewer shots per "magazine", but more abundant than matter cartridges.
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 3, TECH_MAGNET = 5)
	slowdown_worn = 2 // Little slower when worn

/obj/item/weapon/gun/magnetic/railgun/tcc/show_ammo(var/mob/user)
	var/obj/item/stack/rods/ammo = loaded
	if(istype(ammo))
		to_chat(user, "<span class='notice'>It has [ammo.amount] shots loaded.</span>")

/obj/item/weapon/gun/magnetic/railgun/tcc/check_ammo()
	var/obj/item/stack/rods/ammo = loaded
	return ammo && ammo.amount

/obj/item/weapon/gun/magnetic/railgun/tcc/out_of_ammo()
	qdel(loaded)
	loaded = null
	spawn(3)
		playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
	visible_message("<span class='warning'>\The [src] beeps, before clanging as the ammunition bank resets.</span>")

/obj/item/weapon/gun/magnetic/railgun/tcc/use_ammo()
	var/obj/item/stack/rods/ammo = loaded
	ammo.use(1)
	if(!istype(ammo))
		out_of_ammo()

/obj/item/weapon/gun/magnetic/railgun/automatic // Adminspawn only, this shit is absurd.
	name = "LMRA autocannon"
	desc = "The HelTek Arms LMRA-14A Meteor. Originally a vehicle-mounted turret weapon used by the Confederation in the Gaia Conflict for anti-vehicular operations, the fact that it was made man-portable is mindboggling in itself."
	icon_state = "heavy_railgun"
	removable_components = FALSE // Absolutely not. This has an infinity cell.
	gun_unreliable = 0 // If it wasn't OP enough.

	initial_cell_type = /obj/item/weapon/cell/infinite
	initial_capacitor_type = /obj/item/weapon/stock_parts/capacitor/super

	slowdown_held = 3
	slowdown_worn = 2

	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_NO_CONTAINER

	firemodes = list(
		list(mode_name="semiauto",    burst=1, fire_delay=0,    move_delay=null, one_hand_penalty=1, burst_accuracy=null, dispersion=null),
		list(mode_name="short bursts", burst=3, fire_delay=null, move_delay=5,    one_hand_penalty=2, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="long bursts",  burst=6, fire_delay=null, move_delay=10,    one_hand_penalty=2, burst_accuracy=list(0,-1,-1,-1,-2), dispersion=list(0.6, 0.6, 1.0, 1.0, 1.2)),
		)

/obj/item/weapon/gun/magnetic/railgun/automatic/examine(var/mob/user)
	. = ..(user,1)
	if(.)
		to_chat(user, "<span class='notice'>Someone has scratched <i>Ultima Ratio Regum</i> onto the side of the barrel.</span>")

/obj/item/weapon/gun/magnetic/railgun/flechette
	name = "flechette gun"
	desc = "The MI-12 Skadi is a burst fire capable railgun that fires flechette rounds at high velocity. Deadly against armour, but much less effective against soft targets."
	icon_state = "flechette_gun"
	item_state = "z8carbine"
	removable_components = FALSE
	gun_unreliable = 0 // High-tech, quality engineering. This is some good shit. Shame it isn't Terran.
	initial_cell_type = /obj/item/weapon/cell/hyper
	initial_capacitor_type = /obj/item/weapon/stock_parts/capacitor/adv
	slot_flags = SLOT_BACK
	slowdown_held = 0
	slowdown_worn = 0
	power_cost = 100
	load_type = /obj/item/weapon/magnetic_ammo
	projectile_type = /obj/item/projectile/bullet/magnetic/flechette
	loaded = /obj/item/weapon/magnetic_ammo
	wielded_item_state = "z8carbine-wielded"

	firemodes = list(
		list(mode_name="semiauto",    burst=1, fire_delay=0,    move_delay=null, one_hand_penalty=1, burst_accuracy=null, dispersion=null),
		list(mode_name="short bursts", burst=3, fire_delay=null, move_delay=5,    one_hand_penalty=2, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		)

/obj/item/weapon/gun/magnetic/railgun/flechette/out_of_ammo()
	visible_message("<span class='warning'>\The [src] beeps to indicate the magazine is empty.</span>")
