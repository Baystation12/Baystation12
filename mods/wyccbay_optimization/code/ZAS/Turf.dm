//OVERRIDE

/turf/simulated/update_graphic(list/graphic_add = null, list/graphic_remove = null)
	if(length(graphic_add))
		vis_contents += graphic_add

	if(length(graphic_remove))
		vis_contents -= graphic_remove
