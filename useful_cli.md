# What i think potentially is needed but depends on use-case

# Clis
  - dua: https://github.com/Byron/dua-cli?
  - tailscale (only to connect)
  - cryptomator (only for backup)
  - koofr (only for backup)
  - ncspot (listening to music)
  - systemd-manager-tui (systemd manager)
  - fastfetch (see system's installed packages, hardware, managers)
  - eza (needed for yazi)
  - duckdb

# Other

## Bookmarks

### 
Useful to get the jwt token directly via a hotkey :)

javascript:(() => {  const jwtRegex = /\bey[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+\b/;  const bodyText = document.body.innerText || document.body.textContent;  const match = bodyText.match(jwtRegex);  if (match) {    const token = match[0];    navigator.clipboard.writeText(token).then(() => {      console.log("JWT copied to clipboard:", token);      alert("JWT token copied to clipboard.");    });  } else {    alert("No JWT token found on the page.");  }})();
