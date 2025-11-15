/obj/item/gun/magnetic/railgun
	abstract_type = /obj/item/gun/magnetic/railgun
	name = "master railgun object"
	desc = "You should not see this."

	var/slowdown_held = 2
	var/slowdown_worn = 1

	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	bulk = GUN_BULK_RIFLE + 3
	icon = 'icons/obj/guns/railgun.dmi'
	icon_state = "railgun"

	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4, TECH_MAGNET = 4)

	cell = /obj/item/cell/hyper
	capacitor = /obj/item/stock_parts/capacitor/adv
	projectile_type = /obj/item/projectile/bullet/magnetic/slug
	load_type = /obj/item/rcd_ammo
	loaded = /obj/item/rcd_ammo/large // ~30 shots
	one_hand_penalty = 6
	power_cost = 300
	fire_delay = 35
	gun_unreliable = 0


/obj/item/gun/magnetic/railgun/Initialize()
	slowdown_per_slot[slot_l_hand] =  slowdown_held
	slowdown_per_slot[slot_r_hand] =  slowdown_held
	slowdown_per_slot[slot_back] =    slowdown_worn
	slowdown_per_slot[slot_belt] =    slowdown_worn
	slowdown_per_slot[slot_s_store] = slowdown_worn

	. = ..()


// Not going to check type repeatedly, if you code or varedit
// load_type and get runtime errors, don't come crying to me.
/obj/item/gun/magnetic/railgun/show_ammo(mob/user)
	var/obj/item/rcd_ammo/ammo = loaded
	if (ammo)
		to_chat(user, SPAN_NOTICE("There are [ammo.remaining] shot\s remaining in \the [loaded]."))
	else
		to_chat(user, SPAN_NOTICE("There is nothing loaded."))


/obj/item/gun/magnetic/railgun/check_ammo()
	var/obj/item/rcd_ammo/ammo = loaded
	return ammo && ammo.remaining


/obj/item/gun/magnetic/railgun/use_ammo()
	var/obj/item/rcd_ammo/ammo = loaded
	ammo.remaining--
	if(ammo.remaining <= 0)
		spawn(3)
			playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
		out_of_ammo()


/obj/item/gun/magnetic/railgun/proc/out_of_ammo()
	qdel(loaded)
	loaded = null
	visible_message(SPAN_WARNING("\The [src] beeps and ejects its empty cartridge."))


/obj/item/gun/magnetic/railgun/thunderclap
	name = "railgun"
	desc = "The HelTek Arms LM-76 'Thunderclap'. A portable linear motor cannon produced during the Gaia Conflict for anti-armour and \
			anti-fortification operations. Today, it sees wide use among private militaries, and is a staple on the black market."


/obj/item/gun/magnetic/railgun/spatha
	name = "old railgun"
	desc = "The Hephaestus Industries MRG-2 'Spatha'. A man-portable mass driver for squad support, \
			anti-armour and destruction of fortifications and emplacements."

	icon = 'icons/obj/guns/railgun_old.dmi'
	icon_state = "old_railgun"


//Should only be available to TC shock troops or high-budget mercs.
/obj/item/gun/magnetic/railgun/tc
	name = "advanced railgun"
	desc = "The Mars Military Industries MI-2k2 'Hammerhead'. A man-portable helical rail cannon. \
			Adopted in the times of the Terran Commonwealth, during the Ares Conflict. A lost relic of tumultuous times."

	icon = 'icons/obj/guns/railgun_adv.dmi'
	icon_state = "railgun-tcc"

	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 3, TECH_MAGNET = 5)

	loaded = /obj/item/stack/material/rods
	load_type = /obj/item/stack/material/rods // The Confederation learned that chunks of metal work just as well as fancy matter cartridges - actually they dont
	projectile_type = /obj/item/projectile/bullet/magnetic
	power_cost = 280 // Same number of shots, but it'll seem to recharge slightly faster
	load_sheet_max = 6 // Fewer shots per "magazine", but more abundant than matter cartridges.
	slowdown_worn = 3 // Little slower when worn


/obj/item/gun/magnetic/railgun/tc/show_ammo(mob/user)
	var/obj/item/stack/material/rods/ammo = loaded
	if(istype(ammo))
		to_chat(user, SPAN_NOTICE("It has [ammo.amount] shots loaded."))


/obj/item/gun/magnetic/railgun/tc/check_ammo()
	var/obj/item/stack/material/rods/ammo = loaded
	return ammo && ammo.amount


/obj/item/gun/magnetic/railgun/tc/out_of_ammo()
	QDEL_NULL(loaded)
	loaded = null
	spawn(3)
		playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
	visible_message(SPAN_WARNING("\The [src] beeps, before clanging as the ammunition bank resets."))


/obj/item/gun/magnetic/railgun/tc/use_ammo()
	var/obj/item/stack/material/rods/ammo = loaded
	ammo.use(1)
	if(!istype(ammo) || ammo.amount < 1)
		out_of_ammo()


/obj/item/gun/magnetic/railgun/flechette
	name = "flechette gun"
	desc = "The 'Skadi' is a burst fire capable railgun that fires flechette rounds at high velocity. \
			Deadly against armour, but much less effective against soft targets. A dreamt-up prototype."

	icon = 'icons/obj/guns/flechette.dmi'
	icon_state = "flechette_gun"
	item_state = "z8carbine"
	wielded_item_state = "z8carbine-wielded"

	cell = /obj/item/cell/hyper
	capacitor = /obj/item/stock_parts/capacitor/adv
	load_type = /obj/item/magnetic_ammo
	projectile_type = /obj/item/projectile/bullet/magnetic/flechette
	loaded = /obj/item/magnetic_ammo
	one_hand_penalty = 2
	fire_delay = 8
	power_cost = 100

	firemodes = list(
		list(
			"mode_name" = "semiauto",
			"burst" = 1,
			"fire_delay" = 0,
			"move_delay" = null,
			"one_hand_penalty" = 1,
			"burst_accuracy" = null,
			"dispersion" = null
		),
		list(
			"mode_name" = "short bursts",
			"burst" = 3,
			"fire_delay" = null,
			"move_delay" = 5,
			"one_hand_penalty" = 2,
			"burst_accuracy" = list(0, -1, -1),
			"dispersion" = list(0.0, 0.6, 1.0)
		)
	)


/obj/item/gun/magnetic/railgun/flechette/out_of_ammo()
	visible_message(SPAN_WARNING("\The [src] beeps to indicate the magazine is empty."))


/obj/item/gun/magnetic/railgun/flechette/skrell
	name = "skrellian rifle"
	desc = "The Zquiv*Tzuuli-8, or ZT-8, is a railgun rarely seen by anyone other than those within Skrellian SDTF ranks. \
			The rotary magazine houses a cylinder with individual chambers, that press against the barrel when loaded."

	icon = 'icons/obj/guns/skrell_rifle.dmi'
	icon_state = "skrell_rifle"
	item_state = "skrell_rifle"
	wielded_item_state = "skrell_rifle-wielded"

	removable_components = FALSE

	cell = /obj/item/cell/hyper
	capacitor = /obj/item/stock_parts/capacitor/adv
	load_type = /obj/item/magnetic_ammo/skrell
	loaded = /obj/item/magnetic_ammo/skrell/slug
	projectile_type = /obj/item/projectile/bullet/magnetic/slug
	one_hand_penalty = 3
	fire_delay = 10
	slowdown_held = 1
	power_cost = 100

	firemodes = list()


/obj/item/gun/magnetic/railgun/automatic // Adminspawn only, this shit is absurd.
	name = "\improper LM-RA autocannon"
	desc = "The HelTek Arms LM-RA/14A 'Meteor'. A vehicle-mounted turret weapon for anti-armour targets. \
			Originally, a Terran Commonwealth design. The fact that it was made man-portable is mindboggling in itself."

	icon = 'icons/obj/guns/railgun_heavy.dmi'
	icon_state = "heavy_railgun"

	w_class = ITEM_SIZE_NO_CONTAINER
	removable_components = FALSE // Absolutely not. This has an infinity cell.

	cell = /obj/item/cell/infinite
	capacitor = /obj/item/stock_parts/capacitor/super
	fire_delay =  8

	firemodes = list(
		list(
			"mode_name" = "semiauto",
			"burst" = 1,
			"fire_delay" = 0,
			"move_delay" = null,
			"one_hand_penalty" = 1,
			"burst_accuracy" = null,
			"dispersion" = null
		),
		list(
			"mode_name" = "short bursts",
			"burst" = 3,
			"fire_delay" = null,
			"move_delay" = 5,
			"one_hand_penalty" = 2,
			"burst_accuracy" = list(0, -1, -1),
			"dispersion" = list(0.0, 0.6, 1.0)
		),
		list(
			"mode_name" = "long bursts",
			"burst" = 6,
			"fire_delay" = null,
			"move_delay" = 10,
			"one_hand_penalty" = 2,
			"burst_accuracy" = list(0, -1, -1, -1, -2),
			"dispersion" = list(0.6, 0.6, 1.0, 1.0, 1.2)
		)
	)
	var/verse

/obj/item/gun/magnetic/railgun/automatic/Initialize()
	. = ..()
	verse = pick(list(
		"Ultima Ratio Regnum",
		"Ad Finem Amarum",
		"Unum Ultimum Proelium"
	))

/obj/item/gun/magnetic/railgun/automatic/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, SPAN_NOTICE("Someone has scratched <i>[verse]</i> onto the side of the barrel."))


/obj/item/gun/magnetic/railgun/automatic/halberd
	name = "\improper RHR accelerator"
	desc = "The Hephaestus Industries RG-3 'Halberd'. A vehicle-mounted turret weapon for anti-armour targets. \
			Originally, a Terran Commonwealth design. The fact that it was made man-portable is mindboggling in itself."
	icon = 'icons/obj/guns/railgun_old_heavy.dmi'
	icon_state = "old_heavy_railgun"

/obj/item/gun/magnetic/railgun/automatic/halberd/Initialize()
	. = ..()
	verse = pick(list(
		"For Those Who Fell Before Us",
		"Peace on Earth + Mars",
		"Death From Below",
		"Thunder Magic Spoke",
		"NAME_HERE FROM HELLSHEN",
		"NAME_HERE FROM GIDEONSBURG",
		"Thor's Hammer"
	))
	var/name = random_name(prob(50) ? MALE : FEMALE, SPECIES_HUMAN)
	verse = replacetext(verse, "NAME_HERE", uppertext(name))
