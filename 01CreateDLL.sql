SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET client_min_messages = warning;
SET DATESTYLE TO 'European';

--------------TABLA DEPARTAMENTOS-----------------
CREATE TABLE departamentos(
  id_departamento SERIAL NOT NULL,
  nombre CHARACTER VARYING(100) NOT NULL,
  latitud float[],
  longitud float[],
  CONSTRAINT pk_id_departamento PRIMARY KEY (id_departamento)
);

ALTER TABLE departamentos OWNER TO postgres;

COMMENT ON TABLE departamentos
	IS 'Tabla donde se definen los departamentos';
  
COMMENT ON COLUMN departamentos.id_departamento
    IS 'Identificador del registro en la tabla departamentos';

COMMENT ON COLUMN departamentos.nombre
    IS 'Nombre del departamento';

COMMENT ON COLUMN departamentos.latitud
    IS 'Latitudes del departamento';
	
COMMENT ON COLUMN departamentos.longitud
    IS 'Longitudes del departamento';
--------------TABLA SECUENCIAS-----------------
CREATE TABLE secuencias(
  id_secuencia SERIAL NOT NULL,
  codigo CHARACTER VARYING(25) NOT NULL,
  secuencia CHARACTER VARYING(30000) NOT NULL,
  fecha_recoleccion DATE NOT NULL,
  secuencia_alineada CHARACTER VARYING(30000),
  id_departamento INTEGER NOT NULL,
  CONSTRAINT pk_id_secuencia PRIMARY KEY (id_secuencia)
);

ALTER TABLE ONLY secuencias
    ADD CONSTRAINT fk_secuencias_departamento 
	FOREIGN KEY (id_departamento) 
	REFERENCES departamentos(id_departamento);

ALTER TABLE secuencias OWNER TO postgres;

COMMENT ON TABLE secuencias
	IS 'Tabla donde se definen las secuencias genómicas SARS-CoV-2';
  
COMMENT ON COLUMN secuencias.id_secuencia
    IS 'Identificador del registro en la tabla secuencias';
	
COMMENT ON COLUMN secuencias.secuencia
    IS 'Representación de la secuencia genómica SARS-CoV-2';

COMMENT ON COLUMN secuencias.fecha_recoleccion
    IS 'Fecha de recolección de la secuencia genómica SARS-CoV-2';
	
COMMENT ON COLUMN secuencias.secuencia_alineada
    IS 'Representación de la secuencia genómica SARS-CoV-2 alineada';

COMMENT ON COLUMN secuencias.id_departamento
    IS 'Identificador del departamento donde se recolecto la secuencia genómica SARS-CoV-2';
	
--------------TABLA VARIANTES-----------------
CREATE TABLE variantes(
  id_variante SERIAL NOT NULL,
  nomenclatura CHARACTER VARYING(20) NOT NULL,
  linaje_pango TEXT[],
  sustituciones_spike TEXT[],
  nombre CHARACTER VARYING(20),
  secuencia CHARACTER VARYING(3000),
  color CHARACTER VARYING(10) NOT NULL,  
  CONSTRAINT pk_id_variante PRIMARY KEY (id_variante)
);

ALTER TABLE variantes OWNER TO postgres;

COMMENT ON TABLE variantes
	IS 'Tabla donde se definen las variantes';
  
COMMENT ON COLUMN variantes.id_variante
    IS 'Identificador del registro en la tabla variante';
  
COMMENT ON COLUMN variantes.nomenclatura
    IS 'Nomenclatura de la OMS para la variante';
  
COMMENT ON COLUMN variantes.linaje_pango
    IS 'Linaje(s) Pango de la variante';
  
COMMENT ON COLUMN variantes.sustituciones_spike
    IS 'Sustituciones de la proteína spike';

COMMENT ON COLUMN variantes.nombre
    IS 'Nombre de la variante';
	
COMMENT ON COLUMN variantes.secuencia
    IS 'Secuencia de la variante';
  
COMMENT ON COLUMN variantes.color
    IS 'Color identificador de la variante';

--------------TABLA ALGORITMOS-----------------
CREATE TABLE algoritmos(
  id_algoritmo SERIAL NOT NULL,
  nombre CHARACTER VARYING(20) NOT NULL,
  parametro INTEGER DEFAULT 0,
  algoritmo_entrenado BYTEA,
  CONSTRAINT pk_id_algoritmo PRIMARY KEY (id_algoritmo)
);

ALTER TABLE algoritmos OWNER TO postgres;

COMMENT ON TABLE algoritmos
  IS 'Tabla donde se definen los algoritmos';
  
COMMENT ON COLUMN algoritmos.id_algoritmo
    IS 'Identificador del registro en la tabla algoritmos';

COMMENT ON COLUMN algoritmos.nombre
    IS 'Nombre del algoritmo';

COMMENT ON COLUMN algoritmos.parametro
    IS 'Valor del parámetro para el algoritmo de agrupamiento, puede ser k, epsilon o número de cluster';

COMMENT ON COLUMN algoritmos.algoritmo_entrenado
    IS 'Archivo con el algoritmo entrenado';

--------------TABLA AGRUPAMIENTO-----------------
CREATE TABLE agrupamiento(
  id_agrupamiento SERIAL NOT NULL,
  id_algoritmo INTEGER NOT NULL,
  id_secuencia INTEGER NOT NULL,
  id_variante INTEGER NOT NULL,
  num_cluster INTEGER DEFAULT 0,
  CONSTRAINT pk_id_agrupamiento PRIMARY KEY (id_agrupamiento)
);

ALTER TABLE ONLY agrupamiento
    ADD CONSTRAINT fk_agrupamiento_algoritmo
	FOREIGN KEY (id_algoritmo) 
	REFERENCES algoritmos(id_algoritmo);
	
ALTER TABLE ONLY agrupamiento
    ADD CONSTRAINT fk_agrupamiento_secuencia 
	FOREIGN KEY (id_secuencia) 
	REFERENCES secuencias(id_secuencia);
	
ALTER TABLE ONLY agrupamiento
    ADD CONSTRAINT fk_agrupamiento_variante 
	FOREIGN KEY (id_variante) 
	REFERENCES variantes(id_variante);

ALTER TABLE agrupamiento OWNER TO postgres;

COMMENT ON TABLE agrupamiento
  IS 'Tabla donde se definen los agrupamientos';
  
COMMENT ON COLUMN agrupamiento.id_agrupamiento
    IS 'Identificador del registro en la tabla agrupamiento';

COMMENT ON COLUMN agrupamiento.id_algoritmo
    IS 'Identificador del algoritmo';
	
COMMENT ON COLUMN agrupamiento.id_secuencia
    IS 'Identificador de la secuencia genómica SARS-CoV-2';

COMMENT ON COLUMN agrupamiento.id_variante
    IS 'Identificador de la variante';

COMMENT ON COLUMN agrupamiento.num_cluster
    IS 'Número de cluster al que pertenece la secuencia genómica SARS-CoV-2';

--------------TABLA ARCHIVOS-----------------
CREATE TABLE archivos(
  id_archivo SERIAL NOT NULL,
  preprocesamiento BYTEA,
  pca BYTEA,
  estandarizada BYTEA,
  CONSTRAINT pk_id_archivo PRIMARY KEY (id_archivo)
);

ALTER TABLE archivos OWNER TO postgres;

COMMENT ON TABLE archivos
  IS 'Tabla donde se definen los archivos';
  
COMMENT ON COLUMN archivos.id_archivo
    IS 'Identificador del registro en la tabla archivos';
	
COMMENT ON COLUMN archivos.preprocesamiento
    IS 'Archivo del preprocesamiento';
	
COMMENT ON COLUMN archivos.pca
    IS 'Archivo de pca';
	
COMMENT ON COLUMN archivos.estandarizada
    IS 'Archivo con la data estandarizada';