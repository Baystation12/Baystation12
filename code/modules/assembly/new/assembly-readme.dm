/*
Code guide lines:
	Do not refer to any device specifically. E.G. for power, don't search
	for /obj/item/device/assembly/power_bank. Use the global proc for it,
	attempt_get_power_amount(var/amount) which will search every device,
	incase in the future someone wants to add another device which gives
	power without changing your code.

	Try to make all procs return either 1 or 0. This helps the player see
	where they went wrong if they can access the logs, for example.

	Do not use a wrench, screwdriver, wirecutter or multitool
	in holder_attackby, as they are overriden by the holder.


*/