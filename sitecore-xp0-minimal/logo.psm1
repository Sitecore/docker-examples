function Show-Start {
  param(
    [Parameter()]
    [string] $Color = "DarkCyan"
  )

  $logo = @'
    
                              mm,                         
                r"**&,   L /`g                            
        $M     ,wggw, `k ]$  N&                           
        $r   ,$$,gg,,'~  ,$$  @w,                         
        \$gg$$$@"-s* ,g@$$P      *,                       
          *$$@" gF g@$$$$F | |'   x'=                     
      g,,y$@" gl ,@$$$$$@ |     |L  %g                    
      *M* ,gll ,$$$$$$$F |    |`,gQ $$@g                  
g$$$$@gg$$lllL @$$$$$$$r  ,''  *&&ll  *M                  
   `""***"`Al ]$$$$$$$$L ]ll&        '`                   
     $  %g&*l ]$$$$$$$$$  Yll$            /|!L:,,,,       
      $$g,,w$l  $$$$$$$$$@  $ll$          '  '``''''''    
      $lllll$  ]$$$$$$@R**  *lll,      @@,       '" :| L  
        "^"     %$$P`,g@@@r   "*4&,  ,@$$$F            '! 
                  `g@$$$$" ,g@$$Qgww,,,,,,,,,,            
                  $$$$$$F $llllllllllllllllllllL          
                /$$$$$$@ '$llllllllllllllM" Yl$           
                /$$$$$$$$@g  `"****""`l&   @F,F           
              ,N*"  ]$$$$$$$$@@@@@@` "    g",`            
                $$lL ]$$$$$$$$$$P` r     / ;`             
                  *lg ]$$$$$P"  ,r  ggg, ,$l              
                    "  N"  ,<&"  g$$$$$k `                
                          '"`         `                   
     _                              _                  
    | |                            | |                  
    | | __   ___    _ __     __ _  | |__     ___    ___ 
    | |/ /  / _ \  | '_ \   / _` | | '_ \   / _ \  / __|
    |   <  | (_) | | | | | | (_| | | |_) | | (_) | \__ \
    |_|\_\  \___/  |_| |_|  \__,_| |_.__/   \___/  |___/
                                                        

'@

  Write-Host $logo -ForegroundColor $Color
}


function Show-Stop {
  param(
    [Parameter()]
    [string] $Color = "Yellow"
  )

$logo = @'
   __ _                      _    _        _  _          
  / _` |   ___     ___    __| |  | |__    | || |   ___   
  \__, |  / _ \   / _ \  / _` |  | '_ \    \_, |  / -_)  
  |___/   \___/   \___/  \__,_|  |_.__/   _|__/   \___|  
_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_| """"|_|"""""| 
"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'

'@

  Write-Host $logo -ForegroundColor Yellow
}


Export-ModuleMember -Function *
