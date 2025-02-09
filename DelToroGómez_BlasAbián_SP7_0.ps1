#Importante: Este script debe ejecutarse en un entorno con privilegios de administrador.

function pizzeria {
 param (
        [string]$tipo
    )
# Listas de ingredientes
$vege = @("Pimiento", "Tofu")
$novege = @("Peperoni", "Jamon", "Salmon")

# Mensaje de bienvenida
Write-Host "Bienvenido a Pizzería Bella Napoli!"

if ($tipo -eq "vegetariana") {
    Write-Host "Todas nuestras pizzas llevan mozzarella y tomate."
    Write-Host "Solo puedes elegir un ingrediente adicional. Ingredientes disponibles: $($vege -join ', ')"
    
    $ingrediente = Read-Host "Dime qué ingrediente quieres añadir"

    # Validar que el ingrediente esté en la lista de vegetarianos
    if ($vege -contains $ingrediente) {
        Write-Host "Has elegido una **pizza vegetariana** con los siguientes ingredientes: Mozzarella, Tomate y $ingrediente."
    } else {
        Write-Host "Error: Debes elegir solo un ingrediente válido de la lista. *Pedido cancelado*."
    }

} elseif ($tipo -eq "no vegetariana") {
    Write-Host "Todas nuestras pizzas llevan mozzarella y tomate."
    Write-Host "Solo puedes elegir un ingrediente adicional. Ingredientes disponibles: $($novege -join ', ')"
    
    $ingrediente = Read-Host "Dime qué ingrediente quieres añadir"

    # Validar que el ingrediente esté en la lista de no vegetarianos
    if ($novege -contains $ingrediente) {
        Write-Host "Has elegido una **pizza no vegetariana** con los siguientes ingredientes: Mozzarella, Tomate y $ingrediente."
    } else {
        Write-Host "Error: Debes elegir solo un ingrediente válido de la lista. *Pedido cancelado*."
    }

} else {
    Write-Host "Error: Solo puedes elegir 'vegetariana' o 'no vegetariana'. *Pedido cancelado*."
}
}
function bisiesto {
 param (
        [int]$bisiesto
    )
$par = 0
$impar = 0
 
0..365 | %{
    $dia = ([datetime]"01/01/2020 00:00").AddDays($_).Day
    if ($dia %2)
    {
        $impar++
    }
    else
    {
        $par++
    }
}
 
"Días pares: " + $par.ToString()
"Días impares: " + $impar.ToString()
}
function Menu-usuarios {
    ﻿# Función para mostrar el menú
    function Show-Menu {
        Clear-Host
        Write-Host "=== MENU DE USUARIOS ==="
        Write-Host "1. Listar usuarios"
        Write-Host "2. Crear usuario"
        Write-Host "3. Eliminar usuario"
        Write-Host "4. Modificar usuario"
        Write-Host "5. Salir"
        Write-Host "======================="
    }

    # Bucle principal del menú
    do {
        Show-Menu
        $opcion = Read-Host "Seleccione una opción"
    
        switch ($opcion) {
            1 {
                Write-Host "Listando usuarios..."
                Get-LocalUser | Select-Object Name | Out-Host
                pause
            }
            2 {
                $usuario = Read-Host "Ingrese nombre de usuario"
                $password = Read-Host "Ingrese contraseña" -AsSecureString
                New-LocalUser -Name $usuario -Password $password
                Write-Host "Usuario creado con éxito"
                pause
            }
            3 {
                $usuario = Read-Host "Ingrese usuario a eliminar"
                Remove-LocalUser -Name $usuario
                Write-Host "Usuario eliminado con éxito"
                pause
            }
            4 {
                $usuario = Read-Host "Ingrese usuario a modificar"
                $nuevoNombre = Read-Host "Ingrese nuevo nombre"
                Rename-LocalUser -Name $usuario -NewName $nuevoNombre
                Write-Host "Usuario modificado con éxito"
                pause
            }
            5 {
                Write-Host "Saliendo..."
                break
            }
            default {
                Write-Host "Opción no válida"
                pause
            }
        }
    } while ($opcion -ne 5)
}
function Menu-grupos {
    ﻿# Función para mostrar el menú
    function Show-Menu {
        Clear-Host
        Write-Host "=== MENU DE GRUPOS ==="
        Write-Host "1. Listar grupos"
        Write-Host "2. Ver miembros de un grupo"
        Write-Host "3. Crear grupo"
        Write-Host "4. Eliminar grupo"
        Write-Host "5. Agregar miembro a un grupo"
        Write-Host "6. Eliminar miembro de un grupo"
        Write-Host "7. Salir"
        Write-Host "======================="
    }

    # Bucle principal del menú
    do {
        Show-Menu
        $opcion = Read-Host "Seleccione una opción"

        switch ($opcion) {
            1 {
                Write-Host "Listando grupos..."
                Get-LocalGroup | Select-Object Name | Out-Host
                pause
            }
            2 {
                Get-LocalGroup | Select-Object Name | Out-Host
                $grupo = Read-Host "Ingrese el nombre del grupo"
                Write-Host "Miembros del grupo '$grupo':"
                Get-LocalGroupMember -Group $grupo | Select-Object Name | Out-Host
                pause
            }
            3 {
                $grupo = Read-Host "Ingrese el nombre del nuevo grupo"
                New-LocalGroup -Name $grupo
                Write-Host "Grupo '$grupo' creado con éxito"
                pause
            }
            4 {
                $grupo = Read-Host "Ingrese el nombre del grupo a eliminar"
                Remove-LocalGroup -Name $grupo
                Write-Host "Grupo '$grupo' eliminado con éxito"
                pause
            }
            5 {
                $grupo = Read-Host "Ingrese el nombre del grupo"
                $usuario = Read-Host "Ingrese el nombre del usuario a agregar"
                Add-LocalGroupMember -Group $grupo -Member $usuario
                Write-Host "Usuario '$usuario' agregado al grupo '$grupo' con éxito"
                pause
            }
            6 {
                $grupo = Read-Host "Ingrese el nombre del grupo"
                $usuario = Read-Host "Ingrese el nombre del usuario a eliminar"
                Remove-LocalGroupMember -Group $grupo -Member $usuario
                Write-Host "Usuario '$usuario' eliminado del grupo '$grupo' con éxito"
                pause
            }
            7 {
                Write-Host "Saliendo..."
                break
            }
            default {
                Write-Host "Opción no válida"
                pause
            }
        }
    } while ($opcion -ne 7)
}
function diskpart {
﻿# Solicitamos el número de disco
$numdisk = Read-Host "¿Qué disco quiere utilizar?"

#Obtenemos el tamaño del disco pedido en GB
$tamdisk = (Get-Disk -Number $numdisk | Select-Object Size).Size /1GB
Write-Host "El tamaño del disco $numdisk es de $tamdisk GB."

#Abrimos el diskpart, limpiamos el disco seleccionado y lo convertimos en dinámico y gpt.
@"
sel disk $numdisk
clean
conv gpt
con dyn
"@ | diskpart

#Creamos particiones de 1GB hasta limitar su espacio.
$letra = 'D'
$numvol = 0
for ($espacdisk = 1; $espacdisk -le $tamdisk; $espacdisk++) {
$letra = [char]([int]$letra[0] + 1)
$numvol++
@"
sel disk $numdisk
create volume simple size=1022
format fs='NTFS' label='Volumen $numvol' 'quick'
assign letter $letra
"@ | diskpart
}

}
function Menu {
    Write-Host "=== MENÚ PRINCIPAL ==="
    Write-Host "1. Pizzeria"
    Write-Host "2. Verificar Año Bisiesto"
    Write-Host "3. Menu Usuarios"
    Write-Host "4. Menu grupos"
    Write-Host "5. Menu grupos"
    Write-Host "6. Salir"

    $opcion = Read-Host "Seleccione una opción"

    switch ($opcion) {
        1 {
        $pizza = Read-Host "¿Quieres una pizza vegetariana o no vegetariana?"
         pizzeria -tipo $pizza
        }
        2 {
        $bisiesto = Read-Host "Dame el año: "
         bisiesto -tipo $bisiesto
        }
        3 {
        Menu-usuarios
        }
        4 {
        Menu-grupos
        }
        5 {
        diskpart
        }
        6 {
            Write-Host "Saliendo..."
            return
        }
        default {
            Write-Host "Opción no válida."
        }
    }

    # Volver al menú si no se eligió salir
    if ($opcion -ne 6) {
        Menu
    }
}

# Iniciar el menú
Menu