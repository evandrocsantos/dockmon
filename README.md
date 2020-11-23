# Ambiente de Monitoramento Dockmon

[![hackmd-github-sync-badge](https://hackmd.io/o8hoT9nsRP-gdEa1MHLN_A/badge)](https://hackmd.io/o8hoT9nsRP-gdEa1MHLN_A)


![Projeto](https://img.shields.io/badge/Equipe-DevOps-green?style=for-the-badge&logo=superuser) ![Projeto](https://img.shields.io/badge/Projeto-Monitoramento-green?style=for-the-badge&logo=prometheus)

## Apresentação

Este documento traz os detalhes do projeto de monitoração Dockmon, bem como fazer para replicá-lo localmente, para o desenvolvimento/ajuste de alguma de funções e/ou recursos.

O ambiente é baseado em docker e utiliza Prometheus, Nginx, MySQL e Grafana. O código foi hospedado com o CodeCommit da AWS.

## Por que Docker

A escolha por docker se dá pela facilidade de replicação do ambiente, facilitando o desenvolvimento de novos recursos, bem como ajustes em sua estrutura.

Um outro ponto é o encapsulamento da aplicação de forma a isolar e preservar as suas configurações. :whale:

## Como usar esse repositório

### Configurando a chave SSH

O primeiro passo é configurar a chave de acesso ao repositório. Vamos nomeá-la 'commit':

```gherkin=
ssh-keygen -t rsa -b 4096 -C "euandros@vansor.tech"
Generating public/private rsa key pair.
Enter file in which to save the key (/home/esantos/.ssh/id_rsa): /home/esantos/.ssh/commit
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/esantos/.ssh/commit.
Your public key has been saved in /home/esantos/.ssh/commit.pub.
The key fingerprint is:
SHA256:BOnAtS6CqC8VStnrA5EgJPMp38TsdZlzULdN+4eA4O0 EUANDROS
The key's randomart image is:
+---[RSA 4096]----+
|+. . .o.o.. . .  |
|+o +o .+ * o + . |
|+ * +oo B + o o  |
|.O.= o.o +   . o |
|+.+.= . S E   . o|
|o..o .          .|
|..o              |
|.. o             |
| .. .            |
+----[SHA256]-----+

-t: escolha do tipo da chave
-b: definição do tamanho da chave em bits
-C: insere como comentário o e-mail da conta
```

#### Upload da Chave

Faça a cópia do conteúdo de sua chave pública e o insira nas configurações de credenciais de segurança da AWS:

```gherkin=
cat /home/esantos/.ssh/commit.pub

ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDNKYVzo2MqwIpIsNlHdXToURydhj3wds
bVtEUj0WSszrd3M69syx7PRHBl9lSC6AsUdTN5IW+dCfgCR8PaVQmclktsBr3vyS/+cqVk
yT2VnqqF3E/Ou0oYHPPc+usu0Lr9T8N9aXVX0meaNyUCUH7RUkdzobceHt4uXJBGN8rfXW
udVlSDgp3y5T9bnYNBvDd8pSWENzi4f+7A6OvfguMXDjYdxNpeYnyaQZRU4vG2yhB0h94o
36E6NTzPFfavbvTTwLwIUKR7ZiYc01cSvOXxRWJfjK/uBSzbvGfipHsk3N0q+umzi79aQm
L9KuggJaVEHdGZXBjeJMS/m/LUkjNvGRfzrkrm+JH/Iy092qL34Gxp7VulfaSscie8Gj/U
T1DjrWCslZmPkKroUrFswe/87HpCiCioFVXkTPoDZQj91dviz+09v5wumULcFJyOZ9nZ4s
MEwnUSNcaJZpnajCdnHhe64V2OxA7IyZBTDdvitbnLHP8dAaShcPx37Qk9V8gHaFEOvPcm
8ZYW/7lLixptxfXSyoFM3XchqOZ0Cuqm/CXWxX6Ul5kuCgqC4Ll6HJKLUSfC4Avjk2TfBU
vYLctfS1rrvUO6mO/w5w25vxITbNFaND6WMBK26R+L8aR9j8EeGXmfiQ3OppbsRYLGYqX2
/Xtawj9xMaaqFE1qwF8z/w== euandros@vansor.tech
```

##### Configurando o acesso ao Repositório

Com a chave configurada, será necessário criar o arquivo de configuração com os dados de acesso. Por este motivo, acesse ao seu diretório ```~/.ssh``` e crie um arquivo nomeado config com os seguintes dados:

```gherkin=
cd ~/.ssh
nano config

> Host git-codecommit.*.amazonaws.com
>   User APKASAXOOBB5SQEXEMPLO #ID gerada após o upload da sua chave SSH.
>   IdentityFile ~/.ssh/commit                  #Informe o nome da chave.
```

###### Salve o arquivo e saia. Altere a permissão do arquivo com o seguinte comando

```gherkin=
chmod 600 config
```

##### Testando a configuração

Teste a sua configuração e confirme a conexão, para que o domínio seja adicionado ao arquivo ```hosts``` de seu sistema:

```gherkin=
ssh git-codecommit.us-east-1.amazonaws.com

You have successfully authenticated over SSH. You can use Git to interact with AWS CodeCommit. Interactive shells are not supported.Connection to git-codecommit.us-east-1.amazonaws.com closed by remote host.
Connection to git-codecommit.us-east-1.amazonaws.com closed.
```

##### Adicionando o repositório remoto

Crie, em sua pasta pessoal, o diretório ```~/projetos```. Acesse-o e o inicialize como um repositorio GIT. Feito isso, adicione o nosso repositório como remoto, de forma que possa enviar seus `commits`. Não se esqueça de efetuar a configuração de seu perfil, nas configurações do GIT. Assegure que o pacote ```git``` esteja instalado em seu sistema:

```gherkin=
mkdir ~/projetos
cd ~/projetos
git init
git config --global user.name "Euandros"
git config --global user.mail "euandros@vansor.tech"
git remote add "dockmon" ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/dockmon
```

Pronto. Agora é só recriar o ambiente, localmente, para iniciar a sua task de configuração do exporter.

## Comandos úteis

A seguir estão os comandos necessários para iniciar o ambiente em sua máquina:

| Comando                             |                                   Finalidade                                        |
| ------------------------------------|:------------------------------------------------------------------------------------|
| docker-compose up                   | inicia o ambiente a partir das configurações presentes no arquivo docker-compose.yml|
| docker-compose stop                 | para o ambiente que fora gerado anteriormente                                       |
| docker-compose start                | inicia o ambiente que fora parado previamente                                       |
| docker-compose restart              | reinicia o ambiente que fora parado previamente                                     |
| docker inspect <CONTAINER_ID>       | faz a inspeção do contêiner e traz o detalhamento de sua estrutura                  |
| docker exec -i -t <CONTAINER_ID> sh | executa um comando em modo interativo com o contêiner disponibilizando um shell     |

Para maiores detalhes, acesse: [Docker](https://docs.docker.com/)


# O Ambiente


O nosso ambiente de monitoramento está configurado da seguinte maneira:

| Nome do Contêiner            |   Finalidade                                                                                  |
| -----------------------------|:----------------------------------------------------------------------------------------------|
| dockmon-prometheus-monitoring | Contêiner que executa a aplicação Prometheus, a que faz a coleta das métricas do ambiente.    |
| dockmon-grafana-dashboard     | Contêiner que executa a aplicação Grafana, a que é responsável por gerar os dashboards.       |
| dockmon-pushgateway           | Contêiner que executa a aplicação PushGateway, a que é responsável por receber métricas e direcioná-las ao Prometheus                                                                                                    |
| dockmon-mysql-grafana         | Contêiner que executa o banco de dados dedicado à aplicação Grafana                           |
| dockmon-alertmanager          | Contêiner que executa a aplicação Alert Manager, que é responsável por disparar os alertas de eventos observados no ambiente.                                                                                                | 
| dockmon-nginx                 | Contêiner que executa o NGINX como proxy reverso, sobre as demais aplicações.                 |
| dockmon-promtool              | Contêiner que executa a ferramenta promtool, a que é responsável por checar e validar a existência de erros ou inconsistências nos arquivos ```prometheus.yml``` e ```prometheus.rules.yml```. |

A seguir, veremos a configuração de cada um, em detalhe.


---

## NGINX


O **NGINX** está configurado como *proxy reverso*, escutando a porta em que o **Prometheus** publica, redirecionando-a para uma nova. 

Abaixo, estão as sua configurações, a começar pelo arquivo ```docker-compose.yml``` :

```gherkin=
services:

  nginx:
    image: nginx
    container_name: dockmon-nginx
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/conf.d/default.conf:/etc/nginx/conf.d/default.conf
      - ./prometheus/.credentials:/etc/prometheus/.credentials
      - ./prometheus/ssl/:/etc/prometheus/ssl
      - ./nginx/www/:/opt/www/
    restart: "always"
    network_mode: host
    ports:
      - 80:80
      - 443:443
      - 1234:1234
```

No passo acima, temos a chamada no docker-compose para o contêiner do **NGINX**. Primeiramente, declaramos o nome do serviço que iremos usar, em que cada serviço, corresponde a um contêiner (aplicação). Em nosso exemplo ```nginx```.

Logo abaixo, é declarada a imagem de contêiner que será usada como base, bem como o nome que atribuiremos a ele, respectivamente ```ìmage``` e ```container_name```.

Na sequência, observamos que são declarados os ```volumes``` que serão montados e usados pelo docker.

No caso do **NGINX** houve uma particularidade na configuração, a que nos levou a declarar os seus dois arquivos de configuração como volumes, igualmente para o arquivo de credencial de acesso seguro, para que o container já subisse com os arquivos montados e disponíveis para uso, sobrescrevendo os da configuração padrão da imagem.
```gherkin=
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/conf.d/default.conf:/etc/nginx/conf.d/default.conf
      - ./prometheus/.credentials:/etc/prometheus/.credentials
```

O contêiner foi configurado para fazer o seu ``` restart``` sempre que o ocorrer a sua queda. A sua rede está operando no modo ```host```, isto é, ele receberá um ip válido de acordo com a rede do host em que for executado. As portas, ```ports```, que serão utilizadas são apresentadas na lista, uma abaixo da outra.
```gherkin=
    restart: "always"
    network_mode: host
    ports:
      - 80:80
      - 443:443
      - 1234:1234
```

O **NGINX** está configurado para escutar a porta padrão do **Prometheus**, a ```9090```, efetuar o seu redirecionamento para a porta ```1234```, conforme vimos acima.  A seguir está a configuração que fizemos para esse fim, no arquivo ```default.conf```

```gherkin=
server {
    listen 1234 ssl;
    ssl_certificate /etc/prometheus/ssl/prometheus-cert.pem;
    ssl_certificate_key /etc/prometheus/ssl/prometheus-private-key.pem;

    location / {
      auth_basic           "Prometheus";
      auth_basic_user_file /etc/prometheus/.credentials;
      proxy_pass           http://localhost:9090/;
    }
}
```
Além de fazer o redirecionamento, o **NGINX** requerirá a validação por meio de usuário e senha, conforme configurado no arquivo ```.credentials```. São eles:
> * **Usuário**: admin
> * **Senha**: BYK6138T@$%79!

O NGINX também terá em sua configuração, futuramente, o **Alert Manager** e o **Grafana** por trás do *proxy reverso*.


---

## PROMTOOL


O **Promtool** é o validador do código dos arquivos ```prometheus.yml``` e ```prometheus.rules.yml```, verificando se há inconsistência na indentação, ou na forma de declaração utilizada.
```gherkin=
  promtool:
    image: jacknagel/promtool
    container_name: dockmon-promtool
    volumes: 
      - ./prometheus:/tmp/
    command: check config /tmp/prometheus.yml
```
Em linhas gerais, o contêiner executa o comando de checagem do arquivo e como saída temos a resposta se há ou não falhas. Se sim, ele nos indica em qual linha e impede que o contêiner do **Prometheus** seja carregado com falhas. 
```gherkin=
./promtool check config prometheus.yml

Checking prometheus.yml
  SUCCESS: 1 rule files found

Checking prometheus.rules.yml
  FAILED: [yaml: line 174: did not find expected '-' indicator]
```


---

## PROMETHEUS


O **Prometheus** é a nossa ferramenta de monitoramento, que monitora e coleta as métricas do ambiente de nossos clientes. 

Em nosso cenário, ele está configurado com acesso seguro, utilizando certificado e chave SSL.

Abaixo estão as sua configurações, a começar pelo ```docker-compose.yml```:

```gherkin=
  prometheus:
    image: prom/prometheus:latest
    container_name: dockmon-prometheus
    volumes:
      - ./prometheus/:/etc/prometheus/
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/usr/share/prometheus/console_libraries'
      - '--web.console.templates=/usr/share/prometheus/consoles'
      - '--web.listen-address=0.0.0.0:9090'
      - '--web.enable-admin-api'
      - '--web.external-url=https://localhost:1234'
    ports:
      - 9090:9090
    depends_on: 
      - promtool
```
A configuração do compose não apresenta grande diferença em relação aos demais, senão pela declaração dos comandos que serão executados após a carga do contêiner. Por meio da chave ```command``` os declaramos em lista.
```gherkin=
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/usr/share/prometheus/console_libraries'
      - '--web.console.templates=/usr/share/prometheus/consoles'
      - '--web.listen-address=0.0.0.0:9090'
      - '--web.enable-admin-api'
      - '--web.external-url=https://localhost:1234'
```
Um ponto que precisamos nos atentar é à presença da chave ```depends_on```, a que estabelece uma relação de dependência. No caso, a execução do contêiner do **Prometheus** só ocorrerá após a validação do código por meio do **Promtool**.

Abaixo temos o arquivo ```prometheus.yml```:

```gherkin=
global:
  scrape_interval: 15s
  scrape_timeout: 10s
  evaluation_interval: 1m

rule_files:
  - 'prometheus.rules.yml'

scrape_configs:

  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node'
    scrape_interval: 5s
    static_configs:
      - targets: [IP da Máquina:9100]

  - job_name: 'snmp'
    static_configs:
      - targets:
        - IP_do_Alvo
    metrics_path: /snmp
    params:
      module: [if_mib]
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: IP da Máquina:9116
  
  - job_name: ‘rabbitmq’
    static_configs:
      - targets: [IP da Máquina:15672]
    metrics_path: /api/metrics

  - job_name: ‘pushgateway’
    scrape_interval: 1s
    static_configs:
      - targets: [IP da Máquina:9091]
  
  - job_name: 'mysql_exporter'
    scrape_interval: 15s
    static_configs:
      - targets: ['IP da Máquina:9104', 'IP da Máquina:9105']

  - job_name: 'java-exp'
    scrape_interval: 5s
    static_configs:
      - targets: [IP da Máquina:8080]
```

O arquivo contém as configurações necessárias para a coleta de métricas do ambiente, a partir dos ```exporters``` configurados previamente.

O arquivo inicia apresentando as configurações globais, aquelas que serão aplicadas a toda coleta que será especificada no restante do documento.
```gherkin=
global:
  scrape_interval: 15s     <- Intervalo de tempo em que cada coleta será efetuada
  scrape_timeout: 10s      <- Intervalo de tempo em que será aguardado entre uma coleta e outra, caso apresente falha.
  evaluation_interval: 1m  <- Período de avaliação da execução da regra de coleta, antes de iniciar o alerta.
```

Logo abaixo é declarado o caminho do arquivo de regras de alertas:
```gherkin=
rule_files:
  - 'prometheus.rules.yml'
```

A coleta de cada exporter é referendada como *job* e traz a seguinte configuração:
```gherkin=
  - job_name: 'java-exp' <- Nome do Job
    scrape_interval: 5s  <- Intervalo de tempo da coleta especifico do job
    static_configs:
      - targets: [IP da Máquina:8080] <- IP da máquina em que 
                                         está instalado o exporter.
```

Em alguns jobs podemos especificar o caminho em que a coleta publicará as métricas:
```gherkin=
  - job_name: ‘rabbitmq’
    static_configs:
      - targets: [IP da Máquina:15672]
    metrics_path: /api/metrics    <- Caminho da publicação das métricas.
```
---
## ALERT MANAGER

O **Alert Manager** é a ferramenta responsável por fazer o envio de alertas de falhas observadas no ambiente, para os canais que configuramos previamente.

Ele utiliza das regras descritas no arquivo ```prometheus.rules.yml``` para gerir quando e o que enviar como alerta.

O arquivo é iniciado pela chave ```groups```, a que receberá os grupos de alertas, de acordo com a função/serviço/aplicação. Em nosso cenário, o primeiro grupo é aquele que gravará as regras, isto é, aquelas que serão pré-carregadas, dada a frequência de uso, `recording_rules`, sendo seguido pelo grupo de regras referente ao `Hardware Alerts`.
```gherkin=
groups:
    - name: recording_rules
      rules:
        - record: node_exporter:node_memory_free:memory_used_percents
          expr: 100 - 100 * (node_memory_MemFree / node_memory_MemTotal)
    
    - name: Hardware Alerts
      rules:
        - alert: Node Exporter Indisponível
          expr: up{job="node_exporter"} == 0
          for: 1m
          labels:
            severity: major
          annotations:
            title: Node na instância {{ $labels.instance }} - está indisponível
            description: Falha ao coletar o {{ $labels.job }} na {{ $labels.instance }} no último minuto. Node parece estar fora.
```
Abaixo do nome do grupo, nos é apresentado o campo `rules`, que traz abaixo de si a estrutura da regra. 

O item `record` traz o nome da regra seguida pelo detalhe da coleta. Por sua vez, o item `expr` traz a expressão que será usada pela regra:
```gherkin=
record: node_exporter:node_memory_free:memory_used_percents
expr: 100 - 100 * (node_memory_MemFree / node_memory_MemTotal)
```
O grupo de regras de alertas, terá uma estrutura similar: O nome da regra é expresso pelo item `alert` e o período de tempo necessário para o disparo do alerta é expresso pelo item ```for```.
```gherkin=
        - alert: Node Exporter Indisponível
          expr: up{job="node_exporter"} == 0
          for: 1m
```
Em ```lables``` nós temos os detalhes da severidade, ```severity```, como também as anotações da regra, como o título, que será usado para o envio da mensagem, ```title``` e sua descrição, ```description```:
```gherkin=
          labels:
            severity: major
          annotations:
            title: Node na instância {{ $labels.instance }} - está indisponível
            description: Falha ao coletar o {{ $labels.job }} na {{ $labels.instance }} no último minuto. Node parece estar fora.
```
No arquivo ```alertmanager.yml``` nós teremos a configuração do alertmanager e a sua integração com os canais:

```gherkin=
global:
  resolve_timeout: 5m
  http_config: {}
  smtp_hello: localhost
  smtp_require_tls: true
  slack_api_url: https://hooks.slack.com/services/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
 
route:
  receiver: slack-notifications
  group_by:
  - alertname
  - datacenter
  - app

receivers:
- name: slack-notifications
  slack_configs:
  - send_resolved: false
    http_config: {}
    api_url: https://hooks.slack.com/services/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
    channel: '#alertas'
    username: '{{ template "slack.default.username" . }}'
    color: '{{ if eq .Status "firing" }}danger{{ else }}good{{ end }}'
    title: '[{{ .Status | toUpper }}{{ if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{ end }}] {{ .GroupLabels.alertname }} - {{ range .Alerts }} {{ .Labels.severity }} {{ end }}'
    title_link: '{{ template "slack.default.titlelink" . }}'
    pretext: '{{ template "slack.default.pretext" . }}'
    text: '{{ template "slack.myorg.text" . }}'
    footer: '{{ template "slack.default.footer" . }}'
    fallback: '{{ template "slack.default.fallback" . }}'
    callback_id: '{{ template "slack.default.callbackid" . }}'
    icon_emoji: '{{ template "slack.default.iconemoji" . }}'
    icon_url: '{{ template "slack.default.iconurl" . }}'
templates: []
```

No campo ```global``` nós temos as configurações gerais do **Alert Manager**:
```gherkin=
global:
  resolve_timeout: 5m    <- Intervalo de tempo de comunicação entre o **Alert Manager** e o **Prometheus**.
  http_config: {}        <- Configuração do acesso HTTP
  smtp_hello: localhost  <- Configuração do SMTP
  smtp_require_tls: true <__|
  slack_api_url: https://hooks.slack.com/services/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
  ^
  |__ Configuração da API do Slack.
```

O grupo ```route``` nos traz os detalhes de qual canal receberá os alertas e a maneira como os receberá.

```gherkin=
route:
  receiver: slack-notifications <- Nome do destinatário
  group_by:                     <- Agrupamento dos alertas
  - alertname                   <- Agrupamento por: nome dos alertas
  - datacenter                  <- Agrupamento por: localização
  - app                         <- Agrupamento por: aplicação
```

O grupo ```receivers``` traz as informações do destinatário (canal) que receberá os alertas:
```gherkin=
receivers:
- name: slack-notifications
  slack_configs:
  - send_resolved: false
    http_config: {}
    api_url: https://hooks.slack.com/services/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
    channel: '#alertas'
    username: '{{ template "slack.default.username" . }}'
    color: '{{ if eq .Status "firing" }}danger{{ else }}good{{ end }}'
    title: '[{{ .Status | toUpper }}{{ if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{ end }}] {{ .GroupLabels.alertname }} - {{ range .Alerts }} {{ .Labels.severity }} {{ end }}'
    title_link: '{{ template "slack.default.titlelink" . }}'
    pretext: '{{ template "slack.default.pretext" . }}'
    text: '{{ template "slack.myorg.text" . }}'
    footer: '{{ template "slack.default.footer" . }}'
    fallback: '{{ template "slack.default.fallback" . }}'
    callback_id: '{{ template "slack.default.callbackid" . }}'
    icon_emoji: '{{ template "slack.default.iconemoji" . }}'
    icon_url: '{{ template "slack.default.iconurl" . }}'
templates: []
```
Como podemos observar, há - novamente - a apresentação do endereço da API do canal, `api_url` e o canal em que o alerta será publicado, `channel`.

Abaixo temos a delimitação de cores, `colors`, do titulo que será usado no envio,`title` e outros detalhes da forma como a mensagem será estruturada.

Um campo que precisamos estar atentos é o `send_resolved`, em que determinamos se será enviada ou não mensagem de resolução, assim que o alerta for resolvido.

Abaixo, temos a forma como o **Alert Manager** é declarado no `docker-compose.yml`
```gherkin=
  alertmanager:
    image: prom/alertmanager
    container_name: dockmon-alertmanager
    ports:
      - 9093:9093
    volumes:
      - ./alertmanager/:/etc/alertmanager/
      - ./data/alertmanager:/data
    command:
      - '--config.file=/etc/alertmanager/alertmanager.yml'
      - '--storage.path=/data'


```
---
## MSYQL

O **MYSQL**, em nosso cenário, é usado para armazenar as informações geradas/carregadas pelo Grafana.

Vejamos o seu compose:

```gherkin=
  db:
    image: mysql:5.6
    container_name: dockmon-mysql
    environment:
      MYSQL_ROOT_PASSWORD: HKf16a@123
      MYSQL_DATABASE: grafana
      MYSQL_USER: grafana
      MYSQL_PASSWORD: BYK6138t@123
    command: [mysqld, --character-set-server=utf8mb4, --collation-server=utf8mb4_unicode_ci, --innodb_monitor_enable=all, --max-connections=1001]
    ports:
      - 3306:3306
    healthcheck:
      test: ["CMD", "mysqladmin" ,"ping", "-h", "localhost"]
      timeout: 10s
      retries: 10

```
Nesta estrutura, nós temos o uso da chave ```environment```, a que usamos para declarar variáveis do ambiente:
```gherkin=
    environment:
      MYSQL_ROOT_PASSWORD: HKf16a@123 <- Senha do usuário root, do banco.
      MYSQL_DATABASE: grafana         <- Nome da base de dados que será criada.
      MYSQL_USER: grafana             <- Usuário que será criado para manipulação da base.
      MYSQL_PASSWORD: BYK6138t@123    <- Senha que será atribuída ao usuário.
```

Temos, também, a execução de uma checagem da saúde do serviço utilizado no contêiner, a que é apresentada pela chave ```healthcheck```. Nela especificamos qual o teste será efetuado, ```test```, o período de tempo em que será executada uma nova execução, ```timeout```, bem como a quantidade de tentativas em caso de erro, ```retries```:
```gherkin=
    healthcheck:
      test: ["CMD", "mysqladmin" ,"ping", "-h", "localhost"]
      timeout: 10s
      retries: 10
```

---
## GRAFANA


O **Grafana** é a aplicação responsável por gerar os dashboards tendo por base os dados coletados pelo **Prometheus**.

Vejamos o seu compose:

```gherkin=
  grafana:
    image: grafana/grafana:latest
    container_name: dockmon-grafana
    volumes:
      - ./grafana/provisioning/:/etc/grafana/provisioning/
    environment:
      - VIRTUAL_HOST=grafana.loc
      - GF_SERVER_ROOT_URL=http://grafana.loc
      - GF_DATABASE_NAME=grafana
      - GF_DATABASE_USER=grafana
      - GF_DATABASE_PASSWORD=BYK6138t@123
      - GF_DATABASE_TYPE=mysql
      - GF_DATABASE_HOST=db:3306
      - GF_DATABASE_MAX_OPEN_CONN=300
      - GF_SESSION_PROVIDER=mysql
      - GF_SESSION_PROVIDER_CONFIG=grafana:BYK6138t@123@tcp(db:3306)/grafana?allowNativePasswords=true
      - GF_SERVER_ROUTER_LOGGING=true
      - GF_LOG_CONSOLE_FORMAT=json
      - GF_LOG_FILTERS=alerting.notifier:debug,alerting.notifier.slack:debug,auth:debug
      - GF_AUTH_TOKEN_ROTATION_INTERVAL_MINUTES=2
      - GF_SECURITY_ADMIN_USER=${ADMIN_USER:-admin}
      - GF_SECURITY_ADMIN_PASSWORD=${ADMIN_PASSWORD:-HKf16a123}
      - GF_USERS_ALLOW_SIGN_UP=false
    ports:
      - 3000:3000
    depends_on: 
      - db
    command: ["./grafana/valida-mysql.sh", "db:3306", "--", "python", "app.py"]
```

Tal como no contêiner do **MYSQL**, este também utiliza a declaração de variáveis do ambiente, ```environment```, para informar/detalhar quais os detalhes do *banco de dados* que serão utilizados, bem como detalhes da *sessão* e de *segurança/acesso*, sendo elas declaradas como: ```GF_DATABASE```, ```GF_SESSION```, ```GF_AUTH``` e ```GF_SECURITY```.

Um outro ponto importante a ser atentado é o estabelecimento de uma dependência para a chamada/execução desse contêiner, a que ocorrerá apenas após a disponibilidade do banco, que é validada por meio de um script.
```gherkin=
    depends_on: 
      - db
    command: ["./grafana/valida-mysql.sh", "db:3306", "--", "python", "app.py"]
```
o *script valida-mysql.sh*, em detalhe:
```gherkin=
#!/bin/bash

set -e
set -x

host="$1"
shift
cmd="$@"

until mysql -h "$host" -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} -e 'select 1'; do
  >&2 echo "MySQL está indisponível - aguardando"
  sleep 1
done

>&2 echo "Mysql está respondendo - comando executado"
exec $cmd
```

De uma forma geral, o *script* faz a tentativa de se conectar a base de dados, que definimos no contêiner **MYSQL**, com os dados de usuário que informamos, e executar um *select*. Essa instrução é repetida até que seja possivel concluí-la e, para as tentativas que não forem bem sucedidas temos a saida *"MySQL está indisponível - aguardando"*, a que muda quando o *select* for efetudado, *"Mysql está respondendo - comando executado"*.

Uma vez finalizado, o contêiner do *Grafana* é iniciado.

---

# Configuração dos Exporters do Prometheus

## Apresentação

Este documento traz a configuração padrão dos exporters do Prometheus, utilizados em produção.

É mostrado onde o arquivo deve ser alocado, bem como deve ser efetuada a configuração do serviço que irá manipulá-lo.

Seguiremos algumas convenções, as que serão detalhadas a seguir.

## Convenções

Para garantirmos que qualquer membro da equipe possa atuar na manutenção ou configuração de novos itens no ambiente, se fez necessário adotar um padrão para a implantação de cada exporter, em produção.

O primeiro ponto a ser seguido é que cada exporter, isto é, seu **arquivo binário** deve ser alocado em um diretório prório em **```/usr/local/bin```**. Para os **arquivos de configuração** de cada exporter, usaremos o seguinte file system: **```/etc/sysconfig```**. Por sua vez, os **serviços** deverão ser alocados em  **```/etc/systemd/system```**.

Para deixar mais fácil a compreensão, tomemos o exemplo do node exporter.

### Node Exporter

O node exporter é o responsável por coletar e publicar as métricas da infraestrutura física do servidor em que está instalado, isto é, consumo de CPU, Load, consumo de Memória, etc.

Abaixo estão os passos a serem seguidos para sua configuração em um servidor de produção.

#### Obtendo o Exporter

Faremos o download do exporter e o alocaremos em seu diretório padrão: 
```gherkin=
esantos@vansor235: cd Downloads && wget https://github.com/prometheus/node_exporter/releases/download/v*/node_exporter-*.*-amd64.tar.gz`
esantos@vansor235: sudo mkdir /usr/local/bin/node_exporter/
esantos@vansor235: tar xvfz node_exporter-*.*-amd64.tar.gz
esantos@vansor235: sudo cp node_exporter-*.*-amd64/node_exporter /usr/local/bin/node_exporter/
```

#### Criação do Usuário

O exporter deve ser executado com o seu próprio usuário, o que deve ser configurado como uma conta sem privilégios.

```gherkin=
sudo useradd node_exporter -s /sbin/nologin
```

#### Criação do Serviço

Para manipularmos o estado do exporter, nós devemos criar um arquivo de serviço que fará a sua gestão. 

Por esse motivo, criaremos o arquivo **```node_exporter.service```** em **```/etc/systemd/system/```**, com o conteúdo abaixo:

```gherkin=
esantos@vansor235: nano /etc/systemd/system/node_exporter.service

[Unit]
Description=Node Exporter

[Service]
User=node_exporter
EnvironmentFile=/etc/sysconfig/node_exporter/node_exporter
ExecStart=/usr/local/bin/node_exporter/node_exporter $OPTIONS

[Install]
WantedBy=multi-user.target
```
É necessário ressaltar que, ao executarmos o serviço, tal como acima, ele cerregará as opções padrão de coletores:

|Opção      |Finalidade                                                                                                                     |
|-----      |:---------                                                                                                                     |
|diskstats  |Publica as estatísticas de I/O do disco a partir de **```/proc/diskstats.```**                                                 |
|filesystem |Publica as estatísticas do **```filesystem statistics```**, como o espaço de disco em uso                                      |
|loadavg    |Publica a carga do load average.                                                                                               |
|meminfo    |Publica as estatísticas da memória a partir de **```/proc/meminfo```**.                                                        |
|netdev     |Publica as estatísticas de interface de rede a partir de **```/proc/netstat```**, como os bytes transferidos.                  |
|netstat    |Publica as estatísticas de rede a partir de **```/proc/net/netstat```**.                                                       |
|stat       |Publica diversas estatísticas a partir de **```/proc/stat```**, o que inclui o uso da CPU, tempo de boot, forks e interrupts.  |
|textfile   |Publica estatísticas lidas a partir do disco local. A flag **```--collector.textfile.directory```** precisa ser configurada.   |
|time       |Publica o tempo atual do sistema.                                                                                              |
Contudo, é uma boa prática usar o arquivo de configuração, referenciado na opção ```EnvironmentFile``` para aplicarmos as opções específicas que queremos para a execução.

Sendo assim, podemos criar o arquivo **```node_exporter```** em **```/etc/sysconfig/node_exporter```**:
```gherkin=
esantos@vansor235: sudo mkdir /etc/sysconfig/node_exporter/
esantos@vansor235: nano /etc/sysconfig/node_exporter/node_exporter

OPTIONS="--collector.textfile.directory /var/lib/node_exporter/textfile_collector"

# Acima temos um exemplo das opções que podemos usar. Para verificar as demais, utilize o comando /usr/local/bin/node_exporter --help.

```

#### Colocando cada coisa em seu lugar

- [x] Download do Exporter
- [x] Criação do Diretório do Exporter
- [x] Criação do Usuário
- [x] Criação do Serviço
- [x] Criação do Diretório de Configuração
- [x] Criação do Arquivo de Configuração
- [ ] Alteração da Permissão dos Diretórios

Agora que fizemos a maior parte da configuração, devemos nos atentar em atribuir a propriedade/permissão do usuário **`node_exporter`** aos diretórios e ao arquivo de seu serviço:

```gherkin=
esantos@vansor235: sudo chown -R node_exporter:node_exporter /usr/local/bin/node_exporter/
esantos@vansor235: sudo chown -R node_exporter:node_exporter /etc/sysconfig/node_exporter/
esantos@vansor235: sudo chown node_exporter:node_exporter /etc/systemd/system/node_exporter.service
```
Feito isso, devemos recarregar o `daemon` do `systemctl` e habilitarmos o serviço que criamos:

```gherkin=
esantos@vansor235: sudo systemctl daemon-reload
esantos@vansor235: sudo systemctl enable node_exporter
```
O serviço será manipulado com as opções **start**, **stop** e **restart**.

#### Testando a Configuração

Vamos iniciar o node e verificar se ele está operando corretamente:

```gherkin=
esantos@vansor235: sudo systemctl start node_exporter
esantos@vansor235: curl http://localhost:9100/metrics

# HELP go_gc_duration_seconds A summary of the GC invocation durations.
# TYPE go_gc_duration_seconds summary
go_gc_duration_seconds{quantile="0"} 3.8996e-05
go_gc_duration_seconds{quantile="0.25"} 4.5926e-05
go_gc_duration_seconds{quantile="0.5"} 5.846e-05
```

Como vimos, a coleta e a publicação estão ocorrendo sem falhas, e as métricas podem ser acessadas via navegador, pelo mesmo endereço e porta acima.

#### Configurando a Coleta da Métricas no Prometheus

Vamos editar o arquivo **prometheus.yml** adicionando o conteúdo abaixo:

```gherkin=
esantos@vansor235: cd projetos/prometheus
esantos@vansor235: nano prometheus.yml

- job_name: 'node_exporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['IP DA MÁQUINA:9100']
```

Depois de salvar o arquivo será necessário reiniciar o conteiner do **Prometheus**, para que ele seja carregado com as novas configurações.

Após isso, poderemos já observar a coleta, na interface da aplicação.

![](https://i.imgur.com/Yrc6cZv.png)

#### Conclusão

Estes passos que seguimos, bem como a estrutura de hierarquia de arquivos que utilizamos são os mesmos que devem ser seguidos para todos os demais exporters que venham a ser configurados.

Isso auxiliará na configuração e sustentação do ambiente, por meio de qualquer membro da equipe.

:+1:

---
