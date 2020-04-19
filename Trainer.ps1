Set-Location $PSScriptRoot
Add-Type -AssemblyName System.speech

$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
$speak.SelectVoice('Microsoft David Desktop')

$durationPerRoundInSeconds = 25*60
#$durationPerRoundInSeconds = 5

Get-Content .\things-to-do.csv | ConvertFrom-Csv | Get-Random -Count 5 | ForEach-Object {
    $task = $_.name
    $durationInMinutes = [int]$_.durationInMinutes
    [decimal]$durationInSeconds = 60*$durationInMinutes
    [decimal]$remainingSeconds = 60*$durationInMinutes

    Clear-Host
    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-Host "Proposal for the next task : $task" -ForegroundColor Yellow
    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-Host ""

    $speak.Speak("Proposal for the next task : $task")

    While ($remainingSeconds -gt 0) {
        Start-Sleep -Seconds 1
        $minutesRemaining = [Math]::Round( [decimal]($remainingSeconds/60), 2)
        Write-Progress -Activity "$task; $minutesRemaining minutes remaining" -PercentComplete $percentComplete
        $percentComplete = [Math]::Round( ($durationInSeconds-$remainingSeconds) / $durationInSeconds * 100 )
        $remainingSeconds -= 1
    }

    $speak.Speak("Well done. You have completed the mission, you may now continue to the next task.")

    Read-Host "Task complete. Enter for the next one."
}

Write-Host "Round complete."

