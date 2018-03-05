/datum/map_template/ruin/exoplanet/hydrobase
	name = "hydroponics base"
	id = "exoplanet_hydrobase"
	description = "hydroponics base with random plants and a lot of enemies"
	suffixes = list("hydrobase/hydrobase.dmm")
	cost = 1
	allow_duplicates = FALSE //this doesnt work
	clean_slate = 1

// Areas //
/area/map_template/hydrobase
	name = "\improper Hydrobase"
	icon_state = "hydro"
	icon = 'maps/random_ruins/exoplanet_ruins/hydrobase/hydro.dmi'

/area/map_template/hydrobase/solars
	name = "\improper Solar Array"
	icon_state = "solar"

/area/map_template/hydrobase/station/processing
	name = "\improper Processing Area"
	icon_state = "processing"

/area/map_template/hydrobase/station/shipaccess
	name = "\improper Shipping Access"
	icon_state = "shipping"

/area/map_template/hydrobase/station/shower
	name = "\improper Clean Room"
	icon_state = "shower"

/area/map_template/hydrobase/station/growA
	name = "\improper Growing Zone A"
	icon_state = "A"

/area/map_template/hydrobase/station/growB
	name = "\improper Growing Zone B"
	icon_state = "B"

/area/map_template/hydrobase/station/growC
	name = "\improper Growing Zone C"
	icon_state = "C"

/area/map_template/hydrobase/station/growD
	name = "\improper Growing Zone D"
	icon_state = "D"

/area/map_template/hydrobase/station/growF
	name = "\improper Growing Zone F"
	icon_state = "F"

/area/map_template/hydrobase/station/growX
	name = "\improper Growing Zone X"
	icon_state = "X"

/area/map_template/hydrobase/station/goatzone
	name = "\improper Containment Zone"
	icon_state = "goatzone"

/area/map_template/hydrobase/station/dockport
	name = "\improper Access Port"
	icon_state = "airlock"

/area/map_template/hydrobase/station/solarlock
	name = "\improper External Airlock"
	icon_state = "airlock"


// Objs //
/obj/structure/closet/secure_closet/hydroponics/hydro
	name = "hydroponics supplies locker"
	req_access = list()

/obj/item/projectile/beam/drone/weak
	damage = 5 //1/3rd of regular projectile


// Mobs //
/mob/living/simple_animal/hostile/retaliate/goat/king/hydro //these goats are powerful but are not the king of goats
	name = "strange goat"
	desc = "An impressive goat, in size and coat. His horns look pretty serious!"
	health = 450
	maxHealth = 450
	melee_damage_lower = 20
	melee_damage_upper = 45
	faction = "farmbots"

/mob/living/simple_animal/hostile/retaliate/malf_drone/hydro
	name = "Farmbot"
	desc = "The botanist's best friend. There's something slightly odd about the way it moves."
	icon = 'maps/random_ruins/exoplanet_ruins/hydrobase/hydro.dmi'
	speak = list("Initiating harvesting subrout-ine-ine.", "Connection timed out.", "Connection with master AI syst-tem-tem lost.", "Core systems override enab-...")
	emote_see = list("beeps repeatedly", "whirrs violently", "flashes its indicator lights", "emits a ping sound")
	icon_state = "farmbot"
	icon_living = "farmbot"
	icon_dead = "farmbot_dead"
	faction = "farmbots"
	rapid = 0
	health = 200
	maxHealth = 200
	malfunctioning = 0

/mob/living/simple_animal/hostile/retaliate/malf_drone/hydro/Initialize()
	. = ..()
	if(prob(15))
		projectiletype = /obj/item/projectile/beam/drone/weak

/mob/living/simple_animal/hostile/retaliate/malf_drone/hydro/emp_act(severity)
	health -= rand(5,10) * (severity + 1)
	disabled = rand(15, 30)
	malfunctioning = 1
	hostile_drone = 1
	destroy_surroundings = 1
	projectiletype = initial(projectiletype)
	walk(src,0)

/mob/living/simple_animal/hostile/retaliate/malf_drone/hydro/ListTargets()
	if(hostile_drone)
		return view(src, 3)
	else
		return ..()