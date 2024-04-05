/* 1. Junções Internas
Escreva uma consulta que retorne o nome e sobrenome de todos os administradores (officer) com o nome
da empresa que eles administram (business.name) e cidade onde ela está presente (customer.city).
*/
/* Davi Carreta Barcellos */
SELECT officer.fname 'Nome', officer.lname 'Sobrenome', business.name 'Empresa', customer.city 'Cidade'
FROM officer, business, customer
WHERE officer.cust_id = business.cust_id and business.cust_id = customer.cust_id;

/* 2. Junções Internas, União e Seleção
Escreva uma consulta que retorne os nome dos clientes (nome das pessoas jurídicas ou nome + sobrenome
das pessoas físicas) que possuem uma conta em uma cidade diferente da cidade de estabelecimento. 
*/
/* Gabriel da Silva Reboli */
SELECT individual.fname 'Nome', individual.lname 'Sobrenome', customer.city as 'Cidade de Estabelecimento', branch.city as 'Cidade da Conta'
FROM individual
JOIN customer ON individual.cust_id = customer.cust_id
JOIN account ON customer.cust_id = account.cust_id
JOIN branch ON account.open_branch_id = branch.branch_id
WHERE customer.city != branch.city
GROUP BY individual.fname, individual.lname, customer.city, branch.city;

/*3. Junção Externa, Agrupamento, Agregação e Ordenação
Escreva uma consulta que retorne os nome de todos os funcionários com, se for o caso, os números de
transações por ano envolvendo as contas que eles abriram (usando open_emp_id). Ordene os resultados
por ordem alfabética, e depois por ano (do mais antigo para o mais recente).
*/
/* Eduardo Venturini Erler */
SELECT employee.fname AS Nome, 
       employee.lname AS Sobrenome, 
       YEAR(transaction.txn_date) AS Ano,
       COUNT(transaction.txn_id) AS "Numero de transacoes"
FROM employee
LEFT JOIN account ON employee.emp_id = account.open_emp_id
LEFT JOIN transaction ON account.account_id = transaction.account_id
GROUP BY employee.emp_id, YEAR(transaction.txn_date)
ORDER BY employee.fname, employee.lname, Ano;

/*4. Junções Internas, Agrupamento, Agregação, União e Concatenação
Escreva uma consulta que retorne os identificadores de contas com maior saldo de dinheiro por agência,
juntamente com os nomes dos titulares (nome da empresa ou nome e sobrenome da pessoa física) e os
nomes dessas agências.
*/
/* Pedro Lopes Monteiro */
SELECT branch.name AS "Nome da Agencia",
	   account.account_id AS "Identificador da Conta",
    CASE 
        WHEN individual.fname IS NOT NULL THEN CONCAT(individual.fname, ' ', individual.lname)
        ELSE business.name
    END AS "Nome do Titular",
    account.avail_balance AS "Maior Saldo"
FROM account
JOIN branch ON account.open_branch_id = branch.branch_id
LEFT JOIN individual ON account.cust_id = individual.cust_id
LEFT JOIN business ON account.cust_id = business.cust_id
WHERE (account.open_branch_id, account.avail_balance) IN (
    SELECT open_branch_id, MAX(avail_balance)
    FROM account
    GROUP BY open_branch_id
);


/*5.Visualização
Escreva de novo e modularize as consultas 2. e 4. utilizando uma visualização (CREATE VIEW).
*/
/* Danillo Broseghini da Silva */
CREATE VIEW ClienteContaCidadeDiferente AS
SELECT individual.fname 'Nome', individual.lname 'Sobrenome', customer.city as 'Cidade de Estabelecimento', branch.city as 'Cidade da Conta'
FROM individual
JOIN customer ON individual.cust_id = customer.cust_id
JOIN account ON customer.cust_id = account.cust_id
JOIN branch ON account.open_branch_id = branch.branch_id
WHERE customer.city != branch.city
GROUP BY individual.fname, individual.lname, customer.city, branch.city;


SELECT * FROM ClienteContaCidadeDiferente;


CREATE VIEW ContaMaiorSaldoPorAgencia AS
SELECT branch.name AS "Nome da Agencia",
	   account.account_id AS "Identificador da Conta",
    CASE 
        WHEN individual.fname IS NOT NULL THEN CONCAT(individual.fname, ' ', individual.lname)
        ELSE business.name
    END AS "Nome do Titular",
    account.avail_balance AS "Maior Saldo"
FROM account
JOIN branch ON account.open_branch_id = branch.branch_id
LEFT JOIN individual ON account.cust_id = individual.cust_id
LEFT JOIN business ON account.cust_id = business.cust_id
WHERE (account.open_branch_id, account.avail_balance) IN (
    SELECT open_branch_id, MAX(avail_balance)
    FROM account
    GROUP BY open_branch_id
);
         
SELECT * FROM ContaMaiorSaldoPorAgencia;