-- Eliminação de coluna inútil
SELECT * EXCEPT (int64_field_0)
FROM `aulasql-eba-485011.ifood.mkt_data`
LIMIT 10

--- ENTENDENDO O PERFIL DOS CLIENTES
-- Qual é o maior e menor salário encontrado na nossa base? (Income) 
SELECT DISTINCT
  ROUND(MIN(Income), 2) AS min_income,  -- Valor do menor salário (R$ 1.730,00)
  ROUND(Max(Income), 2)
    AS max_income,  -- Valor do maior salário (R$ 113.734,00)
  ROUND(AVG(Income), 2)
    AS avg_income  -- Valor médio do salário (R$ 51.622,09)
FROM `ifood.mkt_data`

-- Qual é a distribuiçao salarial da nossa base? Clientes que ganham muito bem e outros que ganham muito mal? (Income)
SELECT
  CASE
    WHEN Income < 40000 THEN 'Baixa renda' -- Total de clientes 731
    WHEN Income BETWEEN 40000 AND 70000 THEN 'Média renda' -- Total de clientes 975
    ELSE 'Alta renda' -- Total de clientes 499
    END AS faixa_renda,
  COUNT(*) AS total_cliente
FROM `ifood.mkt_data`
GROUP BY faixa_renda

-- Nossos clientes tem nivel educacional maior ou menor? (education_level)
SELECT 
 education_level,
 COUNT(*) AS total
 FROM `ifood.mkt_data`
 GROUP BY 1
 ORDER BY total DESC
 --Graduacao 1113
 -- Phd 476
 -- Master 364
 -- 2n Cycle 198 
 -- Basic 54

-- Quantos clientes temos em cada estado civil? (marital_status)
SELECT 
 marital_status,
 COUNT(*) AS total
FROM `ifood.mkt_data`
GROUP BY 1
ORDER BY total DESC
--Casada 854
-- Juntos 568 
-- Solteiro 477
-- Divorciado 230 
--Viuvo 76

-- Quantos cliente temos em relaçao a quantidade de filhos? (kids)
SELECT 
 kids, 
 COUNT(*) AS total
FROM `ifood.mkt_data`
GROUP BY 1
ORDER BY total DESC
-- 1 KID 1112
-- 0 KID 628
--2 KID 415
-- 3 KID 50
--OBS: A marioria dos cliente possui até 1 filho. Para entender o impacto disso no consumo, é necessário analisar a relaçao entre número de filhos e gastos. 

---COMPORTAMENTO DO CONSUMO: CORRELAÇAO 
-- As pessoas gastam mais ou menos em nossa plataforma quando tem filhos? (Gastos e quantidade de filhos)
SELECT 
 kids, 
 ROUND(AVG(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds),2) AS avg_expenses
FROM `ifood.mkt_data`
GROUP BY 1
ORDER BY 1 
-- Quem tem 0 filho gasta 1.105,59
-- Quem tem 1 filho gasta 475,20
-- Quem tem 3 filhos gasta 255,5
-- Quem tem 2 filhos gasta 247,07 

-- Qual a relacao de estado civil com o numenro de filhos? Será que as pessoas casadas tem um maior numento de filhos? (marital_status e kids)
SELECT 
 marital_status, 
 ROUND(AVG(Kids),2) AS media_filhos,
 COUNT(*) AS total_cliente  
FROM `ifood.mkt_data`
GROUP BY 1
ORDER BY 2 DESC
---Obs: Divorciados tem uma media levemente maior, diferença minima de 0,03, se comparado com o grupo de clientes casadas, onde tem a maior quantidade de clientes. 
--Clientes divorciados apresentam uma média ligeiramente maior de filhos, porém a diferença em relaçao aos casados é pequena. Como o grupo de clientes casados é significativamente maior, eles representam a maior parte dos clientes com filhos na base. 
--Portanto, isso pode indicar que ter filhos náo está fortemente ligado ao estado civil, ou seja, nao é um bom critério sozinho para segmentaçao. 

SELECT DISTINCT
 marital_status,
 kids,
 COUNT(*) AS total
FROM `ifood.mkt_data`
GROUP BY 1,2
ORDER BY 1,2
--Mostra que em todos os status civil, o maior numero de cliente tem 1 filho. 

---As pessoas que tem um maior salário gastam mais? (Income e expense)

SELECT 
 Income, 
 (MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) AS total_expense
FROM `ifood.mkt_data`
WHERE Income IS NOT NULL
--Agrupado

SELECT 
  CASE
   WHEN Income <40000 THEN 'Baixa renda'
   WHEN Income BETWEEN 40000 AND 70000 THEN 'Média renda'
   ELSE 'Alta renda'
  END AS faixa_renda, 
  ROUND(AVG(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds),2) AS media_expense,
  COUNT(*) AS total_clientes
FROM `ifood.mkt_data`
WHERE Income IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC

---A grande parte dos clientes (975) estao classificados com renda media, porem o a sua classificaçao em gasto medio esta em segundo lugar (591,98). O maior gasto medio (1387,22) é feito por clientes (499) que apresentam renda alta. 

-------INSGHT PROFISSIONAL 
-- Clientes de alta renda apresentam maior gasto médio e maior contribuiçao para a receita total, enquanto clientes de renda média representam a maior parte da base. Isso sugere a necessidade de estratégias distintas: rentençao e valorizaçao do público de alta renda, e estímulo ao aumento de consumo no segmento de renda média.


SELECT * EXCEPT (int64_field_0),
  (MntWines + MntFruits + MntMeatProducts + 
   MntFishProducts + MntSweetProducts + MntGoldProds) AS total_expenses,

  CASE 
    WHEN Income < 40000 THEN 'Baixa renda'
    WHEN Income BETWEEN 40000 AND 70000 THEN 'Média renda'
    ELSE 'Alta renda'
  END AS faixa_renda

FROM `ifood.mkt_data`
