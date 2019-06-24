#include "wizard_base_areas.dm"

/datum/game_mode/wizard
	overmap_template = /datum/map_template/ruin/gamemode_site/wizard_base

/obj/effect/overmap/sector/wizard_base
	name = "anomalous ion cloud"
	desc = "A large ion cloud causing unusual sensor readings."
	icon_state = "ion1"
	known = 0

/datum/map_template/ruin/gamemode_site/wizard_base
	name = "anomalous ion cloud"
	id = "awaysite_wizard_hideout"
	description = "A large ion cloud causing unusual sensor readings."
	suffixes = list("wizard/wizard_base.dmm")

/obj/effect/shuttle_landmark/wizard/nav1
	name = "Ion Cloud Navpoint #1"
	landmark_tag = "nav_wiz_1"

/obj/effect/shuttle_landmark/wizard/nav2
	name = "Ion Cloud Navpoint #2"
	landmark_tag = "nav_wiz_2"

/obj/item/weapon/spellbook/OnTopic(var/mob/living/carbon/human/user, href_list)
	if(href_list["reset"] && !(spellbook.book_flags & NOREVERT))
		var/area/map_template/wizard_station/A = get_area(user)
		if(istype(A))
			uses = spellbook.max_uses
			investing_time = 0
			has_sacrificed = 0
			user.spellremove()
			temp = "All spells and investments have been removed. You may now memorize a new set of spells."
			SSstatistics.add_field_details("wizard_spell_learned","UM") //please do not change the abbreviation to keep data processing consistent. Add a unique id to any new spells
		else
			to_chat(user, "<span class='warning'>You must be in the wizard academy to re-memorize your spells.</span>")
		. = TOPIC_REFRESH
	else . = ..()
