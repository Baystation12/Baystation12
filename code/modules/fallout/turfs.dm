turf/wasteland //overworld turf
	name = "wasteland"
	icon = 'icons/fallout/floors.dmi'
	icon_state = "wasteland1"
	dynamic_lighting = 0
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

	temperature = T20C + 10 // 30 deg C
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT

/turf/wasteland/New()
	if(icon_state == "wasteland1")
		icon_state = "wasteland[((x + y) ^ ~(x * y)) % 31]"
	update_starlight()
	..()

/turf/wasteland/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/stack/tile/floor))
		var/obj/item/stack/tile/floor/S = C
		if (S.get_amount() < 1)
			return
		playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
		S.use(1)
		ChangeTurf(/turf/simulated/floor/plating)
		return
	return

/turf/wasteland/proc/update_starlight()
	if(!config.starlight)
		return
	if(locate(/turf/unsimulated) in orange(src,1) || locate(/turf/simulated) in orange(src,1) || locate(/turf/road) in orange(src,1))
		set_light(config.starlight)
	else
		set_light(0)

/turf/simulated/floor/underground
	name = "rock floor"
	icon = 'icons/fallout/floors.dmi'
	icon_state = "desert0"
	dynamic_lighting = 1

	temperature = T20C // 30 deg C

/turf/simulated/floor/underground/New()
	if(icon_state == "desert0")
		icon_state = "desert[((x + y) ^ ~(x * y)) % 12]"

/turf/unsimulated/wall/reinforced_vault
	name = "composite wall"
	icon = 'icons/fallout/walls.dmi'
	icon_state = "vaultcomposition"

/turf/unsimulated/wall/wasteland/drywall
	name = "drywall"
	icon = 'icons/fallout/walls.dmi'
	icon_state = "store0"

/turf/unsimulated/wall/wasteland/peelingwood
	name = "wooden wall"
	icon = 'icons/fallout/walls.dmi'
	icon_state = "wasteland0"


turf/road
	name = "\proper highway"
	icon = 'icons/fallout/floors.dmi'
	icon_state = "innermiddle"
	dynamic_lighting = 0
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

	temperature = T20C + 10 // 30 deg C
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT

turf/road/proc/update_starlight()
	if(!config.starlight)
		return
	if(locate(/turf/unsimulated) in orange(src,1) || locate(/turf/simulated) in orange(src,1))
		set_light(config.starlight)
	else
		set_light(0)

/turf/road/New()
	update_starlight()
	..()

turf/road/edge
	icon_state = "innerpavement"

turf/road/edge/corner
	icon_state = "innerpavementcorner"

turf/road/pothole
	name = "\proper pothole"
	icon_state = "hole"



turf/road/bordered
	icon_state = "bordered"

turf/road/bordered/corner
	icon_state = "outerborder"

turf/road/bordered/corner/alt
	icon_state = "outerbordercorner"

turf/road/sidewalk
	icon_state = "outermiddle"

turf/road/sidewalk/edge
	icon_state = "outerpavement"

turf/road/sidewalk/corner
	icon_state = "outerpavementcorner"

turf/road/sidewalk/corner/tinyvert
	icon_state = "tinycornervertical"

turf/road/sidewalk/corner/tinyhoriz
	icon_state = "tinycornerhorizontal"

turf/road/sidewalk/innerturn
	icon_state = "innerturn"

turf/road/sidewalk/outerturn
	icon_state = "outerturn"
