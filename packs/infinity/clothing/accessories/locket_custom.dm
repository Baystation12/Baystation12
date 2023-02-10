/obj/item/clothing/accessory/locket/inherit_custom_item_data(datum/custom_item/citem)
	. = ..()
	if(list_find(citem.additional_data, "photo_path"))
		var/obj/item/photo/P = new()
		P.img = icon(citem.additional_data["photo_path"])
		P.sprite_offset = citem.additional_data["sprite_offset"]
		P.prewiew_scale = citem.additional_data["prewiew_scale"]
		P.update_icon()
		if(list_find(citem.additional_data, "photo_desc"))
			P.desc = citem.additional_data["photo_desc"]
		held = P
	if(list_find(citem.additional_data, "message"))
		message = citem.additional_data["message"]
