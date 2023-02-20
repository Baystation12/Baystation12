/obj/machinery/suit_storage_unit
	icon = 'packs/infinity/icons/obj/suitstorage.dmi'
	icon_state = "ssu_classic"
	var/base_icon_state = "ssu_classic"


/obj/machinery/suit_storage_unit/on_update_icon()
	cut_overlays()
	//if things arent powered, these show anyways
	if(panelopen)
		add_overlay(image(icon,"[base_icon_state]_panel"))

	if(isopen)
		add_overlay(image(icon,"[base_icon_state]_open"))
		if(suit)
			add_overlay(image(icon,"[base_icon_state]_suit"))
		if(helmet)
			add_overlay(image(icon,"[base_icon_state]_helm"))
		if(boots || tank || mask)
			add_overlay(image(icon,"[base_icon_state]_storage"))
		if(isUV && issuperUV)
			add_overlay(image(icon,"[base_icon_state]_super"))

	if(!MACHINE_IS_BROKEN(src))
		if(isopen)
			add_overlay(image(icon,"[base_icon_state]_lights_open"))
		else
			if(isUV)
				add_overlay(image(icon,"[base_icon_state]_lights_red"))
			else
				add_overlay(image(icon,"[base_icon_state]_lights_closed"))
		//top lights
		if(isUV)
			if(issuperUV)
				add_overlay(overlay_image(icon,"[base_icon_state]_uvstrong", plane = EFFECTS_ABOVE_LIGHTING_PLANE, layer = ABOVE_LIGHTING_LAYER))
			else
				add_overlay(overlay_image(icon,"[base_icon_state]_uv", plane = EFFECTS_ABOVE_LIGHTING_PLANE, layer = ABOVE_LIGHTING_LAYER))
		else
			add_overlay(overlay_image(icon, "[base_icon_state]_ready", plane = EFFECTS_ABOVE_LIGHTING_PLANE, layer = ABOVE_LIGHTING_LAYER))

/obj/machinery/suit_storage_unit/industrial
	name = "industrial suit storage unit"
	icon_state = "industrial"
	base_icon_state = "industrial"
