/obj/machinery/suit_storage_unit
	icon = 'packs/infinity/icons/obj/suitstorage.dmi'
	icon_state = "ssu_classic"
	var/base_icon_state = "ssu_classic"


/obj/machinery/suit_storage_unit/on_update_icon()
	ClearOverlays()
	//if things arent powered, these show anyways
	if(panelopen)
		AddOverlays(image(icon,"[base_icon_state]_panel"))

	if(isopen)
		AddOverlays(image(icon,"[base_icon_state]_open"))
		if(suit)
			AddOverlays(image(icon,"[base_icon_state]_suit"))
		if(helmet)
			AddOverlays(image(icon,"[base_icon_state]_helm"))
		if(boots || tank || mask)
			AddOverlays(image(icon,"[base_icon_state]_storage"))
		if(isUV && issuperUV)
			AddOverlays(image(icon,"[base_icon_state]_super"))

	if(!MACHINE_IS_BROKEN(src))
		if(isopen)
			AddOverlays(image(icon,"[base_icon_state]_lights_open"))
		else
			if(isUV)
				AddOverlays(image(icon,"[base_icon_state]_lights_red"))
			else
				AddOverlays(image(icon,"[base_icon_state]_lights_closed"))
		//top lights
		if(isUV)
			if(issuperUV)
				AddOverlays(overlay_image(icon,"[base_icon_state]_uvstrong", plane = EFFECTS_ABOVE_LIGHTING_PLANE, layer = ABOVE_LIGHTING_LAYER))
			else
				AddOverlays(overlay_image(icon,"[base_icon_state]_uv", plane = EFFECTS_ABOVE_LIGHTING_PLANE, layer = ABOVE_LIGHTING_LAYER))
		else
			AddOverlays(overlay_image(icon, "[base_icon_state]_ready", plane = EFFECTS_ABOVE_LIGHTING_PLANE, layer = ABOVE_LIGHTING_LAYER))

/obj/machinery/suit_storage_unit/industrial
	name = "industrial suit storage unit"
	icon_state = "industrial"
	base_icon_state = "industrial"
