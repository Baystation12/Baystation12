/mob/living/carbon/alien/chorus/OnSelfTopic(var/href_list)
	if(href_list["selected"])
		var/datum/chorus_building/cb = chorus_type.form.get_building_by_type(href_list["selected"])
		if(cb)
			set_selected_building(cb)
		return TOPIC_HANDLED
	return ..()