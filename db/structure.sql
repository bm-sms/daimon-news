--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    site_id integer,
    slug character varying NOT NULL,
    "order" integer,
    ancestry character varying
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: categorizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE categorizations (
    id integer NOT NULL,
    category_id integer NOT NULL,
    post_id integer NOT NULL,
    "order" integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: categorizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categorizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categorizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categorizations_id_seq OWNED BY categorizations.id;


--
-- Name: credit_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE credit_roles (
    id integer NOT NULL,
    name character varying NOT NULL,
    "order" integer NOT NULL,
    site_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: credit_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE credit_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: credit_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE credit_roles_id_seq OWNED BY credit_roles.id;


--
-- Name: credits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE credits (
    id integer NOT NULL,
    post_id integer NOT NULL,
    participant_id integer NOT NULL,
    credit_role_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "order" integer NOT NULL
);


--
-- Name: credits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE credits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: credits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE credits_id_seq OWNED BY credits.id;


--
-- Name: fixed_pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE fixed_pages (
    id integer NOT NULL,
    site_id integer NOT NULL,
    title character varying,
    body text,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: fixed_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fixed_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fixed_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fixed_pages_id_seq OWNED BY fixed_pages.id;


--
-- Name: images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE images (
    id integer NOT NULL,
    image character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    site_id integer NOT NULL
);


--
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE images_id_seq OWNED BY images.id;


--
-- Name: links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE links (
    id integer NOT NULL,
    text character varying NOT NULL,
    url character varying NOT NULL,
    "order" integer NOT NULL,
    site_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE links_id_seq OWNED BY links.id;


--
-- Name: memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE memberships (
    id integer NOT NULL,
    site_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE memberships_id_seq OWNED BY memberships.id;


--
-- Name: participants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE participants (
    id integer NOT NULL,
    site_id integer NOT NULL,
    name character varying NOT NULL,
    summary text,
    photo character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description text
);


--
-- Name: participants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE participants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: participants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE participants_id_seq OWNED BY participants.id;


--
-- Name: pickup_posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pickup_posts (
    id integer NOT NULL,
    site_id integer NOT NULL,
    post_id integer NOT NULL,
    "order" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pickup_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pickup_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pickup_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pickup_posts_id_seq OWNED BY pickup_posts.id;


--
-- Name: popular_posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE popular_posts (
    id integer NOT NULL,
    site_id integer NOT NULL,
    rank integer NOT NULL,
    post_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: popular_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE popular_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: popular_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE popular_posts_id_seq OWNED BY popular_posts.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE posts (
    id integer NOT NULL,
    title character varying,
    body text NOT NULL,
    site_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    published_at timestamp without time zone,
    thumbnail character varying NOT NULL,
    original_updated_at timestamp without time zone,
    public_id integer NOT NULL,
    serial_id integer
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE posts_id_seq OWNED BY posts.id;


--
-- Name: redirect_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE redirect_rules (
    id integer NOT NULL,
    request_path character varying NOT NULL,
    destination character varying NOT NULL,
    site_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: redirect_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE redirect_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: redirect_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE redirect_rules_id_seq OWNED BY redirect_rules.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: serials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE serials (
    id integer NOT NULL,
    title character varying NOT NULL,
    description text NOT NULL,
    site_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    thumbnail character varying NOT NULL
);


--
-- Name: serials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE serials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: serials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE serials_id_seq OWNED BY serials.id;


--
-- Name: sites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sites (
    id integer NOT NULL,
    name character varying NOT NULL,
    js_url character varying,
    css_url character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    fqdn character varying NOT NULL,
    tagline character varying,
    gtm_id character varying,
    content_header_url character varying,
    promotion_url character varying,
    sns_share_caption character varying,
    twitter_account character varying,
    menu_url character varying,
    home_url character varying,
    ad_client character varying,
    ad_slot character varying,
    description character varying,
    footer_url character varying,
    opened boolean DEFAULT false NOT NULL,
    logo_image character varying,
    favicon_image character varying,
    mobile_favicon_image character varying,
    promotion_tag text,
    head_tag text,
    category_title_format character varying,
    view_all boolean DEFAULT false NOT NULL,
    base_hue integer,
    custom_hue_css character varying,
    public_participant_page_enabled boolean DEFAULT false NOT NULL,
    hierarchical_categories_enabled boolean DEFAULT false NOT NULL,
    analytics_viewid character varying,
    ranking_dimension character varying,
    ranking_size integer DEFAULT 5
);


--
-- Name: sites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sites_id_seq OWNED BY sites.id;


--
-- Name: top_fixed_posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE top_fixed_posts (
    id integer NOT NULL,
    site_id integer NOT NULL,
    post_id integer NOT NULL,
    "order" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: top_fixed_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE top_fixed_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: top_fixed_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE top_fixed_posts_id_seq OWNED BY top_fixed_posts.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying,
    admin boolean DEFAULT false NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: categorizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categorizations ALTER COLUMN id SET DEFAULT nextval('categorizations_id_seq'::regclass);


--
-- Name: credit_roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY credit_roles ALTER COLUMN id SET DEFAULT nextval('credit_roles_id_seq'::regclass);


--
-- Name: credits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY credits ALTER COLUMN id SET DEFAULT nextval('credits_id_seq'::regclass);


--
-- Name: fixed_pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fixed_pages ALTER COLUMN id SET DEFAULT nextval('fixed_pages_id_seq'::regclass);


--
-- Name: images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY images ALTER COLUMN id SET DEFAULT nextval('images_id_seq'::regclass);


--
-- Name: links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY links ALTER COLUMN id SET DEFAULT nextval('links_id_seq'::regclass);


--
-- Name: memberships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships ALTER COLUMN id SET DEFAULT nextval('memberships_id_seq'::regclass);


--
-- Name: participants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY participants ALTER COLUMN id SET DEFAULT nextval('participants_id_seq'::regclass);


--
-- Name: pickup_posts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pickup_posts ALTER COLUMN id SET DEFAULT nextval('pickup_posts_id_seq'::regclass);


--
-- Name: popular_posts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY popular_posts ALTER COLUMN id SET DEFAULT nextval('popular_posts_id_seq'::regclass);


--
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts ALTER COLUMN id SET DEFAULT nextval('posts_id_seq'::regclass);


--
-- Name: redirect_rules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY redirect_rules ALTER COLUMN id SET DEFAULT nextval('redirect_rules_id_seq'::regclass);


--
-- Name: serials id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY serials ALTER COLUMN id SET DEFAULT nextval('serials_id_seq'::regclass);


--
-- Name: sites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sites ALTER COLUMN id SET DEFAULT nextval('sites_id_seq'::regclass);


--
-- Name: top_fixed_posts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY top_fixed_posts ALTER COLUMN id SET DEFAULT nextval('top_fixed_posts_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: categorizations categorizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categorizations
    ADD CONSTRAINT categorizations_pkey PRIMARY KEY (id);


--
-- Name: credit_roles credit_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY credit_roles
    ADD CONSTRAINT credit_roles_pkey PRIMARY KEY (id);


--
-- Name: credits credits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY credits
    ADD CONSTRAINT credits_pkey PRIMARY KEY (id);


--
-- Name: fixed_pages fixed_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fixed_pages
    ADD CONSTRAINT fixed_pages_pkey PRIMARY KEY (id);


--
-- Name: images images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: links links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY links
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);


--
-- Name: memberships memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships
    ADD CONSTRAINT memberships_pkey PRIMARY KEY (id);


--
-- Name: participants participants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY participants
    ADD CONSTRAINT participants_pkey PRIMARY KEY (id);


--
-- Name: pickup_posts pickup_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pickup_posts
    ADD CONSTRAINT pickup_posts_pkey PRIMARY KEY (id);


--
-- Name: popular_posts popular_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY popular_posts
    ADD CONSTRAINT popular_posts_pkey PRIMARY KEY (id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: redirect_rules redirect_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY redirect_rules
    ADD CONSTRAINT redirect_rules_pkey PRIMARY KEY (id);


--
-- Name: serials serials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY serials
    ADD CONSTRAINT serials_pkey PRIMARY KEY (id);


--
-- Name: sites sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (id);


--
-- Name: top_fixed_posts top_fixed_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY top_fixed_posts
    ADD CONSTRAINT top_fixed_posts_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_categories_on_ancestry; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categories_on_ancestry ON categories USING btree (ancestry);


--
-- Name: index_categories_on_site_id_and_coalesce_ancestry_and_order; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_categories_on_site_id_and_coalesce_ancestry_and_order ON categories USING btree (site_id, (COALESCE(ancestry, 'NULL'::character varying)), "order");


--
-- Name: index_categories_on_slug_and_site_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_categories_on_slug_and_site_id ON categories USING btree (slug, site_id);


--
-- Name: index_categorizations_on_post_id_and_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_categorizations_on_post_id_and_category_id ON categorizations USING btree (post_id, category_id);


--
-- Name: index_categorizations_on_post_id_and_order; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_categorizations_on_post_id_and_order ON categorizations USING btree (post_id, "order");


--
-- Name: index_credit_roles_on_site_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_credit_roles_on_site_id ON credit_roles USING btree (site_id);


--
-- Name: index_credit_roles_on_site_id_and_order; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_credit_roles_on_site_id_and_order ON credit_roles USING btree (site_id, "order");


--
-- Name: index_credits_on_credit_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_credits_on_credit_role_id ON credits USING btree (credit_role_id);


--
-- Name: index_credits_on_participant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_credits_on_participant_id ON credits USING btree (participant_id);


--
-- Name: index_credits_on_post_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_credits_on_post_id ON credits USING btree (post_id);


--
-- Name: index_credits_on_post_id_and_order; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_credits_on_post_id_and_order ON credits USING btree (post_id, "order");


--
-- Name: index_fixed_pages_on_site_id_and_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_fixed_pages_on_site_id_and_slug ON fixed_pages USING btree (site_id, slug);


--
-- Name: index_links_on_site_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_links_on_site_id ON links USING btree (site_id);


--
-- Name: index_memberships_on_site_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_memberships_on_site_id_and_user_id ON memberships USING btree (site_id, user_id);


--
-- Name: index_participants_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_participants_on_name ON participants USING btree (name);


--
-- Name: index_participants_on_site_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_participants_on_site_id ON participants USING btree (site_id);


--
-- Name: index_pickup_posts_on_post_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pickup_posts_on_post_id ON pickup_posts USING btree (post_id);


--
-- Name: index_pickup_posts_on_site_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pickup_posts_on_site_id ON pickup_posts USING btree (site_id);


--
-- Name: index_pickup_posts_on_site_id_and_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pickup_posts_on_site_id_and_order ON pickup_posts USING btree (site_id, "order");


--
-- Name: index_popular_posts_on_post_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_popular_posts_on_post_id ON popular_posts USING btree (post_id);


--
-- Name: index_popular_posts_on_site_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_popular_posts_on_site_id ON popular_posts USING btree (site_id);


--
-- Name: index_popular_posts_on_site_id_and_rank; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_popular_posts_on_site_id_and_rank ON popular_posts USING btree (site_id, rank);


--
-- Name: index_posts_on_published_at_and_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_published_at_and_id ON posts USING btree (published_at, id);


--
-- Name: index_posts_on_serial_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_serial_id ON posts USING btree (serial_id);


--
-- Name: index_posts_on_site_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_site_id ON posts USING btree (site_id);


--
-- Name: index_posts_on_site_id_and_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_posts_on_site_id_and_id ON posts USING btree (site_id, id);


--
-- Name: index_posts_on_site_id_and_public_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_posts_on_site_id_and_public_id ON posts USING btree (site_id, public_id);


--
-- Name: index_posts_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_updated_at ON posts USING btree (updated_at);


--
-- Name: index_redirect_rules_on_request_path_and_site_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_redirect_rules_on_request_path_and_site_id ON redirect_rules USING btree (request_path, site_id);


--
-- Name: index_redirect_rules_on_site_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_redirect_rules_on_site_id ON redirect_rules USING btree (site_id);


--
-- Name: index_serials_on_site_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_serials_on_site_id ON serials USING btree (site_id);


--
-- Name: index_top_fixed_posts_on_post_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_top_fixed_posts_on_post_id ON top_fixed_posts USING btree (post_id);


--
-- Name: index_top_fixed_posts_on_site_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_top_fixed_posts_on_site_id ON top_fixed_posts USING btree (site_id);


--
-- Name: index_top_fixed_posts_on_site_id_and_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_top_fixed_posts_on_site_id_and_order ON top_fixed_posts USING btree (site_id, "order");


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: credits fk_rails_0311c006db; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY credits
    ADD CONSTRAINT fk_rails_0311c006db FOREIGN KEY (participant_id) REFERENCES participants(id);


--
-- Name: posts fk_rails_0d1e104012; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT fk_rails_0d1e104012 FOREIGN KEY (serial_id) REFERENCES serials(id);


--
-- Name: redirect_rules fk_rails_153f1813ed; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY redirect_rules
    ADD CONSTRAINT fk_rails_153f1813ed FOREIGN KEY (site_id) REFERENCES sites(id);


--
-- Name: top_fixed_posts fk_rails_249328960e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY top_fixed_posts
    ADD CONSTRAINT fk_rails_249328960e FOREIGN KEY (post_id) REFERENCES posts(id);


--
-- Name: fixed_pages fk_rails_400f45177e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fixed_pages
    ADD CONSTRAINT fk_rails_400f45177e FOREIGN KEY (site_id) REFERENCES sites(id);


--
-- Name: categorizations fk_rails_5a40b79a1d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categorizations
    ADD CONSTRAINT fk_rails_5a40b79a1d FOREIGN KEY (category_id) REFERENCES categories(id);


--
-- Name: credit_roles fk_rails_5b5330057c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY credit_roles
    ADD CONSTRAINT fk_rails_5b5330057c FOREIGN KEY (site_id) REFERENCES sites(id);


--
-- Name: top_fixed_posts fk_rails_6824386153; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY top_fixed_posts
    ADD CONSTRAINT fk_rails_6824386153 FOREIGN KEY (site_id) REFERENCES sites(id);


--
-- Name: memberships fk_rails_6c24d54d2a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships
    ADD CONSTRAINT fk_rails_6c24d54d2a FOREIGN KEY (site_id) REFERENCES sites(id);


--
-- Name: popular_posts fk_rails_6d6350e28e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY popular_posts
    ADD CONSTRAINT fk_rails_6d6350e28e FOREIGN KEY (post_id) REFERENCES posts(id);


--
-- Name: credits fk_rails_6dc26c2c8d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY credits
    ADD CONSTRAINT fk_rails_6dc26c2c8d FOREIGN KEY (credit_role_id) REFERENCES credit_roles(id);


--
-- Name: memberships fk_rails_99326fb65d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships
    ADD CONSTRAINT fk_rails_99326fb65d FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: serials fk_rails_9f519866d2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY serials
    ADD CONSTRAINT fk_rails_9f519866d2 FOREIGN KEY (site_id) REFERENCES sites(id);


--
-- Name: credits fk_rails_ab9555028f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY credits
    ADD CONSTRAINT fk_rails_ab9555028f FOREIGN KEY (post_id) REFERENCES posts(id);


--
-- Name: popular_posts fk_rails_b2e9222973; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY popular_posts
    ADD CONSTRAINT fk_rails_b2e9222973 FOREIGN KEY (site_id) REFERENCES sites(id);


--
-- Name: pickup_posts fk_rails_b8e98104ef; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pickup_posts
    ADD CONSTRAINT fk_rails_b8e98104ef FOREIGN KEY (site_id) REFERENCES sites(id);


--
-- Name: categorizations fk_rails_c3f4777003; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categorizations
    ADD CONSTRAINT fk_rails_c3f4777003 FOREIGN KEY (post_id) REFERENCES posts(id);


--
-- Name: links fk_rails_c62c2fc171; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY links
    ADD CONSTRAINT fk_rails_c62c2fc171 FOREIGN KEY (site_id) REFERENCES sites(id);


--
-- Name: participants fk_rails_db7f8b9862; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY participants
    ADD CONSTRAINT fk_rails_db7f8b9862 FOREIGN KEY (site_id) REFERENCES sites(id);


--
-- Name: posts fk_rails_de90ba744d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT fk_rails_de90ba744d FOREIGN KEY (site_id) REFERENCES sites(id);


--
-- Name: pickup_posts fk_rails_e49900da6c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pickup_posts
    ADD CONSTRAINT fk_rails_e49900da6c FOREIGN KEY (post_id) REFERENCES posts(id);


--
-- Name: images fk_rails_fc5c9b486e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY images
    ADD CONSTRAINT fk_rails_fc5c9b486e FOREIGN KEY (site_id) REFERENCES sites(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20151026011256');

INSERT INTO schema_migrations (version) VALUES ('20151026011918');

INSERT INTO schema_migrations (version) VALUES ('20151209012747');

INSERT INTO schema_migrations (version) VALUES ('20151209023430');

INSERT INTO schema_migrations (version) VALUES ('20151209054959');

INSERT INTO schema_migrations (version) VALUES ('20151209060628');

INSERT INTO schema_migrations (version) VALUES ('20151209061323');

INSERT INTO schema_migrations (version) VALUES ('20151210021355');

INSERT INTO schema_migrations (version) VALUES ('20151210063912');

INSERT INTO schema_migrations (version) VALUES ('20151214012924');

INSERT INTO schema_migrations (version) VALUES ('20151214045955');

INSERT INTO schema_migrations (version) VALUES ('20151217052624');

INSERT INTO schema_migrations (version) VALUES ('20151217052636');

INSERT INTO schema_migrations (version) VALUES ('20151217070027');

INSERT INTO schema_migrations (version) VALUES ('20151218020054');

INSERT INTO schema_migrations (version) VALUES ('20151218023953');

INSERT INTO schema_migrations (version) VALUES ('20151218024323');

INSERT INTO schema_migrations (version) VALUES ('20151218045610');

INSERT INTO schema_migrations (version) VALUES ('20151218064409');

INSERT INTO schema_migrations (version) VALUES ('20151221165414');

INSERT INTO schema_migrations (version) VALUES ('20151221174319');

INSERT INTO schema_migrations (version) VALUES ('20151222064556');

INSERT INTO schema_migrations (version) VALUES ('20151222071746');

INSERT INTO schema_migrations (version) VALUES ('20151222073245');

INSERT INTO schema_migrations (version) VALUES ('20151222080641');

INSERT INTO schema_migrations (version) VALUES ('20151224005840');

INSERT INTO schema_migrations (version) VALUES ('20151224021737');

INSERT INTO schema_migrations (version) VALUES ('20151224054209');

INSERT INTO schema_migrations (version) VALUES ('20151224060803');

INSERT INTO schema_migrations (version) VALUES ('20151224073920');

INSERT INTO schema_migrations (version) VALUES ('20151224085935');

INSERT INTO schema_migrations (version) VALUES ('20151224091432');

INSERT INTO schema_migrations (version) VALUES ('20151224093434');

INSERT INTO schema_migrations (version) VALUES ('20151224095700');

INSERT INTO schema_migrations (version) VALUES ('20151224120135');

INSERT INTO schema_migrations (version) VALUES ('20151224120323');

INSERT INTO schema_migrations (version) VALUES ('20151224121642');

INSERT INTO schema_migrations (version) VALUES ('20151224122903');

INSERT INTO schema_migrations (version) VALUES ('20151224123428');

INSERT INTO schema_migrations (version) VALUES ('20151224124718');

INSERT INTO schema_migrations (version) VALUES ('20160104060458');

INSERT INTO schema_migrations (version) VALUES ('20160106025926');

INSERT INTO schema_migrations (version) VALUES ('20160106032149');

INSERT INTO schema_migrations (version) VALUES ('20160106034854');

INSERT INTO schema_migrations (version) VALUES ('20160112055924');

INSERT INTO schema_migrations (version) VALUES ('20160112070338');

INSERT INTO schema_migrations (version) VALUES ('20160112081701');

INSERT INTO schema_migrations (version) VALUES ('20160113045052');

INSERT INTO schema_migrations (version) VALUES ('20160114045111');

INSERT INTO schema_migrations (version) VALUES ('20160114054124');

INSERT INTO schema_migrations (version) VALUES ('20160114055418');

INSERT INTO schema_migrations (version) VALUES ('20160114063055');

INSERT INTO schema_migrations (version) VALUES ('20160115052739');

INSERT INTO schema_migrations (version) VALUES ('20160115054020');

INSERT INTO schema_migrations (version) VALUES ('20160120065347');

INSERT INTO schema_migrations (version) VALUES ('20160120065406');

INSERT INTO schema_migrations (version) VALUES ('20160128102626');

INSERT INTO schema_migrations (version) VALUES ('20160201092922');

INSERT INTO schema_migrations (version) VALUES ('20160201100550');

INSERT INTO schema_migrations (version) VALUES ('20160202025140');

INSERT INTO schema_migrations (version) VALUES ('20160202052041');

INSERT INTO schema_migrations (version) VALUES ('20160204004625');

INSERT INTO schema_migrations (version) VALUES ('20160204070201');

INSERT INTO schema_migrations (version) VALUES ('20160204080445');

INSERT INTO schema_migrations (version) VALUES ('20160205072337');

INSERT INTO schema_migrations (version) VALUES ('20160212051043');

INSERT INTO schema_migrations (version) VALUES ('20160216062303');

INSERT INTO schema_migrations (version) VALUES ('20160216070549');

INSERT INTO schema_migrations (version) VALUES ('20160217074658');

INSERT INTO schema_migrations (version) VALUES ('20160218000943');

INSERT INTO schema_migrations (version) VALUES ('20160218001000');

INSERT INTO schema_migrations (version) VALUES ('20160225024051');

INSERT INTO schema_migrations (version) VALUES ('20160225024906');

INSERT INTO schema_migrations (version) VALUES ('20160225025743');

INSERT INTO schema_migrations (version) VALUES ('20160225030107');

INSERT INTO schema_migrations (version) VALUES ('20160322044538');

INSERT INTO schema_migrations (version) VALUES ('20160322055719');

INSERT INTO schema_migrations (version) VALUES ('20160329021637');

INSERT INTO schema_migrations (version) VALUES ('20160407023218');

INSERT INTO schema_migrations (version) VALUES ('20160412021434');

INSERT INTO schema_migrations (version) VALUES ('20160412023517');

INSERT INTO schema_migrations (version) VALUES ('20160414063913');

INSERT INTO schema_migrations (version) VALUES ('20160419103640');

INSERT INTO schema_migrations (version) VALUES ('20160421081031');

INSERT INTO schema_migrations (version) VALUES ('20160421194616');

INSERT INTO schema_migrations (version) VALUES ('20160512012637');

INSERT INTO schema_migrations (version) VALUES ('20160512013450');

INSERT INTO schema_migrations (version) VALUES ('20160526010558');

INSERT INTO schema_migrations (version) VALUES ('20160629022837');

INSERT INTO schema_migrations (version) VALUES ('20160712005001');

INSERT INTO schema_migrations (version) VALUES ('20160712070026');

INSERT INTO schema_migrations (version) VALUES ('20160712074703');

INSERT INTO schema_migrations (version) VALUES ('20160719005841');

INSERT INTO schema_migrations (version) VALUES ('20160719080821');

INSERT INTO schema_migrations (version) VALUES ('20160726082451');

INSERT INTO schema_migrations (version) VALUES ('20160728110235');

INSERT INTO schema_migrations (version) VALUES ('20160802025651');

INSERT INTO schema_migrations (version) VALUES ('20160802044216');

INSERT INTO schema_migrations (version) VALUES ('20160804090315');

INSERT INTO schema_migrations (version) VALUES ('20161003075535');

INSERT INTO schema_migrations (version) VALUES ('20161121030518');

INSERT INTO schema_migrations (version) VALUES ('20170118022543');

INSERT INTO schema_migrations (version) VALUES ('20170118082036');

INSERT INTO schema_migrations (version) VALUES ('20170210061653');

