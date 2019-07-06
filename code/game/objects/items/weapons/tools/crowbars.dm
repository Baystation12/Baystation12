/obj/item/weapon/tool/crowbar
	name = "crowbar"
	desc = "A heavy crowbar of solid steel, good and solid in your hand."
	description_info = "Crowbars have countless uses: click on floor tiles to pry them loose. Use alongside a screwdriver to install or remove windows. Force open emergency shutters, or depowered airlocks. Open the panel of an unlocked APC. Pry a computer's circuit board free. And much more!"
	description_fluff = "As is the case with most standard-issue tools, crowbars are a simple and timeless design, the only difference being that advanced materials like plasteel have made them uncommonly tough."
	description_antag = "Need to bypass a bolted door? You can use a crowbar to pry the electronics out of an airlock, provided that it has no power and has been welded shut."
	icon_state = "crowbar"
	item_state = "crowbar"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = WEAPON_FORCE_PAINFULL
	worksound = WORKSOUND_EASY_CROWBAR
	w_class = ITEM_SIZE_NORMAL
	//storage_cost = ITEM_SIZE_NORMAL //Unimplemented mechanic to override automatic storage cost generation
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 400)
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")
	tool_qualities = list(QUALITY_PRYING = 25, QUALITY_DIGGING = 10)

//Comes with preapplied red paint
/obj/item/weapon/tool/crowbar/red
	icon_state = "red_crowbar"
	item_state = "crowbar_red"
	preinstalled_mods = list(/obj/item/weapon/tool_upgrade/productivity/red_paint)
	max_upgrades = 4 //It gets an extra mod slot for the preinstalled red paint

/obj/item/weapon/tool/crowbar/improvised
	name = "rebar"
	desc = "A pair of metal rods laboriously twisted into a useful shape"
	icon_state = "impro_crowbar"
	item_state = "crowbar"
	tool_qualities = list(QUALITY_PRYING = 10, QUALITY_DIGGING = 10)
	degradation = 5 //This one breaks REALLY fast


//A compact version of a crowbar which is pretty weak
/obj/item/weapon/tool/crowbar/prybar
	name = "pry bar"
	desc = "A steel bar with a wedge. It comes in a variety of configurations - collect them all."
	icon_state = "prybar"
	item_state = "crowbar"
	force = WEAPON_FORCE_WEAK
	throwforce = WEAPON_FORCE_WEAK
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 80)
	tool_qualities = list(QUALITY_PRYING = 5, QUALITY_DIGGING = 5)

/obj/item/weapon/tool/crowbar/prybar/Initialize()
	icon_state = "prybar[pick("","_red","_green","_aubergine","_blue")]"
	. = ..()

/obj/item/weapon/tool/crowbar/pneumatic
	name = "pneumatic crowbar"
	desc = "When you realy need to crack open something."
	icon_state = "pneumo_crowbar"
	item_state = "jackhammer"
	matter = list(MATERIAL_STEEL = 1200, MATERIAL_PLASTIC = 200)
	tool_qualities = list(QUALITY_PRYING = 40, QUALITY_DIGGING = 35)
	degradation = 0.07
	use_power_cost = 0.8
	max_upgrades = 4
	suitable_cell = /obj/item/weapon/cell
