/obj/effect/decal/cleanable/crayon
	name = "rune"
	desc = "A rune drawn in permanent marker."
	icon = 'icons/obj/rune.dmi'
	anchored = 1

	New(location,main = "#FFFFFF",shade = "#000000",var/type = "rune",description)
		..()
		loc = location
		desc = description

		name = type

		switch(type)
			if("rune")
				type = "rune[rand(1,6)]"
			if("graffiti")
				type = pick("amyjon","face","matt","revolution","engie","guy","end","dwarf","uboa")

		var/icon/mainOverlay = new/icon('icons/effects/crayondecal.dmi',"[type]",2.1)
		var/icon/shadeOverlay = new/icon('icons/effects/crayondecal.dmi',"[type]s",2.1)

		mainOverlay.Blend(main,ICON_ADD)
		shadeOverlay.Blend(shade,ICON_ADD)

		overlays += mainOverlay
		overlays += shadeOverlay

		add_hiddenprint(usr)
