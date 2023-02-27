/obj/item/clothing/accessory/locket
	var/message

/obj/item/clothing/accessory/locket/examine(mob/user)
	. = ..()
	if(open && message)
		to_chat(user, "<span class='notice'>[message]</span>")

/obj/item/photo
	var/prewiew_scale = 64 // В целях правильного масштабирования кастомных фоток ~bear1ake
	var/sprite_offset = 32 // В целях правильного расчета спрайта

/obj/item/photo/on_update_icon()
	overlays.Cut()
	var/scale = 8/(photo_size*sprite_offset)
	var/image/small_img = image(img)
	small_img.transform *= scale
	small_img.pixel_x = -sprite_offset*(photo_size-1)/2 - 3
	small_img.pixel_y = -sprite_offset*(photo_size-1)/2
	overlays |= small_img

	tiny = image(img)
	tiny.transform *= 0.5*scale
	tiny.underlays += image('icons/obj/bureaucracy.dmi', "photo")
	tiny.pixel_x = -sprite_offset*(photo_size-1)/2 - 3
	tiny.pixel_y = -sprite_offset*(photo_size-1)/2 + 3

/obj/item/clothing/accessory/locket/inherit_custom_item_data(datum/custom_item/citem)
	. = ..()
	if(LAZYACCESS(citem.additional_data, "photo_path"))
		var/obj/item/photo/P = new()
		P.img = icon(citem.additional_data["photo_path"])
		P.sprite_offset = citem.additional_data["sprite_offset"]
		P.prewiew_scale = citem.additional_data["prewiew_scale"]
		P.update_icon()
		if(LAZYACCESS(citem.additional_data, "photo_desc"))
			P.desc = citem.additional_data["photo_desc"]
		held = P
	if(LAZYACCESS(citem.additional_data, "message"))
		message = citem.additional_data["message"]
