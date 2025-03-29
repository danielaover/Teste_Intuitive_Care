const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');
const csv = require('csv-parser');

const app = express();
const port = 3001;

app.use(cors());
app.use(express.json());

let operadoras = [];

// Função para carregar os dados do CSV
const carregarDados = () => {
  const filePath = path.join(__dirname, '../files/Relatorio_cadop.csv');
  operadoras = []; 

  fs.createReadStream(filePath)
    .pipe(csv({ separator: ';' })) 
    .on('data', (row) => {
      operadoras.push({
        CNPJ: row.CNPJ,
        NOME_OPERADORA: row.NOME_OPERADORA,
        STATUS_OPERADORA: row.STATUS_OPERADORA
      });
    })
    .on('end', () => {
      console.log(`📄 CSV carregado com ${operadoras.length} operadoras.`);
      console.log('Dados lidos do CSV:', operadoras);
    })
    .on('error', (err) => {
      console.error('Erro ao ler o CSV:', err);
    });
};


carregarDados();


app.get('/search', (req, res) => {
  const query = req.query.query?.toLowerCase();
  if (!query) {
    return res.status(400).json({ error: "A consulta não pode estar vazia" });
  }

  
  if (!operadoras || operadoras.length === 0) {
    return res.status(500).json({ error: "Dados da operadora não carregados ou vazios" });
}

const resultados = operadoras.filter(op =>{
  
  if (op.NOME_OPERADORA) {
      return op.NOME_OPERADORA.toLowerCase().includes(query);
  }
  return false; 
});

const cors = require('cors');
console.log(JSON.stringify(resultados, null, 2));
app.use(cors());


  console.log('Resultados:', resultados); 

    // Garanta que o tipo de conteúdo seja definido como JSON
    res.setHeader('Content-Type', 'application/json');

  res.json(resultados);

});

app.listen(port, () => {
  console.log(`🚀 Servidor rodando em http://localhost:${3001}`);
});
