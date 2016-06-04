/obj/random
	name = "random object"
	desc = "This item type is used to spawn random objects at round-start."
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything


// creates a new object and deletes itself
/obj/random/New()
	..()
	if (!prob(spawn_nothing_percentage))
		spawn_item()

/obj/random/initialize()
	..()
	qdel(src)

// this function should return a specific item to spawn
/obj/random/proc/item_to_spawn()
	return 0


// creates the random item
/obj/random/proc/spawn_item()
	var/build_path = item_to_spawn()

	var/atom/A = new build_path(src.loc)
	if(pixel_x || pixel_y)
		A.pixel_x = pixel_x
		A.pixel_y = pixel_y


/obj/random/single
	name = "randomly spawned object"
	desc = "This item type is used to randomly spawn a given object at round-start."
	icon_state = "x3"
	var/spawn_object = null
	item_to_spawn()
		return ispath(spawn_object) ? spawn_object : text2path(spawn_object)


/obj/random/tool
	name = "random tool"
	desc = "This is a random tool."
	icon = 'icons/obj/items.dmi'
	icon_state = "welder"
	item_to_spawn()
		return pick(/obj/item/weapon/screwdriver,\
					/obj/item/weapon/wirecutters,\
					/obj/item/weapon/weldingtool,\
					/obj/item/weapon/crowbar,\
					/obj/item/weapon/wrench,\
					/obj/item/device/flashlight)


/obj/random/technology_scanner
	name = "random scanner"
	desc = "This is a random technology scanner."
	icon = 'icons/obj/device.dmi'
	icon_state = "atmos"
	item_to_spawn()
		return pick(prob(5);/obj/item/device/t_scanner,\
					prob(2);/obj/item/device/radio,\
					prob(5);/obj/item/device/analyzer)


/obj/random/powercell
	name = "random powercell"
	desc = "This is a random powercell."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	item_to_spawn()
		return pick(prob(10);/obj/item/weapon/cell/crap,\
					prob(40);/obj/item/weapon/cell,\
					prob(40);/obj/item/weapon/cell/high,\
					prob(9);/obj/item/weapon/cell/super,\
					prob(1);/obj/item/weapon/cell/hyper)


/obj/random/bomb_supply
	name = "bomb supply"
	desc = "This is a random bomb supply."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "signaller"
	item_to_spawn()
		return pick(/obj/item/device/assembly/igniter,\
					/obj/item/device/assembly/prox_sensor,\
					/obj/item/device/assembly/signaler,\
					/obj/item/device/multitool)


/obj/random/toolbox
	name = "random toolbox"
	desc = "This is a random toolbox."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"
	item_to_spawn()
		return pick(prob(3);/obj/item/weapon/storage/toolbox/mechanical,\
					prob(2);/obj/item/weapon/storage/toolbox/electrical,\
					prob(1);/obj/item/weapon/storage/toolbox/syndicate,\
					prob(2);/obj/item/weapon/storage/toolbox/emergency)


/obj/random/tech_supply
	name = "random tech supply"
	desc = "This is a random piece of technology supplies."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	spawn_nothing_percentage = 50
	item_to_spawn()
		return pick(prob(3);/obj/random/powercell,\
					prob(2);/obj/random/technology_scanner,\
					prob(1);/obj/item/weapon/packageWrap,\
					prob(2);/obj/random/bomb_supply,\
					prob(1);/obj/item/weapon/extinguisher,\
					prob(1);/obj/item/clothing/gloves/fyellow,\
					prob(3);/obj/item/stack/cable_coil/random,\
					prob(2);/obj/random/toolbox,\
					prob(2);/obj/item/weapon/storage/belt/utility,\
					prob(5);/obj/random/tool,\
					prob(2);/obj/item/weapon/tape_roll)

/obj/random/medical
	name = "Random Medicine"
	desc = "This is a random medical item."
	icon = 'icons/obj/items.dmi'
	icon_state = "brutepack"
	spawn_nothing_percentage = 25
	item_to_spawn()
		return pick(prob(4);/obj/item/stack/medical/bruise_pack,\
					prob(4);/obj/item/stack/medical/ointment,\
					prob(2);/obj/item/stack/medical/advanced/bruise_pack,\
					prob(2);/obj/item/stack/medical/advanced/ointment,\
					prob(1);/obj/item/stack/medical/splint,\
					prob(2);/obj/item/bodybag,\
					prob(1);/obj/item/bodybag/cryobag,\
					prob(2);/obj/item/weapon/storage/pill_bottle/kelotane,\
					prob(2);/obj/item/weapon/storage/pill_bottle/antitox,\
					prob(2);/obj/item/weapon/storage/pill_bottle/tramadol,\
					prob(2);/obj/item/weapon/reagent_containers/syringe/antitoxin,\
					prob(1);/obj/item/weapon/reagent_containers/syringe/antiviral,\
					prob(2);/obj/item/weapon/reagent_containers/syringe/inaprovaline,\
					prob(1);/obj/item/stack/nanopaste)


/obj/random/firstaid
	name = "Random First Aid Kit"
	desc = "This is a random first aid kit."
	icon = 'icons/obj/storage.dmi'
	icon_state = "firstaid"
	item_to_spawn()
		return pick(prob(4);/obj/item/weapon/storage/firstaid/regular,\
					prob(3);/obj/item/weapon/storage/firstaid/toxin,\
					prob(3);/obj/item/weapon/storage/firstaid/o2,\
					prob(2);/obj/item/weapon/storage/firstaid/adv,\
					prob(1);/obj/item/weapon/storage/firstaid/combat,\
					prob(2);/obj/item/weapon/storage/firstaid/empty,\
					prob(3);/obj/item/weapon/storage/firstaid/fire)


/obj/random/contraband
	name = "Random Illegal Item"
	desc = "Hot Stuff."
	icon = 'icons/obj/items.dmi'
	icon_state = "purplecomb"
	spawn_nothing_percentage = 50
	item_to_spawn()
		return pick(prob(3);/obj/item/weapon/storage/pill_bottle/tramadol,\
					prob(4);/obj/item/weapon/haircomb,\
					prob(2);/obj/item/weapon/storage/pill_bottle/happy,\
					prob(2);/obj/item/weapon/storage/pill_bottle/zoom,\
					prob(5);/obj/item/weapon/contraband/poster,\
					prob(2);/obj/item/weapon/material/butterfly,\
					prob(3);/obj/item/weapon/material/butterflyblade,\
					prob(3);/obj/item/weapon/material/butterflyhandle,\
					prob(3);/obj/item/weapon/material/wirerod,\
					prob(1);/obj/item/weapon/material/butterfly/switchblade,\
					prob(1);/obj/item/weapon/reagent_containers/syringe/drugs)


/obj/random/energy
	name = "Random Energy Weapon"
	desc = "This is a random energy weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "energykill100"
	item_to_spawn()
		return pick(prob(4);/obj/item/weapon/gun/energy/laser,\
					prob(3);/obj/item/weapon/gun/energy/gun,\
					prob(2);/obj/item/weapon/gun/energy/retro,\
					prob(2);/obj/item/weapon/gun/energy/lasercannon,\
					prob(3);/obj/item/weapon/gun/energy/xray,\
					prob(1);/obj/item/weapon/gun/energy/sniperrifle,\
					prob(1);/obj/item/weapon/gun/energy/gun/nuclear,\
					prob(2);/obj/item/weapon/gun/energy/ionrifle,\
					prob(3);/obj/item/weapon/gun/energy/toxgun,\
					prob(4);/obj/item/weapon/gun/energy/taser,\
					prob(2);/obj/item/weapon/gun/energy/crossbow/largecrossbow,\
					prob(4);/obj/item/weapon/gun/energy/stunrevolver)

/obj/random/projectile
	name = "Random Projectile Weapon"
	desc = "This is a random projectile weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "revolver"
	item_to_spawn()
		return pick(prob(3);/obj/item/weapon/gun/projectile/shotgun/pump,\
					prob(2);/obj/item/weapon/gun/projectile/automatic/c20r,\
					prob(2);/obj/item/weapon/gun/projectile/automatic/sts35,\
					prob(2);/obj/item/weapon/gun/projectile/automatic/z8,\
					prob(4);/obj/item/weapon/gun/projectile/colt,\
					prob(4);/obj/item/weapon/gun/projectile/sec,\
					prob(3);/obj/item/weapon/gun/projectile/sec/wood,\
					prob(4);/obj/item/weapon/gun/projectile/pistol,\
					prob(5);/obj/item/weapon/gun/projectile/pirate,\
					prob(2);/obj/item/weapon/gun/projectile/revolver,\
					prob(3);/obj/item/weapon/gun/projectile/automatic/wt550,\
					prob(4);/obj/item/weapon/gun/projectile/revolver/detective,\
					prob(2);/obj/item/weapon/gun/projectile/revolver/mateba,\
					prob(4);/obj/item/weapon/gun/projectile/shotgun/doublebarrel,\
					prob(3);/obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn,\
					prob(1);/obj/item/weapon/gun/projectile/heavysniper,\
					prob(2);/obj/item/weapon/gun/projectile/shotgun/pump/combat)

/obj/random/handgun
	name = "Random Handgun"
	desc = "This is a random sidearm."
	icon = 'icons/obj/gun.dmi'
	icon_state = "secgundark"
	item_to_spawn()
		return pick(prob(3);/obj/item/weapon/gun/projectile/sec,\
					prob(2);/obj/item/weapon/gun/energy/gun,\
					prob(2);/obj/item/weapon/gun/projectile/colt,\
					prob(2);/obj/item/weapon/gun/projectile/pistol,\
					prob(1);/obj/item/weapon/gun/energy/retro,\
					prob(1);/obj/item/weapon/gun/projectile/sec/wood)


/obj/random/ammo
	name = "Random Ammunition"
	desc = "This is random ammunition."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "45-10"
	item_to_spawn()
		return pick(prob(6);/obj/item/weapon/storage/box/beanbags,\
					prob(2);/obj/item/weapon/storage/box/shotgunammo,\
					prob(4);/obj/item/weapon/storage/box/shotgunshells,\
					prob(1);/obj/item/weapon/storage/box/stunshells,\
					prob(2);/obj/item/ammo_magazine/c45m,\
					prob(4);/obj/item/ammo_magazine/c45m/rubber,\
					prob(4);/obj/item/ammo_magazine/c45m/flash,\
					prob(2);/obj/item/ammo_magazine/mc9mmt,\
					prob(6);/obj/item/ammo_magazine/mc9mmt/rubber)


/obj/random/action_figure
	name = "random action figure"
	desc = "This is a random action figure."
	icon = 'icons/obj/toy.dmi'
	icon_state = "assistant"
	item_to_spawn()
		return pick(/obj/item/toy/figure/cmo,\
					/obj/item/toy/figure/assistant,\
					/obj/item/toy/figure/atmos,\
					/obj/item/toy/figure/bartender,\
					/obj/item/toy/figure/borg,\
					/obj/item/toy/figure/gardener,\
					/obj/item/toy/figure/captain,\
					/obj/item/toy/figure/cargotech,\
					/obj/item/toy/figure/ce,\
					/obj/item/toy/figure/chaplain,\
					/obj/item/toy/figure/chef,\
					/obj/item/toy/figure/chemist,\
					/obj/item/toy/figure/clown,\
					/obj/item/toy/figure/corgi,\
					/obj/item/toy/figure/detective,\
					/obj/item/toy/figure/dsquad,\
					/obj/item/toy/figure/engineer,\
					/obj/item/toy/figure/geneticist,\
					/obj/item/toy/figure/hop,\
					/obj/item/toy/figure/hos,\
					/obj/item/toy/figure/qm,\
					/obj/item/toy/figure/janitor,\
					/obj/item/toy/figure/agent,\
					/obj/item/toy/figure/librarian,\
					/obj/item/toy/figure/md,\
					/obj/item/toy/figure/mime,\
					/obj/item/toy/figure/miner,\
					/obj/item/toy/figure/ninja,\
					/obj/item/toy/figure/wizard,\
					/obj/item/toy/figure/rd,\
					/obj/item/toy/figure/roboticist,\
					/obj/item/toy/figure/scientist,\
					/obj/item/toy/figure/syndie,\
					/obj/item/toy/figure/secofficer,\
					/obj/item/toy/figure/warden,\
					/obj/item/toy/figure/psychologist,\
					/obj/item/toy/figure/paramedic,\
					/obj/item/toy/figure/ert)


/obj/random/plushie
	name = "random plushie"
	desc = "This is a random plushie."
	icon = 'icons/obj/toy.dmi'
	icon_state = "nymphplushie"
	item_to_spawn()
		return pick(/obj/structure/plushie/ian,\
					/obj/structure/plushie/drone,\
					/obj/structure/plushie/carp,\
					/obj/structure/plushie/beepsky,\
					/obj/item/toy/plushie/nymph,\
					/obj/item/toy/plushie/mouse,\
					/obj/item/toy/plushie/kitten,\
					/obj/item/toy/plushie/lizard)

/obj/random/junk //Broken items, or stuff that could be picked up
	name = "random junk"
	desc = "This is some random junk."
	icon = 'icons/obj/trash.dmi'
	icon_state = "trashbag3"
	item_to_spawn()
		return pick(/obj/item/weapon/material/shard,\
					/obj/item/weapon/material/shard/shrapnel,\
					/obj/item/stack/material/cardboard,\
					/obj/item/weapon/storage/box/lights/mixed,\
					/obj/item/trash/raisins,\
					/obj/item/trash/candy,\
					/obj/item/trash/cheesie,\
					/obj/item/trash/chips,\
					/obj/item/trash/popcorn,\
					/obj/item/trash/sosjerky,\
					/obj/item/trash/syndi_cakes,\
					/obj/item/trash/waffles,\
					/obj/item/trash/plate,\
					/obj/item/trash/snack_bowl,\
					/obj/item/trash/pistachios,\
					/obj/item/trash/semki,\
					/obj/item/trash/tray,\
					/obj/item/trash/candle,\
					/obj/item/trash/liquidfood,\
					/obj/item/trash/tastybread,\
					/obj/item/weapon/paper/crumpled,\
					/obj/item/weapon/paper/crumpled/bloody,\
					/obj/effect/decal/cleanable/molten_item,\
					/obj/item/weapon/cigbutt,\
					/obj/item/weapon/cigbutt/cigarbutt,\
					/obj/item/weapon/pen,\
					/obj/item/weapon/pen/blue,\
					/obj/item/weapon/pen/red,\
					/obj/item/weapon/pen/multi,\
					/obj/item/weapon/bananapeel,\
					/obj/item/inflatable/torn,\
					/obj/item/weapon/storage/box/matches)


/obj/random/trash //Mostly remains and cleanable decals. Stuff a janitor could clean up
	name = "random trash"
	desc = "This is some random trash."
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenglow"
	item_to_spawn()
		return pick(/obj/item/remains/lizard,\
					/obj/effect/decal/cleanable/blood/gibs/robot,\
					/obj/effect/decal/cleanable/blood/oil,\
					/obj/effect/decal/cleanable/blood/oil/streak,\
					/obj/effect/decal/cleanable/spiderling_remains,\
					/obj/item/remains/mouse,\
					/obj/effect/decal/cleanable/vomit,\
					/obj/effect/decal/cleanable/blood/splatter,\
					/obj/effect/decal/cleanable/ash,\
					/obj/effect/decal/cleanable/generic,\
					/obj/effect/decal/cleanable/flour,\
					/obj/effect/decal/cleanable/dirt,\
					/obj/item/remains/robot)


obj/random/closet //A couple of random closets to spice up maint
	name = "random closet"
	desc = "This is a random closet."
	icon = 'icons/obj/closet.dmi'
	icon_state = "syndicate1"
	item_to_spawn()
		return pick(/obj/structure/closet,\
					/obj/structure/closet/firecloset,\
					/obj/structure/closet/firecloset/full,\
					/obj/structure/closet/emcloset,\
					/obj/structure/closet/jcloset,\
					/obj/structure/closet/athletic_mixed,\
					/obj/structure/closet/toolcloset,\
					/obj/structure/closet/l3closet/general,\
					/obj/structure/closet/cabinet,\
					/obj/structure/closet/crate,\
					/obj/structure/closet/crate/freezer,\
					/obj/structure/closet/crate/freezer/rations,\
					/obj/structure/closet/crate/internals,\
					/obj/structure/closet/crate/trashcart,\
					/obj/structure/closet/crate/medical,\
					/obj/structure/closet/boxinggloves,\
					/obj/structure/largecrate,\
					/obj/structure/closet/wardrobe/orange)

obj/random/obstruction //Large objects to block things off in maintenance
	name = "random obstruction"
	desc = "This is a random obstruction."
	icon = 'icons/obj/cult.dmi'
	icon_state = "cultgirder"
	item_to_spawn()
		return pick(/obj/structure/barricade,\
					/obj/structure/girder,\
					/obj/structure/girder/displaced,\
					/obj/structure/girder/reinforced,\
					/obj/structure/grille,\
					/obj/structure/grille/broken,\
					/obj/structure/inflatable/wall,\
					/obj/structure/inflatable/door)


obj/random/material //Random materials for building stuff
	name = "random material"
	desc = "This is a random material."
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet-metal"
	item_to_spawn()
		return pick(/obj/item/stack/material/steel{amount = 10},\
					/obj/item/stack/material/glass{amount = 10},\
					/obj/item/stack/material/plastic{amount = 10},\
					/obj/item/stack/material/wood{amount = 10},\
					/obj/item/stack/material/cardboard{amount = 10},\
					/obj/item/stack/rods{amount = 10},\
					/obj/item/stack/material/plasteel{amount = 10})


/obj/random/coin
	name = "random coin"
	desc = "This is a random coin."
	icon = 'icons/obj/items.dmi'
	icon_state = "coin"
	item_to_spawn()
		return pick(prob(3);/obj/item/weapon/coin/gold,\
					prob(4);/obj/item/weapon/coin/silver,\
					prob(2);/obj/item/weapon/coin/diamond,\
					prob(4);/obj/item/weapon/coin/iron,\
					prob(3);/obj/item/weapon/coin/uranium,\
					prob(1);/obj/item/weapon/coin/platinum,\
					prob(1);/obj/item/weapon/coin/phoron)


/obj/random/toy
	name = "random toy"
	desc = "This is a random toy."
	icon = 'icons/obj/toy.dmi'
	icon_state = "ship"
	item_to_spawn()
		return pick(/obj/item/toy/bosunwhistle,\
					/obj/item/toy/therapy_red,\
					/obj/item/toy/therapy_purple,\
					/obj/item/toy/therapy_blue,\
					/obj/item/toy/therapy_yellow,\
					/obj/item/toy/therapy_orange,\
					/obj/item/toy/therapy_green,\
					/obj/item/toy/cultsword,\
					/obj/item/toy/katana,\
					/obj/item/toy/snappop,\
					/obj/item/toy/sword,\
					/obj/item/toy/balloon,\
					/obj/item/toy/crossbow,\
					/obj/item/toy/blink,\
					/obj/item/toy/waterflower,\
					/obj/item/toy/prize/ripley,\
					/obj/item/toy/prize/fireripley,\
					/obj/item/toy/prize/deathripley,\
					/obj/item/toy/prize/gygax,\
					/obj/item/toy/prize/durand,\
					/obj/item/toy/prize/honk,\
					/obj/item/toy/prize/marauder,\
					/obj/item/toy/prize/seraph,\
					/obj/item/toy/prize/mauler,\
					/obj/item/toy/prize/odysseus,\
					/obj/item/toy/prize/phazon)


/obj/random/tank
	name = "random tank"
	desc = "This is a tank."
	icon = 'icons/obj/tank.dmi'
	icon_state = "canister"
	item_to_spawn()
		return pick(prob(5);/obj/item/weapon/tank/oxygen,\
					prob(4);/obj/item/weapon/tank/oxygen/yellow,\
					prob(4);/obj/item/weapon/tank/oxygen/red,\
					prob(3);/obj/item/weapon/tank/air,\
					prob(4);/obj/item/weapon/tank/emergency/oxygen,\
					prob(3);/obj/item/weapon/tank/emergency/oxygen/engi,\
					prob(2);/obj/item/weapon/tank/emergency/oxygen/double,\
					prob(2);/obj/item/weapon/tank/emergency/nitrogen,\
					prob(1);/obj/item/weapon/tank/nitrogen)


/obj/random/maintenance //Clutter and loot for maintenance and away missions, if you add something, make sure it's not in one of the other lists
	name = "random maintenance item"
	desc = "This is a random maintenance item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"
	item_to_spawn()
		return pick(prob(5);/obj/random/tech_supply,\
					prob(4);/obj/random/medical,\
					prob(3);/obj/random/firstaid,\
					prob(1);/obj/random/contraband,\
					prob(5);/obj/random/action_figure,\
					prob(5);/obj/random/plushie,\
					prob(5);/obj/random/junk,\
					prob(5);/obj/random/trash,\
					prob(4);/obj/random/material,\
					prob(3);/obj/random/coin,\
					prob(5);/obj/random/toy,\
					prob(3);/obj/random/tank,\
					prob(3);/obj/item/device/flashlight/lantern,\
					prob(5);/obj/item/weapon/storage/fancy/cigarettes,\
					prob(4);/obj/item/weapon/storage/fancy/cigarettes/dromedaryco,\
					prob(3);/obj/item/weapon/storage/fancy/cigarettes/killthroat,\
					prob(1);/obj/item/weapon/storage/fancy/cigar,\
					prob(3);/obj/item/clothing/mask/gas,\
					prob(4);/obj/item/clothing/mask/breath,\
					prob(2);/obj/item/clothing/mask/balaclava,\
					prob(2);/obj/item/weapon/reagent_containers/glass/rag ,\
					prob(2);/obj/item/weapon/storage/secure/briefcase,\
					prob(4);/obj/item/weapon/storage/briefcase,\
					prob(4);/obj/item/weapon/storage/briefcase/inflatable,\
					prob(5);/obj/item/weapon/storage/backpack,\
					prob(5);/obj/item/weapon/storage/backpack/satchel,\
					prob(3);/obj/item/weapon/storage/backpack/dufflebag,\
					prob(5);/obj/item/weapon/storage/box,\
					prob(3);/obj/item/weapon/storage/box/donkpockets,\
					prob(2);/obj/item/weapon/storage/box/sinpockets,\
					prob(1);/obj/item/weapon/storage/box/cups,\
					prob(4);/obj/item/weapon/storage/box/mousetraps,\
					prob(3);/obj/item/weapon/storage/box/engineer,\
					prob(3);/obj/item/weapon/storage/wallet,\
					prob(2);/obj/item/weapon/storage/belt/utility/full,\
					prob(2);/obj/item/weapon/storage/belt/medical/emt,\
					prob(4);/obj/item/device/toner,\
					prob(1);/obj/item/device/paicard,\
					prob(3);/obj/item/clothing/shoes/workboots,\
					prob(3);/obj/item/clothing/shoes/jackboots,\
					prob(1);/obj/item/clothing/shoes/swat,\
					prob(1);/obj/item/clothing/shoes/combat,\
					prob(2);/obj/item/clothing/shoes/galoshes,\
					prob(1);/obj/item/clothing/shoes/magboots,\
					prob(4);/obj/item/clothing/shoes/laceup,\
					prob(1);/obj/item/clothing/gloves/yellow,\
					prob(4);/obj/item/clothing/gloves/black,\
					prob(2);/obj/item/clothing/gloves/latex,\
					prob(1);/obj/item/clothing/gloves/swat,\
					prob(1);/obj/item/clothing/gloves/combat,\
					prob(5);/obj/item/clothing/gloves/white,\
					prob(5);/obj/item/clothing/gloves/rainbow,\
					prob(1);/obj/item/clothing/glasses/sunglasses,\
					prob(3);/obj/item/clothing/glasses/meson,\
					prob(2);/obj/item/clothing/glasses/meson/prescription,\
					prob(4);/obj/item/clothing/glasses/science,\
					prob(3);/obj/item/clothing/glasses/material,\
					prob(1);/obj/item/clothing/glasses/welding,\
					prob(2);/obj/item/weapon/weldingtool/largetank,\
					prob(2);/obj/item/clothing/head/helmet,\
					prob(4);/obj/item/clothing/head/hardhat,\
					prob(4);/obj/item/clothing/head/hardhat/orange,\
					prob(4);/obj/item/clothing/head/hardhat/red,\
					prob(4);/obj/item/clothing/head/hardhat/dblue,\
					prob(3);/obj/item/clothing/head/ushanka,\
					prob(2);/obj/item/clothing/head/welding,\
					prob(4);/obj/item/clothing/suit/storage/hazardvest,\
					prob(2);/obj/item/clothing/suit/armor/vest,\
					prob(4);/obj/item/clothing/suit/storage/toggle/labcoat,\
					prob(1);/obj/item/weapon/beartrap,\
					prob(2);/obj/item/weapon/handcuffs,\
					prob(3);/obj/item/weapon/camera_assembly,\
					prob(4);/obj/item/weapon/caution,\
					prob(4);/obj/item/weapon/caution/cone,\
					prob(1);/obj/random/loot,\
					prob(3);/obj/item/device/radio/headset)


/obj/random/loot /*Better loot for away missions and salvage */
	name = "random loot"
	desc = "This is some random loot."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift2"
	item_to_spawn()
		return pick(prob(4);/obj/random/powercell,\
					prob(4);/obj/random/technology_scanner,\
					prob(4);/obj/random/bomb_supply,\
					prob(4);/obj/item/stack/cable_coil,\
					prob(3);/obj/random/toolbox,\
					prob(4);/obj/random/tool,\
					prob(4);/obj/item/weapon/tape_roll,\
					prob(4);/obj/random/medical,\
					prob(3);/obj/random/firstaid,\
					prob(2);/obj/random/contraband,\
					prob(4);/obj/random/material,\
					prob(3);/obj/random/coin,\
					prob(3);/obj/random/tank,\
					prob(1);/obj/random/energy,\
					prob(1);/obj/random/projectile,\
					prob(4);/obj/item/device/flashlight/lantern,\
					prob(4);/obj/item/weapon/storage/fancy/cigarettes/dromedaryco,\
					prob(3);/obj/item/weapon/storage/fancy/cigarettes/killthroat,\
					prob(2);/obj/item/weapon/storage/fancy/cigar,\
					prob(4);/obj/item/clothing/mask/gas,\
					prob(3);/obj/item/clothing/mask/gas/swat,\
					prob(2);/obj/item/clothing/mask/balaclava,\
					prob(2);/obj/item/weapon/reagent_containers/glass/rag ,\
					prob(5);/obj/item/weapon/storage/box,\
					prob(3);/obj/item/weapon/storage/box/donkpockets,\
					prob(2);/obj/item/weapon/storage/box/sinpockets,\
					prob(2);/obj/item/weapon/storage/belt/utility/full,\
					prob(1);/obj/item/clothing/shoes/swat,\
					prob(1);/obj/item/clothing/shoes/combat,\
					prob(2);/obj/item/clothing/shoes/galoshes,\
					prob(1);/obj/item/clothing/shoes/magboots,\
					prob(4);/obj/item/clothing/shoes/laceup,\
					prob(4);/obj/item/clothing/gloves/black,\
					prob(2);/obj/item/clothing/gloves/latex,\
					prob(1);/obj/item/clothing/gloves/swat,\
					prob(1);/obj/item/clothing/gloves/combat,\
					prob(1);/obj/item/clothing/gloves/yellow,\
					prob(1);/obj/item/clothing/glasses/sunglasses,\
					prob(3);/obj/item/clothing/glasses/meson,\
					prob(2);/obj/item/clothing/glasses/meson/prescription,\
					prob(4);/obj/item/clothing/glasses/science,\
					prob(3);/obj/item/clothing/glasses/material,\
					prob(2);/obj/item/clothing/glasses/welding,\
					prob(1);/obj/item/clothing/glasses/night,\
					prob(1);/obj/item/clothing/glasses/thermal,\
					prob(3);/obj/item/weapon/weldingtool/largetank,\
					prob(4);/obj/item/clothing/head/helmet,\
					prob(4);/obj/item/clothing/head/collectable/petehat,\
					prob(3);/obj/item/clothing/head/ushanka,\
					prob(2);/obj/item/clothing/head/welding,\
					prob(4);/obj/item/clothing/suit/storage/hazardvest,\
					prob(4);/obj/item/clothing/suit/armor/vest,\
					prob(2);/obj/item/clothing/suit/storage/vest/merc,\
					prob(4);/obj/item/clothing/suit/storage/toggle/labcoat,\
					prob(2);/obj/item/weapon/handcuffs,\
					prob(2);/obj/item/weapon/circular_saw,\
					prob(2);/obj/item/weapon/scalpel,\
					prob(2);/obj/item/stack/material/diamond{amount = 10},\
					prob(2);/obj/item/stack/material/glass/phoronrglass{amount = 10},\
					prob(3);/obj/item/stack/material/marble{amount = 10},\
					prob(2);/obj/item/stack/material/phoron{amount = 10},\
					prob(2);/obj/item/stack/material/gold{amount = 10},\
					prob(2);/obj/item/stack/material/silver{amount = 10},\
					prob(2);/obj/item/stack/material/osmium{amount = 10},\
					prob(3);/obj/item/stack/material/platinum{amount = 10},\
					prob(2);/obj/item/stack/material/tritium{amount = 10},\
					prob(2);/obj/item/stack/material/mhydrogen{amount = 10},\
					prob(3);/obj/item/stack/material/plasteel{amount = 10},\
					prob(2);/obj/item/weapon/archaeological_find,\
					prob(1);/obj/machinery/artifact,\
					prob(2);/obj/item/device/multitool/hacktool,\
					prob(3);/obj/item/clothing/mask/gas/vox,\
					prob(3);/obj/item/device/radio/headset)

/obj/random/voidhelmet
	name = "Random Voidsuit Helmet"
	desc = "This is a random voidsuit helmet."
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "void"
	item_to_spawn()
		return pick(/obj/item/clothing/head/helmet/space/void,\
					/obj/item/clothing/head/helmet/space/void/engineering,\
					/obj/item/clothing/head/helmet/space/void/engineering/alt,\
					/obj/item/clothing/head/helmet/space/void/mining,\
					/obj/item/clothing/head/helmet/space/void/mining/alt,\
					/obj/item/clothing/head/helmet/space/void/security,\
					/obj/item/clothing/head/helmet/space/void/security/alt,\
					/obj/item/clothing/head/helmet/space/void/atmos,\
					/obj/item/clothing/head/helmet/space/void/atmos/alt,\
					/obj/item/clothing/head/helmet/space/void/merc,\
					/obj/item/clothing/head/helmet/space/void/medical,\
					/obj/item/clothing/head/helmet/space/void/medical/alt)

/obj/random/voidsuit
	name = "Random Voidsuit"
	desc = "This is a random voidsuit."
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "void"
	item_to_spawn()
		return pick(/obj/item/clothing/suit/space/void,\
					/obj/item/clothing/suit/space/void/engineering,\
					/obj/item/clothing/suit/space/void/engineering/alt,\
					/obj/item/clothing/suit/space/void/mining,\
					/obj/item/clothing/suit/space/void/mining/alt,\
					/obj/item/clothing/suit/space/void/security,\
					/obj/item/clothing/suit/space/void/security/alt,\
					/obj/item/clothing/suit/space/void/atmos,\
					/obj/item/clothing/suit/space/void/atmos/alt,\
					/obj/item/clothing/suit/space/void/merc,\
					/obj/item/clothing/suit/space/void/medical,\
					/obj/item/clothing/suit/space/void/medical/alt)

/obj/random/hardsuit
	name = "Random Hardsuit"
	desc = "This is a random hardsuit control module."
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "generic"
	item_to_spawn()
		return pick(/obj/item/weapon/rig/industrial,\
					/obj/item/weapon/rig/eva,\
					/obj/item/weapon/rig/light/hacker,\
					/obj/item/weapon/rig/light/stealth,\
					/obj/item/weapon/rig/light,\
					/obj/item/weapon/rig/unathi,\
					/obj/item/weapon/rig/unathi/fancy)
