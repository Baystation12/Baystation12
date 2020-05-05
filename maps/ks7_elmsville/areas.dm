/obj/autolight_init
	var/targ_area = /area/exo_ice_facility/exterior/autolight
	var/light_type = /obj/machinery/light/invis

/obj/autolight_init/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/autolight_init/LateInitialize()
	var/area/found = locate(targ_area)
	for(var/turf/create_at in found.contents)
		for(var/t in trange(1,create_at))
			var/turf/adj_turf = t
			if(adj_turf.loc != src)
				var/obj/machinery/light/l = new light_type (create_at)
				l.process()
				GLOB.processing_objects -= l
				break
	return INITIALIZE_HINT_QDEL

/area/exo_ice_facility
	name =  "KS7-535 \"New Pompeii\""
	base_turf = /turf/simulated/floor/exoplanet/snow
	has_gravity = 1
	dynamic_lighting = 0

/area/exo_ice_facility/interior
	name = "KS7-535 Interiors"
	requires_power = 0
	dynamic_lighting = 1

/area/exo_ice_facility/exterior
	dynamic_lighting = 0

/area/exo_ice_facility/exterior/autolight

/area/exo_ice_facility/exterior/caves
	dynamic_lighting = 1

/area/exo_ice_facility/exterior/caves/underground
	name = "KS7 - Underground"

/area/exo_ice_facility/exterior/caves/volcano
	name = "Volcano"

/area/exo_ice_facility/interior/bar
	name = "KS7 - Shatter Point Bar"

/area/exo_ice_facility/interior/museum_library
	name = "KS7 - Museum / Library"

/area/exo_ice_facility/interior/biodome/left
	name = "KS7 - Left Biodome"

/area/exo_ice_facility/interior/biodome/right
	name = "KS7 - Right Biodome"

/area/exo_ice_facility/interior/biodome/professional
	name = "KS7 - Hydroponics Biodome"

/area/exo_ice_facility/interior/biodome/worker_station
	name = "KS7 - Biodome Technicians"

/area/exo_ice_facility/interior/aerodrome
	name = "KS7 - Aerodrome"

/area/exo_ice_facility/interior/housing
	name = "KS7 - Housing Block 1"

/area/exo_ice_facility/interior/housing/biodome
	name = "KS7 - Housing Block 2"

/area/exo_ice_facility/interior/housing/lake
	name = "KS7 - Lake House"

/area/exo_ice_facility/interior/police
	name = "KS7 - Police Station"

/area/exo_ice_facility/interior/hospital
	name = "KS7 - Hospital"

/area/exo_ice_facility/interior/pharmacy
	name = "KS7 - Pharmacy"

/area/exo_ice_facility/interior/casino
	name = "KS7 - Casino"

/area/exo_ice_facility/interior/pirate_camp/left
	name = "KS7 - Pirate Camp Aux Armory"

/area/exo_ice_facility/interior/pirate_camp/right
	name = "KS7 - Pirate Camp"

/area/exo_ice_facility/interior/pirate_camp/armory
	name = "KS7 - Pirate Camp Vault"

/area/exo_ice_facility/interior/salvage_cov
	name = "KS7 - Covenant Salvage, Left"

/area/exo_ice_facility/interior/salvage_cov2
	name = "KS7 - Covenant Salvage, Middle"

/area/exo_ice_facility/interior/salvage_unsc
	name = "KS7 - UNSC Salvage"

/area/exo_ice_facility/interior/organlegger_den
	name = "KS7 - Organlegger's Den"

/area/exo_ice_facility/interior/umbi_west
	name = "KS7 - West Umbilical"

/area/exo_ice_facility/interior/umbi_east
	name = "KS7 - East Umbilical"

/*
/area/exo_Ice_facility/ground/interior
	name = "KS7-535 Facility Interior"
	requires_power= 0
	has_gravity = 1

/area/exo_Ice_facility/ground/interior/living
	name = "KS7-535 Facility Living Quarters"
	icon_state = "Sleep"

/area/exo_Ice_facility/ground/interior/hallway
	name = "KS7-535 Facility Hallways"
	icon_state = "hallC1"

/area/exo_Ice_facility/ground/interior/armory
	name = "KS7-535 Facility Armory"
	icon_state = "armory"

/area/exo_Ice_facility/ground/interior/hangar
	name = "KS7-535 Facility Hangar"
	icon_state = "hangar"

/area/exo_Ice_facility/ground/interior/control
	name = "KS7-535 Facility Control Room"
	icon_state = "bridge"

/area/exo_Ice_facility/ground/interior/bar
	name = "Emsville Bar"
	icon_state = "bar"

/area/exo_Ice_facility/ground/interior/sushiems
	name = "Sushi Stall"
	icon_state = "cafeteria"

/area/exo_Ice_facility/ground/interior/mech
	name = "Emsville Base Mech Lab"

/area/exo_Ice_facility/ground/interior/livingtop
	name = "Emsville Topside Living Quarters"
	icon_state = "crew_quarters"

/area/exo_Ice_facility/ground/interior/library
	name = "Emsville Library"
	icon_state = "library"

/area/exo_Ice_facility/ground/interior/corridorentrance
	name = "Emsville Entrance Acces Corridor"
	icon_state = "hallS"

/area/exo_Ice_facility/ground/interior/cryodorm
	name = "KS7-535 Facility Cryodorms"
	icon_state = "cryo"

/area/exo_Ice_facility/basement/interior
	name = "KS7-535 Facility Basement Interior"
	requires_power= 0
	icon_state = "hallC3"

/area/exo_Ice_facility/ground/exterior/south
	name = "KS7-535 Southern Wilderness"
	requires_power= 0
	has_gravity = 1
	icon_state = "south"

/area/exo_Ice_facility/ground/exterior/north
	name = "KS7-535 Northern Wilderness"
	icon_state = "north"

/area/exo_Ice_facility/ground/exterior/emsvilleexterior
	name = "Emsville Outpost Exterior"
	icon_state = "red"

/area/exo_Ice_facility/ground/exterior/emsvillepads
	name = "Emsville Pelican Landing Pads"
	icon_state = "porthang"

/area/exo_Ice_facility/ground/exterior/cave
	name = "KS7-535 Caves"
	requires_power= 0
	has_gravity = 1
	icon_state = "anomaly"

/area/exo_Ice_facility/ground/exterior/cave/cavenorthw
	name = "KS7-535 East Caves"
	icon_state = "northwest"

/area/exo_Ice_facility/ground/exterior/cave/caveeast
	name = "KS7-535 Nortwest Caves"
	icon_state = "east"

/area/exo_Ice_facility/basement/interior/storage
	name = "KS7-535 Facility Basement Storage Depot"
	icon_state = "auxstorage"

/area/exo_Ice_facility/basement/interior/medicalb
	name = "KS7-535 Facility Basement Medical Bay"
	icon_state = "medbay"

/area/exo_Ice_facility/basement/interior/hallway
	name = "KS7-535 Facility Basement Hallways"
	icon_state = "hallF"

/area/exo_Ice_facility/basement/interior/hangar
	name = "KS7-535 Facility Basement Hangar"
	icon_state = "vehicleshop"

/area/exo_Ice_facility/basement/interior/grocery
	name = "Emsville Grocery Store"
	icon_state = "kitchen"

/area/exo_Ice_facility/basement/interior/emsmedical
	name = "Emsville Medical Facility"
	icon_state = "medbay2"

/area/exo_Ice_facility/basement/interior/emslivingb
	name = "Emsville Living Quarters"
	icon_state = "locker"

/area/exo_Ice_facility/basement/interior/emscorridorb
	name = "Emsville Central Access Corridor"
	icon_state = "hallC2"

/area/exo_Ice_facility/basement/interior/emsmselterb
	name = "Emsville Smelter"
	icon_state = "mining_production"

/area/exo_Ice_facility/basement/interior/emsminigprep
	name = "Emsville Mining Prep"
	icon_state = "mining"

/area/exo_Ice_facility/basement/interior/emspark
	name = "Emsville Park"
	icon_state = "garden"

/area/exo_Ice_facility/basement/interior/emsdisco
	name = "Emsville Disco"
	icon_state = "holodeck"

/area/exo_Ice_facility/basement/interior/emssmelter
	name = "Emsville Storage"
	icon_state = "storage"

/area/exo_Ice_facility/basement/interior/emssecurity
	name = "Emsville Marshall's Office"
	icon_state = "security"

/area/exo_Ice_facility/basement/interior/emshydroponics
	name = "Emsville Hydroponics Bay"
	icon_state = "hydro"

/area/exo_Ice_facility/basement/exterior/cave
	name = "KS7-535 Lower Caves"
	requires_power= 0
	has_gravity = 1
	icon_state = "cave"
*/
