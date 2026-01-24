#!/usr/bin/env nu

def main [site?: string, username?: string] {
  let site = if ($site | is-empty) { input $"Site name? " } else { $site }
  let user = if ($username | is-empty) { input $"Username/email? " } else { $username }

  let pw = (bw generate -ulns --length 16)

  let template = (bw get template item | jq ($"
    .name = \"($site)\"
    | .login.username = \"($user)\"
    | .login.password = \"($pw)\"
    | .login.uris += [{\"uri\": \"https://(($site | str lowercase) + '.com')\"}]
  "))

  bw encode | bw create item <<< $template

  echo $pw | wl-copy

  print $"Generated and stored password for ($site) ($user): ($pw)"
  print "Copied to clipboard. Run `bw sync` to push to vault."
}
