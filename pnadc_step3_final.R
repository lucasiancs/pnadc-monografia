# Carregando pacotes necessários
library(readr)   # Para leitura de arquivos CSV
library(dplyr)   # Para manipulação de dados

# Lendo o arquivo com as variáveis tratadas e dummies já criadas
dados_pnadc20224 <- read_csv("pnad_limpa.csv")

# -----------------------------------------
# SIMPLIFICAÇÃO DE VARIÁVEIS CATEGÓRICAS
# -----------------------------------------

# Em alguns casos, foi necessário agrupar categorias para análises mais robustas

# ---- Raça/Cor simplificada ----
# Criando nova variável 'branco' que inclui brancos e amarelos (usualmente agrupados como "não PPI")
dados_pnadc20224$branco <- dados_pnadc20224$branco + dados_pnadc20224$amarela

# Criando nova variável 'ppi' que agrega pretos, pardos e indígenas
dados_pnadc20224$ppi <- dados_pnadc20224$preta + dados_pnadc20224$parda + dados_pnadc20224$indigena

# ---- Escolaridade simplificada ----
# Agrupando:
# - sem instrução com fundamental incompleto
# - fundamental completo com médio incompleto
# - médio completo com superior incompleto
# superior completo permanece como está (não precisa ser alterado)

dados_pnadc20224$sem_instrucao <- dados_pnadc20224$sem_instrucao + dados_pnadc20224$fundamental_i
dados_pnadc20224$fundamental_completo <- dados_pnadc20224$fundamental_c + dados_pnadc20224$medio_i
dados_pnadc20224$medio_completo <- dados_pnadc20224$medio_c + dados_pnadc20224$superior_i
# superior_c já existe e pode ser usado diretamente

# Salvando os dados simplificados em um novo arquivo CSV
write.csv(dados_pnadc20224, "pnad_final.csv")
