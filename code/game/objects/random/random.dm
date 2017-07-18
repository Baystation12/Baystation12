/obj/random
	name = "random object"
	desc = "This item type is used to spawn random objects at round-start."
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything

// creates a new object and deletes itself
/obj/random/Initialize()
	..()
	spawn_item()
	return INITIALIZE_HINT_QDEL

// this function should return a specific item to spawn
/obj/random/proc/item_to_spawn()
	return 0

// creates the random item
/obj/random/proc/spawn_item()
	if(prob(spawn_nothing_percentage))
		return

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
					/obj/item/weapon/weldingtool/largetank,\
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
	icon_state = "hcell"
	item_to_spawn()
		return pick(prob(10);/obj/item/weapon/cell/crap,\
					prob(80);/obj/item/weapon/cell,\
					prob(50);/obj/item/weapon/cell/high,\
					prob(20);/obj/item/weapon/cell/super,\
					prob(10);/obj/item/weapon/cell/hyper,\
					prob(70);/obj/item/weapon/cell/device/standard,\
					prob(50);/obj/item/weapon/cell/device/high)


/obj/random/bomb_supply
	name = "bomb supply"
	desc = "This is a random bomb supply."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "signaller"
	item_to_spawn()
		return pick(/obj/item/device/assembly/igniter,\
					/obj/item/device/assembly/prox_sensor,\
					/obj/item/device/assembly/signaler,\
					/obj/item/device/assembly/timer,\
					/obj/item/device/multitool)


/obj/random/toolbox
	name = "random toolbox"
	desc = "This is a random toolbox."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"
	item_to_spawn()
		return pick(prob(30);/obj/item/weapon/storage/toolbox/mechanical,\
					prob(20);/obj/item/weapon/storage/toolbox/electrical,\
					prob(20);/obj/item/weapon/storage/toolbox/emergency,\
					prob(1);/obj/item/weapon/storage/toolbox/syndicate)


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
					prob(1);/obj/item/weapon/hand_labeler,\
					prob(2);/obj/random/bomb_supply,\
					prob(1);/obj/item/weapon/extinguisher,\
					prob(1);/obj/item/clothing/gloves/insulated/cheap,\
					prob(3);/obj/item/stack/cable_coil/random,\
					prob(2);/obj/random/toolbox,\
					prob(2);/obj/item/weapon/storage/belt/utility,\
					prob(1);/obj/item/weapon/storage/belt/utility/atmostech,\
					prob(5);/obj/random/tool,\
					prob(2);/obj/item/weapon/tape_roll)

/obj/random/medical
	name = "Random Medical equipment"
	desc = "This is a random medical item."
	icon = 'icons/obj/items.dmi'
	icon_state = "traumakit"
	item_to_spawn()
		return pick(prob(21);/obj/random/medical/lite,\
					prob(2);/obj/item/bodybag,\
					prob(2);/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline,\
					prob(2);/obj/item/weapon/reagent_containers/glass/bottle/antitoxin,\
					prob(2);/obj/item/weapon/storage/pill_bottle,\
					prob(1);/obj/item/weapon/storage/pill_bottle/tramadol,\
					prob(2);/obj/item/weapon/storage/pill_bottle/citalopram,\
					prob(1);/obj/item/weapon/storage/pill_bottle/dexalin_plus,\
					prob(1);/obj/item/weapon/storage/pill_bottle/dermaline,\
					prob(1);/obj/item/weapon/storage/pill_bottle/bicaridine,\
					prob(2);/obj/item/weapon/reagent_containers/syringe/antitoxin,\
					prob(1);/obj/item/weapon/reagent_containers/syringe/antiviral,\
					prob(2);/obj/item/weapon/reagent_containers/syringe/inaprovaline,\
					prob(1);/obj/item/weapon/storage/box/freezer,\
					prob(1);/obj/item/stack/nanopaste)

/obj/random/medical/lite
	name = "Random Medicine"
	desc = "This is a random simple medical item."
	icon = 'icons/obj/items.dmi'
	icon_state = "brutepack"
	spawn_nothing_percentage = 25
	item_to_spawn()
		return pick(prob(4);/obj/item/stack/medical/bruise_pack,\
					prob(4);/obj/item/stack/medical/ointment,\
					prob(2);/obj/item/weapon/storage/pill_bottle/antidexafen,\
					prob(2);/obj/item/weapon/storage/pill_bottle/paracetamol,\
					prob(2);/obj/item/stack/medical/advanced/bruise_pack,\
					prob(2);/obj/item/stack/medical/advanced/ointment,\
					prob(1);/obj/item/stack/medical/splint,\
					prob(1);/obj/item/bodybag/cryobag,\
					prob(3);/obj/item/weapon/reagent_containers/hypospray/autoinjector,\
					prob(2);/obj/item/weapon/storage/pill_bottle/kelotane,\
					prob(2);/obj/item/weapon/storage/pill_bottle/antitox)


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
		return pick(prob(4);/obj/item/weapon/haircomb,\
					prob(3);/obj/item/weapon/storage/pill_bottle/tramadol,\
					prob(2);/obj/item/weapon/storage/pill_bottle/happy,\
					prob(2);/obj/item/weapon/storage/pill_bottle/zoom,\
					prob(1);/obj/item/weapon/reagent_containers/glass/beaker/vial/random/toxin,\
					prob(1);/obj/item/weapon/reagent_containers/glass/beaker/sulphuric,\
					prob(5);/obj/item/weapon/contraband/poster,\
					prob(2);/obj/item/weapon/material/butterfly,\
					prob(3);/obj/item/weapon/material/butterflyblade,\
					prob(3);/obj/item/weapon/material/butterflyhandle,\
					prob(3);/obj/item/weapon/material/wirerod,\
					prob(1);/obj/item/weapon/melee/baton/cattleprod,\
					prob(1);/obj/item/weapon/material/butterfly/switchblade,\
					prob(1);/obj/item/weapon/material/hatchet/tacknife,\
					prob(2);/obj/item/weapon/material/kitchen/utensil/knife/boot,\
					prob(1);/obj/item/weapon/storage/secure/briefcase/money,\
					prob(1);/obj/item/weapon/storage/box/syndie_kit/cigarette,\
					prob(1);/obj/item/stack/telecrystal,\
					prob(2);/obj/item/clothing/under/syndicate,\
					prob(3);/obj/item/weapon/reagent_containers/syringe,\
					prob(2);/obj/item/weapon/reagent_containers/syringe/steroid,\
					prob(1);/obj/item/weapon/reagent_containers/syringe/drugs)


/obj/random/drinkbottle
	name = "random drink"
	desc = "This is a random drink."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "whiskeybottle"
	item_to_spawn()
		return pick(/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/gin,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/specialwhiskey,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/tequilla,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/absinthe,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/wine,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/cognac,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/rum,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/patron)


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
		return pick(/obj/item/toy/plushie/nymph,\
					/obj/item/toy/plushie/mouse,\
					/obj/item/toy/plushie/kitten,\
					/obj/item/toy/plushie/lizard)

/obj/random/plushie/large
	name = "random large plushie"
	desc = "This is a random large plushie."
	icon = 'icons/obj/toy.dmi'
	icon_state = "droneplushie"
	item_to_spawn()
		return pick(/obj/structure/plushie/ian,\
					/obj/structure/plushie/drone,\
					/obj/structure/plushie/carp,\
					/obj/structure/plushie/beepsky)

/obj/random/junk //Broken items, or stuff that could be picked up
	name = "random junk"
	desc = "This is some random junk."
	icon = 'icons/obj/trash.dmi'
	icon_state = "trashbag3"

/obj/random/junk/item_to_spawn()
	return get_random_junk_type()

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
obj/random/closet/item_to_spawn()
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
				/obj/structure/closet/wardrobe/xenos,\
				/obj/structure/closet/wardrobe/mixed,\
				/obj/structure/closet/wardrobe/suit,\
				/obj/structure/closet/wardrobe/orange)


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
					/obj/item/toy/water_balloon,\
					/obj/item/toy/crossbow,\
					/obj/item/toy/blink,\
					/obj/item/weapon/reagent_containers/spray/waterflower,\
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
					/obj/item/toy/prize/phazon,\
					/obj/item/weapon/deck/cards)


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
					prob(1);/obj/item/weapon/tank/emergency/nitrogen/double,\
					prob(1);/obj/item/weapon/tank/nitrogen,\
					prob(1);/obj/item/device/suit_cooling_unit)


obj/random/material //Random materials for building stuff
	name = "random material"
	desc = "This is a random material."
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet-metal"
	item_to_spawn()
		return pick(/obj/item/stack/material/steel{amount = 10},\
					/obj/item/stack/material/glass{amount = 10},\
					/obj/item/stack/material/glass/reinforced{amount = 10},\
					/obj/item/stack/material/plastic{amount = 10},\
					/obj/item/stack/material/wood{amount = 10},\
					/obj/item/stack/material/cardboard{amount = 10},\
					/obj/item/stack/rods{amount = 10},\
					/obj/item/stack/material/plasteel{amount = 10},
					/obj/item/stack/material/steel/fifty,\
					/obj/item/stack/material/glass/fifty,\
					/obj/item/stack/material/glass/reinforced{amount = 50},\
					/obj/item/stack/material/plastic/fifty,\
					/obj/item/stack/material/wood/fifty,\
					/obj/item/stack/material/cardboard/fifty,\
					/obj/item/stack/rods{amount = 50},\
					/obj/item/stack/material/plasteel/fifty)

/obj/random/soap
	name = "Random Cleaning Supplies"
	desc = "This is a random bar of soap. Soap! SOAP?! SOAP!!!"
	icon = 'icons/obj/items.dmi'
	icon_state = "soap"
	item_to_spawn()
		return pick(prob(4);/obj/item/weapon/soap,\
					prob(3);/obj/item/weapon/soap/nanotrasen,\
					prob(3);/obj/item/weapon/soap/deluxe,\
					prob(1);/obj/item/weapon/soap/syndie,\
					prob(1);/obj/item/weapon/soap/gold,\
					prob(2);/obj/item/weapon/reagent_containers/glass/rag ,\
					prob(2);/obj/item/weapon/reagent_containers/spray/cleaner,\
					prob(1);/obj/item/weapon/grenade/chem_grenade/cleaner)


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
					/obj/structure/foamedmetal,\
					/obj/item/weapon/caution,\
					/obj/item/weapon/caution/cone,\
					/obj/structure/inflatable/wall,\
					/obj/structure/inflatable/door)

/obj/random/assembly
	name = "random assembly"
	desc = "This is a random circuit assembly."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"
	item_to_spawn()
		return pick(/obj/item/device/electronic_assembly,\
					/obj/item/device/electronic_assembly/medium,\
					/obj/item/device/electronic_assembly/large,\
					/obj/item/device/electronic_assembly/drone)



/obj/random/advdevice
	name = "random advanced device"
	desc = "This is a random advanced device."
	icon = 'icons/obj/items.dmi'
	icon_state = "game_kit"
	item_to_spawn()
		return pick(/obj/item/device/flashlight/lantern,\
					/obj/item/device/flashlight/flare,\
					/obj/item/device/flashlight/pen,\
					/obj/item/device/toner,\
					/obj/item/device/paicard,\
					/obj/item/device/destTagger,\
					/obj/item/weapon/beartrap,\
					/obj/item/weapon/handcuffs,\
					/obj/item/weapon/camera_assembly,\
					/obj/item/device/camera,\
					/obj/item/device/pda,\
					/obj/item/weapon/card/emag_broken,\
					/obj/item/device/radio/headset,\
					/obj/item/device/flashlight/glowstick/yellow,\
					/obj/item/device/flashlight/glowstick/orange)


/obj/random/smokes
	name = "random smokeable"
	desc = "This is a random smokeable item."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "Bpacket"
	item_to_spawn()
		return pick(prob(5);/obj/item/weapon/storage/fancy/cigarettes,\
					prob(4);/obj/item/weapon/storage/fancy/cigarettes/dromedaryco,\
					prob(1);/obj/item/weapon/storage/fancy/cigarettes/killthroat,\
					prob(3);/obj/item/weapon/storage/fancy/cigarettes/luckystars,\
					prob(3);/obj/item/weapon/storage/fancy/cigarettes/jerichos,\
					prob(2);/obj/item/weapon/storage/fancy/cigarettes/menthols,\
					prob(3);/obj/item/weapon/storage/fancy/cigarettes/carcinomas,\
					prob(2);/obj/item/weapon/storage/fancy/cigarettes/professionals,\
					prob(1);/obj/item/weapon/storage/fancy/cigar,\
					prob(2);/obj/item/clothing/mask/smokable/cigarette,\
					prob(2);/obj/item/clothing/mask/smokable/cigarette/menthol,\
					prob(1);/obj/item/clothing/mask/smokable/cigarette/cigar,\
					prob(1);/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba,\
					prob(1);/obj/item/clothing/mask/smokable/cigarette/cigar/havana)


/obj/random/masks
	name = "random mask"
	desc = "This is a random face mask."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "gas_mask"
	item_to_spawn()
		return pick(prob(4);/obj/item/clothing/mask/gas,\
					prob(5);/obj/item/clothing/mask/gas/half,\
					prob(1);/obj/item/clothing/mask/gas/swat,\
					prob(1);/obj/item/clothing/mask/gas/syndicate,\
					prob(6);/obj/item/clothing/mask/breath,\
					prob(4);/obj/item/clothing/mask/breath/medical,\
					prob(3);/obj/item/clothing/mask/balaclava,\
					prob(2);/obj/item/clothing/mask/balaclava/tactical,\
					prob(4);/obj/item/clothing/mask/surgical)


/obj/random/snack
	name = "random snack"
	desc = "This is a random snack item."
	icon = 'icons/obj/food.dmi'
	icon_state = "sosjerky"
	item_to_spawn()
		return pick(/obj/item/weapon/reagent_containers/food/snacks/liquidfood,\
					/obj/item/weapon/reagent_containers/food/snacks/candy,\
					/obj/item/weapon/reagent_containers/food/drinks/dry_ramen,\
					/obj/item/weapon/reagent_containers/food/snacks/chips,\
					/obj/item/weapon/reagent_containers/food/snacks/sosjerky,\
					/obj/item/weapon/reagent_containers/food/snacks/no_raisin,\
					/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie,\
					/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers,\
					/obj/item/weapon/reagent_containers/food/snacks/tastybread,\
					/obj/item/weapon/reagent_containers/food/snacks/candy/proteinbar,\
					/obj/item/weapon/reagent_containers/food/snacks/syndicake,\
					/obj/item/weapon/reagent_containers/food/snacks/donut,\
					/obj/item/weapon/reagent_containers/food/snacks/donut/cherryjelly,\
					/obj/item/weapon/reagent_containers/food/snacks/donut/jelly,\
					/obj/item/pizzabox/meat,\
					/obj/item/pizzabox/vegetable,\
					/obj/item/pizzabox/margherita,\
					/obj/item/pizzabox/mushroom,\
					/obj/item/weapon/reagent_containers/food/snacks/plumphelmetbiscuit,\
					/obj/item/weapon/reagent_containers/food/snacks/skrellsnacks)


/obj/random/storage
	name = "random storage item"
	desc = "This is a storage item."
	icon = 'icons/obj/storage.dmi'
	icon_state = "idOld"
	item_to_spawn()
		return pick(prob(2);/obj/item/weapon/storage/secure/briefcase,\
					prob(4);/obj/item/weapon/storage/briefcase,\
					prob(3);/obj/item/weapon/storage/briefcase/inflatable,\
					prob(5);/obj/item/weapon/storage/backpack,\
					prob(5);/obj/item/weapon/storage/backpack/satchel,\
					prob(2);/obj/item/weapon/storage/backpack/dufflebag,\
					prob(5);/obj/item/weapon/storage/box,\
					prob(3);/obj/item/weapon/storage/box/donkpockets,\
					prob(1);/obj/item/weapon/storage/box/sinpockets,\
					prob(2);/obj/item/weapon/storage/box/donut,\
					prob(3);/obj/item/weapon/storage/box/cups,\
					prob(4);/obj/item/weapon/storage/box/mousetraps,\
					prob(3);/obj/item/weapon/storage/box/engineer,\
					prob(2);/obj/item/weapon/storage/box/autoinjectors,\
					prob(3);/obj/item/weapon/storage/box/beakers,\
					prob(3);/obj/item/weapon/storage/box/syringes,\
					prob(3);/obj/item/weapon/storage/box/gloves,\
					prob(2);/obj/item/weapon/storage/box/large,\
					prob(3);/obj/item/weapon/storage/box/glowsticks,\
					prob(1);/obj/item/weapon/storage/wallet,\
					prob(2);/obj/item/weapon/storage/ore,\
					prob(2);/obj/item/weapon/storage/belt/utility/full,\
					prob(2);/obj/item/weapon/storage/belt/medical/emt,\
					prob(2);/obj/item/weapon/storage/belt/medical,\
					prob(2);/obj/item/weapon/storage/belt/security,\
					prob(1);/obj/item/weapon/storage/belt/security/tactical)


/obj/random/shoes
	name = "random footwear"
	desc = "This is a random pair of shoes."
	icon = 'icons/obj/clothing/shoes.dmi'
	icon_state = "boots"
	item_to_spawn()
		return pick(prob(3);/obj/item/clothing/shoes/workboots,\
					prob(3);/obj/item/clothing/shoes/jackboots,\
					prob(1);/obj/item/clothing/shoes/swat,\
					prob(1);/obj/item/clothing/shoes/combat,\
					prob(2);/obj/item/clothing/shoes/galoshes,\
					prob(1);/obj/item/clothing/shoes/syndigaloshes,\
					prob(1);/obj/item/clothing/shoes/magboots,\
					prob(4);/obj/item/clothing/shoes/laceup,\
					prob(4);/obj/item/clothing/shoes/black,\
					prob(3);/obj/item/clothing/shoes/jungleboots,\
					prob(3);/obj/item/clothing/shoes/dutyboots,\
					prob(1);/obj/item/clothing/shoes/tactical,\
					prob(3);/obj/item/clothing/shoes/dress,\
					prob(3);/obj/item/clothing/shoes/dress/white,\
					prob(3);/obj/item/clothing/shoes/sandal,\
					prob(4);/obj/item/clothing/shoes/brown,\
					prob(4);/obj/item/clothing/shoes/red,\
					prob(4);/obj/item/clothing/shoes/blue,\
					prob(4);/obj/item/clothing/shoes/leather)


/obj/random/gloves
	name = "random gloves"
	desc = "This is a random pair of gloves."
	icon = 'icons/obj/clothing/gloves.dmi'
	icon_state = "rainbow"
	item_to_spawn()
		return pick(prob(3);/obj/item/clothing/gloves/insulated,\
					prob(6);/obj/item/clothing/gloves/thick,\
					prob(5);/obj/item/clothing/gloves/thick/botany,\
					prob(4);/obj/item/clothing/gloves/latex,\
					prob(3);/obj/item/clothing/gloves/thick/swat,\
					prob(3);/obj/item/clothing/gloves/thick/combat,\
					prob(5);/obj/item/clothing/gloves/white,\
					prob(1);/obj/item/clothing/gloves/rainbow,\
					prob(5);/obj/item/clothing/gloves/duty,\
					prob(3);/obj/item/clothing/gloves/guards,\
					prob(3);/obj/item/clothing/gloves/tactical,\
					prob(5);/obj/item/clothing/gloves/insulated/cheap)


/obj/random/glasses
	name = "random eyewear"
	desc = "This is a random pair of glasses."
	icon = 'icons/obj/clothing/glasses.dmi'
	icon_state = "leforge"
	item_to_spawn()
		return pick(prob(3);/obj/item/clothing/glasses/sunglasses,\
					prob(7);/obj/item/clothing/glasses/regular,\
					prob(5);/obj/item/clothing/glasses/meson,\
					prob(4);/obj/item/clothing/glasses/meson/prescription,\
					prob(3);/obj/item/clothing/glasses/meson/monocle,\
					prob(6);/obj/item/clothing/glasses/science,\
					prob(5);/obj/item/clothing/glasses/material,\
					prob(3);/obj/item/clothing/glasses/welding,\
					prob(4);/obj/item/clothing/glasses/hud/health,\
					prob(3);/obj/item/clothing/glasses/hud/health/prescription,\
					prob(4);/obj/item/clothing/glasses/hud/security,\
					prob(3);/obj/item/clothing/glasses/hud/security/prescription,\
					prob(2);/obj/item/clothing/glasses/sunglasses/sechud,\
					prob(3);/obj/item/clothing/glasses/sunglasses/sechud/toggle,\
					prob(1);/obj/item/clothing/glasses/sunglasses/sechud/goggles,\
					prob(1);/obj/item/clothing/glasses/tacgoggles)


/obj/random/hat
	name = "random headgear"
	desc = "This is a random hat of some kind."
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "tophat"
	item_to_spawn()
		return pick(prob(2);/obj/item/clothing/head/helmet,\
					prob(1);/obj/item/clothing/head/helmet/tactical,\
					prob(1);/obj/item/clothing/head/helmet/space/emergency,\
					prob(1);/obj/item/clothing/head/bio_hood/general,\
					prob(4);/obj/item/clothing/head/hardhat,\
					prob(4);/obj/item/clothing/head/hardhat/orange,\
					prob(4);/obj/item/clothing/head/hardhat/red,\
					prob(4);/obj/item/clothing/head/hardhat/dblue,\
					prob(3);/obj/item/clothing/head/ushanka,\
					prob(2);/obj/item/clothing/head/welding)


/obj/random/solgov
	name = "random solgov equipment"
	desc = "This is a random piece of solgov equipment or clothing."
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "helmet_sol"
	item_to_spawn()
		return pick(prob(4);/obj/item/clothing/head/utility/fleet,\
					prob(4);/obj/item/clothing/head/utility/marine,\
					prob(3);/obj/item/clothing/head/utility/marine/tan,\
					prob(3);/obj/item/clothing/head/utility/marine/green,\
					prob(2);/obj/item/clothing/head/soft/sol/expedition,\
					prob(4);/obj/item/clothing/head/soft/sol/fleet,\
					prob(1);/obj/item/clothing/head/helmet/solgov,\
					prob(2);/obj/item/clothing/suit/armor/vest/solgov,\
					prob(1);/obj/item/clothing/suit/storage/vest/solgov,\
					prob(4);/obj/item/clothing/suit/storage/service/expeditionary,\
					prob(2);/obj/item/clothing/under/utility/marine/tan,\
					prob(2);/obj/item/clothing/under/utility/marine/green,\
					prob(3);/obj/item/clothing/under/utility/marine,\
					prob(5);/obj/item/clothing/under/utility,\
					prob(3);/obj/item/clothing/under/utility/fleet,\
					prob(4);/obj/item/clothing/under/pt/expeditionary,\
					prob(2);/obj/item/clothing/under/pt/marine,\
					prob(4);/obj/item/clothing/under/pt/fleet,\
					prob(3);/obj/item/clothing/accessory/armband/bluegold)


/obj/random/suit
	name = "random suit"
	desc = "This is a random piece of outerwear."
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "fire"
	item_to_spawn()
		return pick(prob(4);/obj/item/clothing/suit/storage/hazardvest,\
					prob(4);/obj/item/clothing/suit/storage/toggle/labcoat,\
					prob(1);/obj/item/clothing/suit/space/emergency,\
					prob(4);/obj/item/clothing/suit/armor/vest,\
					prob(1);/obj/item/clothing/suit/storage/vest/tactical,\
					prob(3);/obj/item/clothing/suit/storage/vest,\
					prob(3);/obj/item/clothing/suit/storage/toggle/bomber,\
					prob(3);/obj/item/clothing/suit/chef/classic,\
					prob(2);/obj/item/clothing/suit/surgicalapron,\
					prob(3);/obj/item/clothing/suit/apron/overalls,\
					prob(1);/obj/item/clothing/suit/bio_suit/general,\
					prob(3);/obj/item/clothing/suit/storage/toggle/hoodie/black,\
					prob(3);/obj/item/clothing/suit/storage/toggle/brown_jacket,\
					prob(3);/obj/item/clothing/suit/storage/leather_jacket,\
					prob(4);/obj/item/clothing/suit/apron)


/obj/random/clothing
	name = "random clothes"
	desc = "This is a random piece of clothing."
	icon = 'icons/obj/clothing/uniforms.dmi'
	icon_state = "grey"
	item_to_spawn()
		return pick(prob(2);/obj/item/clothing/under/syndicate/tacticool,\
					prob(1);/obj/item/clothing/under/syndicate/combat,\
					prob(4);/obj/item/clothing/under/hazard,\
					prob(4);/obj/item/clothing/under/sterile,\
					prob(1);/obj/item/clothing/under/pt,\
					prob(2);/obj/item/clothing/under/casual_pants/camo,\
					prob(2);/obj/item/clothing/under/frontier,\
					prob(2);/obj/item/clothing/under/harness,\
					prob(2);/obj/item/clothing/under/rank/medical/paramedic,\
					prob(2);/obj/item/clothing/under/overalls,\
					prob(2);/obj/item/clothing/ears/earmuffs,\
					prob(1);/obj/item/clothing/under/tactical)


/obj/random/accessory
	name = "random accessory"
	desc = "This is a random utility accessory."
	icon = 'icons/obj/clothing/ties.dmi'
	icon_state = "horribletie"
	item_to_spawn()
		return pick(prob(3);/obj/item/clothing/accessory/storage/webbing,\
					prob(3);/obj/item/clothing/accessory/storage/webbing_large,\
					prob(2);/obj/item/clothing/accessory/storage/black_vest,\
					prob(2);/obj/item/clothing/accessory/storage/brown_vest,\
					prob(2);/obj/item/clothing/accessory/storage/white_vest,\
					prob(1);/obj/item/clothing/accessory/storage/bandolier,\
					prob(1);/obj/item/clothing/accessory/holster/thigh,\
					prob(1);/obj/item/clothing/accessory/holster/hip,\
					prob(1);/obj/item/clothing/accessory/holster/waist,\
					prob(1);/obj/item/clothing/accessory/holster/armpit,\
					prob(3);/obj/item/clothing/accessory/kneepads,\
					prob(2);/obj/item/clothing/accessory/stethoscope)


/obj/random/cash
	name = "random currency"
	desc = "LOADSAMONEY!"
	icon = 'icons/obj/items.dmi'
	icon_state = "spacecash1"
	item_to_spawn()
		return pick(prob(4);/obj/item/weapon/spacecash/bundle/c1,\
					prob(3);/obj/item/weapon/spacecash/bundle/c10,\
					prob(3);/obj/item/weapon/spacecash/bundle/c20,\
					prob(2);/obj/item/weapon/spacecash/bundle/c50,\
					prob(2);/obj/item/weapon/spacecash/bundle/c100,\
					prob(1);/obj/item/weapon/spacecash/bundle/c1000)


/obj/random/maintenance/solgov //can be used for loot on non-torch maps, so not a torch item
	name = "random maintenance item"
	desc = "This is a random maintenance item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"
	item_to_spawn()
		return pick(prob(400);/obj/random/junk,\
					prob(400);/obj/random/trash,\
					prob(500);/obj/random/maintenance/solgov/clean)


/obj/random/maintenance/solgov/clean
	name = "random maintenance item"
	desc = "This is a random maintenance item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift2"
	item_to_spawn()
		return pick(
					prob(300);/obj/random/solgov,\
					prob(80000);/obj/random/maintenance/clean)


/obj/random/maintenance //Clutter and loot for maintenance and away missions
	name = "random maintenance item"
	desc = "This is a random maintenance item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"
	item_to_spawn()
		return pick(prob(400);/obj/random/junk,\
					prob(400);/obj/random/trash,\
					prob(500);/obj/random/maintenance/clean)

/obj/random/maintenance/clean
/*Maintenance loot lists without the trash, for use inside things.
Individual items to add to the maintenance list should go here, if you add
something, make sure it's not in one of the other lists.*/
	name = "random clean maintenance item"
	desc = "This is a random clean maintenance item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift2"
	item_to_spawn()
		return pick(prob(1000);/obj/random/tech_supply,\
					prob(400);/obj/random/medical,\
					prob(800);/obj/random/medical/lite,\
					prob(200);/obj/random/firstaid,\
					prob(500);/obj/random/powercell,\
					prob(500);/obj/random/technology_scanner,\
					prob(800);/obj/random/bomb_supply,\
					prob(10);/obj/random/contraband,\
					prob(20);/obj/random/action_figure,\
					prob(20);/obj/random/plushie,\
					prob(400);/obj/random/material,\
					prob(50);/obj/random/coin,\
					prob(20);/obj/random/toy,\
					prob(200);/obj/random/tank,\
					prob(50);/obj/random/soap,\
					prob(50);/obj/random/drinkbottle,\
					prob(10);/obj/random/loot,\
					prob(500);/obj/random/advdevice,\
					prob(300);/obj/random/smokes,\
					prob(100);/obj/random/masks,\
					prob(600);/obj/random/snack,\
					prob(300);/obj/random/storage,\
					prob(200);/obj/random/shoes,\
					prob(100);/obj/random/gloves,\
					prob(200);/obj/random/glasses,\
					prob(100);/obj/random/hat,\
					prob(200);/obj/random/suit,\
					prob(300);/obj/random/clothing,\
					prob(200);/obj/random/accessory,\
					prob(100);/obj/random/cash)

/obj/random/loot /*Better loot for away missions and salvage */
	name = "random loot"
	desc = "This is some random loot."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift3"
	item_to_spawn()
		return pick(

					prob(10);/obj/random/energy,\
					prob(10);/obj/random/projectile,\
					prob(10);/obj/random/voidhelmet,\
					prob(10);/obj/random/voidsuit,\
					prob(10);/obj/random/hardsuit,\
					prob(100);/obj/random/maintenance/clean,\
					prob(7);/obj/item/clothing/mask/muzzle,\
					prob(8);/obj/item/clothing/mask/gas/vox,\
					prob(10);/obj/item/clothing/mask/gas/syndicate,\
					prob(3);/obj/item/clothing/glasses/night,\
					prob(1);/obj/item/clothing/glasses/thermal,\
					prob(7);/obj/item/clothing/glasses/welding/superior,\
					prob(4);/obj/item/clothing/head/collectable/petehat,\
					prob(3);/obj/item/clothing/suit/storage/vest/merc,\
					prob(6);/obj/item/clothing/suit/straight_jacket,\
					prob(3);/obj/item/clothing/head/helmet/merc,\
					prob(7);/obj/item/stack/material/diamond{amount = 10},\
					prob(7);/obj/item/stack/material/glass/phoronrglass{amount = 10},\
					prob(8);/obj/item/stack/material/marble{amount = 10},\
					prob(7);/obj/item/stack/material/phoron{amount = 10},\
					prob(7);/obj/item/stack/material/gold{amount = 10},\
					prob(7);/obj/item/stack/material/silver{amount = 10},\
					prob(7);/obj/item/stack/material/osmium{amount = 10},\
					prob(8);/obj/item/stack/material/platinum{amount = 10},\
					prob(7);/obj/item/stack/material/tritium{amount = 10},\
					prob(6);/obj/item/stack/material/mhydrogen{amount = 10},\
					prob(9);/obj/item/stack/material/plasteel{amount = 10},\
					prob(5);/obj/item/weapon/storage/box/monkeycubes,\
					prob(4);/obj/item/weapon/storage/box/monkeycubes/neaeracubes,\
					prob(4);/obj/item/weapon/storage/box/monkeycubes/stokcubes,\
					prob(4);/obj/item/weapon/storage/box/monkeycubes/farwacubes,\
					prob(4);/obj/item/weapon/storage/firstaid/surgery,\
					prob(1);/obj/item/weapon/cell/infinite,\
					prob(2);/obj/item/weapon/archaeological_find,\
					prob(1);/obj/machinery/artifact,\
					prob(2);/obj/item/device/multitool/hacktool,\
					prob(7);/obj/item/weapon/surgicaldrill,\
					prob(7);/obj/item/weapon/FixOVein,\
					prob(7);/obj/item/weapon/retractor,\
					prob(7);/obj/item/weapon/hemostat,\
					prob(7);/obj/item/weapon/cautery,\
					prob(7);/obj/item/weapon/bonesetter,\
					prob(7);/obj/item/weapon/bonegel,\
					prob(7);/obj/item/weapon/circular_saw,\
					prob(7);/obj/item/weapon/scalpel,\
					prob(9);/obj/item/weapon/melee/baton/loaded,\
					prob(6);/obj/item/device/radio/headset/syndicate)

/obj/random/voidhelmet
	name = "Random Voidsuit Helmet"
	desc = "This is a random voidsuit helmet."
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "void"
	item_to_spawn()
		return pick(/obj/item/clothing/head/helmet/space/void,\
					/obj/item/clothing/head/helmet/space/void/engineering,\
					/obj/item/clothing/head/helmet/space/void/engineering/alt,\
					/obj/item/clothing/head/helmet/space/void/engineering/salvage,\
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
					/obj/item/clothing/suit/space/void/engineering/salvage,\
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

/*
	Selects one spawn point out of a group of points with the same ID and asks it to generate its items
*/
var/list/multi_point_spawns

/obj/random_multi
	name = "random object spawn point"
	desc = "This item type is used to spawn random objects at round-start. Only one spawn point for a given group id is selected."
	icon = 'icons/misc/mark.dmi'
	icon_state = "x3"
	invisibility = INVISIBILITY_MAXIMUM
	var/id     // Group id
	var/weight // Probability weight for this spawn point

/obj/random_multi/Initialize()
	. = ..()
	weight = max(1, round(weight))

	if(!multi_point_spawns)
		multi_point_spawns = list()
	var/list/spawnpoints = multi_point_spawns[id]
	if(!spawnpoints)
		spawnpoints = list()
		multi_point_spawns[id] = spawnpoints
	spawnpoints[src] = weight

/obj/random_multi/Destroy()
	var/list/spawnpoints = multi_point_spawns[id]
	spawnpoints -= src
	if(!spawnpoints.len)
		multi_point_spawns -= id
	. = ..()

/obj/random_multi/proc/generate_items()
	return

/obj/random_multi/single_item
	var/item_path  // Item type to spawn

/obj/random_multi/single_item/generate_items()
	new item_path(loc)

/hook/roundstart/proc/generate_multi_spawn_items()
	for(var/id in multi_point_spawns)
		var/list/spawn_points = multi_point_spawns[id]
		var/obj/random_multi/rm = pickweight(spawn_points)
		rm.generate_items()
		for(var/entry in spawn_points)
			qdel(entry)
	return 1

/obj/random_multi/single_item/captains_spare_id
	name = "Multi Point - Captain's Spare"
	id = "Captain's spare id"
	item_path = /obj/item/weapon/card/id/captains_spare

var/list/random_junk_
var/list/random_useful_
/proc/get_random_useful_type()
	if(!random_useful_)
		random_useful_ = list()
		random_useful_ += /obj/item/weapon/pen/crayon/random
		random_useful_ += /obj/item/weapon/pen
		random_useful_ += /obj/item/weapon/pen/blue
		random_useful_ += /obj/item/weapon/pen/red
		random_useful_ += /obj/item/weapon/pen/multi
		random_useful_ += /obj/item/weapon/storage/box/matches
		random_useful_ += /obj/item/stack/material/cardboard
		random_useful_ += /obj/item/weapon/storage/fancy/cigarettes
		random_useful_ += /obj/item/weapon/deck/cards
	return pick(random_useful_)

/proc/get_random_junk_type()
	if(prob(20)) // Misc. clutter
		return /obj/effect/decal/cleanable/generic

	// 80% chance that we reach here
	if(prob(95)) // Misc. junk
		if(!random_junk_)
			random_junk_ = subtypesof(/obj/item/trash)
			random_junk_ += typesof(/obj/item/weapon/cigbutt)
			random_junk_ += /obj/effect/decal/cleanable/spiderling_remains
			random_junk_ += /obj/item/remains/mouse
			random_junk_ += /obj/item/remains/robot
			random_junk_ += /obj/item/weapon/paper/crumpled
			random_junk_ += /obj/item/inflatable/torn
			random_junk_ += /obj/effect/decal/cleanable/molten_item
			random_junk_ += /obj/item/weapon/material/shard
			random_junk_ += /obj/item/weapon/hand/missing_card

			random_junk_ -= /obj/item/trash/plate
			random_junk_ -= /obj/item/trash/snack_bowl
			random_junk_ -= /obj/item/trash/syndi_cakes
			random_junk_ -= /obj/item/trash/tray
		return pick(random_junk_)

	// Misc. actually useful stuff or perhaps even food
	// 4% chance that we reach here
	if(prob(75))
		return get_random_useful_type()

	// 1% chance that we reach here
	var/lunches = lunchables_lunches()
	return lunches[pick(lunches)]
