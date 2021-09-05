
ALTER TABLE secuencias drop constraint fk_secuencias_departamento;

ALTER TABLE agrupamiento drop constraint fk_agrupamiento_algoritmo;

ALTER TABLE agrupamiento drop constraint fk_agrupamiento_secuencia;

ALTER TABLE agrupamiento drop constraint fk_agrupamiento_variante;
