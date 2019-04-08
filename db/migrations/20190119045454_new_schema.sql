-- migrate:up

CREATE TABLE bs12_rank(
	id SMALLSERIAL PRIMARY KEY,
	name TEXT UNIQUE NOT NULL,
	permissions INTEGER NOT NULL,
	flags INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE bs12_player(
	id SERIAL PRIMARY KEY,
	ckey TEXT UNIQUE NOT NULL,
	first_seen TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	rank SMALLINT DEFAULT NULL REFERENCES bs12_rank ON DELETE SET NULL,
	staffwarn TEXT
);

CREATE TABLE bs12_round(
	id SERIAL PRIMARY KEY,
	roundid TEXT UNIQUE NOT NULL,
	startts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	endts TIMESTAMP
);

CREATE TABLE bs12_ip(
	id SERIAL PRIMARY KEY,
	ip INET UNIQUE NOT NULL
);

CREATE TABLE bs12_computerid(
	id SERIAL PRIMARY KEY,
	computerid INTEGER UNIQUE NOT NULL
);

CREATE TABLE bs12_login(
	id BIGSERIAL PRIMARY KEY,
	player INTEGER NOT NULL REFERENCES bs12_player,
	ip INTEGER NOT NULL REFERENCES bs12_ip,
	computerid INTEGER NOT NULL REFERENCES bs12_computerid,
	round INTEGER NOT NULL REFERENCES bs12_round
);

CREATE TABLE bs12_library(
	id SERIAL PRIMARY KEY,
	author_id INTEGER NOT NULL REFERENCES bs12_player,
	category TEXT NOT NULL,
	author TEXT NOT NULL,
	title TEXT NOT NULL,
	content TEXT NOT NULL
);

CREATE TABLE bs12_whitelist(
	id SERIAL PRIMARY KEY,
	player INTEGER NOT NULL REFERENCES bs12_player,
	scope TEXT NOT NULL,
	UNIQUE(player, scope)
);

CREATE INDEX bs12_whitelist_player_hash ON bs12_whitelist USING HASH (player);

CREATE TABLE bs12_ban(
	id SERIAL PRIMARY KEY,
	admin INTEGER NOT NULL REFERENCES bs12_player,
	ts TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE bs12_ban_reason(
	id SERIAL PRIMARY KEY,
	ban INTEGER NOT NULL REFERENCES bs12_ban ON DELETE CASCADE,
	admin INTEGER NOT NULL REFERENCES bs12_player,
	ts TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	reason TEXT NOT NULL
);

CREATE TABLE bs12_ban_scope(
	id SERIAL PRIMARY KEY,
	ban INTEGER NOT NULL REFERENCES bs12_ban ON DELETE CASCADE,
	admin INTEGER NOT NULL REFERENCES bs12_player,
	ts TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	scope TEXT[] NOT NULL
);

CREATE TABLE bs12_ban_expiry(
	id SERIAL PRIMARY KEY,
	ban INTEGER NOT NULL REFERENCES bs12_ban ON DELETE CASCADE,
	admin INTEGER NOT NULL REFERENCES bs12_player,
	ts TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	expiry TIMESTAMPTZ
);

CREATE TABLE bs12_ban_target(
	id SERIAL PRIMARY KEY,
	ban INTEGER NOT NULL REFERENCES bs12_ban ON DELETE CASCADE,
	admin INTEGER NOT NULL REFERENCES bs12_player,
	ts TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	target_ip INET[] NOT NULL DEFAULT ARRAY[],
	target_ckey TEXT[] NOT NULL DEFAULT ARRAY[],
	target_computerid INTEGER[] NOT NULL DEFAULT[],
	CHECK(CARDINALITY(target_ip) > 0 OR CARDINALITY(target_ckey) > 0 OR CARDINALITY(target_computerid) > 0)
);

CREATE INDEX bs12_ban_reason_ban_hash ON bs12_ban_reason USING HASH (ban);
CREATE INDEX bs12_ban_scope_ban_hash ON bs12_ban_scope USING HASH (ban);
CREATE INDEX bs12_ban_expiry_ban_hash ON bs12_ban_expiry USING HASH (ban);
CREATE INDEX bs12_ban_target_ban_hash ON bs12_ban_target USING HASH (ban);
CREATE INDEX bs12_ban_reason_ts_bt ON bs12_ban_reason (ts);
CREATE INDEX bs12_ban_scope_ts_bt ON bs12_ban_scope (ts);
CREATE INDEX bs12_ban_expiry_ts_bt ON bs12_ban_expiry (ts);
CREATE INDEX bs12_ban_target_ts_bt ON bs12_ban_target (ts);

CREATE VIEW bs12_active_ban_reason AS
	SELECT id, ban, reason FROM bs12_ban_reason
	WHERE id IN (SELECT id FROM bs12_ban_expiry WHERE ts IN (SELECT MAX(ts) FROM bs12_ban_expiry GROUP BY ban));

CREATE VIEW bs12_active_ban_scope AS
	SELECT id, ban, scope FROM bs12_ban_scope
	WHERE id IN (SELECT id FROM bs12_ban_expiry WHERE ts IN (SELECT MAX(ts) FROM bs12_ban_expiry GROUP BY ban));

CREATE VIEW bs12_active_ban_expiry AS
	SELECT id, ban, expiry FROM bs12_ban_expiry
	WHERE id IN (SELECT id FROM bs12_ban_expiry WHERE ts IN (SELECT MAX(ts) FROM bs12_ban_expiry GROUP BY ban));

CREATE VIEW bs12_active_ban_target AS
	SELECT id, ban, target_ip, target_ckey, target_computerid FROM bs12_ban_target
	WHERE id IN (SELECT id FROM bs12_ban_expiry WHERE ts IN (SELECT MAX(ts) FROM bs12_ban_expiry GROUP BY ban));

CREATE VIEW bs12_active_ban AS
	SELECT bs12_ban.id, bs12_ban.admin, reason, scope, expiry, target_ip, target_ckey, target_computerid
	FROM bs12_ban
	INNER JOIN bs12_active_ban_reason AS r ON bs12_ban.id = r.ban
	INNER JOIN bs12_active_ban_scope AS s ON bs12_ban.id = s.ban
	INNER JOIN bs12_active_ban_expiry AS e ON bs12_ban.id = e.ban
	INNER JOIN bs12_active_ban_target AS t ON bs12_ban.id = t.ban
	WHERE expiry IS NULL OR expiry > CURRENT_TIMESTAMP;

CREATE TABLE bs12_valid_scope(
	id SERIAL PRIMARY KEY,
	scope TEXT NOT NULL,
	category TEXT NOT NULL,
	version SMALLINT NOT NULL,
	UNIQUE(scope, category, version)
);

CREATE INDEX bs12_valid_scope_version_hash ON bs12_valid_scope USING HASH (version);

INSERT INTO bs12_player(ckey, last_seen) VALUES ('xales', CURRENT_TIMESTAMP);
INSERT INTO bs12_ban(admin) VALUES (1);
INSERT INTO bs12_ban_reason(ban, admin, reason) VALUES (1, 1, 'because');
INSERT INTO bs12_ban_scope(ban, admin, scope) VALUES (1, 1, '{"server", "BaNaNa"}');
INSERT INTO bs12_ban_expiry(ban, admin, expiry) VALUES (1, 1, CURRENT_TIMESTAMP + '30 MINUTES');
INSERT INTO bs12_ban_target(ban, admin, target_ckey) VALUES (1, 1, '{"loweg"}');

-- migrate:down

DROP VIEW bs12_active_ban;
DROP VIEW bs12_active_ban_target;
DROP VIEW bs12_active_ban_expiry;
DROP VIEW bs12_active_ban_scope;
DROP VIEW bs12_active_ban_reason;
DROP TABLE bs12_ban_target;
DROP TABLE bs12_ban_expiry;
DROP TABLE bs12_ban_scope;
DROP TABLE bs12_ban_reason;
DROP TABLE bs12_ban;
DROP TABLE bs12_whitelist;
DROP TABLE bs12_library;
DROP TABLE bs12_login;
DROP TABLE bs12_computerid;
DROP TABLE bs12_ip;
DROP TABLE bs12_round;
DROP TABLE bs12_player;
DROP TABLE bs12_rank;
