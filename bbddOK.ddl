-- Generado por Oracle SQL Developer Data Modeler 20.2.0.167.1538
--   en:        2020-12-06 17:50:19 CET
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE acta (
    nota_numerica           NUMBER(5, 2) NOT NULL,
    nota_cualitativa        VARCHAR2(10) NOT NULL,
    n_convocatoria          NUMBER(1) NOT NULL,
    matricula_n_expediente  VARCHAR2(15) NOT NULL,
    asignatura_referencia   VARCHAR2(6) NOT NULL,
    matricula_dni           VARCHAR2(10) NOT NULL
);

ALTER TABLE acta
    ADD CONSTRAINT acta_pk PRIMARY KEY ( matricula_n_expediente,
                                         matricula_dni,
                                         asignatura_referencia );

CREATE TABLE alfil (
    docencia               CHAR(1) NOT NULL,
    firma_acta             CHAR(1) NOT NULL,
    es_coordinador         CHAR(1) NOT NULL,
    asignatura_referencia  VARCHAR2(6) NOT NULL,
    profesor_dni           VARCHAR2(10) NOT NULL
);

ALTER TABLE alfil ADD CONSTRAINT alfil_pk PRIMARY KEY ( asignatura_referencia,
                                                        profesor_dni );

CREATE TABLE alumno (
    dni             VARCHAR2(10) NOT NULL,
    email_personal  VARCHAR2(50) NOT NULL,
    tlf_movil       VARCHAR2(20) NOT NULL,
    tlf_fijo        VARCHAR2(20)
);

ALTER TABLE alumno ADD CONSTRAINT alumno_pk PRIMARY KEY ( dni );

ALTER TABLE alumno ADD CONSTRAINT alumno_email_personal_un UNIQUE ( email_personal );

CREATE TABLE asignatura (
    referencia               VARCHAR2(6) NOT NULL,
    nombre                   VARCHAR2(20) NOT NULL,
    caracter                 VARCHAR2(10) NOT NULL,
    creditos                 NUMBER(3) NOT NULL,
    duracion                 VARCHAR2(10) NOT NULL,
    unidad_temporal          VARCHAR2(10) NOT NULL,
    pie                      CHAR(1) NOT NULL,
    primer_idioma            VARCHAR2(10) NOT NULL,
    segundo_idioma           VARCHAR2(10),
    n_plazas                 NUMBER(3),
    titulacion_codigo        VARCHAR2(5),
    departamento_codigo_dep  VARCHAR2(5) NOT NULL
);

ALTER TABLE asignatura ADD CONSTRAINT asignatura_pk PRIMARY KEY ( referencia );

CREATE TABLE companeros (
    matricula_n_expediente  VARCHAR2(15) NOT NULL,
    matricula_dni           VARCHAR2(10) NOT NULL,
    grupo_curso             VARCHAR2(5) NOT NULL,
    grupo_nombre_grupo      CHAR(1) NOT NULL
);

ALTER TABLE companeros
    ADD CONSTRAINT companeros_pk PRIMARY KEY ( matricula_n_expediente,
                                               matricula_dni,
                                               grupo_curso,
                                               grupo_nombre_grupo );

CREATE TABLE comunidad_universitaria (
    dni                  VARCHAR2(10) NOT NULL,
    nombre_completo      VARCHAR2(30) NOT NULL,
    email_institucional  VARCHAR2(50) NOT NULL
);

ALTER TABLE comunidad_universitaria ADD CONSTRAINT comunidad_universitaria_pk PRIMARY KEY ( dni );

CREATE TABLE departamento (
    codigo_dep  VARCHAR2(5) NOT NULL,
    nombre_dep  VARCHAR2(50) NOT NULL,
    tlf_dep     VARCHAR2(20) NOT NULL
);

ALTER TABLE departamento ADD CONSTRAINT departamento_pk PRIMARY KEY ( codigo_dep );

CREATE TABLE elige (
    asignatura_referencia  VARCHAR2(6) NOT NULL,
    encuesta_alumno_dni    VARCHAR2(10) NOT NULL
);

ALTER TABLE elige ADD CONSTRAINT elige_pk PRIMARY KEY ( asignatura_referencia,
                                                        encuesta_alumno_dni );

CREATE TABLE encuesta (
    turno_preferente   VARCHAR2(10) NOT NULL,
    fecha_realizacion  DATE NOT NULL,
    alumno_dni         VARCHAR2(10) NOT NULL
);

ALTER TABLE encuesta ADD CONSTRAINT encuesta_pk PRIMARY KEY ( alumno_dni );

CREATE TABLE grupo (
    curso         VARCHAR2(5) NOT NULL,
    nombre_grupo  CHAR(1) NOT NULL,
    turno         VARCHAR2(10) NOT NULL,
    descripcion   VARCHAR2(10)
);

ALTER TABLE grupo ADD CONSTRAINT grupo_pk PRIMARY KEY ( curso,
                                                        nombre_grupo );

CREATE TABLE horario (
    asignatura_referencia  VARCHAR2(6) NOT NULL,
    grupo_curso            VARCHAR2(5) NOT NULL,
    grupo_nombre_grupo     CHAR(1) NOT NULL,
    hora_inicio            DATE NOT NULL,
    hora_fin               DATE NOT NULL,
    dia                    VARCHAR2(10) NOT NULL
);

ALTER TABLE horario
    ADD CONSTRAINT horario_pk PRIMARY KEY ( asignatura_referencia,
                                            grupo_curso,
                                            grupo_nombre_grupo );

ALTER TABLE horario
    ADD CONSTRAINT horario_uk UNIQUE ( dia,
                                       hora_inicio,
                                       hora_fin,
                                       grupo_curso,
                                       grupo_nombre_grupo );

CREATE TABLE matricula (
    n_expediente            VARCHAR2(15) NOT NULL,
    n_archivo               VARCHAR2(15),
    fecha_matricula         DATE,
    turno_preferente        VARCHAR2(10) NOT NULL,
    curso_academico         VARCHAR2(9) NOT NULL,
    metodo_pago             VARCHAR2(20) NOT NULL,
    fecha_realizacion_pago  DATE,
    alumno_dni              VARCHAR2(10) NOT NULL
);

ALTER TABLE matricula ADD CONSTRAINT matricula_pk PRIMARY KEY ( n_expediente,
                                                                alumno_dni );

ALTER TABLE matricula ADD CONSTRAINT matricula_n_archivo_un UNIQUE ( n_archivo );

CREATE TABLE profesor (
    dni                       VARCHAR2(10) NOT NULL,
    curso_academico           VARCHAR2(10) NOT NULL,
    titulacion                VARCHAR2(50) NOT NULL,
    categoria_administrativa  VARCHAR2(50) NOT NULL,
    departamento_codigo_dep   VARCHAR2(5) NOT NULL
);

ALTER TABLE profesor ADD CONSTRAINT profesor_pk PRIMARY KEY ( dni );

CREATE TABLE titulacion (
    codigo            VARCHAR2(5) NOT NULL,
    nombre            VARCHAR2(20) NOT NULL,
    centro_adicional  VARCHAR2(50)
);

ALTER TABLE titulacion ADD CONSTRAINT titulacion_pk PRIMARY KEY ( codigo );

ALTER TABLE acta
    ADD CONSTRAINT acta_asignatura_fk FOREIGN KEY ( asignatura_referencia )
        REFERENCES asignatura ( referencia );

ALTER TABLE acta
    ADD CONSTRAINT acta_matricula_fk FOREIGN KEY ( matricula_n_expediente,
                                                   matricula_dni )
        REFERENCES matricula ( n_expediente,
                               alumno_dni );

ALTER TABLE alfil
    ADD CONSTRAINT alfil_asignatura_fk FOREIGN KEY ( asignatura_referencia )
        REFERENCES asignatura ( referencia );

ALTER TABLE alfil
    ADD CONSTRAINT alfil_profesor_fk FOREIGN KEY ( profesor_dni )
        REFERENCES profesor ( dni );

ALTER TABLE alumno
    ADD CONSTRAINT alumno_c_u_fk FOREIGN KEY ( dni )
        REFERENCES comunidad_universitaria ( dni );

ALTER TABLE asignatura
    ADD CONSTRAINT asignatura_departamento_fk FOREIGN KEY ( departamento_codigo_dep )
        REFERENCES departamento ( codigo_dep );

ALTER TABLE asignatura
    ADD CONSTRAINT asignatura_titulacion_fk FOREIGN KEY ( titulacion_codigo )
        REFERENCES titulacion ( codigo );

ALTER TABLE companeros
    ADD CONSTRAINT companeros_grupo_fk FOREIGN KEY ( grupo_curso,
                                                     grupo_nombre_grupo )
        REFERENCES grupo ( curso,
                           nombre_grupo );

ALTER TABLE companeros
    ADD CONSTRAINT companeros_matricula_fk FOREIGN KEY ( matricula_n_expediente,
                                                         matricula_dni )
        REFERENCES matricula ( n_expediente,
                               alumno_dni );

ALTER TABLE elige
    ADD CONSTRAINT elige_asignatura_fk FOREIGN KEY ( asignatura_referencia )
        REFERENCES asignatura ( referencia );

ALTER TABLE elige
    ADD CONSTRAINT elige_encuesta_fk FOREIGN KEY ( encuesta_alumno_dni )
        REFERENCES encuesta ( alumno_dni );

ALTER TABLE encuesta
    ADD CONSTRAINT encuesta_alumno_fk FOREIGN KEY ( alumno_dni )
        REFERENCES alumno ( dni );

ALTER TABLE horario
    ADD CONSTRAINT horario_asignatura_fk FOREIGN KEY ( asignatura_referencia )
        REFERENCES asignatura ( referencia );

ALTER TABLE horario
    ADD CONSTRAINT horario_grupo_fk FOREIGN KEY ( grupo_curso,
                                                  grupo_nombre_grupo )
        REFERENCES grupo ( curso,
                           nombre_grupo );

ALTER TABLE matricula
    ADD CONSTRAINT matricula_alumno_fk FOREIGN KEY ( alumno_dni )
        REFERENCES alumno ( dni );

ALTER TABLE profesor
    ADD CONSTRAINT profesor_c_u_fk FOREIGN KEY ( dni )
        REFERENCES comunidad_universitaria ( dni );

ALTER TABLE profesor
    ADD CONSTRAINT profesor_departamento_fk FOREIGN KEY ( departamento_codigo_dep )
        REFERENCES departamento ( codigo_dep );

--  ERROR: No Discriminator Column found in Arc FKArc_1 - constraint trigger for Arc cannot be generated 

--  ERROR: No Discriminator Column found in Arc FKArc_1 - constraint trigger for Arc cannot be generated



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            14
-- CREATE INDEX                             0
-- ALTER TABLE                             34
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   2
-- WARNINGS                                 0
