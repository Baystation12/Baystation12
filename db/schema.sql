SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: bs12_ban_expiry; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bs12_ban_expiry (
    id integer NOT NULL,
    ban integer NOT NULL,
    admin integer NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    expiry timestamp with time zone
);


--
-- Name: bs12_active_ban_expiry; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.bs12_active_ban_expiry AS
 SELECT bs12_ban_expiry.id,
    bs12_ban_expiry.ban,
    bs12_ban_expiry.expiry
   FROM public.bs12_ban_expiry
  WHERE (bs12_ban_expiry.id IN ( SELECT bs12_ban_expiry_1.id
           FROM public.bs12_ban_expiry bs12_ban_expiry_1
          WHERE (bs12_ban_expiry_1.ts IN ( SELECT max(bs12_ban_expiry_2.ts) AS max
                   FROM public.bs12_ban_expiry bs12_ban_expiry_2
                  GROUP BY bs12_ban_expiry_2.ban))));


--
-- Name: bs12_ban_reason; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bs12_ban_reason (
    id integer NOT NULL,
    ban integer NOT NULL,
    admin integer NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    reason text NOT NULL
);


--
-- Name: bs12_active_ban_reason; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.bs12_active_ban_reason AS
 SELECT bs12_ban_reason.id,
    bs12_ban_reason.ban,
    bs12_ban_reason.reason
   FROM public.bs12_ban_reason
  WHERE (bs12_ban_reason.id IN ( SELECT bs12_ban_expiry.id
           FROM public.bs12_ban_expiry
          WHERE (bs12_ban_expiry.ts IN ( SELECT max(bs12_ban_expiry_1.ts) AS max
                   FROM public.bs12_ban_expiry bs12_ban_expiry_1
                  GROUP BY bs12_ban_expiry_1.ban))));


--
-- Name: bs12_ban_scope; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bs12_ban_scope (
    id integer NOT NULL,
    ban integer NOT NULL,
    admin integer NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    scope text[] NOT NULL
);


--
-- Name: bs12_active_ban_scope; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.bs12_active_ban_scope AS
 SELECT bs12_ban_scope.id,
    bs12_ban_scope.ban,
    bs12_ban_scope.scope
   FROM public.bs12_ban_scope
  WHERE (bs12_ban_scope.id IN ( SELECT bs12_ban_expiry.id
           FROM public.bs12_ban_expiry
          WHERE (bs12_ban_expiry.ts IN ( SELECT max(bs12_ban_expiry_1.ts) AS max
                   FROM public.bs12_ban_expiry bs12_ban_expiry_1
                  GROUP BY bs12_ban_expiry_1.ban))));


--
-- Name: bs12_ban_target; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bs12_ban_target (
    id integer NOT NULL,
    ban integer NOT NULL,
    admin integer NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    target_ip inet[],
    target_ckey text[],
    target_computerid integer[],
    CONSTRAINT bs12_ban_target_check CHECK (((target_ip IS NOT NULL) OR (target_ckey IS NOT NULL) OR (target_computerid IS NOT NULL)))
);


--
-- Name: bs12_active_ban_target; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.bs12_active_ban_target AS
 SELECT bs12_ban_target.id,
    bs12_ban_target.ban,
    bs12_ban_target.target_ip,
    bs12_ban_target.target_ckey,
    bs12_ban_target.target_computerid
   FROM public.bs12_ban_target
  WHERE (bs12_ban_target.id IN ( SELECT bs12_ban_expiry.id
           FROM public.bs12_ban_expiry
          WHERE (bs12_ban_expiry.ts IN ( SELECT max(bs12_ban_expiry_1.ts) AS max
                   FROM public.bs12_ban_expiry bs12_ban_expiry_1
                  GROUP BY bs12_ban_expiry_1.ban))));


--
-- Name: bs12_ban; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bs12_ban (
    id integer NOT NULL,
    admin integer NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: bs12_active_ban; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.bs12_active_ban AS
 SELECT bs12_ban.id,
    bs12_ban.admin,
    r.reason,
    s.scope,
    e.expiry,
    t.target_ip,
    t.target_ckey,
    t.target_computerid
   FROM ((((public.bs12_ban
     JOIN public.bs12_active_ban_reason r ON ((bs12_ban.id = r.ban)))
     JOIN public.bs12_active_ban_scope s ON ((bs12_ban.id = s.ban)))
     JOIN public.bs12_active_ban_expiry e ON ((bs12_ban.id = e.ban)))
     JOIN public.bs12_active_ban_target t ON ((bs12_ban.id = t.ban)))
  WHERE ((e.expiry IS NULL) OR (e.expiry > CURRENT_TIMESTAMP));


--
-- Name: bs12_ban_expiry_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bs12_ban_expiry_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bs12_ban_expiry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bs12_ban_expiry_id_seq OWNED BY public.bs12_ban_expiry.id;


--
-- Name: bs12_ban_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bs12_ban_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bs12_ban_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bs12_ban_id_seq OWNED BY public.bs12_ban.id;


--
-- Name: bs12_ban_reason_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bs12_ban_reason_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bs12_ban_reason_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bs12_ban_reason_id_seq OWNED BY public.bs12_ban_reason.id;


--
-- Name: bs12_ban_scope_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bs12_ban_scope_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bs12_ban_scope_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bs12_ban_scope_id_seq OWNED BY public.bs12_ban_scope.id;


--
-- Name: bs12_ban_target_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bs12_ban_target_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bs12_ban_target_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bs12_ban_target_id_seq OWNED BY public.bs12_ban_target.id;


--
-- Name: bs12_computerid; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bs12_computerid (
    id integer NOT NULL,
    computerid integer NOT NULL
);


--
-- Name: bs12_computerid_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bs12_computerid_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bs12_computerid_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bs12_computerid_id_seq OWNED BY public.bs12_computerid.id;


--
-- Name: bs12_ip; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bs12_ip (
    id integer NOT NULL,
    ip inet NOT NULL
);


--
-- Name: bs12_ip_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bs12_ip_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bs12_ip_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bs12_ip_id_seq OWNED BY public.bs12_ip.id;


--
-- Name: bs12_library; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bs12_library (
    id integer NOT NULL,
    author integer NOT NULL,
    category text NOT NULL,
    title text NOT NULL,
    content text NOT NULL
);


--
-- Name: bs12_library_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bs12_library_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bs12_library_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bs12_library_id_seq OWNED BY public.bs12_library.id;


--
-- Name: bs12_login; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bs12_login (
    id bigint NOT NULL,
    player integer NOT NULL,
    ip integer NOT NULL,
    computerid integer NOT NULL,
    round integer NOT NULL
);


--
-- Name: bs12_login_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bs12_login_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bs12_login_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bs12_login_id_seq OWNED BY public.bs12_login.id;


--
-- Name: bs12_player; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bs12_player (
    id integer NOT NULL,
    ckey text NOT NULL,
    first_seen timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_seen timestamp with time zone NOT NULL,
    rank smallint,
    staffwarn text
);


--
-- Name: bs12_player_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bs12_player_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bs12_player_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bs12_player_id_seq OWNED BY public.bs12_player.id;


--
-- Name: bs12_rank; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bs12_rank (
    id smallint NOT NULL,
    name text NOT NULL,
    permissions integer NOT NULL,
    flags integer DEFAULT 0 NOT NULL
);


--
-- Name: bs12_rank_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bs12_rank_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bs12_rank_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bs12_rank_id_seq OWNED BY public.bs12_rank.id;


--
-- Name: bs12_round; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bs12_round (
    id integer NOT NULL,
    roundid text NOT NULL,
    startts timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    endts timestamp without time zone
);


--
-- Name: bs12_round_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bs12_round_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bs12_round_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bs12_round_id_seq OWNED BY public.bs12_round.id;


--
-- Name: bs12_whitelist; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bs12_whitelist (
    id integer NOT NULL,
    player integer NOT NULL,
    scope text NOT NULL
);


--
-- Name: bs12_whitelist_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bs12_whitelist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bs12_whitelist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bs12_whitelist_id_seq OWNED BY public.bs12_whitelist.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: bs12_ban id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_ban ALTER COLUMN id SET DEFAULT nextval('public.bs12_ban_id_seq'::regclass);


--
-- Name: bs12_ban_expiry id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_ban_expiry ALTER COLUMN id SET DEFAULT nextval('public.bs12_ban_expiry_id_seq'::regclass);


--
-- Name: bs12_ban_reason id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_ban_reason ALTER COLUMN id SET DEFAULT nextval('public.bs12_ban_reason_id_seq'::regclass);


--
-- Name: bs12_ban_scope id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_ban_scope ALTER COLUMN id SET DEFAULT nextval('public.bs12_ban_scope_id_seq'::regclass);


--
-- Name: bs12_ban_target id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_ban_target ALTER COLUMN id SET DEFAULT nextval('public.bs12_ban_target_id_seq'::regclass);


--
-- Name: bs12_computerid id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_computerid ALTER COLUMN id SET DEFAULT nextval('public.bs12_computerid_id_seq'::regclass);


--
-- Name: bs12_ip id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_ip ALTER COLUMN id SET DEFAULT nextval('public.bs12_ip_id_seq'::regclass);


--
-- Name: bs12_library id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_library ALTER COLUMN id SET DEFAULT nextval('public.bs12_library_id_seq'::regclass);


--
-- Name: bs12_login id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_login ALTER COLUMN id SET DEFAULT nextval('public.bs12_login_id_seq'::regclass);


--
-- Name: bs12_player id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_player ALTER COLUMN id SET DEFAULT nextval('public.bs12_player_id_seq'::regclass);


--
-- Name: bs12_rank id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_rank ALTER COLUMN id SET DEFAULT nextval('public.bs12_rank_id_seq'::regclass);


--
-- Name: bs12_round id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_round ALTER COLUMN id SET DEFAULT nextval('public.bs12_round_id_seq'::regclass);


--
-- Name: bs12_whitelist id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_whitelist ALTER COLUMN id SET DEFAULT nextval('public.bs12_whitelist_id_seq'::regclass);


--
-- Name: bs12_ban_expiry bs12_ban_expiry_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_ban_expiry
    ADD CONSTRAINT bs12_ban_expiry_pkey PRIMARY KEY (id);


--
-- Name: bs12_ban bs12_ban_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_ban
    ADD CONSTRAINT bs12_ban_pkey PRIMARY KEY (id);


--
-- Name: bs12_ban_reason bs12_ban_reason_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_ban_reason
    ADD CONSTRAINT bs12_ban_reason_pkey PRIMARY KEY (id);


--
-- Name: bs12_ban_scope bs12_ban_scope_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_ban_scope
    ADD CONSTRAINT bs12_ban_scope_pkey PRIMARY KEY (id);


--
-- Name: bs12_ban_target bs12_ban_target_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_ban_target
    ADD CONSTRAINT bs12_ban_target_pkey PRIMARY KEY (id);


--
-- Name: bs12_computerid bs12_computerid_computerid_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_computerid
    ADD CONSTRAINT bs12_computerid_computerid_key UNIQUE (computerid);


--
-- Name: bs12_computerid bs12_computerid_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_computerid
    ADD CONSTRAINT bs12_computerid_pkey PRIMARY KEY (id);


--
-- Name: bs12_ip bs12_ip_ip_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_ip
    ADD CONSTRAINT bs12_ip_ip_key UNIQUE (ip);


--
-- Name: bs12_ip bs12_ip_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_ip
    ADD CONSTRAINT bs12_ip_pkey PRIMARY KEY (id);


--
-- Name: bs12_library bs12_library_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_library
    ADD CONSTRAINT bs12_library_pkey PRIMARY KEY (id);


--
-- Name: bs12_login bs12_login_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_login
    ADD CONSTRAINT bs12_login_pkey PRIMARY KEY (id);


--
-- Name: bs12_player bs12_player_ckey_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_player
    ADD CONSTRAINT bs12_player_ckey_key UNIQUE (ckey);


--
-- Name: bs12_player bs12_player_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_player
    ADD CONSTRAINT bs12_player_pkey PRIMARY KEY (id);


--
-- Name: bs12_rank bs12_rank_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_rank
    ADD CONSTRAINT bs12_rank_name_key UNIQUE (name);


--
-- Name: bs12_rank bs12_rank_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_rank
    ADD CONSTRAINT bs12_rank_pkey PRIMARY KEY (id);


--
-- Name: bs12_round bs12_round_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_round
    ADD CONSTRAINT bs12_round_pkey PRIMARY KEY (id);


--
-- Name: bs12_round bs12_round_roundid_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_round
    ADD CONSTRAINT bs12_round_roundid_key UNIQUE (roundid);


--
-- Name: bs12_whitelist bs12_whitelist_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_whitelist
    ADD CONSTRAINT bs12_whitelist_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: bs12_ban_expiry_ban_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bs12_ban_expiry_ban_hash ON public.bs12_ban_expiry USING hash (ban);


--
-- Name: bs12_ban_expiry_ts_bt; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bs12_ban_expiry_ts_bt ON public.bs12_ban_expiry USING btree (ts);


--
-- Name: bs12_ban_reason_ban_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bs12_ban_reason_ban_hash ON public.bs12_ban_reason USING hash (ban);


--
-- Name: bs12_ban_reason_ts_bt; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bs12_ban_reason_ts_bt ON public.bs12_ban_reason USING btree (ts);


--
-- Name: bs12_ban_scope_ban_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bs12_ban_scope_ban_hash ON public.bs12_ban_scope USING hash (ban);


--
-- Name: bs12_ban_scope_ts_bt; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bs12_ban_scope_ts_bt ON public.bs12_ban_scope USING btree (ts);


--
-- Name: bs12_ban_target_ban_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bs12_ban_target_ban_hash ON public.bs12_ban_target USING hash (ban);


--
-- Name: bs12_ban_target_ts_bt; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bs12_ban_target_ts_bt ON public.bs12_ban_target USING btree (ts);


--
-- Name: bs12_whitelist_player_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bs12_whitelist_player_hash ON public.bs12_whitelist USING hash (player);


--
-- Name: bs12_ban bs12_ban_admin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_ban
    ADD CONSTRAINT bs12_ban_admin_fkey FOREIGN KEY (admin) REFERENCES public.bs12_player(id);


--
-- Name: bs12_ban_expiry bs12_ban_expiry_admin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_ban_expiry
    ADD CONSTRAINT bs12_ban_expiry_admin_fkey FOREIGN KEY (admin) REFERENCES public.bs12_player(id);


--
-- Name: bs12_ban_expiry bs12_ban_expiry_ban_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_ban_expiry
    ADD CONSTRAINT bs12_ban_expiry_ban_fkey FOREIGN KEY (ban) REFERENCES public.bs12_ban(id);


--
-- Name: bs12_ban_reason bs12_ban_reason_admin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_ban_reason
    ADD CONSTRAINT bs12_ban_reason_admin_fkey FOREIGN KEY (admin) REFERENCES public.bs12_player(id);


--
-- Name: bs12_ban_reason bs12_ban_reason_ban_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_ban_reason
    ADD CONSTRAINT bs12_ban_reason_ban_fkey FOREIGN KEY (ban) REFERENCES public.bs12_ban(id);


--
-- Name: bs12_ban_scope bs12_ban_scope_admin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_ban_scope
    ADD CONSTRAINT bs12_ban_scope_admin_fkey FOREIGN KEY (admin) REFERENCES public.bs12_player(id);


--
-- Name: bs12_ban_scope bs12_ban_scope_ban_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_ban_scope
    ADD CONSTRAINT bs12_ban_scope_ban_fkey FOREIGN KEY (ban) REFERENCES public.bs12_ban(id);


--
-- Name: bs12_ban_target bs12_ban_target_admin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_ban_target
    ADD CONSTRAINT bs12_ban_target_admin_fkey FOREIGN KEY (admin) REFERENCES public.bs12_player(id);


--
-- Name: bs12_ban_target bs12_ban_target_ban_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_ban_target
    ADD CONSTRAINT bs12_ban_target_ban_fkey FOREIGN KEY (ban) REFERENCES public.bs12_ban(id);


--
-- Name: bs12_library bs12_library_author_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_library
    ADD CONSTRAINT bs12_library_author_fkey FOREIGN KEY (author) REFERENCES public.bs12_player(id);


--
-- Name: bs12_login bs12_login_computerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_login
    ADD CONSTRAINT bs12_login_computerid_fkey FOREIGN KEY (computerid) REFERENCES public.bs12_computerid(id);


--
-- Name: bs12_login bs12_login_ip_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_login
    ADD CONSTRAINT bs12_login_ip_fkey FOREIGN KEY (ip) REFERENCES public.bs12_ip(id);


--
-- Name: bs12_login bs12_login_player_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_login
    ADD CONSTRAINT bs12_login_player_fkey FOREIGN KEY (player) REFERENCES public.bs12_player(id);


--
-- Name: bs12_login bs12_login_round_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_login
    ADD CONSTRAINT bs12_login_round_fkey FOREIGN KEY (round) REFERENCES public.bs12_round(id);


--
-- Name: bs12_player bs12_player_rank_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_player
    ADD CONSTRAINT bs12_player_rank_fkey FOREIGN KEY (rank) REFERENCES public.bs12_rank(id) ON DELETE SET NULL;


--
-- Name: bs12_whitelist bs12_whitelist_player_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bs12_whitelist
    ADD CONSTRAINT bs12_whitelist_player_fkey FOREIGN KEY (player) REFERENCES public.bs12_player(id);


--
-- PostgreSQL database dump complete
--


--
-- Dbmate schema migrations
--

INSERT INTO public.schema_migrations (version) VALUES
    ('20190119045454');
