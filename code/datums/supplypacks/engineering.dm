/decl/hierarchy/supply_pack/engineering
	name = "Engineering"

/decl/hierarchy/supply_pack/engineering/smes_circuit
	name = "Electronics - Superconducting magnetic energy storage unit circuitry"
	contains = list(/obj/item/stock_parts/circuitboard/smes)
	cost = 20
	containername = "superconducting magnetic energy storage unit circuitry crate"

/decl/hierarchy/supply_pack/engineering/smescoil
	name = "Parts - Superconductive magnetic coil"
	contains = list(/obj/item/stock_parts/smes_coil)
	cost = 35
	containername = "superconductive magnetic coil crate"

/decl/hierarchy/supply_pack/engineering/smescoil_weak
	name = "Parts - Basic superconductive magnetic coil"
	contains = list(/obj/item/stock_parts/smes_coil/weak)
	cost = 25
	containername = "basic superconductive magnetic coil crate"

/decl/hierarchy/supply_pack/engineering/smescoil_super_capacity
	name = "Parts - Superconductive capacitance coil"
	contains = list(/obj/item/stock_parts/smes_coil/super_capacity)
	cost = 45
	containername = "superconductive capacitance coil crate"

/decl/hierarchy/supply_pack/engineering/smescoil_super_io
	name = "Parts- Superconductive Transmission Coil"
	contains = list(/obj/item/stock_parts/smes_coil/super_io)
	cost = 45
	containername = "Superconductive Transmission Coil crate"

/decl/hierarchy/supply_pack/engineering/electrical
	name = "Gear - Electrical maintenance"
	contains = list(/obj/item/storage/toolbox/electrical = 2,
					/obj/item/clothing/gloves/insulated = 2,
					/obj/item/cell/standard = 2,
					/obj/item/cell/high = 2)
	cost = 15
	containername = "electrical maintenance crate"

/decl/hierarchy/supply_pack/engineering/mechanical
	name = "Gear - Mechanical maintenance"
	contains = list(/obj/item/storage/belt/utility/full = 3,
					/obj/item/clothing/suit/storage/hazardvest = 3,
					/obj/item/clothing/head/welding = 2,
					/obj/item/clothing/head/hardhat)
	cost = 10
	containername = "mechanical maintenance crate"

/decl/hierarchy/supply_pack/engineering/solar
	name = "Power - Solar pack"
	contains  = list(/obj/item/solar_assembly = 14,
					/obj/item/stock_parts/circuitboard/solar_control,
					/obj/item/tracker_electronics,
					/obj/item/paper/solar
					)
	cost = 15
	containername = "solar pack crate"

/decl/hierarchy/supply_pack/engineering/solar_assembly
	name = "Power - Solar assembly"
	contains  = list(/obj/item/solar_assembly = 16)
	cost = 10
	containername = "solar assembly crate"

/decl/hierarchy/supply_pack/engineering/emitter
	name = "Equipment - Emitter"
	contains = list(/obj/machinery/power/emitter = 2)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/large
	containername = "emitter crate"
	access = access_engine_equip

/decl/hierarchy/supply_pack/engineering/field_gen
	name = "Equipment - Field generator"
	contains = list(/obj/machinery/field_generator = 2)
	containertype = /obj/structure/closet/crate/large
	cost = 10
	containername = "field generator crate"
	access = access_ce

/decl/hierarchy/supply_pack/engineering/sing_gen
	name = "Equipment - Singularity generator"
	contains = list(/obj/machinery/the_singularitygen)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/large
	containername = "singularity generator crate"
	access = access_ce

/decl/hierarchy/supply_pack/engineering/collector
	name = "Power - Collector"
	contains = list(/obj/machinery/power/rad_collector = 2)
	cost = 8
	containertype = /obj/structure/closet/crate/secure/large
	containername = "collector crate"
	access = access_engine_equip

/decl/hierarchy/supply_pack/engineering/PA
	name = "Equipment - Particle accelerator"
	contains = list(/obj/structure/particle_accelerator/fuel_chamber,
					/obj/machinery/particle_accelerator/control_box,
					/obj/structure/particle_accelerator/particle_emitter/center,
					/obj/structure/particle_accelerator/particle_emitter/left,
					/obj/structure/particle_accelerator/particle_emitter/right,
					/obj/structure/particle_accelerator/power_box,
					/obj/structure/particle_accelerator/end_cap)
	cost = 40
	containertype = /obj/structure/largecrate
	containername = "particle accelerator crate"
	access = access_ce

/decl/hierarchy/supply_pack/engineering/pacman_parts
	name = "Power - P.A.C.M.A.N. portable generator parts"
	contains = list(/obj/item/stock_parts/micro_laser,
					/obj/item/stock_parts/capacitor,
					/obj/item/stock_parts/matter_bin,
					/obj/item/stock_parts/circuitboard/pacman)
	cost = 45
	containername = "\improper P.A.C.M.A.N. Portable Generator Construction Kit"
	containertype = /obj/structure/closet/crate/secure
	access = access_tech_storage

/decl/hierarchy/supply_pack/engineering/super_pacman_parts
	name = "Power - Super P.A.C.M.A.N. portable generator parts"
	contains = list(/obj/item/stock_parts/micro_laser,
					/obj/item/stock_parts/capacitor,
					/obj/item/stock_parts/matter_bin,
					/obj/item/stock_parts/circuitboard/pacman/super)
	cost = 55
	containername = "\improper Super P.A.C.M.A.N. portable generator construction kit"
	containertype = /obj/structure/closet/crate/secure
	access = access_tech_storage

/decl/hierarchy/supply_pack/engineering/teg
	name = "Power - Mark I Thermoelectric Generator"
	contains = list(/obj/machinery/power/generator)
	cost = 75
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper Mk1 TEG crate"
	access = access_engine_equip

/decl/hierarchy/supply_pack/engineering/circulator
	name = "Equipment - Binary atmospheric circulator"
	contains = list(/obj/machinery/atmospherics/binary/circulator)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/large
	containername = "atmospheric circulator crate"
	access = access_atmospherics

/decl/hierarchy/supply_pack/engineering/air_dispenser
	name = "Equipment - Pipe Dispenser"
	contains = list(/obj/machinery/pipedispenser)
	cost = 35
	containertype = /obj/structure/closet/crate/secure/large
	containername = "pipe dispenser crate"
	access = access_atmospherics

/decl/hierarchy/supply_pack/engineering/disposals_dispenser
	name = "Equipment - Disposals pipe dispenser"
	contains = list(/obj/machinery/pipedispenser/disposal)
	cost = 35
	containertype = /obj/structure/closet/crate/secure/large
	containername = "disposal dispenser crate"
	access = access_atmospherics

/decl/hierarchy/supply_pack/engineering/shield_generator
	name = "Equipment - Shield generator construction kit"
	contains = list(/obj/item/stock_parts/circuitboard/shield_generator, /obj/item/stock_parts/capacitor, /obj/item/stock_parts/micro_laser, /obj/item/stock_parts/smes_coil, /obj/item/stock_parts/console_screen)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "shield generator construction kit crate"
	access = access_engine

/decl/hierarchy/supply_pack/engineering/smbig
	name = "Power - Supermatter core"
	contains = list(/obj/machinery/power/supermatter)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/large/phoron
	containername = "\improper Supermatter crate (CAUTION)"
	access = access_ce

/decl/hierarchy/supply_pack/engineering/smsmall
	name = "Power - Supermatter shard"
	contains = list(/obj/machinery/power/supermatter/shard)
	cost = 75
	containertype = /obj/structure/closet/crate/secure/large/phoron
	containername = "\improper Supermatter crate (CAUTION)"
	access = access_ce

/decl/hierarchy/supply_pack/engineering/fueltank
	name = "Liquid - Fuel tank"
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	cost = 8
	containertype = /obj/structure/largecrate
	containername = "fuel tank crate"

/decl/hierarchy/supply_pack/engineering/robotics
	name = "Parts - Robotics assembly"
	contains = list(/obj/item/device/assembly/prox_sensor = 3,
					/obj/item/storage/toolbox/electrical,
					/obj/item/device/flash = 4,
					/obj/item/cell/high = 2)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "robotics assembly crate"
	access = access_robotics

/decl/hierarchy/supply_pack/engineering/radsuit
	name = "Gear - Radiation protection gear"
	contains = list(/obj/item/clothing/suit/radiation = 6,
			/obj/item/clothing/head/radiation = 6)
	cost = 20
	containertype = /obj/structure/closet/radiation
	containername = "radiation suit locker"

/decl/hierarchy/supply_pack/engineering/bluespacerelay
	name = "Parts - Emergency Bluespace Relay parts"
	contains = list(/obj/item/stock_parts/circuitboard/bluespacerelay,
					/obj/item/stock_parts/manipulator,
					/obj/item/stock_parts/manipulator,
					/obj/item/stock_parts/subspace/filter,
					/obj/item/stock_parts/subspace/crystal,
					/obj/item/storage/toolbox/electrical)
	cost = 75
	containername = "emergency bluespace relay assembly kit"

/decl/hierarchy/supply_pack/engineering/firefighter
	name = "Gear - Firefighting equipment"
	contains = list(/obj/item/clothing/suit/fire/firefighter,
			/obj/item/clothing/mask/gas,
			/obj/item/tank/oxygen_scba,
			/obj/item/extinguisher,
			/obj/item/clothing/head/hardhat/red,
			/obj/item/scrubpack/standard,
			/obj/item/tank/scrubber)
	cost = 20
	containertype = /obj/structure/closet/firecloset
	containername = "fire-safety closet"

/decl/hierarchy/supply_pack/engineering/voidsuit_engineering
	name = "EVA - Voidsuit, Engineering"
	contains = list(/obj/item/clothing/suit/space/void/engineering/alt,
					/obj/item/clothing/head/helmet/space/void/engineering/alt,
					/obj/item/clothing/shoes/magboots)
	cost = 120
	containername = "engineering voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_engine
