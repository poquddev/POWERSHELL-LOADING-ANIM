$host.UI.RawUI.BackgroundColor = "Black"
$host.UI.RawUI.ForegroundColor = "Green"
Clear-Host

$width = $host.UI.RawUI.WindowSize.Width
$height = $host.UI.RawUI.WindowSize.Height

$chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
$columns = @()
for ($i = 0; $i -lt $width; $i++) {
    $columns += @{
        Position = Get-Random -Minimum -$height -Maximum 0
        Speed = Get-Random -Minimum 1 -Maximum 3
    }
}

$startTime = Get-Date
$frameCount = 0
$running = $true

function Draw-Box($x, $y, $w, $h, $text) {
    $top = "+" + "-" * ($w - 2) + "+"
    $bottom = "+" + "-" * ($w - 2) + "+"
    $side = "|" + " " * ($w - 2) + "|"

    [Console]::SetCursorPosition($x, $y)
    Write-Host $top -ForegroundColor Cyan -NoNewline
    for ($i = 1; $i -lt $h - 1; $i++) {
        [Console]::SetCursorPosition($x, $y + $i)
        Write-Host $side -ForegroundColor Cyan -NoNewline
    }
    [Console]::SetCursorPosition($x, $y + $h - 1)
    Write-Host $bottom -ForegroundColor Cyan -NoNewline

    [Console]::SetCursorPosition($x + 1, $y + [math]::Floor(($h - 1) / 2))
    Write-Host $text.PadRight($w - 2).Substring(0, [Math]::Min($text.Length, $w - 2)) -ForegroundColor White -BackgroundColor Black -NoNewline
}

while ($running) {
    if ([Console]::KeyAvailable) {
        $key = [Console]::ReadKey($true)
        if ($key.Key -eq 'Q') {
            $running = $false
        }
        if ($key.Key -eq 'D') {
            Clear-Host
            Write-Host "WARNING: Self-destruct initiated. The app will close in 3 seconds." -ForegroundColor Red
            Start-Sleep -Seconds 3
            $running = $false
        }
    }

    $output = ""
    for ($y = 0; $y -lt $height - 5; $y++) {
        for ($x = 0; $x -lt $width; $x++) {
            if ($y -eq $columns[$x].Position) {
                $output += $chars[(Get-Random -Maximum $chars.Length)]
            } else {
                $output += " "
            }
        }
    }
    
    [Console]::SetCursorPosition(0, 0)
    Write-Host $output -NoNewline
    
    for ($i = 0; $i -lt $width; $i++) {
        $columns[$i].Position += $columns[$i].Speed
        if ($columns[$i].Position -gt $height - 5) {
            $columns[$i].Position = Get-Random -Minimum -10 -Maximum 0
        }
    }
    
    $frameCount++
    $elapsedTime = (Get-Date) - $startTime
    $fps = [math]::Round($frameCount / $elapsedTime.TotalSeconds, 2)
    
    Draw-Box 0 ($height - 5) $width 3 "Current app is loading..."
    Draw-Box 0 ($height - 2) $width 2 ("FPS: {0} | Press 'Q' to quit, 'D' to destruct" -f $fps)
    
    Start-Sleep -Milliseconds 50
}

Clear-Host

# Reset console colors
$host.UI.RawUI.BackgroundColor = $originalBackground
$host.UI.RawUI.ForegroundColor = $originalForeground
Clear-Host