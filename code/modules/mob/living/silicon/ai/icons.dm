var/datum/ai_icon/default_ai_icon = new/datum/ai_icon/blue()
var/list/datum/ai_icon/ai_icons

/datum/ai_icon
	var/name
	var/alive_icon
	var/alive_light = "#FFFFFF"
	var/nopower_icon = "4"
	var/nopower_light = "#FFFFFF"
	var/dead_icon = "ai-crash"
	var/dead_light = "#000099"

/datum/ai_icon/New(var/name, var/alive_icon, var/nopower_icon, var/dead_icon, var/alive_light, var/nopower_light, var/dead_light)
	if(name)
		src.name = name
		src.alive_icon = alive_icon
		src.nopower_icon = nopower_icon
		src.dead_icon = dead_icon
		src.alive_light = alive_light
		src.nopower_light = nopower_light
		src.dead_light = dead_light
	if(!ai_icons)
		ai_icons = list()
		init_subtypes(/datum/ai_icon, ai_icons)
	..()

/datum/ai_icon/red
	name = "Red"
	alive_icon = "ai-red"
	alive_light = "#F04848"

/datum/ai_icon/green
	name = "Green"
	alive_icon = "ai-wierd"
	alive_light = "#00FF99"

/datum/ai_icon/blue
	name = "Blue"
	alive_icon = "ai"
	alive_light = "#81DDFF"

/datum/ai_icon/angry
	name = "Angry"
	alive_icon = "ai-angryface"
	alive_light = "#FFFF33"

/datum/ai_icon/bliss
	name = "Bliss"
	alive_icon = "ai-bliss"
	alive_light = "#5C7A4A"

/datum/ai_icon/chatterbox
	name = "Chatterbox"
	alive_icon = "ai-president"
	alive_light = "#40666B"

/datum/ai_icon/database
	name = "Database"
	alive_icon = "ai-database"

/datum/ai_icon/dorf
	name = "Dorf"
	alive_icon = "ai-dorf"

/datum/ai_icon/dugtodeep
	name = "Dug Too Deep"
	alive_icon = "ai-toodeep"
	alive_light = "#81DDFF"

/datum/ai_icon/firewall
	name = "Firewall"
	alive_icon = "ai-magma"
	alive_light = "#FF4126"

/datum/ai_icon/glitchman
	name = "Glitchman"
	alive_icon = "ai-glitchman"

/datum/ai_icon/goon
	name = "Goon"
	alive_icon = "ai-goon"
	alive_light = "#3E5C80"

/datum/ai_icon/heartline
	name = "Heartline"
	alive_icon = "ai-heartline"
	dead_icon = "ai-heartline_dead"

/datum/ai_icon/helios
	name = "Helios"
	alive_icon = "ai-helios"
	alive_light = "#F2CF73"

/datum/ai_icon/inverted
	name = "Inverted"
	alive_icon = "ai-u"
	alive_light = "#81DDFF"

/datum/ai_icon/lonestar
	name = "Lonestar"
	alive_icon = "ai-lonestar"
	alive_light = "#58751C"

/datum/ai_icon/matrix
	name = "Matrix"
	alive_icon = "ai-matrix"
	alive_light = "#449944"

/datum/ai_icon/monochrome
	name = "Monochrome"
	alive_icon = "ai-mono"
	alive_light = "#585858"

/datum/ai_icon/nanotrasen
	name = "Nanotrasen"
	alive_icon = "ai-nanotrasen"
	alive_light = "#000029"

/datum/ai_icon/rainbow
	name = "Rainbow"
	alive_icon = "ai-clown"
	alive_light = "#E50213"

/datum/ai_icon/smiley
	name = "Smiley"
	alive_icon = "ai-smiley"
	alive_light = "#F3DD00"

/datum/ai_icon/soviet
	name = "Soviet"
	alive_icon = "ai-redoctober"
	alive_light = "#FF4307"

/datum/ai_icon/Static
	name = "Static"
	alive_icon = "ai-static"
	alive_light = "#4784C1"

/datum/ai_icon/text
	name = "Text"
	alive_icon = "ai-text"

/datum/ai_icon/trapped
	name = "Trapped"
	alive_icon = "ai-hades"

/datum/ai_icon/triumvirate_static
	name = "Triumvirate"
	alive_icon = "ai-triumvirate"
	alive_light = "#020B2B"

/datum/ai_icon/triumvirate_static
	name = "Triumvirate Static"
	alive_icon = "ai-static"
	alive_light = "#020B2B"

/datum/ai_icon/hotdogger
	name = "Dancing Hotdog"
	alive_icon = "ai-hotdog"
	alive_light = "#81DDFF"