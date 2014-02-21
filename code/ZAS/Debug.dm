var/image/assigned = image('icons/Testing/Zone.dmi', icon_state = "assigned")
var/image/created = image('icons/Testing/Zone.dmi', icon_state = "created")
var/image/merged = image('icons/Testing/Zone.dmi', icon_state = "merged")
var/image/invalid_zone = image('icons/Testing/Zone.dmi', icon_state = "invalid")
var/image/air_blocked = image('icons/Testing/Zone.dmi', icon_state = "block")
var/image/zone_blocked = image('icons/Testing/Zone.dmi', icon_state = "zoneblock")
var/image/blocked = image('icons/Testing/Zone.dmi', icon_state = "fullblock")
var/image/mark = image('icons/Testing/Zone.dmi', icon_state = "mark")

/turf/var/tmp/dbg_img
/turf/proc/dbg(image/img, d = 0)
	if(d > 0) img.dir = d
	overlays -= dbg_img
	overlays += img
	dbg_img = img

/turf/simulated/var/verbose = 0
/turf/simulated/verb/Verbose()
	set src in world
	verbose = !verbose