function show-menu {
    cls
    Write-Host "======================================"
    Write-Host "            Menú principal            "
    Write-Host "======================================"
    Write-Host "(Digite el número correspondiente a la opción que desea)"
    Write-Host "1) Desplegar los cinco procesos que más CPU estén consumiendo en ese momento"
    Write-Host "2) Desplegar los filesystems o discos conectados a la máquina"
    Write-Host "3) Desplegar el nombre y el tamaño del archivo más grande almacenado en un disco o filesystem especificado"
    Write-Host "4) Desplegar cantidad de memoria libre y cantidad del espacio de swap en uso"
    Write-Host "5) Desplegar número de conexiones de red activas actualmente (en estado ESTABLISHED)"
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
            Write-Host "Top 5 procesos que más están consumiendo, en este momento, son:"
            Get-Process | sort cpu -Descending | select -First 5
        }

        2 {
            Write-Host "Filesystems/Discos conectados:"
            Get-PSDrive -PSProvider FileSystem | select Name, @{Name="Size (B)"; Expression={$_.Used + $_.Free}}, @{Name="FreeSpace (B)"; Expression={$_.Free}} | ft
        }

        default {
            Write-Host "Opción inválida."
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