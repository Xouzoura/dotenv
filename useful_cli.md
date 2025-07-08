# What i think potentially is needed but depends on use-case

# Clis
  - dua: https://github.com/Byron/dua-cli?
  - tailscale
  - cryptomator
  - cronitor (sudo cronitor dash)
  - koofr (backup)
  - ncspot (listening to music)
  - systemd-manager-tui

# Other

## Bookmarks
javascript:(() => {  const jwtRegex = /\bey[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+\b/;  const bodyText = document.body.innerText || document.body.textContent;  const match = bodyText.match(jwtRegex);  if (match) {    const token = match[0];    navigator.clipboard.writeText(token).then(() => {      console.log("JWT copied to clipboard:", token);      alert("JWT token copied to clipboard.");    });  } else {    alert("No JWT token found on the page.");  }})();
