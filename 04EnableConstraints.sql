ALTER TABLE ONLY secuencias
    ADD CONSTRAINT fk_secuencias_departamento 
	FOREIGN KEY (id_departamento) 
	REFERENCES departamentos(id_departamento);

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