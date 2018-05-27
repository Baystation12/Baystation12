#define GC_TEST_TIME 140 SECONDS

datum/unit_test/computer_files_must_gc
	name = "GC: All computer files must garbage collect"
	async = 1
	var/start_time

datum/unit_test/computer_files_must_gc/start_test()
	var/obj/item/modular_computer/computer = new //Spawn a computer in nullspace for better testing.
	computer.hard_drive = new /obj/item/weapon/computer_hardware/hard_drive/cluster
	for(var/type in typesof(/datum/computer_file))
		qdel(new type) //nullspace test first
		var/file = new type
		computer.hard_drive.store_file(file)
		qdel(file) //Then from a hard drive, provided they can be stored in the first place.
	qdel(computer) //This also tests for whether preloaded programs can be gc'd
	start_time = world.time
	return 1

/datum/unit_test/computer_files_must_gc/check_result()
	if(world.time < GC_TEST_TIME)
		return 0
	pass("All computer files have garbage collected.") //Failure condition is to throw runtimes.
	return 1

#undef GC_TEST_TIME