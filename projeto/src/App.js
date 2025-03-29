import React, { useState } from 'react';
import './styles/App.css';

function App() {
  const [query, setQuery] = useState('');
  const [operadoras, setOperadoras] = useState([]);
  const [loading, setLoading] = useState(false); // Adiciona estado de carregamento

  const buscarOperadoras = async () => {
    if (!query.trim()) {
      setOperadoras([]); // Limpa os resultados se a consulta estiver vazia
      return;
    }

    setLoading(true); // Inicia o carregamento
    try {
      const response = await fetch(`http://localhost:3001/search?query=${query}`);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      setOperadoras(data);
      console.log('Resultados da busca:', data);
      console.log('Dados recebidos da API:', data);
    } catch (error) {
      console.error('Erro ao buscar operadoras:', error);
      setOperadoras([]);
    } finally {
      setLoading(false); // Finaliza o carregamento
    }
  };

  return (
    <div className="App">
      <header className="App-header">
        <nav className="navbar">
          <div className="logo">Intuitive Care</div>
          <ul className="nav-links">
            <li><a href="/inicio">Início</a></li>
            <li><a href="/sobre">Sobre</a></li>
            <li><a href="/servicos">Serviços</a></li>
            <li><a href="/contato">Contato</a></li>
          </ul>
        </nav>
      </header>

      <section className="operador">
        <div className="container">
          <div className="quadrado">
            <h1>Buscar Operadoras de Saúde</h1>
            <input
              type="text"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder="Digite o nome da operadora..."
            />
            <button onClick={buscarOperadoras}>Buscar</button>

            {loading && <p>Carregando...</p>} {/* Exibe carregamento */}

            {operadoras.length === 0 && !loading && <p>Nenhuma operadora encontrada.</p>} {/* Exibe mensagem se não houver resultados */}

            <ul>
              {operadoras.map((operadora) => (
                <li key={operadora.CNPJ}>
                  <strong>{operadora.NOME_OPERADORA}</strong>
                  <br />
                  CNPJ: {operadora.CNPJ}
                  <br />
                  Status: {operadora.STATUS_OPERADORA}
                </li>
              ))}
            </ul>
          </div>
        </div>
      </section>
    </div>
  );
}

export default App;