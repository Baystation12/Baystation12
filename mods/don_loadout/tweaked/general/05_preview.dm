/datum/category_item/player_setup_item/physical/preview/content(mob/user)
	if(!pref.preview_icon)
		pref.update_preview_icon()
	send_rsc(user, pref.preview_icon, "previewicon.png")
	var/width = pref.preview_icon.Width()
	var/height = pref.preview_icon.Height()
	. = "<hr><b>Превью:</b>"
	. += "<br>[BTN("cyclebg", "Изменить фон")]"
	. += " - [BTN("previewgear", "[pref.preview_gear ? "Спрятать" : "Показать"] лодаут")]"
	. += " - [BTN("previewjob", "[pref.preview_job ? "Спрятать" : "Показать"] униформу")]"
	. += " - [BTN("resize", "Изменить размер")]"
	. += {"<br /><div class="statusDisplay" style="text-align:center"><img src="previewicon.png" width="[width]" height="[height]"></div>"}
