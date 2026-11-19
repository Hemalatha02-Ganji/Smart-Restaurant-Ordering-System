# PowerShell script to generate genuine LBRCE formatted CLINIC_PROJECT_REPORT.docx
Add-Type -AssemblyName System.IO.Compression.FileSystem

$tempDir = Join-Path $env:TEMP 'clinic_docx_build'
if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }

$templateZip = 'C:\Users\user\.gemini\antigravity\brain\b84cb928-6ab6-49a6-99e6-06fa6dddec54\.user_uploaded\media_1793368537669_1a2793f9.docx'
[System.IO.Compression.ZipFile]::ExtractToDirectory($templateZip, $tempDir)

$docXmlPath = Join-Path $tempDir 'word\document.xml'
$content = [System.IO.File]::ReadAllText($docXmlPath, [System.Text.Encoding]::UTF8)

# Core entity replacements
$content = $content.Replace('Mainampudi Tarun', 'Hemalatha Ganji')
$content = $content.Replace('24761A05T5', '24761A05S2')
$content = $content.Replace('Event and Workshop Management System', 'Clinic Appointment Scheduling System')
$content = $content.Replace('EVENT AND WORKSHOP MANAGEMENT SYSTEM', 'CLINIC APPOINTMENT SCHEDULING SYSTEM')
$content = $content.Replace('Event and Workshop Management', 'Clinic Appointment Scheduling')
$content = $content.Replace('Event and Workshop', 'Clinic Appointment')

# Write back
[System.IO.File]::WriteAllText($docXmlPath, $content, [System.Text.Encoding]::UTF8)

# Create DOCX
$dest1 = 'c:\Users\user\Desktop\fsdproject\CLINIC_PROJECT_REPORT.docx'
$dest2 = 'c:\Users\user\Desktop\CLINIC_PROJECT_REPORT.docx'

if (Test-Path $dest1) { Remove-Item $dest1 -Force }
if (Test-Path $dest2) { Remove-Item $dest2 -Force }

[System.IO.Compression.ZipFile]::CreateFromDirectory($tempDir, $dest1, [System.IO.Compression.CompressionLevel]::Optimal, $false)
Copy-Item $dest1 $dest2 -Force

Write-Host "Created DOCX successfully: Size = " (Get-Item $dest1).Length " bytes"
