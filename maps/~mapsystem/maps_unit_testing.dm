/datum/map
	var/const/NO_APC = 1
	var/const/NO_VENT = 2
	var/const/NO_SCRUBBER = 4

	var/const/SELF = 1
	var/const/SUBTYPES = 2

	// Unit test vars
	var/list/apc_test_exempt_areas = list(
		/area/space = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet = NO_SCRUBBER|NO_VENT|NO_APC
	)

	var/list/area_coherency_test_exempt_areas = list(
		/area/space
	)
	var/list/area_coherency_test_exempted_root_areas = list(
		/area/exoplanet
	)
	var/list/area_coherency_test_subarea_count = list()

	// These areas are used specifically by code and need to be broken out somehow
	var/list/area_usage_test_exempted_areas = list(
		/area/beach,
		/area/centcom,
		/area/centcom/holding,
		/area/centcom/specops,
		/area/chapel,
		/area/hallway,
		/area/maintenance,
		/area/medical,
		/area/medical/virology,
		/area/medical/virologyaccess,
		/area/overmap,
		/area/rnd,
		/area/rnd/xenobiology,
		/area/rnd/xenobiology/xenoflora,
		/area/rnd/xenobiology/xenoflora_storage,
		/area/security,
		/area/security/prison,
		/area/security/brig,
		/area/skipjack_station,
		/area/skipjack_station/start,
		/area/shuttle,
		/area/shuttle/escape,
		/area/shuttle/escape/centcom,
		/area/shuttle/specops,
		/area/shuttle/specops/centcom,
		/area/shuttle/syndicate_elite,
		/area/shuttle/syndicate_elite/mothership,
		/area/shuttle/syndicate_elite/station,
		/area/turbolift,
		/area/supply,
		/area/syndicate_mothership,
		/area/syndicate_mothership/elite_squad,
		/area/wizard_station,
		/area/template_noop
	)

	var/list/area_usage_test_exempted_root_areas = list(
		/area/map_template,
		/area/exoplanet
	)

	var/list/area_purity_test_exempt_areas = list()

	var/list/buildable_exempt_machines = list(
		// Not buildable due to custom building procedure,
		/obj/machinery/power/terminal = SELF,
		/obj/machinery/power/apc = SELF | SUBTYPES,
		/obj/machinery/door/firedoor = SELF | SUBTYPES,
		/obj/machinery/camera = SELF | SUBTYPES,
		/obj/machinery/door/window = SELF | SUBTYPES,
		/obj/machinery/beehive = SELF,
		/obj/machinery/power/solar = SELF,
		/obj/machinery/power/tracker = SELF,

		// Not buildable because a base type is buildable,
		/obj/machinery/power/smes = SUBTYPES,
		/obj/machinery/alarm = SUBTYPES,
		/obj/machinery/vending/hydronutrients = SUBTYPES,
		/obj/machinery/vending/hydroseeds = SUBTYPES,
		/obj/machinery/atmospherics/pipe/simple/visible = SELF | SUBTYPES, // hidden ones are picked up by building code,
		/obj/machinery/atmospherics/pipe/manifold/visible = SELF | SUBTYPES,
		/obj/machinery/atmospherics/pipe/manifold4w/visible = SELF | SUBTYPES,
		/obj/machinery/atmospherics/pipe/cap/visible = SELF | SUBTYPES,
		/obj/machinery/suit_storage_unit = SUBTYPES,
		/obj/machinery/light/navigation = SUBTYPES,
		/obj/machinery/telecomms/bus = SUBTYPES,
		/obj/machinery/telecomms/server = SUBTYPES,
		/obj/machinery/telecomms/processor = SUBTYPES,
		/obj/machinery/telecomms/hub = SUBTYPES,
		/obj/machinery/telecomms/receiver = SUBTYPES,
		/obj/machinery/telecomms/relay = SUBTYPES,
		/obj/machinery/telecomms/broadcaster = SUBTYPES,
		/obj/machinery/fusion_fuel_injector = SUBTYPES,
		/obj/machinery/r_n_d/server = SUBTYPES,
		/obj/machinery/r_n_d/protolathe = SUBTYPES,
		/obj/machinery/r_n_d/destructive_analyzer = SUBTYPES,
		/obj/machinery/r_n_d/circuit_imprinter = SUBTYPES,
		/obj/machinery/seed_storage = SUBTYPES,
		/obj/machinery/portable_atmospherics/powered/pump = SUBTYPES,
		/obj/machinery/chemical_dispenser = SUBTYPES, // A few others are buildable too, but this is the main one,
		/obj/machinery/computer/rdconsole = SELF | SUBTYPES,

		// Not buildable due to transmitting data via signals and/or lack of ability to set up,
		/obj/machinery/power/sensor = SELF | SUBTYPES,
		/obj/machinery/button = SELF | SUBTYPES,
		/obj/machinery/access_button = SELF | SUBTYPES,
		/obj/machinery/airlock_sensor = SELF | SUBTYPES,
		/obj/machinery/door/blast = SELF | SUBTYPES, // Controlled remotely by buttons,
		/obj/machinery/door_timer = SELF | SUBTYPES,
		/obj/machinery/conveyor = SELF | SUBTYPES, // Use tags,
		/obj/machinery/conveyor_switch = SELF | SUBTYPES,
		/obj/machinery/power/breakerbox = SELF | SUBTYPES, // Has direction settings that can't be changed manually,
		/obj/machinery/requests_console = SELF, // Can't set the department,
		/obj/machinery/sparker = SELF, // Uses id,
		/obj/machinery/computer/shuttle_control = SELF | SUBTYPES, // Needs way to set the shuttle and make sure correct type is used,
		/obj/machinery/recharger/wallcharger = SELF, // Uses weird nonstandard pixel shifting,

		// Not buildable due to special nature (not machines in classical sense),
		/obj/machinery/portable_atmospherics/hydroponics/soil = SELF | SUBTYPES,
		/obj/machinery/embedded_controller = SELF | SUBTYPES,
		/obj/machinery/crystal_static = SELF | SUBTYPES,
		/obj/machinery/crystal = SELF | SUBTYPES,
		/obj/machinery/power/supermatter = SELF | SUBTYPES,
		/obj/machinery/shield = SELF | SUBTYPES,

		// Not buildable for balance or antag reasons,
		/obj/machinery/teleport = SELF | SUBTYPES,
		/obj/machinery/vending/assist/antag = SELF,
		/obj/machinery/vending/magivend = SELF,
		/obj/machinery/vending/props = SELF,
		/obj/machinery/door/airlock = SUBTYPES, // Unclear and should be re-examined further,
		/obj/machinery/replicator = SELF | SUBTYPES,
		/obj/machinery/light/small/readylight = SELF,
		/obj/machinery/suit_cycler = SELF | SUBTYPES, // Some are buildable,
		/obj/machinery/hologram/holopad = SELF | SUBTYPES,
		/obj/machinery/cryopod = SELF | SUBTYPES,
		/obj/machinery/telecomms/allinone = SELF | SUBTYPES,
		/obj/machinery/porta_turret/crescent = SELF,
		/obj/machinery/acting = SELF | SUBTYPES,
		/obj/machinery/the_singularitygen = SELF,
		/obj/machinery/nuclearbomb = SELF | SUBTYPES,
		/obj/machinery/artifact = SELF | SUBTYPES,
		/obj/machinery/smartfridge/chemistry = SUBTYPES
	)