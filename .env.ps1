$env:PATH = "$env:HOMEPATH/.local/bin; $env:PATH"
$env:GH_USERNAME = "nathanblair"

if (-Not (Test-Path env:PIPENV_VENV_IN_PROJECT)) {
    New-Item -Name PIPENV_VENV_IN_PROJECT -Path env: -ItemType Variable -Value 1 | Out-Null
}
