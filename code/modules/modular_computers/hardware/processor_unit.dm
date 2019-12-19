// CPU that allows the computer to run programs.
// Better CPUs are obtainable via research and can run more programs on background.

/obj/item/weapon/stock_parts/computer/processor_unit
	name = "standard processor"
	desc = "A standard CPU used in most computers."
	icon_state = "cpu_normal"
	hardware_size = 2
	power_usage = 100
	critical = 1
	malfunction_probability = 1
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)

	var/processing_power = 2 // Used for DDoS speed calculations

/obj/item/weapon/stock_parts/computer/processor_unit/small
	name = "standard microprocessor"
	desc = "A standard miniaturised CPU used in portable devices. It can run up to two programs simultaneously."
	icon_state = "cpu_small"
	hardware_size = 1
	power_usage = 25
	processing_power = 1
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)

/obj/item/weapon/stock_parts/computer/processor_unit/photonic
	name = "photonic processor"
	desc = "An advanced experimental CPU that uses photonic core instead of regular circuitry. It is more power efficient than its elecron analog."
	icon_state = "cpu_normal_photonic"
	hardware_size = 2
	power_usage = 50
	processing_power = 4
	origin_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 4)

/obj/item/weapon/stock_parts/computer/processor_unit/photonic/small
	name = "photonic microprocessor"
	desc = "An advanced miniaturised CPU for use in portable devices. It uses photonic core instead of regular circuitry. It is more power efficient than its elecron analog."
	icon_state = "cpu_small_photonic"
	hardware_size = 1
	power_usage = 10
	processing_power = 2
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
