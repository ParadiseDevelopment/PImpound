fx_version 'bodacious'
game 'gta5'


server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server.lua',
  }
  
  client_scripts {
    '@NativeUI/NativeUI.lua', 
    'config.lua',
    'client.lua',
  }


author 'Paradise'
description 'PImpound'
version '1.0.0'