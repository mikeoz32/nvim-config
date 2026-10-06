$ErrorActionPreference = 'Stop'

$repo = if ($env:CR_ANALYZER_ROOT) {
	$env:CR_ANALYZER_ROOT
} else {
	Join-Path $HOME 'cr-analyzer'
}

$installDir = if ($env:CR_ANALYZER_INSTALL_DIR) {
	$env:CR_ANALYZER_INSTALL_DIR
} else {
	Join-Path $env:LOCALAPPDATA 'nvim-data\cr-analyzer'
}

$binary = Join-Path $installDir 'cr-analyzer.exe'
$stagedBinary = Join-Path $installDir "cr-analyzer.new.$PID.exe"

if (-not (Test-Path (Join-Path $repo 'shard.yml')) -or
	-not (Test-Path (Join-Path $repo 'src\bin\cra.cr'))) {
	throw "cr-analyzer source not found at '$repo'. Set CR_ANALYZER_ROOT to its checkout path."
}

foreach ($tool in @('crystal', 'shards')) {
	if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
		throw "Required command not found: $tool"
	}
}

New-Item -ItemType Directory -Force -Path $installDir | Out-Null
Push-Location $repo
try {
	& shards install --frozen
	if ($LASTEXITCODE -ne 0) {
		throw "shards install failed with exit code $LASTEXITCODE"
	}

	& crystal build src/bin/cra.cr --release --no-debug --output $stagedBinary
	if ($LASTEXITCODE -ne 0) {
		throw "crystal build failed with exit code $LASTEXITCODE"
	}

	Move-Item -Force $stagedBinary $binary
} finally {
	Pop-Location
	if (Test-Path $stagedBinary) {
		Remove-Item -Force $stagedBinary
	}
}

Write-Output "Installed cr-analyzer from $repo to $binary"
