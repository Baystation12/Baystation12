/obj/item/weapon/tool/pickaxe
	name = "pickaxe"
	desc = "The most basic of mining tools, for short excavations and small mineral extractions."
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = WEAPON_FORCE_DANGEROUS
	throwforce = WEAPON_FORCE_NORMAL
	icon_state = "pickaxe"
	item_state = "pickaxe"
	w_class = ITEM_SIZE_LARGE
	matter = list(MATERIAL_STEEL = 600)
	tool_qualities = list(QUALITY_DIGGING = 30, QUALITY_PRYING = 20, QUALITY_EXCAVATION = 10)
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	attack_verb = list("hit", "pierced", "sliced", "attacked")
	sharp = 1
	//structure_damage_factor = 3 //Drills and picks are made for getting through hard materials
	//They are the best anti-structure melee weapons
	//embed_mult = 1.2 //Digs deep

/obj/item/weapon/tool/pickaxe/jackhammer
	name = "jackhammer"
	icon_state = "jackhammer"
	item_state = "jackhammer"
	matter = list(MATERIAL_STEEL = 900, MATERIAL_PLASTIC = 600)
	tool_qualities = list(QUALITY_DIGGING = 35, QUALITY_EXCAVATION = 10)
	origin_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	desc = "Cracks rocks with blasts, perfect for killing cave lizards."
	degradation = 0.07
	use_power_cost = 0.6
	suitable_cell = /obj/item/weapon/cell

/obj/item/weapon/tool/pickaxe/drill
	name = "mining drill" // Can dig sand as well!
	icon_state = "handdrill"
	item_state = "jackhammer"
	tool_qualities = list(QUALITY_DIGGING = 40, QUALITY_DRILLING = 10, QUALITY_EXCAVATION = 15)
	matter = list(MATERIAL_STEEL = 1200, MATERIAL_PLASTIC = 800)
	origin_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	desc = "Yours is the drill that will pierce through the rock walls."
	degradation = 0.07
	use_fuel_cost = 0.15
	max_fuel = 100

/obj/item/weapon/tool/pickaxe/diamonddrill
	name = "diamond-point mining drill"
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	force = WEAPON_FORCE_DANGEROUS*1.15
	tool_qualities = list(QUALITY_DIGGING = 50, QUALITY_DRILLING = 20, QUALITY_EXCAVATION = 15)
	matter = list(MATERIAL_STEEL = 1600, MATERIAL_PLASTIC = 500, MATERIAL_DIAMOND = 800)
	origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 5)
	desc = "Yours is the drill that will pierce the heavens!"
	max_upgrades = 4
	degradation = 0.01
	use_fuel_cost = 0.15
	max_fuel = 120

/obj/item/weapon/tool/pickaxe/diamonddrill/rig
	use_fuel_cost = 0
	passive_fuel_cost = 0

/obj/item/weapon/tool/pickaxe/excavation
	name = "hand pickaxe"
	icon_state = "pick_hand"
	item_state = "syringe_0"
	throwforce = WEAPON_FORCE_NORMAL //It's smaller
	desc = "A smaller, more precise version of the pickaxe, used for archeology excavation."
	tool_qualities = list(QUALITY_DIGGING = 15, QUALITY_PRYING = 15, QUALITY_EXCAVATION = 30)
	w_class = ITEM_SIZE_NORMAL
	matter = list(MATERIAL_STEEL = 800)
