[CmdletBinding()]
param(
    [string]$Tag = "1.0.7",
    [switch]$Publish
)

$ErrorActionPreference = "Stop"
[Console]::InputEncoding = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
$OutputEncoding = [Console]::OutputEncoding

$notesPath = Join-Path ([System.IO.Path]::GetTempPath()) "comfy-portal-release-notes-$PID.md"
$notes = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('IyMg0KfRgtC+INC90L7QstC+0LPQvgoKLSDQntCx0L3QvtCy0LvRkdC9INC40L3RgtC10YDRhNC10LnRgSDQsiDRgdGC0LjQu9C1IE1hdGVyaWFsIDMuCi0g0JLRi9Cx0L7RgCDQvNC+0LTQtdC70LXQuSDRgdGC0LDQuyDQv9C+0L3Rj9GC0L3QtdC1OiDQutC+0LzQv9C+0L3QtdC90YLRiyDQutCw0LbQtNC+0Lkg0LzQvtC00LXQu9C4INGD0YHRgtCw0L3QsNCy0LvQuNCy0LDRjtGC0YHRjyDQvtC00L3QuNC8INC00LXQudGB0YLQstC40LXQvC4KLSDQlNC+0LHQsNCy0LvQtdC90YsgTWlhb01pYW8gSGFyZW0sIE1pYW9NaWFvIEhhcmVtIChBbmltZSBDb2xvcmluZyksIEtyZWEgMiBMVVNUSUZZINC4IE5vdmEgQW5pbWUgWEwuCi0g0KPRgdGC0LDRgNC10LLRiNC40LUg0LLQsNGA0LjQsNC90YLRiyDRgdC60LDRh9C40LLQsNC90LjRjyDQu CBDb21meVVJX1N3d2FuINCx0L7Qu9GM0YjQtSDQvdC1INC/0YDQtdC00LvQsNCz0LDRjtGC0YHRjyDQuiDRg9GB0YLQsNC90L7QstC60LUuCi0g0JjRgdC/0YDQsNCy0LvQtdC9IFVURi04INC/0YPRgtGMINC00LvRjyByZWxlYXNlIG5vdGVzLgoKTWlhb01pYW8g4oCUINC80L7QtNC10LvRjCDQs9C+0YLQvtCy0LAuCg=='.Replace(' ', '')))

[System.IO.File]::WriteAllText($notesPath, $notes, [System.Text.UTF8Encoding]::new($false))
$readBack = [System.IO.File]::ReadAllText($notesPath, [System.Text.UTF8Encoding]::new($false))
if ($readBack -cne $notes -or $readBack.Contains([char]0xFFFD) -or $readBack.Contains("???")) {
    throw "UTF-8 verification of release notes failed."
}
Write-Host "UTF-8 release notes verified: $notesPath"

if (-not $Publish) {
    Write-Host "Draft only. Run with -Publish after build and smoke tests."
    exit 0
}

gh release create $Tag --title $Tag --notes-file $notesPath
$publishedBody = gh release view $Tag --json body --jq .body
foreach ($requiredText in @(
    [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('0J7QsdC90L7QstC70ZHQvSDQuNC90YLQtdGA0YTQtdC50YE=')),
    [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('TWlhb01pYW8g4oCUINC80L7QtNC10LvRjCDQs9C+0YLQvtCy0LA='))
)) {
    if (-not $publishedBody.Contains($requiredText)) {
        throw "GitHub release body did not preserve UTF-8 text: $requiredText"
    }
}
Write-Host "GitHub release body verified as UTF-8."
