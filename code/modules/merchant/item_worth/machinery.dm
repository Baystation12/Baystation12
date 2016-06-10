/obj/machinery
	var/item_worth = 1000 //Typically most machinery are expensive

/obj/machinery/proc/get_worth()
	. = item_worth
	if(component_parts && component_parts.len)
		for(var/a in component_parts)
			if(istype(a, /obj/item))
				var/obj/item/A = a
				. += A.get_worth()
	if(stat & BROKEN)
		. *= 0.5
	. = round(.)

/obj/machinery/Destroy()
	station_damage_score += item_worth
	..()

/obj/machinery/merchant_pad
	item_worth = 2000

/obj/machinery/mineral/unloading_machine
	item_worth = 500

/obj/machinery/mining/brace
	item_worth = 300

/obj/machinery/drone_fabricator
	item_worth = 3000

/obj/machinery/photocopier/faxmachine
	item_worth = 500

/obj/machinery/papershredder
	item_worth = 80

/obj/machinery/gravity_generator
	item_worth = 16000

/obj/machinery/light
	item_worth = 50

/obj/machinery/power/smes/buildable
	item_worth = 15000

/obj/machinery/compressor
	item_worth = 4000

/obj/machinery/power/turbine
	item_worth = 6000

/obj/machinery/computer/turbine_computer
	item_worth = 2000

/obj/machinery/chem_master
	item_worth = 6000

/obj/machinery/chemical_dispenser
	item_worth = 5000

/obj/machinery/conveyor
	item_worth = 200

/obj/machinery/conveyor_switch
	item_worth = 100

/obj/machinery/disposal
	item_worth = 500

/obj/machinery/blackbox_recorder
	item_worth = 9500

/obj/machinery/r_n_d
	item_worth = 1000

/obj/machinery/r_n_d/protolathe
	item_worth = 15000

/obj/machinery/r_n_d/server
	item_worth = 20000

/obj/machinery/auto_cloner
	item_worth = 13000

/obj/machinery/giga_drill
	item_worth = 1900

/obj/machinery/artifact
	item_worth = 13500

/obj/machinery/artifact_analyser
	item_worth = 11900

/obj/machinery/artifact_harvester
	item_worth = 12300

/obj/machinery/artifact_scanpad
	item_worth = 1800

/obj/machinery/suspension_gen
	item_worth = 3000

/obj/machinery/keycard_auth
	item_worth = 100

/obj/machinery/shield_gen
	item_worth = 15000

/obj/machinery/power/supermatter
	item_worth = 500000

/obj/machinery/power/supermatter/shard
	item_worth = 100000

/obj/machinery/disease2/diseaseanalyser
	item_worth = 8000

/obj/machinery/disease2/isolator/
	item_worth = 9000

/obj/machinery/atmospherics/pipe
	item_worth = 100

/obj/machinery/atmospherics/pipe/simple/heat_exchanging
	item_worth = 1000

/obj/machinery/atmospherics/portables_connector
	item_worth = 500

/obj/machinery/atmospherics/tvalve
	item_worth = 150

/obj/machinery/atmospherics/valve
	item_worth = 120

/obj/machinery/atmospherics/binary/circulator
	item_worth = 2500

/obj/machinery/atmospherics/binary/dp_vent_pump
	item_worth = 850

/obj/machinery/atmospherics/binary/passive_gate
	item_worth = 1600

/obj/machinery/atmospherics/pipeturbine
	item_worth = 3000

/obj/machinery/atmospherics/binary/pump
	item_worth = 1900

/obj/machinery/atmospherics/binary/pump/high_power
	item_worth = 2500

/obj/machinery/atmospherics/omni/filter
	item_worth = 4000

/obj/machinery/atmospherics/omni/mixer
	item_worth = 3600

/obj/machinery/atmospherics/trinary/filter
	item_worth = 3300

/obj/machinery/atmospherics/trinary/mixer
	item_worth = 3000

/obj/machinery/atmospherics/unary/freezer
	item_worth = 6000

/obj/machinery/atmospherics/unary/generator_input
	item_worth = 2500

/obj/machinery/atmospherics/unary/heater
	item_worth = 6000

/obj/machinery/atmospherics/unary/outlet_injector
	item_worth = 2300

/obj/machinery/atmospherics/unary/oxygen_generator
	item_worth = 10000

/obj/machinery/atmospherics/unary/vent_pump
	item_worth = 2000

/obj/machinery/atmospherics/unary/vent_scrubber
	item_worth = 2300

/obj/machinery/dna_scannernew
	item_worth = 15000

/obj/machinery/computer/scan_consolenew
	item_worth = 6000

/obj/machinery/bodyscanner
	item_worth = 6000

/obj/machinery/body_scanconsole
	item_worth = 1500

/obj/machinery/ai_slipper
	item_worth = 500

/obj/machinery/alarm
	item_worth = 800

/obj/machinery/air_sensor
	item_worth = 800

/obj/machinery/autolathe
	item_worth = 3300

/obj/machinery/bluespacerelay
	item_worth = 4000

/obj/machinery/button
	item_worth = 100

/obj/machinery/cablelayer
	item_worth = 1700

/obj/machinery/cell_charger
	item_worth = 90

/obj/machinery/clonepod
	item_worth = 9000

/obj/machinery/constructable_frame
	item_worth = 500

/obj/machinery/cryopod
	item_worth = 3000

/obj/machinery/deployable/barrier
	item_worth = 500

/obj/machinery/floodlight
	item_worth = 200

/obj/machinery/floor_light
	item_worth = 100

/obj/machinery/floorlayer
	item_worth = 1500

/obj/machinery/igniter
	item_worth = 300

/obj/machinery/sparker
	item_worth = 500

/obj/machinery/iv_drip
	item_worth = 100

/obj/machinery/media/jukebox
	item_worth = 700

/obj/machinery/magnetic_module
	item_worth = 500

/obj/machinery/magnetic_controller
	item_worth = 500

/obj/machinery/mass_driver
	item_worth = 500

/obj/machinery/navbeacon
	item_worth = 90

/obj/machinery/newscaster
	item_worth = 100

/obj/machinery/nuclearbomb
	item_worth = 10000

obj/machinery/recharger
	item_worth = 200

/obj/machinery/sleeper
	item_worth = 4000

/obj/machinery/space_heater
	item_worth = 500

/obj/machinery/ai_status_display
	item_worth = 600

/obj/machinery/teleport
	item_worth = 15000

/obj/machinery/bot/mulebot
	item_worth = 3000

/obj/machinery/camera
	item_worth = 700

obj/machinery/airlock_sensor
	item_worth = 800

/obj/machinery/door
	item_worth = 100

/obj/machinery/door/airlock
	item_worth = 800

/obj/machinery/door/blast
	item_worth = 1000

/obj/machinery/door/blast/shutters
	item_worth = 300

/obj/machinery/door/firedoor
	item_worth = 600

/obj/machinery/door_timer
	item_worth = 300

/obj/machinery/embedded_controller/radio/airlock
	item_worth = 600

/obj/machinery/gibber
	item_worth = 600

/obj/machinery/microwave
	item_worth = 70

/obj/machinery/pipedispenser
	item_worth = 100

/obj/machinery/telecomms/broadcaster
	item_worth = 10000

/obj/machinery/telecomms
	item_worth = 7000

/obj/machinery/computer/mecha
	item_worth = 1000

/obj/machinery/shower
	item_worth = 300

/obj/machinery/acting/changer
	item_worth = 3000

/obj/machinery/artillerycontrol
	item_worth = 1400

/obj/machinery/dnaforensics
	item_worth = 1200

/obj/machinery/microscope
	item_worth = 550

/obj/machinery/account_database
	item_worth = 3000

/obj/machinery/atm
	item_worth = 4500

/obj/machinery/food_replicator
	item_worth = 9000

/obj/machinery/readybutton
	item_worth = 0

/obj/machinery/botany
	item_worth = 9050

/obj/machinery/botany/editor
	item_worth = 16000

/obj/machinery/seed_storage
	item_worth = 500

/obj/machinery/beehive
	item_worth = 500

/obj/machinery/portable_atmospherics/hydroponics
	item_worth = 2300

/obj/machinery/portable_atmospherics/hydroponics/soil
	item_worth = 0 //its dirt

/obj/machinery/librarypubliccomp
	item_worth = 600

/obj/machinery/librarycomp
	item_worth = 1000

/obj/machinery/libraryscanner
	item_worth = 1000

/obj/machinery/bookbinder
	item_worth = 1200