-- Case-insensitive is the default but we're playing it safe
UPDATE erro_ban SET job="Borer" WHERE job="borer";
UPDATE erro_ban SET job="Xenomorph" WHERE job="xeno";
-- UPDATE erro_ban SET job="actor" WHERE job="actor"; -- Same
UPDATE erro_ban SET job="ert" WHERE job="Emergency Response Team";
UPDATE erro_ban SET job="mercenary" WHERE job="operative";
-- UPDATE erro_ban SET job="raider" WHERE job="raider"; -- Same
-- UPDATE erro_ban SET job="wizard" WHERE job="wizard"; -- Same
-- UPDATE erro_ban SET job="changeling" WHERE job="changeling"; -- Same
-- UPDATE erro_ban SET job="cultist" WHERE job="cultist"; -- Same
-- UPDATE erro_ban SET job="loyalist" WHERE job="loyalist"; -- Same
-- UPDATE erro_ban SET job="revolutionary" WHERE job="revolutionary"; -- Same
