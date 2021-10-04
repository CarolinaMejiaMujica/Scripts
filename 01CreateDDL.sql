SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET client_min_messages = warning;
SET DATESTYLE TO 'European';

--------------TABLA DEPARTAMENTOS-----------------
CREATE TABLE Departamentos(
  id_departamento SERIAL NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  latitud DOUBLE PRECISION[],
  longitud DOUBLE PRECISION[],
  CONSTRAINT pk_id_departamento PRIMARY KEY (id_departamento)
);

ALTER TABLE Departamentos OWNER TO postgres;

COMMENT ON TABLE Departamentos
	IS 'Tabla donde se registran los departamentos';
  
COMMENT ON COLUMN Departamentos.id_departamento
    IS 'Identificador del registro en la tabla departamentos';

COMMENT ON COLUMN Departamentos.nombre
    IS 'Nombre del departamento';

COMMENT ON COLUMN Departamentos.latitud
    IS 'Latitudes del departamento';
	
COMMENT ON COLUMN Departamentos.longitud
    IS 'Longitudes del departamento';
--------------TABLA SECUENCIAS-----------------
CREATE TABLE Secuencias(
  id_secuencia SERIAL NOT NULL,
  codigo VARCHAR(25) NOT NULL,
  secuencia TEXT NOT NULL,
  fecha_recoleccion DATE NOT NULL,
  secuencia_alineada TEXT,
  id_departamento INTEGER NOT NULL,
  linaje_pango TEXT,
  CONSTRAINT pk_id_secuencia PRIMARY KEY (id_secuencia)
);

ALTER TABLE ONLY Secuencias
    ADD CONSTRAINT fk_secuencias_departamento
	FOREIGN KEY (id_departamento) 
	REFERENCES departamentos(id_departamento);

ALTER TABLE Secuencias OWNER TO postgres;

COMMENT ON TABLE Secuencias
	IS 'Tabla donde se registran las secuencias genómicas SARS-CoV-2';
  
COMMENT ON COLUMN Secuencias.id_secuencia
    IS 'Identificador del registro en la tabla secuencias';
	
COMMENT ON COLUMN Secuencias.codigo
    IS 'Identificador de la secuencia genómica SARS-CoV-2 en GISAID';
	
COMMENT ON COLUMN Secuencias.secuencia
    IS 'Representación de la secuencia genómica SARS-CoV-2';

COMMENT ON COLUMN Secuencias.fecha_recoleccion
    IS 'Fecha de recolección de la secuencia genómica SARS-CoV-2';
	
COMMENT ON COLUMN Secuencias.secuencia_alineada
    IS 'Representación de la secuencia genómica SARS-CoV-2 alineada';

COMMENT ON COLUMN Secuencias.id_departamento
    IS 'Identificador del departamento donde se recolecto la secuencia genómica SARS-CoV-2';
	
COMMENT ON COLUMN Secuencias.linaje_pango
    IS 'Linaje pango de la secuencia genómica SARS-CoV-2 en GISAID';
	
--------------TABLA VARIANTES-----------------
CREATE TABLE Variantes(
  id_variante SERIAL NOT NULL,
  nomenclatura VARCHAR(20) NOT NULL,
  linaje_pango TEXT[],
  sustituciones_spike TEXT[],
  nombre VARCHAR(20),
  color VARCHAR(10) NOT NULL,
  CONSTRAINT pk_id_variante PRIMARY KEY (id_variante)
);

ALTER TABLE Variantes OWNER TO postgres;

COMMENT ON TABLE Variantes
	IS 'Tabla donde se registran las variantes';
  
COMMENT ON COLUMN Variantes.id_variante
    IS 'Identificador del registro en la tabla variante';
  
COMMENT ON COLUMN Variantes.nomenclatura
    IS 'Nomenclatura de la OMS para la variante';
  
COMMENT ON COLUMN Variantes.linaje_pango
    IS 'Linaje(s) Pango de la variante';
  
COMMENT ON COLUMN Variantes.sustituciones_spike
    IS 'Sustituciones de la proteína spike';

COMMENT ON COLUMN Variantes.nombre
    IS 'Nombre de la variante';
	
COMMENT ON COLUMN Variantes.color
    IS 'Color identificador de la variante';

--------------TABLA ALGORITMOS-----------------
CREATE TABLE Algoritmos(
  id_algoritmo SERIAL NOT NULL,
  nombre VARCHAR(20) NOT NULL,
  parametro INTEGER DEFAULT 0,
  algoritmo_entrenado BYTEA,
  CONSTRAINT pk_id_algoritmo PRIMARY KEY (id_algoritmo)
);

ALTER TABLE Algoritmos OWNER TO postgres;

COMMENT ON TABLE Algoritmos
	IS 'Tabla donde se registran los algoritmos';
  
COMMENT ON COLUMN Algoritmos.id_algoritmo
    IS 'Identificador del registro en la tabla algoritmos';

COMMENT ON COLUMN Algoritmos.nombre
    IS 'Nombre del algoritmo';

COMMENT ON COLUMN Algoritmos.parametro
    IS 'Valor del parámetro para el algoritmo de agrupamiento, puede ser k, epsilon o número de cluster';

COMMENT ON COLUMN Algoritmos.algoritmo_entrenado
    IS 'Archivo con el algoritmo entrenado';

--------------TABLA AGRUPAMIENTO-----------------
CREATE TABLE Agrupamiento(
  id_agrupamiento SERIAL NOT NULL,
  id_algoritmo INTEGER NOT NULL,
  id_secuencia INTEGER NOT NULL,
  id_variante INTEGER NOT NULL,
  num_cluster INTEGER DEFAULT 0,
  CONSTRAINT pk_id_agrupamiento PRIMARY KEY (id_agrupamiento)
);

ALTER TABLE ONLY Agrupamiento
    ADD CONSTRAINT fk_agrupamiento_algoritmo
	FOREIGN KEY (id_algoritmo) 
	REFERENCES algoritmos(id_algoritmo);
	
ALTER TABLE ONLY Agrupamiento
    ADD CONSTRAINT fk_agrupamiento_secuencia
	FOREIGN KEY (id_secuencia) 
	REFERENCES secuencias(id_secuencia);
	
ALTER TABLE ONLY Agrupamiento
    ADD CONSTRAINT fk_agrupamiento_variante
	FOREIGN KEY (id_variante) 
	REFERENCES variantes(id_variante);

ALTER TABLE Agrupamiento OWNER TO postgres;

COMMENT ON TABLE Agrupamiento
	IS 'Tabla donde se registran los agrupamientos realizados';
  
COMMENT ON COLUMN Agrupamiento.id_agrupamiento
    IS 'Identificador del registro en la tabla agrupamiento';

COMMENT ON COLUMN Agrupamiento.id_algoritmo
    IS 'Identificador del algoritmo';
	
COMMENT ON COLUMN Agrupamiento.id_secuencia
    IS 'Identificador de la secuencia genómica SARS-CoV-2';

COMMENT ON COLUMN Agrupamiento.id_variante
    IS 'Identificador de la variante';

COMMENT ON COLUMN Agrupamiento.num_cluster
    IS 'Número de cluster al que pertenece la secuencia genómica SARS-CoV-2';

--------------TABLA ARCHIVOS-----------------
CREATE TABLE Archivos(
  id_archivo SERIAL NOT NULL,
  matriz_distancia BYTEA,
  mds BYTEA,
  pca BYTEA,
  CONSTRAINT pk_id_archivo PRIMARY KEY (id_archivo)
);

ALTER TABLE Archivos OWNER TO postgres;

COMMENT ON TABLE Archivos
	IS 'Tabla donde se registran los archivos';

COMMENT ON COLUMN Archivos.id_archivo
    IS 'Identificador del registro en la tabla archivos';

COMMENT ON COLUMN Archivos.matriz_distancia
    IS 'Archivo que contiene la matriz de distancia';

COMMENT ON COLUMN Archivos.mds
    IS 'Archivo de MDS';

COMMENT ON COLUMN Archivos.pca
    IS 'Archivo de PCA';