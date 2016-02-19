do

function run(msg, matches)
  return
    inrealm
    ingroup
    inpm
    banhammer
    Feedback
    lock_join
    antilink
    antitag
    gps
    leave
    tagall
    arabic_lock
    welcome
    google
    sms
    chat
    Debian_service
    sudoers
    add_admin
    anti_spam
    add_bot
    owners
    set
    get
    broadcast
    download_media
    invite
    all
    leave_ban
    danestani
    joke
    nerkh
    echo
    linkpv
    antifosh
    calculato
    setrank
    tex
    map
    share-contact
    qr
    on-off
    virous
    translate
    time
    location
    
    
end

return {
  description = "plugin", 
  usage = "/pluginlist",
  patterns = {
    "^[Pp]luginlist",
    "^[!/]pluginlist$",

  },
  run = run
}

end
