/decl/prefab/ic_assembly/hand_teleporter
	assembly_name = "hand-teleporter"
	assembly_type = /obj/item/device/electronic_assembly
	shell_type = /obj/item/electronic_assembly_shell/hand_teleporter
	integrated_circuits = newlist(               // Index,
		/datum/ic_assembly_integrated_circuits { // 1,
			circuit_type = /obj/item/integrated_circuit/manipulation/bluespace_rift
		},
		/datum/ic_assembly_integrated_circuits { // 2,
			circuit_type = /obj/item/integrated_circuit/input/teleporter_locator
		},
		/datum/ic_assembly_integrated_circuits { // 3,
			circuit_type = /obj/item/integrated_circuit/input/button;
			circuit_name = "Open Rift"
		}
	)
	connections = newlist(
		/datum/ic_assembly_connection/output_to_input {
			circuit_index_a = 2; // Teleport Control Locator to
			circuit_index_b = 1  // Bluespace Generator Input
		},
		/datum/ic_assembly_connection/activator_to_activator {
			circuit_index_a = 1; // Open Rift (button) to
			circuit_index_b = 3  // Bluespace Rift Generator
		}
	)

/obj/prefab/hand_teleporter
	prefab_type = /decl/prefab/ic_assembly/hand_teleporter

/decl/prefab/ic_assembly/proximity_frag_grenade_assembly
	assembly_type = /obj/item/device/electronic_assembly/medium
	integrated_circuits = newlist(
		/datum/ic_assembly_integrated_circuits { // 1,
			circuit_type = /obj/item/integrated_circuit/manipulation/grenade/frag
		},
		/datum/ic_assembly_integrated_circuits { // 2,
			circuit_type = /obj/item/integrated_circuit/sensor/proximity/proximity
		},
		/datum/ic_assembly_integrated_circuits { // 3,
			circuit_type = /obj/item/integrated_circuit/time/delay/five_sec
		},
		/datum/ic_assembly_integrated_circuits { // 4,
			circuit_type = /obj/item/integrated_circuit/memory/constant
		},
		/datum/ic_assembly_integrated_circuits { // 5,
			circuit_type = /obj/item/integrated_circuit/output/led/red;
			circuit_name = "Arming"
		},
		/datum/ic_assembly_integrated_circuits { // 6,
			circuit_type = /obj/item/integrated_circuit/output/led/red;
			circuit_name = "Armed"
		},
		/datum/ic_assembly_integrated_circuits { // 7 - Starts the whole setup,
			circuit_type = /obj/item/integrated_circuit/input/button;
			circuit_name = "Arm"
		},
		/datum/ic_assembly_integrated_circuits { // 8 - Audible warning 1,
			circuit_type = /obj/item/integrated_circuit/output/sound/beeper
		},
		/datum/ic_assembly_integrated_circuits { // 9 - Audible warning 2,
			circuit_type = /obj/item/integrated_circuit/output/sound/beepsky
		},
		/datum/ic_assembly_integrated_circuits { // 10 - Used to ensure the Armed LED doesn't light up until the prox sensor is enabled,
			circuit_type = /obj/item/integrated_circuit/memory
		},
		/datum/ic_assembly_integrated_circuits { // 11 - Used to ensure things are activated in the expected order, every time,
			circuit_type = /obj/item/integrated_circuit/transfer/activator_splitter/medium
		}
	)
	value_presets = newlist(
		/datum/ic_assembly_value_preset/output {
			circuit_index = 4; // Give Constant a value of
			value = 1
		},
		/datum/ic_assembly_value_preset/input {
			circuit_index = 8; // Give Beeper - Sound a value of
			value = "beep"
		},
		/datum/ic_assembly_value_preset/input {
			circuit_index = 8; // Give Beeper - Volume a value of
			value = 50;
			io_pin_index = 2
		},
		/datum/ic_assembly_value_preset/input {
			circuit_index = 9; // Give Beepsky - Sound a value of
			value = "freeze"
		},
		/datum/ic_assembly_value_preset/input {
			circuit_index = 9; // Give Beepsky - Volume a value of
			value = 50;
			io_pin_index = 2
		},
		/datum/ic_assembly_value_preset/input {
			circuit_index = 1; // Give !Grenade! a detonation time of
			value = 1
		}
	)
	connections = newlist(
		/datum/ic_assembly_connection/activator_to_activator {
			circuit_index_a = 7; // Button to
			circuit_index_b = 3  // Timed Delay
		},
		/datum/ic_assembly_connection/activator_to_activator {
			circuit_index_a = 7; // Button to
			circuit_index_b = 4  // Constant
		},
		/datum/ic_assembly_connection/activator_to_activator {
			circuit_index_a = 7; // Button to
			circuit_index_b = 8  // Beeper
		},
		/datum/ic_assembly_connection/activator_to_activator {
			circuit_index_a = 3;  // Timed Delay to
			circuit_index_b = 11; // Splitter
			io_pin_index_a = 2    // Outgoing pulse
		},
		/datum/ic_assembly_connection/activator_to_activator {
			circuit_index_a = 11; // Splitter to
			circuit_index_b = 9;  // Beepsky
			io_pin_index_a = 2    // Trigger first
		},
		/datum/ic_assembly_connection/activator_to_activator {
			circuit_index_a = 11; // Splitter to
			circuit_index_b = 10; // Memory
			io_pin_index_a = 3    // Trigger second
		},
		/datum/ic_assembly_connection/activator_to_activator {
			circuit_index_a = 11; // Splitter
			circuit_index_b = 2;  // Proximity Sensor
			io_pin_index_a = 4    // Trigger last
		},
		/datum/ic_assembly_connection/activator_to_activator {
			circuit_index_a = 2; // Proximity Sensor to
			circuit_index_b = 1; // !Grenade! when
			io_pin_index_a = 2   // Sensor Trigger
		},
		/datum/ic_assembly_connection/output_to_input {
			circuit_index_a = 4; // Constant to
			circuit_index_b = 5  // Arming LED
		},
		/datum/ic_assembly_connection/output_to_input {
			circuit_index_a = 4; // Constant to
			circuit_index_b = 10 // Memory
		},
		/datum/ic_assembly_connection/output_to_input {
			circuit_index_a = 10; // Memory to
			circuit_index_b = 6   // Armed LED
		},
		/datum/ic_assembly_connection/output_to_input {
			circuit_index_a = 10; // Memory to
			circuit_index_b = 2   // Proximity Sensor
		}
	)

/obj/prefab/proximity_frag_grenade
	prefab_type = /decl/prefab/ic_assembly/proximity_frag_grenade_assembly
