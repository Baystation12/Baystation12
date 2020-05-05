
/obj/machinery/iv_drip/covenant
	name = "Covenant IV drip"
	icon = 'code/modules/halo/covenant/medical/medical.dmi'
	icon_state = "cov_unhooked"

/obj/machinery/iv_drip/update_icon()
	if(src.attached)
		icon_state = "cov_hooked"
	else
		icon_state = "cov_unhooked"

	overlays = null

	if(beaker)
		var/datum/reagents/reagents = beaker.reagents
		var/percent = round((reagents.total_volume / beaker.volume) * 100)
		if(reagents.total_volume)
			var/image/filling = image('icons/obj/iv_drip.dmi', src, "reagent")

			switch(percent)
				if(0 to 9)		filling.icon_state = "reagent0"
				if(10 to 24) 	filling.icon_state = "reagent10"
				if(25 to 49)	filling.icon_state = "reagent25"
				if(50 to 74)	filling.icon_state = "reagent50"
				if(75 to 79)	filling.icon_state = "reagent75"
				if(80 to 90)	filling.icon_state = "reagent80"
				if(91 to INFINITY)	filling.icon_state = "reagent100"
			filling.icon += reagents.get_color()
			overlays += filling
