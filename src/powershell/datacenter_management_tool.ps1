function show-menu {
    cls
    Write-Host "======================================"
    Write-Host "            Men� principal            "
    Write-Host "======================================"
    Write-Host "(Digite el n�mero correspondiente a la opci�n que desea)"
    Write-Host "1) Desplegar los cinco procesos que m�s CPU est�n consumiendo en ese momento"
    Write-Host "2) Desplegar los filesystems o discos conectados a la m�quina"
    Write-Host "3) Desplegar el nombre y el tama�o del archivo m�s grande almacenado en un disco o filesystem especificado"
    Write-Host "4) Desplegar cantidad de memoria libre y cantidad del espacio de swap en uso"
    Write-Host "5) Desplegar n�mero de conexiones de red activas actualmente (en estado ESTABLISHED)"
    Write-Host "0) Salir"
}

function exec-option {
    param (
        [int]$option
    )

    Write-Host ""

    switch ($option) {
        0 {
            Write-Host "Saliendo..."
            exit
        }

        1 {
            Write-Host "Top 5 procesos que m�s est�n consumiendo, en este momento, son:"
            Get-Process | sort cpu -Descending | select -First 5
        }

        2 {
            Write-Host "Filesystems/Discos conectados:"
            Get-PSDrive -PSProvider FileSystem | select Name, @{Name="Size (B)"; Expression={($_.Used + $_.Free)*1KB}}, @{Name="FreeSpace (B)"; Expression={($_.Free)*1KB}} | ft
        }

        3 {
            $drive = Read-Host "Especifique un disco (C:, por ejemplo)"
            Write-Host "Archivo m�s grande:"
            dir -Path $drive -Recurse | sort Length -Descending | select Name, Length, Directory -First 1 | ft
        }

        4 {
            Write-Host "Memoria libre y espacio swap en uso:"
            Get-WmiObject -Class Win32_OperatingSystem | select @{Name="Free Memory (B)"; Expression={$_.FreePhysicalMemory * 1KB}}, @{Name="Free Memory (%)"; Expression={(($_.FreePhysicalMemory * 1KB) / ($_.TotalVisibleMemorySize * 1KB)) * 100}}, @{Name="Swap in Use (B)"; Expression={($_.TotalVirtualMemorySize - $_.FreeVirtualMemory) * 1KB}}, @{Name="Swap in Use (%)"; Expression={(($_.TotalVirtualMemorySize - $_.FreeVirtualMemory) * 1KB) / ($_.TotalVirtualMemorySize * 1KB) * 100}} | ft
        }

        5 {
            Write-Host "Conexiones de red activas:"
            Get-NetTCPConnection -State Established

            Write-Host ""
            
            Write-Host "N�mero de conexiones de red activas actualmente (en estado ESTABLISHED):"
            (Get-NetTCPConnection -State Established).Count
        }

        default {
            Write-Host "Opci�n inv�lida."
        }
    }

    Write-Host ""
}

do {
    show-menu
    $userInput = Read-Host 
    [int]$selection = -1
    [void][int]::TryParse($userInput, [ref]$selection)
    exec-option -option $userInput
    Pause
} while ($selection -ne 0)