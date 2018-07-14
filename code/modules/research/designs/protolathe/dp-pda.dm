// PDA and cartridges
/datum/design/item/pda
	name = "PDA design"
	desc = "Cheaper than whiny non-digital assistants."
	id = "pda"
	req_tech = list(TECH_ENGINEERING = 2, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	build_path = /obj/item/device/pda
	sort_string = "VCAAA"
	category_items = "PDA"

/datum/design/item/pda_cartridge
	req_tech = list(TECH_ENGINEERING = 2, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	category_items = "PDA"

/datum/design/item/pda_cartridge/cart_basic
	id = "cart_basic"
	build_path = /obj/item/weapon/cartridge
	sort_string = "VCBAA"

/datum/design/item/pda_cartridge/engineering
	id = "cart_engineering"
	build_path = /obj/item/weapon/cartridge/engineering
	sort_string = "VCBAB"

/datum/design/item/pda_cartridge/atmos
	id = "cart_atmos"
	build_path = /obj/item/weapon/cartridge/atmos
	sort_string = "VCBAC"

/datum/design/item/pda_cartridge/medical
	id = "cart_medical"
	build_path = /obj/item/weapon/cartridge/medical
	sort_string = "VCBAD"

/datum/design/item/pda_cartridge/chemistry
	id = "cart_chemistry"
	build_path = /obj/item/weapon/cartridge/chemistry
	sort_string = "VCBAE"

/datum/design/item/pda_cartridge/security
	id = "cart_security"
	build_path = /obj/item/weapon/cartridge/security
	sort_string = "VCBAF"

/datum/design/item/pda_cartridge/janitor
	id = "cart_janitor"
	build_path = /obj/item/weapon/cartridge/janitor
	sort_string = "VCBAG"

/datum/design/item/pda_cartridge/science
	id = "cart_science"
	build_path = /obj/item/weapon/cartridge/signal/science
	sort_string = "VCBAH"

/datum/design/item/pda_cartridge/quartermaster
	id = "cart_quartermaster"
	build_path = /obj/item/weapon/cartridge/quartermaster
	sort_string = "VCBAI"

/datum/design/item/pda_cartridge/hop
	id = "cart_hop"
	build_path = /obj/item/weapon/cartridge/hop
	sort_string = "VCBAJ"

/datum/design/item/pda_cartridge/hos
	id = "cart_hos"
	build_path = /obj/item/weapon/cartridge/hos
	sort_string = "VCBAK"

/datum/design/item/pda_cartridge/ce
	id = "cart_ce"
	build_path = /obj/item/weapon/cartridge/ce
	sort_string = "VCBAL"

/datum/design/item/pda_cartridge/cmo
	id = "cart_cmo"
	build_path = /obj/item/weapon/cartridge/cmo
	sort_string = "VCBAM"

/datum/design/item/pda_cartridge/rd
	id = "cart_rd"
	build_path = /obj/item/weapon/cartridge/rd
	sort_string = "VCBAN"

/datum/design/item/pda_cartridge/captain
	id = "cart_captain"
	build_path = /obj/item/weapon/cartridge/captain
	sort_string = "VCBAO"