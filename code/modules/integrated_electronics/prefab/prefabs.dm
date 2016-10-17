/decl/prefab/ic_assembly/hand_teleporter
	assembly_name = "hand tele"
	assembly_type = /obj/item/device/electronic_assembly
	shell_type = /obj/item/electronic_assembly_shell/hand_teleporter
	ic_types = list(
		/obj/item/integrated_circuit/manipulation/bluespace_rift = "bluespace gen",
		/obj/item/integrated_circuit/input/teleporter_locator = "Teleport Locator",
		/obj/item/integrated_circuit/input/button = "Open Rift"
	)
	connections = newlist(
		/datum/ic_assembly_connection/output_to_input {
			circuit_index_a = 2
			circuit_index_b = 1
			io_pin_index_a = 1
			io_pin_index_b = 1
		},
		/datum/ic_assembly_connection/activator_to_activator {
			circuit_index_a = 1
			circuit_index_b = 3
			io_pin_index_a = 1
			io_pin_index_b = 1
		}
	)

/obj/prefab/hand_teleporter
	prefab_type = /decl/prefab/ic_assembly/hand_teleporter
