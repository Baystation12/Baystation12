/obj/item
	var/item_worth = 5

/obj/item/proc/get_worth()
	. = item_worth
	for(var/a in contents)
		if(istype(a, /obj/item))
			var/obj/item/A = a
			. += A.get_worth()

/obj/item/slime_extract
	item_worth = 200

/obj/item/slime_extract/get_worth()
	return item_worth * Uses

/obj/item/broken_device
	item_worth = 10

/obj/item/robot_parts
	item_worth = 30

/obj/item/robot_parts/robot_component
	item_worth = 250

/obj/item/modular_computer
	item_worth = 4000

/obj/item/modular_computer/tablet
	item_worth = 1300

/obj/item/laptop
	item_worth = 3000

/obj/machinery/modular_computer/laptop
	item_worth = 3000

/obj/item/solar_assembly
	item_worth = 680

/obj/item/ammo_casing
	item_worth = 5

/obj/item/ammo_casing/get_worth()
	if(!BB)
		return 1
	return ..()

/obj/item/ammo_magazine
	item_worth = 30

/obj/item/ammo_magazine/c45m/empty
	item_worth = 5

/obj/item/ammo_magazine/mc9mm/empty
	item_worth = 5

/obj/item/ammo_magazine/c9mm/empty
	item_worth = 5

/obj/item/ammo_magazine/mc9mmt/empty
	item_worth = 5

/obj/item/ammo_magazine/a50/empty
	item_worth = 5

/obj/item/ammo_magazine/a75/empty
	item_worth = 5

/obj/item/ammo_magazine/a762/empty
	item_worth = 5

/obj/item/conveyor_construct
	item_worth = 100

/obj/item/conveyor_switch_construct
	item_worth = 30

/obj/item/supply_beacon
	item_worth = 5000

/obj/item/frame
	item_worth = 60

/obj/item/pipe
	item_worth = 100

/obj/item/pipe_meter
	item_worth = 300

/obj/item/mecha_parts
	item_worth = 500

/obj/item/mecha_parts/chassis
	item_worth = 1200

/obj/item/mecha_parts/mecha_tracking
	item_worth = 400

/obj/item/mecha_parts/mecha_equipment
	item_worth = 1000

/obj/item/mecha_parts/mecha_equipment/teleporter
	item_worth = 3050

/obj/item/mecha_parts/mecha_equipment/gravcatapult
	item_worth = 3000

/obj/item/mecha_parts/mecha_equipment/armor_booster
	item_worth = 1100

/obj/item/mecha_parts/mecha_equipment/repair_droid
	item_worth = 1900

/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay
	item_worth = 1300

/obj/item/mecha_parts/mecha_equipment/generator
	item_worth = 1200

/obj/item/mecha_parts/mecha_equipment/generator/nuclear
	item_worth = 1700

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
	item_worth = 2000

/obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser
	item_worth = 1200

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy
	item_worth = 3000

/obj/item/mecha_parts/mecha_equipment/weapon/energy/ion
	item_worth = 1550

/obj/item/mecha_parts/mecha_equipment/weapon/energy/pulse
	item_worth = 5000

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot
	item_worth = 4750

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg
	item_worth = 5800

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive
	item_worth = 2500

/obj/item/missile
	item_worth = 1200

/obj/item/blueprints
	item_worth = 4000 //Information is valuable

/obj/item/bodybag
	item_worth = 20

/obj/item/bodybag/cryobag
	item_worth = 600

/obj/item/glass_jar
	item_worth = 10

/obj/item/target
	item_worth = 15

/obj/item/inflatable
	item_worth = 30

/obj/item/roller
	item_worth = 80

/obj/item/rig_module
	item_worth = 1000

/obj/item/rig_module/grenade_launcher
	item_worth = 1500

/obj/item/rig_module/mounted
	item_worth = 4100

/obj/item/rig_module/mounted/egun
	item_worth = 2100

/obj/item/rig_module/mounted/energy_blade
	item_worth = 2200

/obj/item/rig_module/fabricator
	item_worth = 2800

/obj/item/rig_module/stealth_field
	item_worth = 2500

/obj/item/rig_module/teleporter
	item_worth = 3000

/obj/item/rig_module/fabricator/energy_net
	item_worth = 1200

/obj/item/seeds
	item_worth = 10

/obj/item/bee_smoker
	item_worth = 60

/obj/item/honey_frame
	item_worth = 15

/obj/item/beehive_assembly
	item_worth = 100

/obj/item/bee_pack
	item_worth = 200

/obj/item/weedkiller
	item_worth = 30