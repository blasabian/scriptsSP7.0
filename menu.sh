factorial(){
 #Pedimos el parametro
  read -p "De un número positivo: " num
 #Comprobamos que ha sido pasado
  if [ -z $num ]; then
        echo "Debe de pasar un parametro"
        exit 1
  fi

  #Comprobamos que sea positivo
  if [[ $num -lt 0 ]]; then
        echo "El número debe de ser positivo"
        exit 1
  fi

  #Calculamos
  numero=$num
  factorial=1

  while [ $numero -gt 1 ]; do
        factorial=$((factorial*numero))
        numero=$((numero - 1))
  done

  echo "El factorial de $num es $factorial"
  exit 1
}

bisiesto(){
 read -p "Debe de dar el año actual. Ej: 2005 |  " year

 #Verificar si se ha pasado el parametro
 if [ -z $year ]; then
        echo "Debe de dar el año actual."
        exit 1
 fi

 #Verificar que el año, obviamente, sea positivo

 if [ $year -lt 0 ]; then
        echo "El año debe de ser positivo"
        exit 1
  fi

 #Verificar si el año es bisiesto

  if (( ($year % 4 == 0 && $year % 100 != 0 ) || ($year % 400 == 0) )); then
        echo "El año $year es bisiesto."
  else
        echo "El año $year no es bisiesto."
  fi

 exit 1

}

adivina() {

 #Generamos el número aleatorio

 num_aleatorio=$(( RANDOM % 100 + 1 ))
 intentos=0
 adivinado=0

  echo "¡Bienvenido al juego de Adivina el Número!"
  echo "He pensado en un número entre 1 y 100. ¡Intenta adivinarlo!"

 #Bucle
 until [ $adivinado -eq 1 ]; do
  # Incrementar el contador de intentos
  ((intentos++))

  # Pedir al usuario que introduzca un número
 read -p "Introduzca el número: " num_usu

  # Gemerar el número introducido con el número aleatorio

  if [ $num_usu -lt $num_aleatorio ]; then
        echo "Demasiado bajo. Intenta de nuevo."
  elif [ $num_usu -gt $num_aleatorio ]; then
        echo "Demasiado alto. Intenta de nuevo."
  else
        echo "¡Felicades! Has adivinado el número."
        echo "Número de intentos: $intentos"
        adivinado=1
  fi
 done

 exit 1
}

edad(){
 #Pedimos la edad
 read -p "Introduzca su edad: " edad

 if [ $edad -lt 3 ]; then
          echo "Está en su niñez"
   elif [ $edad -le 10 ] && [ $edad -ge 3 ]; then
          echo "Estás en la infancia"
 elif [ $edad -lt 18 ] && [ $edad -gt 10 ]; then
          echo "Estás en la adolescencia"
   elif [ $edad -lt 40 ] && [ $edad -ge 18 ]; then
          echo "Estás en la juventud"
   elif [ $edad -lt 65 ] && [ $edad -ge 40 ]; then
          echo "Estás en la madurez"
   elif [ $edad -ge 65 ]; then
          echo "Estás en la vejez"
 fi

 exit 1
}

fichero(){
 read -p "¿Cuál es el nombre del fichero? Debe de poner la ruta absoluta.  " fichero

 if [ -z $fichero ]; then
        echo "Debe de pasar el nombre del fichero. "
        exit 1
 fi

 if [ ! -e "$fichero" ]; then
        echo "El fichero no existe"
        exit 1
 fi
#Tomamos el tamaño del fichero
 size=$(stat --format="%s" "$fichero") #stat se usa para obtener los datos

 #Tipo de fichero
 tipo=$(stat --format="%F" "$fichero")

 #Nº de inodo
 inodo=$(stat --format="%i" "$fichero")

 #Punto de montaje
 punto_montaje=$(df --output=target "$fichero" | tail -n 1) #la primera parte obtiene el punto de montaje

 #Mostramos la información

 echo "Información del fichero:"
 echo "Ruta: $fichero"
 echo "Tamaño: $size bytes"
 echo "Tipo: $tipo"
 echo "Inodo: $inodo"
 echo "Punto de montaje: $punto_montaje"

 exit 1
}
configurarred(){

 echo "Hola. Pasaremos a recoger los datos."
 read -p "Escriba la IP que desea asignar: " ip
 read -p "Escriba la máscara que desee asignar(En formato CIDR. Ej 24): " mascara
 read -p "Escriba la puerta de enlace: " gw
 read -p "Escriba su DNS: " dns

 Netplan="/etc/netplan/50-cloud-init.yaml"
 Backup="/etc/netplan/50-cloud-init.yaml.bak"

 #Creamos un respaldo del archivo de netplan
 if [ -f "$netplan" ]; then
        echo "Creando un respaldo del archivo existente en $Backup..."
        sudo cp "$Netplan" "$Backup"
 fi

 #Sobreescribimos el contenido
 cat << EOF | sudo tee "$Netplan"
 network:
   version: 2
   ethernets:
     enp0s3:
       dhcp4: false
       addresses:
         - $ip/$mascara
       gateway4: $gw
       nameservers:
         addresses:
           - $dns
EOF

 #Aplicamos la configuración
        echo "Aplicando la nueva configuración"
        sudo netplan apply

 #Mostramos la configuración
        echo "Configuración de la red"
        ip addr show
        echo "-----"
        ip route show
        echo "-----"
        cat "$Netplan"
 exit 1
}

buscar(){
 read -p "Introduzca el nombre del archivo que desee buscar: " archivo

 if [ -z $archivo ]; then
                echo "Debe de pasar el nombre del archivo"
                exit 1
 fi

 busqueda=$(find / -type f -name "$archivo")

 if [ -z "$busqueda" ]; then
        echo "El archivo no existe en el sistema."
 else
        echo "Fichero encontrado en: $busqueda"
        vocales=$(cat "$busqueda" | tr -cd "aeiouAEIOU" | wc -c)
        echo "El fichero contiene $vocales vocales"
 fi

 exit 1
}

contar(){
 read -p "Establezca el direcotrio del desea contar su número de directorios: " directorio

 busqueda=$(find / -type d -name "$directorio")

 if [ -z "$busqueda" ]; then
        echo "El directorio no existe en el sistema."
 else
        echo "Directorio encontrado."
        echo "Contando el número de ficheros..."
        ficheros=$(find "$directorio" -type f | wc -l)
        echo "El direcotrio $directorio contiene $ficheros ficheros."
 fi

 exit 1
}


privilegios(){

 usuario=$(whoami)

 echo "Usted es el usuario $usuario. Confirmaremos sus privilegios.."

  if sudo -n true; then
        echo "Usted tiene permisos administrativos en este sistema."
  else
        echo "Usted no tiene permisos administrativos en este sistema."
  fi
}

permisosoctal(){

 read -p "Introduzca la ruta absoluta del objeto que desee revisar sus permisos octales: " objeto

 if [ ! -e "$objeto" ]; then
        echo "El archivo o directorio no existe en el sistema"
 else
        permisos=$(stat --format '%a' "$objeto")
        permisos_especiales=$(stat --formar '%A' "$objeto")

        echo "Ruta: $objeto"
        echo "Permisos en octal: $permisos"
        echo "Permisos detallados: $permisos_especiales"
 fi

exit 1
}






#Creamos el menu principal
menu(){
  op=1
  while [ $op -ne 0 ]; do
        echo -e "\nOpción 1: factorial"
        echo "Opción 2: bisiesto"
        echo "Opción 3: configurarred"
        echo "Opción 4: adivina"
        echo "Opción 5: edad"
        echo "Opción 6: fichero"
        echo "Opción 7: buscar"
        echo "Opción 8: contar"
        echo "Opción 9: privilegios"
        echo "Opción 10: permisosoctal"
        echo "Opción 0: Salir"
        read -p "Elegir la opción deseada " op
        echo ""
        case $op in
           0)
           ;;
           1)
                echo "factorial"
                factorial
           ;;
           2)
                echo "bisiesto"
                bisiesto
           ;;
           3)
                echo "configurarred"
                configurarred
           ;;
           4)
                echo "adivina"
                adivina
          ;;
           5)
                echo "edad"
                edad
           ;;
           6)
                echo "fichero"
                fichero
           ;;
           7)
                echo "buscar"
                buscar
           ;;
           8)
                echo "contar"
                contar
           ;;
           9)
                echo "privilegios"
                privilegios
           ;;
           10)
                echo "permisosoctal"
                permisosoctal
        esac
     done
}
menu
