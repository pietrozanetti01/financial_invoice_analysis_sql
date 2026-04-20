USE fatturazione;
SELECT COUNT(*) AS num_clienti FROM clienti;
SELECT COUNT(*) AS num_fatture FROM fatture;
SELECT COUNT(*) AS num_pagamenti FROM pagamenti;
SELECT COUNT(*) AS num_metodi_pagamento FROM metodi_pagamento;
SELECT SUM(totale_fattura) AS fatturato_totale FROM fatture;
SELECT SUM(importo) AS incasso_totale FROM pagamenti;
SELECT id_fattura, numero, id_cliente, totale_fattura, totale_pagamento, (totale_fattura - totale_pagamento) AS residuo
FROM fatture
WHERE totale_pagamento < totale_fattura
ORDER BY residuo DESC;
SELECT c.id_cliente, c.nome, COUNT(f.id_fattura) AS numero_fatture, SUM(f.totale_fattura) AS fatturato_cliente,
SUM(f.totale_pagamento) AS pagato_cliente,
SUM(f.totale_fattura - f.totale_pagamento) AS credito_residuo
FROM clienti c
JOIN fatture f
ON c.id_cliente = f.id_cliente
GROUP BY c.id_cliente, c.nome
ORDER BY fatturato_cliente DESC;
SELECT id_fattura, numero, data_fattura, data_scadenza, data_pagamento, DATEDIFF(data_pagamento, data_scadenza) AS giorni_ritardo
FROM fatture
WHERE data_pagamento IS NOT NULL
AND data_pagamento > data_scadenza
ORDER BY giorni_ritardo DESC;
SELECT
m.descrizione AS metodo_pagamento,
COUNT(*) AS numero_pagamenti,
SUM(p.importo) AS totale_incassato
FROM pagamenti p
JOIN metodi_pagamento m
ON p.metodo_pagamento = m.id_metodo_pagamento
GROUP BY m.descrizione
ORDER BY totale_incassato DESC;
SELECT
DATE_FORMAT(data_fattura, '%Y-%m') AS mese,
COUNT(*) AS numero_fatture,
SUM(totale_fattura) AS fatturato_mensile,
SUM(totale_pagamento) AS incassato_mensile
FROM fatture
GROUP BY DATE_FORMAT(data_fattura, '%Y-%m')
ORDER BY mese;
SELECT
ROUND(SUM(totale_pagamento) / SUM(totale_fattura) * 100, 2) AS collection_rate_percent
FROM fatture;
