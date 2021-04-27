/obj/machinery/chemical_dispenser/full
	spawn_cartridges = list(
			/obj/item/reagent_containers/chem_disp_cartridge/hydrazine,
			/obj/item/reagent_containers/chem_disp_cartridge/lithium,
			/obj/item/reagent_containers/chem_disp_cartridge/carbon,
			/obj/item/reagent_containers/chem_disp_cartridge/ammonia,
			/obj/item/reagent_containers/chem_disp_cartridge/acetone,
			/obj/item/reagent_containers/chem_disp_cartridge/sodium,
			/obj/item/reagent_containers/chem_disp_cartridge/aluminium,
			/obj/item/reagent_containers/chem_disp_cartridge/silicon,
			/obj/item/reagent_containers/chem_disp_cartridge/phosphorus,
			/obj/item/reagent_containers/chem_disp_cartridge/sulfur,
			/obj/item/reagent_containers/chem_disp_cartridge/hclacid,
			/obj/item/reagent_containers/chem_disp_cartridge/potassium,
			/obj/item/reagent_containers/chem_disp_cartridge/iron,
			/obj/item/reagent_containers/chem_disp_cartridge/copper,
			/obj/item/reagent_containers/chem_disp_cartridge/mercury,
			/obj/item/reagent_containers/chem_disp_cartridge/radium,
			/obj/item/reagent_containers/chem_disp_cartridge/water,
			/obj/item/reagent_containers/chem_disp_cartridge/ethanol,
			/obj/item/reagent_containers/chem_disp_cartridge/sugar,
			/obj/item/reagent_containers/chem_disp_cartridge/sacid,
			/obj/item/reagent_containers/chem_disp_cartridge/tungsten
		)

/obj/machinery/chemical_dispenser/ert
	name = "medicine dispenser"
	spawn_cartridges = list(
			/obj/item/reagent_containers/chem_disp_cartridge/inaprov,
			/obj/item/reagent_containers/chem_disp_cartridge/ryetalyn,
			/obj/item/reagent_containers/chem_disp_cartridge/paracetamol,
			/obj/item/reagent_containers/chem_disp_cartridge/tramadol,
			/obj/item/reagent_containers/chem_disp_cartridge/oxycodone,
			/obj/item/reagent_containers/chem_disp_cartridge/sterilizine,
			/obj/item/reagent_containers/chem_disp_cartridge/leporazine,
			/obj/item/reagent_containers/chem_disp_cartridge/kelotane,
			/obj/item/reagent_containers/chem_disp_cartridge/dermaline,
			/obj/item/reagent_containers/chem_disp_cartridge/dexalin,
			/obj/item/reagent_containers/chem_disp_cartridge/dexalin_p,
			/obj/item/reagent_containers/chem_disp_cartridge/tricord,
			/obj/item/reagent_containers/chem_disp_cartridge/dylovene,
			/obj/item/reagent_containers/chem_disp_cartridge/synaptizine,
			/obj/item/reagent_containers/chem_disp_cartridge/hyronalin,
			/obj/item/reagent_containers/chem_disp_cartridge/arithrazine,
			/obj/item/reagent_containers/chem_disp_cartridge/alkysine,
			/obj/item/reagent_containers/chem_disp_cartridge/imidazoline,
			/obj/item/reagent_containers/chem_disp_cartridge/peridaxon,
			/obj/item/reagent_containers/chem_disp_cartridge/bicaridine,
			/obj/item/reagent_containers/chem_disp_cartridge/hyperzine,
			/obj/item/reagent_containers/chem_disp_cartridge/rezadone,
			/obj/item/reagent_containers/chem_disp_cartridge/spaceacillin,
			/obj/item/reagent_containers/chem_disp_cartridge/ethylredox,
			/obj/item/reagent_containers/chem_disp_cartridge/sleeptox,
			/obj/item/reagent_containers/chem_disp_cartridge/chloral,
			/obj/item/reagent_containers/chem_disp_cartridge/cryoxadone,
			/obj/item/reagent_containers/chem_disp_cartridge/clonexadone
		)

/obj/machinery/chemical_dispenser/bar_soft
	name = "soft drink dispenser"
	desc = "A soft drink machine." //Doesn't just serve soda --BlueNexus
	icon_state = "soda_dispenser"
	ui_title = "Soda Dispenser"
	accept_drinking = 1
	core_skill = SKILL_COOKING
	can_contaminate = FALSE //It's not a complex panel, and I'm fairly sure that most people don't haymaker the control panel on a soft drinks machine. -- Chaoko99

/obj/machinery/chemical_dispenser/bar_soft/full
	spawn_cartridges = list(
			/obj/item/reagent_containers/chem_disp_cartridge/water,
			/obj/item/reagent_containers/chem_disp_cartridge/ice,
			/obj/item/reagent_containers/chem_disp_cartridge/coffee,
			/obj/item/reagent_containers/chem_disp_cartridge/hot_coco,
			/obj/item/reagent_containers/chem_disp_cartridge/cream,
			/obj/item/reagent_containers/chem_disp_cartridge/tea,
			/obj/item/reagent_containers/chem_disp_cartridge/green_tea,
			/obj/item/reagent_containers/chem_disp_cartridge/chai_tea,
			/obj/item/reagent_containers/chem_disp_cartridge/red_tea,
			/obj/item/reagent_containers/chem_disp_cartridge/cola,
			/obj/item/reagent_containers/chem_disp_cartridge/smw,
			/obj/item/reagent_containers/chem_disp_cartridge/dr_gibb,
			/obj/item/reagent_containers/chem_disp_cartridge/spaceup,
			/obj/item/reagent_containers/chem_disp_cartridge/tonic,
			/obj/item/reagent_containers/chem_disp_cartridge/sodawater,
			/obj/item/reagent_containers/chem_disp_cartridge/lemon_lime,
			/obj/item/reagent_containers/chem_disp_cartridge/sugar,
			/obj/item/reagent_containers/chem_disp_cartridge/orange,
			/obj/item/reagent_containers/chem_disp_cartridge/lime,
			/obj/item/reagent_containers/chem_disp_cartridge/watermelon
		)

/obj/machinery/chemical_dispenser/bar_alc
	name = "booze dispenser"
	desc = "A beer machine. Like a soda machine, but more fun!"
	icon_state = "booze_dispenser"
	ui_title = "Booze Dispenser"
	accept_drinking = 1
	core_skill = SKILL_COOKING
	can_contaminate = FALSE //See above.

/obj/machinery/chemical_dispenser/bar_alc/full
	spawn_cartridges = list(
			/obj/item/reagent_containers/chem_disp_cartridge/lemon_lime,
			/obj/item/reagent_containers/chem_disp_cartridge/sugar,
			/obj/item/reagent_containers/chem_disp_cartridge/orange,
			/obj/item/reagent_containers/chem_disp_cartridge/lime,
			/obj/item/reagent_containers/chem_disp_cartridge/sodawater,
			/obj/item/reagent_containers/chem_disp_cartridge/tonic,
			/obj/item/reagent_containers/chem_disp_cartridge/beer,
			/obj/item/reagent_containers/chem_disp_cartridge/kahlua,
			/obj/item/reagent_containers/chem_disp_cartridge/whiskey,
			/obj/item/reagent_containers/chem_disp_cartridge/wine,
			/obj/item/reagent_containers/chem_disp_cartridge/vodka,
			/obj/item/reagent_containers/chem_disp_cartridge/gin,
			/obj/item/reagent_containers/chem_disp_cartridge/rum,
			/obj/item/reagent_containers/chem_disp_cartridge/tequila,
			/obj/item/reagent_containers/chem_disp_cartridge/vermouth,
			/obj/item/reagent_containers/chem_disp_cartridge/cognac,
			/obj/item/reagent_containers/chem_disp_cartridge/ale,
			/obj/item/reagent_containers/chem_disp_cartridge/mead,
			/obj/item/reagent_containers/chem_disp_cartridge/triple_sec,
			/obj/item/reagent_containers/chem_disp_cartridge/creme_de_cacao,
			/obj/item/reagent_containers/chem_disp_cartridge/creme_de_menthe
		)

/obj/machinery/chemical_dispenser/bar_coffee
	name = "coffee dispenser"
	desc = "Driving crack dealers out of employment since 2280."
	icon_state = "coffee_dispenser"
	ui_title = "Coffee Dispenser"
	accept_drinking = 1
	core_skill = SKILL_COOKING
	can_contaminate = FALSE //See above.

/obj/machinery/chemical_dispenser/bar_coffee/full
	spawn_cartridges = list(
			/obj/item/reagent_containers/chem_disp_cartridge/coffee,
			/obj/item/reagent_containers/chem_disp_cartridge/decaf_cof,
			/obj/item/reagent_containers/chem_disp_cartridge/espresso,
			/obj/item/reagent_containers/chem_disp_cartridge/cafe_latte,
			/obj/item/reagent_containers/chem_disp_cartridge/soy_latte,
			/obj/item/reagent_containers/chem_disp_cartridge/hot_coco,
			/obj/item/reagent_containers/chem_disp_cartridge/milk,
			/obj/item/reagent_containers/chem_disp_cartridge/cream,
			/obj/item/reagent_containers/chem_disp_cartridge/tea,
			/obj/item/reagent_containers/chem_disp_cartridge/green_tea,
			/obj/item/reagent_containers/chem_disp_cartridge/chai_tea,
			/obj/item/reagent_containers/chem_disp_cartridge/red_tea,
			/obj/item/reagent_containers/chem_disp_cartridge/decaf_tea,
			/obj/item/reagent_containers/chem_disp_cartridge/ice,
			/obj/item/reagent_containers/chem_disp_cartridge/syrup_chocolate,
			/obj/item/reagent_containers/chem_disp_cartridge/syrup_caramel,
			/obj/item/reagent_containers/chem_disp_cartridge/syrup_vanilla,
			/obj/item/reagent_containers/chem_disp_cartridge/syrup_pumpkin
		)