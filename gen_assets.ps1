$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$dir = Join-Path $root 'assets'
New-Item -ItemType Directory -Force $dir | Out-Null
$utf8 = New-Object Text.UTF8Encoding($false)
function Save($name, $text) { [IO.File]::WriteAllText((Join-Path $dir $name), $text, $utf8) }

$themes = @{
    dark  = @{ bg = '#0d1117'; tile = '#1b1f27'; line = '#30363d'; text = '#e6edf3'; muted = '#8b949e'; a1 = '#ffc857'; a2 = '#f5902f' }
    light = @{ bg = '#ffffff'; tile = '#f3f4f6'; line = '#d0d7de'; text = '#1f2328'; muted = '#656d76'; a1 = '#f0a020'; a2 = '#d9701a' }
}
$font = "'Segoe UI','Helvetica Neue',Arial,sans-serif"

function IconPath($slug) {
    $svg = (Invoke-WebRequest -UseBasicParsing "https://cdn.simpleicons.org/$slug/ffffff").Content
    if ($svg -match ' d="([^"]+)"') { return $Matches[1] }
    throw "no path for $slug"
}
$tg = IconPath 'telegram'
$dc = IconPath 'discord'

foreach ($k in $themes.Keys) {
    $t = $themes[$k]

    # --- header banner -----------------------------------------------------
    Save "header-$k.svg" @"
<svg xmlns="http://www.w3.org/2000/svg" width="900" height="170" viewBox="0 0 900 170" role="img" aria-label="ohixx">
  <defs>
    <linearGradient id="g" x1="0" y1="0" x2="1" y2="0"><stop offset="0" stop-color="$($t.a1)"/><stop offset="1" stop-color="$($t.a2)"/></linearGradient>
  </defs>
  <text x="450" y="110" text-anchor="middle" font-family="$font" font-size="76" font-weight="700" letter-spacing="2" fill="url(#g)">ohixx</text>
</svg>
"@

    # --- section headings --------------------------------------------------
    foreach ($s in 'stack', 'activity', 'now', 'projects', 'stats') {
        $label = $s.ToUpper()
        Save "section-$s-$k.svg" @"
<svg xmlns="http://www.w3.org/2000/svg" width="900" height="44" viewBox="0 0 900 44" role="img" aria-label="$s">
  <line x1="0" y1="22" x2="370" y2="22" stroke="$($t.line)" stroke-width="1"/>
  <line x1="530" y1="22" x2="900" y2="22" stroke="$($t.line)" stroke-width="1"/>
  <text x="450" y="28" text-anchor="middle" font-family="$font" font-size="15" font-weight="700" letter-spacing="6" fill="$($t.a2)">$label</text>
</svg>
"@
    }

    # --- contact tiles -----------------------------------------------------
    $icon = $t.a2
    Save "contact-telegram-$k.svg" "<svg xmlns=`"http://www.w3.org/2000/svg`" width=`"56`" height=`"56`" viewBox=`"0 0 56 56`" role=`"img`" aria-label=`"Telegram`"><rect width=`"56`" height=`"56`" rx=`"13`" fill=`"$($t.tile)`"/><svg x=`"14`" y=`"14`" width=`"28`" height=`"28`" viewBox=`"0 0 24 24`"><path fill=`"$icon`" d=`"$tg`"/></svg></svg>"
    Save "contact-discord-$k.svg" "<svg xmlns=`"http://www.w3.org/2000/svg`" width=`"56`" height=`"56`" viewBox=`"0 0 56 56`" role=`"img`" aria-label=`"Discord`"><rect width=`"56`" height=`"56`" rx=`"13`" fill=`"$($t.tile)`"/><svg x=`"14`" y=`"14`" width=`"28`" height=`"28`" viewBox=`"0 0 24 24`"><path fill=`"$icon`" d=`"$dc`"/></svg></svg>"
    $fp = [IO.File]::ReadAllText((Join-Path $root 'funpay.b64')).Trim()
    Save "contact-funpay-$k.svg" "<svg xmlns=`"http://www.w3.org/2000/svg`" xmlns:xlink=`"http://www.w3.org/1999/xlink`" width=`"56`" height=`"56`" viewBox=`"0 0 56 56`" role=`"img`" aria-label=`"FunPay`"><defs><clipPath id=`"c`"><rect x=`"14`" y=`"14`" width=`"28`" height=`"28`" rx=`"7`"/></clipPath></defs><rect width=`"56`" height=`"56`" rx=`"13`" fill=`"$($t.tile)`"/><image x=`"14`" y=`"14`" width=`"28`" height=`"28`" clip-path=`"url(#c)`" xlink:href=`"data:image/png;base64,$fp`"/></svg>"
}
"ok"
