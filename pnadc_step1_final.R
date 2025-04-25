# Carregando pacotes necessários
library(PNADcIBGE)   # Para ler microdados da PNAD Contínua
library(survey)      # Para manipulação e análise de dados amostrais
library(convey)      # Para indicadores de desigualdade com dados amostrais
library(magrittr)    # Fornece o operador pipe (%>%)
library(dplyr)       # Manipulação de dados

# Caminhos para os arquivos de microdados e de input
microdata <- ("PNADC_2022_trimestre4.txt")
inputs <- ("input.txt")

# Seleção das variáveis de interesse
variables <- c("UF", "Ano", "Trimestre", "Capital", "RM_RIDE", "UPA", "Estrato", 
               "V1008", "V1014", "V1022", "V1028", "V2005", "V2007", "V2009", 
               "V2010", "VD2002", "VD2003", "VD3004", "VD4002", "VD4007", 
               "VD4008", "VD4009", "VD4016", "VD4017", "VD4031", "VD4032", 
               "VD4033", "VD4034", "VD4035", "S14001", "V4013", "V4032")

# Lendo os microdados com as variáveis selecionadas
dados_pnadc <- read_pnadc(microdata = microdata, input_txt = inputs, vars = variables)

# Mantendo apenas as colunas de interesse
dados_pnadc <- dados_pnadc[variables]

# Convertendo para data.frame
dados_pnadc <- data.frame(dados_pnadc)

# Filtrando trabalhadores ocupados (VD4002 == 1)
# VD4002 indica a condição de ocupação do indivíduo
dados_pnadc <- dados_pnadc %>%
  mutate(VD4002 = as.numeric(VD4002))  # Garantindo que seja numérico para evitar erros
pnad_ocupados <- dados_pnadc %>%
  filter(VD4002 == 1)

# Exportando os dados filtrados para CSV
write.csv(pnad_ocupados, file = "pnad_ocupados.csv")