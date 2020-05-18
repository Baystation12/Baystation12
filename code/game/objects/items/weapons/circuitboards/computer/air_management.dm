/obj/item/weapon/stock_parts/circuitboard/air_management
	name = T_BOARD("atmosphere monitoring console")
	build_path = /obj/machinery/computer/air_control
	var/console_name
	var/frequency = 1441
	var/sensor_tag
	var/sensor_name
	var/list/sensor_information = list()

/obj/item/weapon/stock_parts/circuitboard/air_management/supermatter_core
	name = T_BOARD("core control")
	build_path = /obj/machinery/computer/air_control/supermatter_core
	frequency = 1438
	var/input_tag
	var/output_tag

	var/list/input_info = list()
	var/list/output_info = list()

	var/input_flow_setting = 700
	var/pressure_setting = 100

/obj/item/weapon/stock_parts/circuitboard/air_management/injector_control
	name = T_BOARD("injector control")
	build_path = /obj/machinery/computer/air_control/fuel_injection
	var/device_tag
	var/list/device_info
	var/automation = 0
	var/cutoff_temperature = 2000
	var/on_temperature = 1200

/************
* Construct *
************/
/obj/item/weapon/stock_parts/circuitboard/air_management/construct(var/obj/machinery/computer/air_control/C)
	if (..(C))
		if(console_name)
			C.SetName(console_name)
		C.set_frequency(frequency)
		C.sensor_tag = sensor_tag
		C.sensor_name = sensor_name
		C.sensor_info = sensor_information.Copy()
		return 1

/obj/item/weapon/stock_parts/circuitboard/air_management/supermatter_core/construct(var/obj/machinery/computer/air_control/supermatter_core/SC)
	if(..(SC))
		SC.input_tag = input_tag
		SC.output_tag = output_tag

		SC.input_info = input_info.Copy()
		SC.output_info = output_info.Copy()

		SC.input_flow_setting = input_flow_setting
		SC.pressure_setting = input_flow_setting
		return 1

/obj/item/weapon/stock_parts/circuitboard/air_management/injector_control/construct(var/obj/machinery/computer/air_control/fuel_injection/FI)
	if(..(FI))
		FI.device_tag = device_tag
		FI.device_info = device_info.Copy()
		FI.automation = automation
		FI.cutoff_temperature = cutoff_temperature
		FI.on_temperature = on_temperature
		return 1

/**************
* Deconstruct *
**************/
/obj/item/weapon/stock_parts/circuitboard/air_management/deconstruct(var/obj/machinery/computer/air_control/C)
	if (..(C))
		console_name = C.name
		frequency = C.frequency
		sensor_tag = C.sensor_tag
		sensor_name = C.sensor_name
		sensor_information = C.sensor_info.Copy()
		return 1

/obj/item/weapon/stock_parts/circuitboard/air_management/supermatter_core/deconstruct(var/obj/machinery/computer/air_control/supermatter_core/SC)
	if(..(SC))
		input_tag = SC.input_tag
		output_tag = SC.output_tag

		input_info = SC.input_info.Copy()
		output_info = SC.output_info.Copy()

		input_flow_setting = SC.input_flow_setting
		pressure_setting = SC.input_flow_setting
		return 1

/obj/item/weapon/stock_parts/circuitboard/air_management/injector_control/deconstruct(var/obj/machinery/computer/air_control/fuel_injection/FI)
	if(..(FI))
		device_tag = FI.device_tag
		device_info = FI.device_info.Copy()
		automation = FI.automation
		cutoff_temperature = FI.cutoff_temperature
		on_temperature = FI.on_temperature
		return 1