//airlock x4
//1
/obj/machinery/embedded_controller/radio/airlock/airlock_controller/minnoe/1
	tag_airpump = "minnoe_pump_1"
	tag_chamber_sensor = "minnoe_sensor_1"
	tag_exterior_door = "minnoe_exterior_1"
	tag_interior_door = "minnoe_interior_1"
	frequency = 1380
	id_tag = "minnoe_1"

/obj/machinery/door/airlock/external/bolted/minnoe/1
	frequency = 1380
	id_tag "minnoe_exterior_1"

/obj/machinery/door/airlock/external/bolted/minnoe/1
	frequency = 1380
	id_tag "minnoe_interior_1"

/obj/machinery/access_button/airlock_exterior/minnoe/1
	frequency = 1380
	master_tag = "minnoe_1"

/obj/machinery/access_button/airlock_interior/minnoe/1
	frequency = 1380
	master_tag = "minnoe_1"

/obj/machinery/airlock_sensor/minnoe/1
	frequency = 1380
	id_tag = "minnoe_sensor_1"

/obj/machinery/atmospherics/unary/vent_pump/high_volume/minnoe/1
	power_rating = 15000
	id_tag = "minnoe_pump_1"
