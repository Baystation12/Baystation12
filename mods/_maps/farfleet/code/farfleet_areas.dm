/area/ship/farfleet
	name = "\improper ICCGN Farfleet"
	icon_state = "shuttle2"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/ship/farfleet/crew
	name = "\improper Officer's Locker Room"
	icon_state = "locker"
	req_access = list(access_away_iccgn)
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/ship/farfleet/crew/hydroponics
	name = "\improper Auxiliary Hydroponics"
	icon_state = "green"
	req_access = list(access_away_iccgn)

/area/ship/farfleet/crew/canteen
	name = "\improper Canteen"
	icon_state = "cafeteria"
	req_access = list(access_away_iccgn)

/area/ship/farfleet/crew/kitchen
	name = "\improper Galley"
	icon_state = "green"
	req_access = list(access_away_iccgn)

/area/ship/farfleet/crew/freezer
	name = "\improper Freezer"
	icon_state = "locker"
	req_access = list(access_away_iccgn)

/area/ship/farfleet/crew/cryo
	name = "Cryo Storage"
	icon_state = "cryo"
	req_access = list(access_away_iccgn)

/area/ship/farfleet/crew/comms
	name = "Communication Relay"
	icon_state = "teleporter"
	req_access = list(access_away_iccgn, access_away_iccgn_captain)

/area/ship/farfleet/crew/toilet
	name = "\improper Toilet"
	icon_state = "toilet"
	req_access = list(access_away_iccgn)

/area/ship/farfleet/crew/hallway/lower
	name = "\improper Hallway - Operative Deck"
	icon_state = "hallF"
	req_access = list(access_away_iccgn)
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/ship/farfleet/crew/hallway/upper
	name = "\improper Hallway - Hangar Deck"
	icon_state = "hallA"
	req_access = list(access_away_iccgn)
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/ship/farfleet/crew/brig
	name = "\improper Ship Brig"
	icon_state = "red"
	req_access = list(access_away_iccgn)
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

/area/ship/farfleet/crew/brig/emergency_armory
	name = "\improper Emergency Armory"
	icon_state = "red"
	req_access = list(access_away_iccgn, access_away_iccgn_captain)
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

/area/ship/farfleet/crew/brig/css
	name = "\improper Counsultant Room"
	icon_state = "red"
	req_access = list(access_away_iccgn)
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/area/ship/farfleet/engineering/hallway
	name = "\improper Engineering Hallway"
	icon_state = "yellow"
	req_access = list(access_away_iccgn)
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/ship/farfleet/engineering/equipment
	name = "\improper Engineering Equipment"
	icon_state = "yellow"
	req_access = list(access_away_iccgn)
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/ship/farfleet/engineering/atmos_equipment
	name = "\improper Atmospherics Equipment"
	icon_state = "yellow"
	req_access = list(access_away_iccgn)
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/ship/farfleet/engineering/storage
	name = "\improper Engineering Storage"
	icon_state = "engineering_locker"
	req_access = list(access_away_iccgn)
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/ship/farfleet/engineering/shield
	name = "\improper Shield Generator"
	icon_state = "yellow"
	req_access = list(access_away_iccgn)
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/ship/farfleet/engineering/fussion
	name = "\improper Fussion Zone"
	icon_state = "rust_reactor"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambieng1.ogg')
	req_access = list(access_away_iccgn)
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/ship/farfleet/engineering/fussion/control
	name = "\improper Fussion Control"
	icon_state = "green"
	req_access = list(access_away_iccgn)
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/ship/farfleet/engineering/atmospherics
	name = "\improper Atmospherics"
	icon_state = "atmos"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambiatm1.ogg')
	req_access = list(access_away_iccgn)
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/ship/farfleet/barracks
	name = "\improper Droptroops Section"
	icon_state = "locker"
	req_access = list(access_away_iccgn, access_away_iccgn_droptroops)
	holomap_color = HOLOMAP_AREACOLOR_EXPLORATION

/area/ship/farfleet/barracks/armory
	name = "\improper Droptroops Armory"
	icon_state = "red"
	req_access = list(access_away_iccgn, access_away_iccgn_droptroops, access_away_iccgn_sergeant)
	holomap_color = HOLOMAP_AREACOLOR_EXPLORATION



/area/ship/farfleet/medbay
	name = "\improper Medical Bay"
	icon_state = "exam_room"
	req_access = list(access_away_iccgn)
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL

/area/ship/farfleet/medbay/storage
	name = "\improper Medical Storage"
	icon_state = "medbay"
	req_access = list(access_away_iccgn)

/area/ship/farfleet/medbay/surgery
	name = "\improper Surgery"
	icon_state = "surgery"
	req_access = list(access_away_iccgn)





/area/ship/farfleet/maintenance
	name = "\improper Port Maintenance"
	icon_state = "amaint"
	req_access = list(access_away_iccgn)

/area/ship/farfleet/maintenance/anomaly
	name = "\improper Anomaly Materials "
	icon_state = "amaint"
	req_access = list(access_away_iccgn)
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/ship/farfleet/maintenance/storage
	name = "\improper Auxiliary Storage"
	icon_state = "amaint"
	req_access = list(access_away_iccgn)

/area/ship/farfleet/maintenance/waste
	name = "\improper Waste Disposal"
	icon_state = "amaint"
	req_access = list(access_away_iccgn)

/area/ship/farfleet/maintenance/engine
	name = "\improper Thrusters"
	icon_state = "red"
	req_access = list(access_away_iccgn)



/area/ship/farfleet/command/bridge
	name = "\improper Bridge"
	icon_state = "bridge"
	req_access = list(access_away_iccgn)
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/area/ship/farfleet/command/eva
	name = "\improper Fleet EVA"
	icon_state = "eva"
	req_access = list(access_away_iccgn)
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/area/ship/farfleet/command/equipment
	name = "\improper Fleet Equipment"
	icon_state = "eva"
	req_access = list(access_away_iccgn)

/area/ship/farfleet/command/snz_hangar
	name = "\improper SNZ Hangar"
	icon_state = "hangar"
	req_access = list(access_away_iccgn)
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/ship/farfleet/command/hangar_canisters
	name = "\improper Fuel station"
	icon_state = "purple"
	req_access = list(access_away_iccgn)
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/ship/farfleet/command/launcher
	name = "\improper Fore Impulse Cannon"
	icon_state = "blue"
	req_access = list(access_away_iccgn)
	holomap_color = HOLOMAP_AREACOLOR_COMMAND



/area/ship/farfleet/dock
	name = "\improper Docking Bay"
	icon_state = "entry_1"
	req_access = list(access_away_iccgn)
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING
