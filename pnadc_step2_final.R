# Carregando pacotes necessários
library(readr)         # Para leitura de arquivos CSV
library(dplyr)         # Para manipulação de dados
library(fastDummies)   # Para criação automática de variáveis dummies

# Lendo base de dados com trabalhadores ocupados da PNAD Contínua
dados_pnadc20224 <- read_csv("pnad_ocupados.csv")

# Criando faixa etária a partir de 18 anos
# As faixas são: [18–26), [26–36), [36–51), [51–65)
limites <- c(18, 26, 36, 51, 65)
rotulos <- c("1", "2", "3", "4")
dados_pnadc20224$faixaetaria <- cut(dados_pnadc20224$V2009, breaks = limites, labels = rotulos, right = FALSE)

# Criando variável de macrorregião com base no código da UF (primeiro dígito)
dados_pnadc20224$grande_regiao <- as.numeric(substr(dados_pnadc20224$UF, 1, 1))


# ---------------------------
# CRIAÇÃO DE VARIÁVEIS DUMMIES
# ---------------------------

# Filtrando indivíduos com raça declarada
dados_pnadc20224 <- dados_pnadc20224 %>%
  filter(V2010 != 9)  # Código 9 = raça não declarada

# Dummies de raça/cor
dados_pnadc20224$branco   <- ifelse(dados_pnadc20224$V2010 == 1, 1, 0)
dados_pnadc20224$preta    <- ifelse(dados_pnadc20224$V2010 == 2, 1, 0)
dados_pnadc20224$amarela  <- ifelse(dados_pnadc20224$V2010 == 3, 1, 0)
dados_pnadc20224$parda    <- ifelse(dados_pnadc20224$V2010 == 4, 1, 0)
dados_pnadc20224$indigena <- ifelse(dados_pnadc20224$V2010 == 5, 1, 0)

# Dummy de gênero (1 = homem, 0 = mulher)
dados_pnadc20224$homem <- ifelse(dados_pnadc20224$V2007 == 1, 1, 0)

# Dummies de escolaridade (VD3004 = nível mais elevado que frequentou ou concluiu)
dados_pnadc20224$sem_instrucao <- ifelse(dados_pnadc20224$VD3004 == 1, 1, 0)
dados_pnadc20224$fundamental_i <- ifelse(dados_pnadc20224$VD3004 == 2, 1, 0)
dados_pnadc20224$fundamental_c <- ifelse(dados_pnadc20224$VD3004 == 3, 1, 0)
dados_pnadc20224$medio_i       <- ifelse(dados_pnadc20224$VD3004 == 4, 1, 0)
dados_pnadc20224$medio_c       <- ifelse(dados_pnadc20224$VD3004 == 5, 1, 0)
dados_pnadc20224$superior_i    <- ifelse(dados_pnadc20224$VD3004 == 6, 1, 0)
dados_pnadc20224$superior_c    <- ifelse(dados_pnadc20224$VD3004 == 7, 1, 0)

# Dummies para posição na ocupação (VD4008)
dados_pnadc20224$empregado  <- ifelse(dados_pnadc20224$VD4008 == 1, 1, 0)
dados_pnadc20224$domestico  <- ifelse(dados_pnadc20224$VD4008 == 2, 1, 0)
dados_pnadc20224$publico    <- ifelse(dados_pnadc20224$VD4008 == 3, 1, 0)
dados_pnadc20224$empregador <- ifelse(dados_pnadc20224$VD4008 == 4, 1, 0)
dados_pnadc20224$propria    <- ifelse(dados_pnadc20224$VD4008 == 5, 1, 0)
dados_pnadc20224$familiar   <- ifelse(dados_pnadc20224$VD4008 == 6, 1, 0)

# Dummies de faixas etárias
dados_pnadc20224$idade_18 <- ifelse(dados_pnadc20224$faixaetaria == 1, 1, 0)
dados_pnadc20224$idade_26 <- ifelse(dados_pnadc20224$faixaetaria == 2, 1, 0)
dados_pnadc20224$idade_36 <- ifelse(dados_pnadc20224$faixaetaria == 3, 1, 0)
dados_pnadc20224$idade_51 <- ifelse(dados_pnadc20224$faixaetaria == 4, 1, 0)

# Criando dummies automáticas para a variável grande_regiao
pnad <- dummy_cols(dados_pnadc20224, select_columns = "grande_regiao", remove_first_dummy = FALSE)

# Salvando dataset final com variáveis dummies em CSV
write.csv(pnad, file = "pnad_limpa.csv")