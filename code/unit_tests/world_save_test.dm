#ifdef UNIT_TEST
/datum/sample_obj/test_container
	var/test_var
	var/test_var_2
	var/test_var_3

/datum/sample_obj/test_container/proc/test_proc()
	return 1

/datum/unit_test/persistence
	var/datum/persistence/serializer/serializer = new()
	template = /datum/unit_test/persistence
	async = 0
	name = "PERSISTENCE template"

/datum/unit_test/persistence/proc/reset_serializer()
	serializer = new /datum/persistence/serializer()

/datum/unit_test/persistence/text_saveable
	name = "PERSISTENCE: Text is saveable by serializer."

/datum/unit_test/persistence/text_saveable/start_test()
	try
		reset_serializer()

		var/S = "Foo!@#$%^&*()-=`1234567890\"''"
		var/correct_sql = "(1,1,'test_var','TEXT',\"[sanitizeSQL(S)]\",1)"
		var/datum/sample_obj/test_container/T = new()
		T.test_var = S
		serializer.SerializeThing(T)

		if(serializer.var_inserts[1] != correct_sql)
			fail("Text was not saved correctly. Got '[serializer.var_inserts[1]]' and expected '[correct_sql]'.")
		else
			pass("Text is serializing correctly.")
	catch(var/exception/e)
		fail("Text was not saved correctly. Caught exception on line[e.line] at [e.file] with msg '[e]'.")
	return 1

/datum/unit_test/persistence/numbers_saveable
	name = "PERSISTENCE: Numbers are saveable by serializer."

/datum/unit_test/persistence/numbers_saveable/start_test()
	try
		reset_serializer()

		var/S = 12345
		var/correct_sql = "(1,1,'test_var','NUM',\"12345\",1)"
		var/datum/sample_obj/test_container/T = new()
		T.test_var = S
		serializer.SerializeThing(T)

		if(serializer.var_inserts[1] != correct_sql)
			fail("Number was not saved correctly. Got '[serializer.var_inserts[1]]' and expected '[correct_sql]'.")
		else
			pass("Number is serializing correctly.")
	catch(var/exception/e)
		fail("Number was not saved correctly. Caught exception on line[e.line] at [e.file] with msg '[e]'.")
	return 1

/datum/unit_test/persistence/nulls_saveable
	name = "PERSISTENCE: Null values are saveable by serializer."

/datum/unit_test/persistence/nulls_saveable/start_test()
	try
		reset_serializer()

		var/S = null
		var/correct_sql = "(1,1,'test_var','NULL',\"\",1)"
		var/datum/sample_obj/test_container/T = new()
		T.test_var = S
		serializer.SerializeThing(T)

		if(serializer.var_inserts[1] != correct_sql)
			fail("Null was not saved correctly. Got '[serializer.var_inserts[1]]' and expected '[correct_sql]'.")
		else
			pass("Null is serializing correctly.")
	catch(var/exception/e)
		fail("Null was not saved correctly. Caught exception on line[e.line] at [e.file] with msg '[e]'.")
	return 1

/datum/unit_test/persistence/objects_saveable
	name = "PERSISTENCE: Objects are saveable by serializer."

/datum/unit_test/persistence/objects_saveable/start_test()
	try
		reset_serializer()

		var/S = new /datum/sample_obj/test_container()
		var/correct_sql = "(1,1,'test_var','OBJ',\"2\",1)"
		var/datum/sample_obj/test_container/T = new()
		T.test_var = S
		serializer.SerializeThing(T)

		var/found_var = FALSE
		for(var/insert in serializer.var_inserts)
			if(insert == correct_sql)
				found_var = TRUE
				break
		if(!found_var)
			fail("Object was not saved correctly. Unable to find serialized object in inserts.")
		else
			pass("Object is serializing correctly.")
	catch(var/exception/e)
		fail("Object was not saved correctly. Caught exception on line[e.line] at [e.file] with msg '[e]'.")
	return 1

/datum/unit_test/persistence/recursion_saveable
	name = "PERSISTENCE: Recursive Objects are saveable by serializer."

/datum/unit_test/persistence/recursion_saveable/start_test()
	try
		reset_serializer()
		var/correct_sql = "(1,1,'test_var','OBJ',\"1\",1)"
		var/datum/sample_obj/test_container/T = new()
		T.test_var = T
		serializer.SerializeThing(T)

		if(serializer.var_inserts[1] != correct_sql)
			fail("Recursive Object was not saved correctly. Got '[serializer.var_inserts[1]]' and expected '[correct_sql]'.")
		else
			pass("Recursive Object is serializing correctly.")
	catch(var/exception/e)
		fail("Recursive Object was not saved correctly. Caught exception on line[e.line] at [e.file] with msg '[e]'.")
	return 1

/datum/unit_test/persistence/paths_saveable
	name = "PERSISTENCE: Paths are saveable by serializer."

/datum/unit_test/persistence/paths_saveable/start_test()
	try
		reset_serializer()

		var/S = /datum/sample_obj/test_container
		var/correct_sql = "(1,1,'test_var','PATH',\"/datum/sample_obj/test_container\",1)"
		var/datum/sample_obj/test_container/T = new()
		T.test_var = S
		serializer.SerializeThing(T)

		if(serializer.var_inserts[1] != correct_sql)
			fail("Path was not saved correctly. Got '[serializer.var_inserts[1]]' and expected '[correct_sql]'.")
		else
			pass("Path is serializing correctly.")
	catch(var/exception/e)
		fail("Path was not saved correctly. Caught exception on line[e.line] at [e.file] with msg '[e]'.")
	return 1

/datum/unit_test/persistence/procs_saveable
	name = "PERSISTENCE: Procs are saveable by serializer."

/datum/unit_test/persistence/procs_saveable/start_test()
	try
		reset_serializer()

		var/S = /datum/sample_obj/test_container/proc/test_proc
		var/correct_sql = "(1,1,'test_var','PATH',\"/datum/sample_obj/test_container/proc/test_proc\",1)"
		var/datum/sample_obj/test_container/T = new()
		T.test_var = S
		serializer.SerializeThing(T)

		if(serializer.var_inserts[1] != correct_sql)
			fail("Proc was not saved correctly. Got '[serializer.var_inserts[1]]' and expected '[correct_sql]'.")
		else
			pass("Proc is serializing correctly.")
	catch(var/exception/e)
		fail("Proc was not saved correctly. Caught exception on line[e.line] at [e.file] with msg '[e]'.")
	return 1

/datum/unit_test/persistence/lists_saveable
	name = "PERSISTENCE: Lists are saveable by serializer."

/datum/unit_test/persistence/lists_saveable/start_test()
	try
		reset_serializer()

		var/S = list("foo")
		var/correct_sql = "(1,1,'test_var','LIST',\"1\",1)"
		var/list_insert = "(1,1,1)"
		var/element_insert = "(1,1,1,\"foo\",'TEXT',\"\",\"NULL\",1)"
		var/datum/sample_obj/test_container/T = new()
		T.test_var = S
		serializer.SerializeThing(T)

		if(serializer.var_inserts[1] != correct_sql)
			fail("List was not saved correctly. Invalid var insert. Got '[serializer.var_inserts[1]]' and expected '[correct_sql]'.")
		else if(serializer.list_inserts[1] != list_insert)
			fail("List was not saved correctly. Invalid list insert. Got '[serializer.list_inserts[1]]' and expected '[list_insert]'.")
		else if(serializer.element_inserts[1] != element_insert)
			fail("List was not saved correctly. Invalid element insert. Got '[serializer.element_inserts[1]]' and expected '[element_insert]'.")
		else
			pass("List is serializing correctly.")
	catch(var/exception/e)
		fail("List was not saved correctly. Caught exception on line[e.line] at [e.file] with msg '[e]'.")
	return 1

/datum/unit_test/persistence/dicts_saveable
	name = "PERSISTENCE: Dicts are saveable by serializer."

/datum/unit_test/persistence/dicts_saveable/start_test()
	try
		reset_serializer()

		var/S = list()
		S["foo"] = "bar"
		var/correct_sql = "(1,1,'test_var','LIST',\"1\",1)"
		var/list_insert = "(1,1,1)"
		var/element_insert = "(1,1,1,\"foo\",'TEXT',\"bar\",\"TEXT\",1)"
		var/datum/sample_obj/test_container/T = new()
		T.test_var = S
		serializer.SerializeThing(T)

		if(serializer.var_inserts[1] != correct_sql)
			fail("Dict was not saved correctly. Invalid var insert. Got '[serializer.var_inserts[1]]' and expected '[correct_sql]'.")
		else if(serializer.list_inserts[1] != list_insert)
			fail("Dict was not saved correctly. Invalid list insert. Got '[serializer.list_inserts[1]]' and expected '[list_insert]'.")
		else if(serializer.element_inserts[1] != element_insert)
			fail("Dict was not saved correctly. Invalid element insert. Got '[serializer.element_inserts[1]]' and expected '[element_insert]'.")
		else
			pass("Dict is serializing correctly.")
	catch(var/exception/e)
		fail("Dict was not saved correctly. Caught exception on line[e.line] at [e.file] with msg '[e]'.")
	return 1

/datum/unit_test/persistence/mixed_list_saveable
	name = "PERSISTENCE: Mixed lists are saveable by serializer."

/datum/unit_test/persistence/mixed_list_saveable/start_test()
	try
		reset_serializer()

		var/S = list("zed")
		S["foo"] = "bar"
		var/correct_sql = "(1,1,'test_var','LIST',\"1\",1)"
		var/element_insert = "(1,1,1,\"zed\",'TEXT',\"\",\"NULL\",1)"
		var/element2_insert = "(2,1,2,\"foo\",'TEXT',\"bar\",\"TEXT\",1)"
		var/datum/sample_obj/test_container/T = new()
		T.test_var = S
		serializer.SerializeThing(T)

		if(serializer.var_inserts[1] != correct_sql)
			fail("Mixed list was not saved correctly. Invalid var insert. Got '[serializer.var_inserts[1]]' and expected '[correct_sql]'.")
		else if(serializer.element_inserts[1] != element_insert)
			fail("Mixed list was not saved correctly. Invalid element insert. Got '[serializer.element_inserts[1]]' and expected '[element_insert]'.")
		else if(serializer.element_inserts[2] != element2_insert)
			fail("Mixed list was not saved correctly. Invalid second element insert. Got '[serializer.element_inserts[2]]' and expected '[element2_insert]'.")
		else
			pass("Mixed list is serializing correctly.")
	catch(var/exception/e)
		fail("Mixed list was not saved correctly. Caught exception on line[e.line] at [e.file] with msg '[e]'.")
	return 1

/datum/unit_test/persistence/saved_vars_correct
	name = "PERSISTENCE: Datums return the right vars to save."

/datum/unit_test/persistence/saved_vars_correct/start_test()
	var/datum/sample_obj/test_container/sample_datum = new()
	try
		if(sample_datum.get_default_vars() == sample_datum.get_saved_vars())
			fail("Incorrect vars returned. Didn't get back default list. Got back vars: [jointext(sample_datum.get_saved_vars(), ", ")].")
		else
			LAZYADD(GLOB.saved_vars[/datum/sample_obj/test_container], "test_var")
			if("test_var_2" in sample_datum.get_saved_vars())
				fail("Incorrect vars returned. Got 'test_var_2' despite it not being on the whitelist")
			else if(!("test_var" in sample_datum.get_saved_vars()))
				fail("test_var was not in whitelist despite being explicitly added.")
			else
				pass("Correct saved vars returned.")
		GLOB.saved_vars.Remove(/datum/sample_obj/test_container)
	catch(var/exception/e)
		fail("Caught exception on line[e.line] at [e.file] with msg '[e]'.")
	return 1

/datum/unit_test/persistence/vars_never_included
	name = "PERSISTENCE: Datums never return vars as something to save."

/datum/unit_test/persistence/vars_never_included/start_test()
	var/datum/sample_obj/test_container/sample_datum = new()
	if("vars" in sample_datum.get_saved_vars())
		fail("Vars is being serialized! Bad!")
	else
		pass("Vars is not being serialized.")
	return 1

#endif
