Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Mapear localizações para geoUrn do LinkedIn
$geoMap = @{
    "Portugal"        = "100364837"
    "Lisboa e Região" = "90010352"
    "Porto e Região"  = "90010354"
    "Faro e Região"   = "90010349"
}

function Open-LinkedInSearch {
    param(
        [string]$Keywords,
        [string]$Location,
        [bool]$OpenToWork
    )

    if (-not $Keywords.Trim()) {
        [System.Windows.Forms.MessageBox]::Show("Por favor, insira as keywords.","Erro")
        return $false
    }
    if (-not $Location.Trim()) {
        [System.Windows.Forms.MessageBox]::Show("Por favor, selecione a localização.","Erro")
        return $false
    }

    # Formata keywords com AND
    $terms = $Keywords -split ',' | ForEach-Object { $_.Trim() }

    # OpenToWork (opcional)
    if ($OpenToWork) {
        $terms += "#OpenToWork"
    }

    $searchTerms = [System.Uri]::EscapeDataString(($terms -join " AND "))

    # Localização
    if ($geoMap.ContainsKey($Location)) {
        $geoUrn = [System.Uri]::EscapeDataString("[$($geoMap[$Location])]")

    } else {
        $geoUrn = ""
    }

    # Monta URL LinkedIn
    $linkedinUrl = "https://www.linkedin.com/search/results/people/?keywords=$searchTerms"
    if ($geoUrn) {
        $linkedinUrl += "&geoUrn=$geoUrn"
    }

    # Abrir no Brave
    $bravePath = "CAMINHO DO EXE DO BROWSER"
    if (Test-Path $bravePath) {
        Start-Process $bravePath $linkedinUrl
        return $true
    } else {
        [System.Windows.Forms.MessageBox]::Show("Brave não encontrado no caminho:`n$bravePath","Erro")
        return $false
    }
}

# ---------- FORM ----------
$form = New-Object System.Windows.Forms.Form
$form.Text = "Pesquisa de Candidatos LinkedIn"
$form.Size = New-Object System.Drawing.Size(520,320)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false

# ---------- GROUPBOX ----------
$group = New-Object System.Windows.Forms.GroupBox
$group.Text = "Pesquisa de Candidatos"
$group.Size = New-Object System.Drawing.Size(480,200)
$group.Location = New-Object System.Drawing.Point(15,10)
$form.Controls.Add($group)

# ---------- KEYWORDS ----------
$lblKeywords = New-Object System.Windows.Forms.Label
$lblKeywords.Text = "Keywords (separadas por vírgula):"
$lblKeywords.Location = New-Object System.Drawing.Point(10,30)
$lblKeywords.AutoSize = $true
$group.Controls.Add($lblKeywords)

$txtKeywords = New-Object System.Windows.Forms.TextBox
$txtKeywords.Size = New-Object System.Drawing.Size(450,25)
$txtKeywords.Location = New-Object System.Drawing.Point(10,50)
$group.Controls.Add($txtKeywords)

# ---------- LOCALIZAÇÃO ----------
$lblLocation = New-Object System.Windows.Forms.Label
$lblLocation.Text = "Localização:"
$lblLocation.Location = New-Object System.Drawing.Point(10,85)
$lblLocation.AutoSize = $true
$group.Controls.Add($lblLocation)

$comboLocation = New-Object System.Windows.Forms.ComboBox
$comboLocation.Size = New-Object System.Drawing.Size(450,25)
$comboLocation.Location = New-Object System.Drawing.Point(10,105)
$comboLocation.DropDownStyle = 'DropDownList'
$comboLocation.Items.AddRange(@(
    "Portugal",
    "Lisboa e Região",
    "Porto e Região",
    "Faro e Região"
))
$group.Controls.Add($comboLocation)

# ---------- OPENTOWORK ----------
$chkOpen = New-Object System.Windows.Forms.CheckBox
$chkOpen.Text = "Apenas #OpenToWork"
$chkOpen.Location = New-Object System.Drawing.Point(10,140)
$chkOpen.AutoSize = $true
$group.Controls.Add($chkOpen)

# ---------- BOTÕES ----------
$btnSearch = New-Object System.Windows.Forms.Button
$btnSearch.Text = "Pesquisar"
$btnSearch.Size = New-Object System.Drawing.Size(110,35)
$btnSearch.Location = New-Object System.Drawing.Point(260,235)
$btnSearch.BackColor = [System.Drawing.Color]::FromArgb(0,120,215)
$btnSearch.ForeColor = 'White'
$btnSearch.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)

$btnSearch.Add_Click({
    $success = Open-LinkedInSearch `
        $txtKeywords.Text `
        $comboLocation.Text `
        $chkOpen.Checked

    if ($success) {
        # RESET DO FORM
        $txtKeywords.Clear()
        $comboLocation.SelectedIndex = -1
        $chkOpen.Checked = $false
        $txtKeywords.Focus()
    }
})

$form.Controls.Add($btnSearch)

$btnClose = New-Object System.Windows.Forms.Button
$btnClose.Text = "Fechar"
$btnClose.Size = New-Object System.Drawing.Size(110,35)
$btnClose.Location = New-Object System.Drawing.Point(380,235)
$btnClose.BackColor = 'Gray'
$btnClose.ForeColor = 'White'
$btnClose.Font = $btnSearch.Font
$btnClose.Add_Click({ $form.Close() })
$form.Controls.Add($btnClose)

# ---------- MOSTRAR FORM ----------
[void]$form.ShowDialog()

