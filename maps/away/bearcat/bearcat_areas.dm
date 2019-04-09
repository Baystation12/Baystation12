/area/ship/scrap
	name = "Generic Ship"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambigen12.ogg')

/area/ship/scrap/crew
	name = "Crew Compartements"
	icon_state = "crew_quarters"

/area/ship/scrap/crew/hallway/port
	name = "Crew Hallway - Port"

/area/ship/scrap/crew/hallway/starboard
	name = "Crew Hallway - Starboard"

/area/ship/scrap/crew/kitchen
	name = "Galley"
	icon_state = "kitchen"

/area/ship/scrap/crew/cryo
	name = "Cryo Storage"
	icon_state = "cryo"

/area/ship/scrap/crew/dorms1
	name = "Crew Cabin #1"
	icon_state = "green"

/area/ship/scrap/crew/dorms2
	name = "Crew Cabin #2"
	icon_state = "purple"

/area/ship/scrap/crew/dorms3
	name = "Crew Cabin #3"
	icon_state = "yellow"

/area/ship/scrap/crew/saloon
	name = "Saloon"
	icon_state = "conference"

/area/ship/scrap/crew/toilets
	name = "Bathrooms"
	icon_state = "toilet"
	turf_initializer = /decl/turf_initializer/maintenance

/area/ship/scrap/crew/wash
	name = "Washroom"
	icon_state = "locker"

/area/ship/scrap/crew/medbay
	name = "Medical Bay"
	icon_state = "medbay"

/area/ship/scrap/cargo
	name = "Cargo Hold"
	icon_state = "quartstorage"

/area/ship/scrap/cargo/lower
	name = "Lower Cargo Hold"

/area/ship/scrap/dock
	name = "Docking Bay"
	icon_state = "entry_1"

/area/ship/scrap/fire
	name = "Firefighting Equipment Comparment"
	icon_state = "green"

/area/ship/scrap/unused
	name = "Compartment 2-B"
	icon_state = "yellow"
	turf_initializer = /decl/turf_initializer/maintenance
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambimo1.ogg','sound/ambience/ambimo2.ogg')

/area/ship/scrap/hidden
	name = "Unknown" //shielded compartment
	icon_state = "auxstorage"

/area/ship/scrap/escape_port
	name = "Port Escape Pods"
	icon_state = "green"

/area/ship/scrap/escape_star
	name = "Starboard Escape Pods"
	icon_state = "yellow"

/area/ship/scrap/broken1
	name = "Robotic Maintenance"
	icon_state = "green"

/area/ship/scrap/broken2
	name = "Compartment 1-B"
	icon_state = "yellow"

/area/ship/scrap/gambling
	name = "Compartment 1-C"
	icon_state = "cave"

/area/ship/scrap/maintenance
	name = "Maintenance Compartments"
	icon_state = "amaint"
	req_access = list(access_bearcat)

/area/ship/scrap/maintenance/hallway
	name = "Maintenance Corridors"

/area/ship/scrap/maintenance/lower
	name = "Lower Deck Maintenance Compartments"
	icon_state = "sub_maint_aft"

/area/ship/scrap/maintenance/storage
	name = "Tools Storage"
	icon_state = "engineering_storage"

/area/ship/scrap/maintenance/techstorage
	name = "Parts Storage"
	icon_state = "engineering_supply"

/area/ship/scrap/maintenance/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/ship/scrap/maintenance/engineering
	name = "Engineering Bay"
	icon_state = "engineering_supply"

/area/ship/scrap/maintenance/atmos
	name = "Atmospherics Comparment"
	icon_state = "atmos"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambiatm1.ogg')

/area/ship/scrap/maintenance/power
	name = "Power Compartment"
	icon_state = "engine_smes"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambieng1.ogg')

/area/ship/scrap/maintenance/engine
	icon_state = "engine"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambieng1.ogg')

/area/ship/scrap/maintenance/engine/aft
	name = "Main Engine Bay"

/area/ship/scrap/maintenance/engine/port
	name = "Port Thruster"

/area/ship/scrap/maintenance/engine/starboard
	name = "Starboard Thruster"

/area/ship/scrap/command/hallway
	name = "Command Deck"
	icon_state = "centcom"
	req_access = list(access_bearcat)

/area/ship/scrap/command/bridge
	name = "Bridge"
	icon_state = "bridge"
	req_access = list(access_bearcat)

/area/ship/scrap/command/captain
	name = "Captain's Quarters"
	icon_state = "captain"
	req_access = list(access_bearcat_captain)

/area/ship/scrap/comms
	name = "Communications Relay"
	icon_state = "tcomsatcham"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/signal.ogg','sound/ambience/sonar.ogg')

/area/ship/scrap/shuttle/lift
  name = "Cargo Lift"
  icon_state = "shuttle3"
  base_turf = /turf/simulated/open