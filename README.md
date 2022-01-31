# ETL-Challenge-API

 <br><br>
>  Este projeto é uma REST API que utiliza os dados da API http://challenge.dienekes.com.br/api, uma API pública que disponibiliza um array de números fora de ordem a cada page solicitada. A ETL-Challenge-API tem a missão de realizar um processo de ETL (Extract, Transform and Load). Extrair os todos os números contidos no http://challenge.dienekes.com.br/api, ordená-los de forma crescente, salvá-los e deve expor uma API que disponibiliza o conjunto final de números ordenados.


## Apresentação


## 💻 Tecnologias usadas

### Linguagem:
* <b>Ruby 3.0.1</b>

### Freamwork Web:
*  <b>Rails 6.1.4.4</b>

### Banco de Dados:
* <b>SQLite3</b>
-------------------------
### Gems Auxiliares:
- <b>RSpec</b> -Testes Automatizados
- <b>JBuilder</b> - Respondendo com JSON
- <b>RestClient</b> - Acessando outras APIs
- <b>Kaminari</b> - Paginação

## 🚀 Instalando ETL-Challenge-API

Para instalar o ETL-Challenge-API, siga estas etapas:

Após clonar o projeto na sua máquina... 

Através do terminal navegue até o diretório do projeto e execute: 

```bash
$ bundle
```
```bash
$ rails db:create
```
```bash
$ rails db:migrate
```

## Processo de ETL (Extract, Transform and Load)
```bash
$ rails make_etl:do
```
## Executar testes automatizados
```bash
$ rspec
```

## Para subir o servidor da API...
```bash
$ rails s
```


## ☕ Usando ETL-Challenge-API

Para acessar a API: 
http://localhost:3000/api/numbers

<b>GET /numbers</b>
![image](https://user-images.githubusercontent.com/68911852/151863249-93f45fb0-5376-4024-a9f7-7dbf1bce83c5.png)

Passando parametros de paginação: 
![image](https://user-images.githubusercontent.com/68911852/151863329-b4aae0c3-db75-437b-a3db-2ada7f923332.png)
OBS.: Os números nos resultados apresentados são apenas exemplos. 






[⬆ Voltar ao topo](#ETL-Challenge-API)<br>
