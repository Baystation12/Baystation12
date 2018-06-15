
/mob/living/simple_animal/npc/New()
	..()
	if(prob(50))
		gender = FEMALE
	else
		gender = MALE
	sprite_set_human()
	real_name = random_name(gender)
	if(npc_job_title)
		name = "[real_name] ([npc_job_title])"
	else
		name = "[real_name] (NPC)"

	if(jumpsuits.len)
		var/newtype = pick(jumpsuits)
		var/new_item = new newtype(src)
		sprite_equip_human(new_item,slot_w_uniform_str)

	if(shoes.len)
		var/newtype = pick(shoes)
		var/new_item = new newtype(src)
		sprite_equip_human(new_item,slot_shoes_str)

	if(gloves.len && prob(glove_chance))
		var/newtype = pick(gloves)
		var/new_item = new newtype(src)
		sprite_equip_human(new_item,slot_gloves_str)

	if(suits.len && prob(suit_chance))
		var/newtype = pick(suits)
		var/new_item = new newtype(src)
		sprite_equip_human(new_item,slot_wear_suit_str)

	var/h_style
	var/image/res = image('icons/mob/human_face.dmi',"bald_s")
	if(hats.len && prob(hat_chance))
		var/newtype = pick(hats)
		var/new_item = new newtype(src)
		sprite_equip_human(new_item,slot_head_str)
	else
		//give them some head hair
		h_style = random_hair_style(gender)
		var/datum/sprite_accessory/hair/hair_style = hair_styles_list[h_style]
		/*if(owner.head && (owner.head.flags_inv & BLOCKHEADHAIR))
			if(!hair_style.veryshort)
				hair_style = hair_styles_list["Short Hair"]*/
		var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
		/*if(hair_style.do_colouration && islist(h_col) && h_col.len >= 3)
			hair_s.Blend(rgb(h_col[1], h_col[2], h_col[3]), ICON_ADD)*/
		res.overlays |= hair_s

	//give them some facial hair
	var/f_style = random_facial_hair_style(gender)
	var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[f_style]
	var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
	/*if(facial_hair_style.do_colouration)
		facial_s.Blend(rgb(owner.r_facial, owner.g_facial, owner.b_facial), ICON_ADD)*/
	res.overlays |= facial_s

	//skin_tone = random_skin_tone()
	overlays += res

	//update_interact_icon()

	trade_controller_debug = trade_controller

//this proc does not check the simple animal type! only use it on human type mobs
/mob/living/simple_animal/npc/proc/sprite_set_human()
	src.icon = 'npc.dmi'
	if(src.gender == FEMALE)
		src.icon_state = "body_f_s"
	else
		src.icon_state = "body_m_s"

//repository/images/proc/overlay_image(var/icon, var/icon_state, var/alpha, var/appearance_flags, var/color, var/dir, var/plane = FLOAT_PLANE, var/layer = FLOAT_LAYER)
/mob/living/simple_animal/npc/proc/sprite_equip_human(var/obj/item/I, var/slot)
	overlays += I.get_mob_overlay(src, slot)

/mob/living/simple_animal/npc/proc/update_interact_icon()
	src.dir = SOUTH
	interact_icon = getFlatIcon(src)

/mob/living/simple_animal/npc/Initialize()
	. = ..()
	generate_trade_items()
