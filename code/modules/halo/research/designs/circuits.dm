
/datum/research_design/circuit
	build_type = IMPRINTER
	complexity = 8
	category_type = /datum/research_design/circuit
	required_materials = list("steel" = 1, "glass" = 1)
	required_reagents = list(/datum/reagent/acid = 20)

/datum/research_design/circuit/recharger
	name = T_BOARD("energy weapon recharging station")
	product_type = /obj/item/weapon/circuitboard/recharger

/datum/research_design/circuit/cell_charger
	name = T_BOARD("energy cell recharging station")
	product_type = /obj/item/weapon/circuitboard/cell_charger

/datum/research_design/circuit/destructive_analyser
	name = T_BOARD("destructive analyser")
	product_type = /obj/item/weapon/circuitboard/destructor

/datum/research_design/circuit/dissassembler
	name = T_BOARD("component disassembly")
	product_type = /obj/item/weapon/circuitboard/dissembler

/datum/research_design/circuit/protolathe
	name = T_BOARD("protolathe")
	product_type = /obj/item/weapon/circuitboard/protolathe

/datum/research_design/circuit/circuit_printer
	name = T_BOARD("circuit imprinter")
	product_type = /obj/item/weapon/circuitboard/circuit_printer
