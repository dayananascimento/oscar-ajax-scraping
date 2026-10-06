# ============================================================
# WEB SCRAPING - OSCAR WINNING FILMS
# FCM2026
# ============================================================

# Carregar os pacotes
library(httr2)
library(jsonlite)
library(dplyr)
library(purrr)
library(readr)


# ============================================================
# 1. URL DA PÁGINA
# ============================================================

url <- "https://www.scrapethissite.com/pages/ajax-javascript/"


# ============================================================
# 2. ANOS QUE SERÃO EXTRAÍDOS
# ============================================================

anos <- 2010:2015

print(anos)


# ============================================================
# 3. FUNÇÃO DE WEB SCRAPING
# ============================================================

buscar_filmes <- function(ano) {
  
  # URL da requisição AJAX
  url_ajax <- paste0(
    url,
    "?ajax=true&year=",
    ano
  )
  
  print(paste("Extraindo dados de:", ano))
  
  # Fazer a requisição
  resposta <- request(url_ajax) |>
    req_headers(
      `User-Agent` = "Mozilla/5.0"
    ) |>
    req_perform()
  
  # Obter o conteúdo retornado pelo site
  dados <- resposta |>
    resp_body_string()
  
  # Converter JSON em tabela
  filmes <- fromJSON(dados) |>
    as_tibble()
  
  return(filmes)
}


# ============================================================
# 4. EXTRAIR OS DADOS
# ============================================================

filmes_oscar <- map_dfr(
  anos,
  buscar_filmes
)


# ============================================================
# 5. VISUALIZAR OS DADOS
# ============================================================

print(filmes_oscar)

View(filmes_oscar)


# ============================================================
# 6. SALVAR OS DADOS EM CSV
# ============================================================

write_csv(
  filmes_oscar,
  "oscar_winning_films.csv"
)


# ============================================================
# 7. RESULTADO FINAL
# ============================================================

cat("\n")
cat("========================================\n")
cat("SCRAPING CONCLUÍDO!\n")
cat("========================================\n")
cat("Anos extraídos:", paste(anos, collapse = ", "), "\n")
cat("Total de registros:", nrow(filmes_oscar), "\n")
cat("Arquivo criado: oscar_winning_films.csv\n")
cat("========================================\n")