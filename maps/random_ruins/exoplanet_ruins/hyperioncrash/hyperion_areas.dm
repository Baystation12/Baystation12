/area/ship/hyperion
	name = "Generic Ship"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambigen12.ogg')

/area/ship/hyperion/spine
	name = "Hallway - Spine"
	icon_state = "green"

/area/ship/hyperion/medbay
	name = "Medical Bay"
	icon_state = "medbay"

/area/ship/hyperion/engineering
	name = "Engineering Bay"
	icon_state = "engineering_supply"

/area/ship/hyperion/engine
	icon_state = "engine"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambieng1.ogg')

/area/ship/hyperion/engine/star
	name = "Engine - Starboard"

/area/ship/hyperion/engine/port
	name = "Engine - Port"

/area/ship/hyperion/cockpit
	name = "Command Deck"
	icon_state = "centcom"
	req_access = list(access_hyperion)

/area/ship/hyperion/eva
	name = "EVA"
	icon_state = "eva"