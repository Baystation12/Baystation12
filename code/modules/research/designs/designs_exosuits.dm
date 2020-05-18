/datum/design/circuit/exosuit/AssembleDesignName()
	name = "Exosuit software design ([name])"
/datum/design/circuit/exosuit/AssembleDesignDesc()
	desc = "Allows for the construction of \a [name] module."

/datum/design/circuit/exosuit/engineering
	name = "engineering system control"
	id = "mech_software_engineering"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/weapon/circuitboard/exosystem/engineering
	sort_string = "NAAAA"

/datum/design/circuit/exosuit/utility
	name = "utility system control"
	id = "mech_software_utility"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/weapon/circuitboard/exosystem/utility
	sort_string = "NAAAB"

/datum/design/circuit/exosuit/medical
	name = "medical system control"
	id = "mech_software_medical"
	req_tech = list(TECH_DATA = 3,TECH_BIO = 2)
	build_path = /obj/item/weapon/circuitboard/exosystem/medical
	sort_string = "NAABA"

/datum/design/circuit/exosuit/weapons
	name = "basic weapon control"
	id = "mech_software_weapons"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/exosystem/weapons
	sort_string = "NAACA"