/*
n_Json v11.3.21
*/

proc
	json2list(json)
		var/static/json_reader/_jsonr = new()
		return _jsonr.ReadObject(_jsonr.ScanJson(json))

	list2json(list/L)
		var/static/json_writer/_jsonw = new()
		return _jsonw.write(L)

	list2json_usecache(list/L)
		var/static/json_writer/_jsonw = new()
		_jsonw.use_cache = 1
		return _jsonw.write(L)
