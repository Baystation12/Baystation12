/datum/hud
	///UI for screentips that appear when you mouse over things
	var/obj/screen/screentip/screentip_text

/datum/hud/New()
	screentip_text = new(null, src)
	. = ..()

/datum/hud/Destroy()
	QDEL_NULL(screentip_text)
	. = ..()
