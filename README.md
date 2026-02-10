# 🔍 LinkedIn Candidate Search Tool (PowerShell)

Ferramenta gráfica em **PowerShell (Windows Forms)** que permite pesquisar perfis de candidatos no LinkedIn de forma rápida e organizada, abrindo automaticamente os resultados no navegador **Brave**.

Ideal para **recrutadores, RH, IT recruiters** ou qualquer pessoa que faça sourcing manual no LinkedIn.

---

## 📌 O que é isto?

Este script cria uma **interface gráfica (GUI)** em PowerShell que:

- Recebe **keywords** (separadas por vírgulas)
- Permite escolher uma **localização específica** (Portugal, Lisboa, Porto, Faro)
- Opcionalmente filtra apenas perfis **#OpenToWork**
- Constrói automaticamente a **URL correcta do LinkedIn**
- Abre a pesquisa directamente no navegador Brave

Sem APIs, sem scraping, sem violar regras do LinkedIn — apenas automação inteligente de pesquisa.

---

## 🎯 Para que serve?

- Acelerar pesquisas de candidatos no LinkedIn  
- Evitar escrever URLs longas e filtros manualmente  
- Garantir consistência nas pesquisas (AND lógico entre termos)  
- Usar como ferramenta diária de sourcing  

Exemplos de uso:
- `helpdesk, support, l1`
- `windows, intune, azure`
- `customer service, remote`

---

## ⚙️ Como funciona?

1. O utilizador introduz as **keywords**
2. O script:
   - Separa os termos por vírgula
   - Junta-os com operador `AND`
   - Codifica os termos para URL
3. A localização seleccionada é convertida para o respectivo **geoUrn do LinkedIn**
4. (Opcional) Adiciona `#OpenToWork` à pesquisa
5. A pesquisa é aberta automaticamente no **Brave Browser**

---

## 🖥️ Interface

A interface inclui:

- Campo de texto para keywords  
- Dropdown de localização  
- Checkbox `Apenas #OpenToWork`  
- Botão **Pesquisar**
- Botão **Fechar**

Após uma pesquisa bem-sucedida, o formulário é automaticamente limpo.

---

## 🚀 Como pôr a funcionar

### 1️⃣ Requisitos

- Windows 10 ou superior  
- PowerShell 5.1 ou PowerShell 7  
- Brave Browser instalado em:
- Caso usem outro browser, terão de dar o caminho do executavel.

> ⚠️ Se o Brave estiver noutro caminho, altera a variável `$bravePath` no script.

---

### 2️⃣ Executar o script

1. Faz clone do repositório ou descarrega o ficheiro `.ps1`
2. Abre o PowerShell
3. (Se necessário) permite execução de scripts:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

.\LinkedInSearchTool.ps1
