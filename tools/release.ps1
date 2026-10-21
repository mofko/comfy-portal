[CmdletBinding()]
param(
    [string]$Tag = "1.0.9",
    [switch]$Publish
)

$ErrorActionPreference = "Stop"
[Console]::InputEncoding = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
$OutputEncoding = [Console]::OutputEncoding

$notesPath = Join-Path ([System.IO.Path]::GetTempPath()) "comfy-portal-release-notes-$PID.md"
$notes = @"
## Что нового

- Добавлена загрузка MiaoMiao RealSkin EPS-v1.4 в ComfyUI/models/checkpoints.
"@

[System.IO.File]::WriteAllText($notesPath, $notes, [System.Text.UTF8Encoding]::new($false))
$readBack = [System.IO.File]::ReadAllText($notesPath, [System.Text.UTF8Encoding]::new($false))
if ($readBack -cne $notes -or $readBack.Contains([char]0xFFFD)) {
    throw "UTF-8 verification of release notes failed."
}
Write-Host "UTF-8 release notes verified: $notesPath"

if (-not $Publish) {
    Write-Host "Draft only. Run with -Publish after build and smoke tests."
    exit 0
}

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw "GitHub CLI (gh) is required to publish a release."
}
gh release create $Tag --title $Tag --notes-file $notesPath
$publishedBody = gh release view $Tag --json body --jq .body
foreach ($requiredText in @("MiaoMiao RealSkin EPS-v1.4", "ComfyUI")) {
    if (-not $publishedBody.Contains($requiredText)) {
        throw "GitHub release body did not preserve text: $requiredText"
    }
}
Write-Host "GitHub release body verified."
