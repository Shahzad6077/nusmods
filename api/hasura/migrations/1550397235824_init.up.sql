--
-- PostgreSQL database dump
--

-- Dumped from database version 11.1
-- Dumped by pg_dump version 11.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: account; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.account (
    account_id uuid DEFAULT public.gen_random_uuid() PRIMARY KEY,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    email text NOT NULL UNIQUE
);


--
-- Name: TABLE account; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.account IS 'Contains user account data';


--
-- Name: session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.session (
    session_id uuid DEFAULT public.gen_random_uuid() PRIMARY KEY,
    last_accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    account_id uuid NOT NULL,
    user_agent text NOT NULL
);


--
-- Name: TABLE session; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.session IS 'Contains user session data';


--
-- Name: school; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.school (
    school_id integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    long_name text NOT NULL,
    short_name text
);


--
-- Name: TABLE school; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.school IS 'Contains school metadata';


--
-- Name: term; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.term (
    term_id integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    starts_at timestamp with time zone NOT NULL,
    ends_at timestamp with time zone NOT NULL,
    name text NOT NULL,
    school_id integer NOT NULL
);


--
-- Name: TABLE term; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.term IS 'Contains semester/term data';




--
-- Name: department; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.department (
    department_id integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    name text NOT NULL,
    term_id integer NOT NULL,
    school_id integer NOT NULL
);


--
-- Name: TABLE department; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.department IS 'Contains school department data';


--
-- Name: venue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.venue (
    venue_id integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    latitude numeric,
    longitude numeric,
    alttitude numeric,
    floor text,
    term_id integer NOT NULL,
    department_id integer NOT NULL,
    school_id integer NOT NULL
);


--
-- Name: TABLE venue; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.venue IS 'Contains school venues data';



--
-- Name: course; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.course (
    course_id integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    code text NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    value numeric,
    prerequisite_text text,
    preclusion_text text,
    corequisite_text text,
    term_id integer NOT NULL
);


--
-- Name: TABLE course; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.course IS 'Contains module/course data';


--
-- Name: lesson; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lesson (
    lesson_id integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    starts_at timestamp with time zone NOT NULL,
    end_at timestamp with time zone NOT NULL,
    type text NOT NULL,
    day text NOT NULL,
    week text NOT NULL,
    code text NOT NULL,
    course_id integer NOT NULL,
    venue_id integer NOT NULL
);


--
-- Name: TABLE lesson; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.lesson IS 'Contains school lesson/recitation/lecture data';


--
-- Name: url; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.url (
    short_url text PRIMARY KEY,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    long_url text NOT NULL
);


--
-- Name: TABLE url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.url IS 'URL shorterner service table';


--
-- Name: days_of_week; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.days_of_week (
    day text PRIMARY KEY
);


--
-- Name: TABLE days_of_week; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.days_of_week IS 'Describes days of week (e.g. Mon, Tues)';


--
-- Name: TABLE days_of_week; Type: INSERT; Schema: public; Owner: -
--
INSERT INTO public.days_of_week (day)
VALUES  ('Monday'), ('Tuesday'), ('Wednesday'), ('Thursday'), ('Friday'),
        ('Saturday'), ('Sunday');


--
-- Name: session session_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.account(account_id) ON DELETE CASCADE;


--
-- Name: session session_expires_at_future; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_expires_at_future CHECK (expires_at > now());

--
-- Name: course course_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.term(term_id);


--
-- Name: department department_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.school(school_id);


--
-- Name: department department_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.term(term_id);


--
-- Name: lesson lesson_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.course(course_id);


--
-- Name: lesson lesson_day_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_day_fkey FOREIGN KEY (day) REFERENCES public.days_of_week(day);


--
-- Name: lesson lesson_venue_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_venue_id_fkey FOREIGN KEY (venue_id) REFERENCES public.venue(venue_id);


--
-- Name: term term_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.term
    ADD CONSTRAINT term_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.school(school_id);


--
-- Name: venue venue_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venue
    ADD CONSTRAINT venue_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.department(department_id);


--
-- Name: venue venue_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venue
    ADD CONSTRAINT venue_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.school(school_id);


--
-- Name: venue venue_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venue
    ADD CONSTRAINT venue_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.term(term_id);


--
-- PostgreSQL database dump complete
--

