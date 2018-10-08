/decl/hierarchy/rd_shopping_article
	name = "shop article"
	var/cost = 0
	var/item_path = null
	var/amount = 1 // for stackables

/decl/hierarchy/rd_shopping_article/dociler
	name = "Dociler"
	cost = 2000
	item_path = /obj/item/device/dociler

/decl/hierarchy/rd_shopping_article/slimescanner
	name = "Slime scanner"
	cost = 1500
	item_path = /obj/item/device/slime_scanner

/decl/hierarchy/rd_shopping_article/rcdbin
	name = "High-capacity RCD matter bin"
	cost = 800
	item_path = /obj/item/weapon/rcd_ammo/large

/decl/hierarchy/rd_shopping_article/hypospray
	name = "Hypospray"
	cost = 2500
	item_path = /obj/item/weapon/reagent_containers/hypospray/vial

/decl/hierarchy/rd_shopping_article/oxycandle
	name = "Oxycandle"
	cost = 500
	item_path = /obj/item/device/oxycandle

/decl/hierarchy/rd_shopping_article/hypercapacity
	name = "Hyper-capacity power cell"
	cost = 1000
	item_path = /obj/item/weapon/cell/hyper
