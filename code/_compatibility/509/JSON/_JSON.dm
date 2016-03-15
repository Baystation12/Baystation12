#if DM_VERSION < 510
/*
n_Json v11.3.21
*/

proc
	json_decode(json)
		var/static/json_reader/_jsonr = new()
		return _jsonr.ReadObject(_jsonr.ScanJson(json))

	json_encode(list/L)
		var/static/json_writer/_jsonw = new()
		return _jsonw.write(L)


#endif