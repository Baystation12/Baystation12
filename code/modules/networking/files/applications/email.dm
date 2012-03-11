datum/emailuser
	var/name = "nick"
	var/fullname
	var/pass = "pass"
	var/list/emails = list()

datum/email
	var/subject
	var/contains
	var/from

datum/dir/file/program/emailclient
	progname = "emailclient"

datum/dir/file/program/emailclient/Run()
	return 1