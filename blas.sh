#!/bin/bash

factorial(){
  num=$1
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
}

bisiesto() {
 y=$1
  #Verificar si se ha pasado el parametro
  if [ -z $y ]; then
      echo "Debe de dar el año actual."
      exit 1
  fi

  #Verificar que el año, obviamente, sea positivo
  if [ $y -lt 0 ]; then
       echo "El año debe de ser positivo"
       exit 1
  fi

  #Verificar si el año es bisiesto
  if (( ($y % 4 == 0 && $y %100 != 0) || ($y % 400 == 0) )); then
   echo "El año $y es bisiesto."
  else
   echo "El año $y no es bisiesto."
  fi

 exit 1
}

configurarred() {
    if [ -z $4 ]; then
        echo "Debe de pasar el parametro cuando se le solicite"
        return
    fi
    sudo ip addr flush dev enp0s3
    sudo ip addr add $1/$2 dev enp0s3
    sudo ip addr link set enp0s3 up
    sudo ip route add default via $3
    echo -e "nameserver $4" | sudo tee /etc/resolv.cond 2>/dev/null
    echo "Configuración aplicada"
    ip a
}

adivina() {
rand=$((RANDOM%100+1))
intentos=0
adivinado=0

while [ $adivinado -ne 1 ]; do
    read -p "Este es su intento número $(($intentos+1)). Deme el número: " num
    intentos=$(($intentos+1))

    if [ $num -gt $rand ]; then
        echo "El número introducido es mayor. Pruebe uno más bajo."
    elif [ $num -lt $rand ]; then
        echo "El número introducido es menor. Pruebe uno más alto."
    else
        echo "Ha adivinado. En un total de $intentos "
        echo ""
        adivinado=1
    fi
done
}

edad() {
  if [ -z $1 ]; then
    echo "Por favor, registre su edad"
    exit 1
  fi
  #Comparamos la edad
  if [ $1 -lt 3 ]; then
    echo "Está en su niñez"
  elif [ $1 -ge 3 ] && [ $1 -le 10 ]; then
    echo "Estás en tu infancia"
  elif [ $1 -lt 18 ] && [ $1 -gt 10 ]; then
    echo "Estás en tu adolescencia"
  elif [ $1 -lt 40 ] && [ $1 -ge 18 ]; then
    echo "Estás en tu juventud"
  elif [ $1 -lt 65 ] && [ $1 -ge 40 ]; then
    echo "Estás en tu madurez"
  elif [ $1 -ge 65 ]; then
    echo "Estás en tu vejez"
  else
   echo "Introduzca un número"
   exit 1
  fi
exit 1
}

fichero() {
  tamanio=$(stat -c "%s" "$1")
  tipo=$(stat -c "%F" "$1")
  inodo=$(stat -c "%i" "$1")
  montaje=$(stat -c "%m" "$1")
  echo "Datos del fichero $fichero: "
  echo "Tamaño: $tamanio"
  echo "Tipo: $tipo"
  echo "Inodo: $inodo"
  echo "Montaje: $montaje"
}

buscar() {
 busqueda=$(find / -type f -name "$1" 2>/dev/null)
 if [ -z $busqueda ]; then
   echo "El fichero no se encuentra en el sistema"
 else
  echo "Fichero encontrado."
  echo "Contando vocales almacenadas..."
  voc=$(cat "$1" | tr -cd  "aeiouAEIOU"  | wc -c)
  echo "El fichero contiene $voc vocales"
 fi
}


contar(){
num=$(ls -l "$1" | grep "^-" | wc -l)
echo "El número de ficheros dentro del directorio $1 es de $num."
}

privilegios() {
 if sudo -n true 2>/dev/null; then
        echo "Usted tiene privilegios"
 else
        echo "Usted es negro"
 fi
}

permisosoctal() {
  permisos=$(stat -c '%c' $1)
  echo "Los permisos del fichero son: $permisos"
  echo ""
}

romano() {
  romano=""
  # Validar que el número esté en el rango
  if [[ "$1" =~ ^[0-9]+$ ]] && (( $1 >= 1 && $1 <= 200 )); then
      numero=$1
  else
      echo "Número fuera de rango o inválido. Debe ser un número entre 1 y 200."
  fi

  # Definir los valores romanos
    valores=(100 90 50 40 10 9 5 4 1)
    simbolos=(C XC L XL X IX V IV I)

    for i in "${!valores[@]}"; do
        while (( numero >= valores[i] )); do
            romano+="${simbolos[i]}"
            ((numero -= valores[i]))
        done
    done

    echo "$romano"
}

automatizar() {
 if [ "$(ls /mnt/usuarios)" 2>/dev/null ]; then
        for i in $(ls /mnt/usuarios); do
            useradd -m -s /bin/bash $i
            for d in $(cat /mnt/usuarios/$i); do
                mkdir -p /home/$i/$d
            done
            rm /mnt/usuarios/$i
        done
 else
        echo "Directorio vacío"
 fi
}
crear() {
  if [ -z $2 ]; then
        fallocate -l 1024K $1
  else
        fallocate -l "$2K" $1
  fi
}

crear_2() {
  if [ -z $2 ]; then
     tamano=1024
  else
     tamano=$2
  fi

  archivo="$1"

  if [ -e "$archivo" ]; then
        i=1
        creado=0
        while [ $i -le 9 ]; do
          nuevo="${archivo}${i}"
          if [ ! -e "$nuevo" ]; then
            archivo="$nuevo"
            creado=1
            break
          fi
          ((i++))
        done

        if [ "$creado" -eq 0 ]; then
                echo "No se pueden crear más archivos del mismo nombre."
                exit 1
        fi
        echo "El archivo ya existe. Se creará uno de nombre $archivo"
  fi

  fallocate -l "${tamano}K" "$archivo"
  echo "Archivo creado: "
  echo "Nombre: $archivo"
  echo "Tamaño: $(stat -c '%s' "$archivo")"

}

reescribir() {
  # Comprobamos si se ha pasado un parámetro
  if [ -z "$1" ]; then
      echo "Por favor, pase una palabra como parámetro."
      exit 1
  fi

  # Almacenamos la palabra en una variable
  palabra=$1

  # Reemplazamos las vocales por los números correspondientes
  palabra_modificada=$(echo "$palabra" | sed 's/a/1/g' | sed 's/e/2/g' | sed 's/i/3/g' | sed 's/o/4/g' | sed 's/u/5/g')

  # Mostramos la palabra modificada
  echo "$palabra_modificada"

}

contusu(){
  # Directorio donde se guardarán las copias de seguridad
  backup_dir="/home/copiaseguridad"

  # Verificar si el directorio de copias de seguridad existe, si no, crearlo
  if [ ! -d "$backup_dir" ]; then
    echo "El directorio de copias de seguridad no existe, creándolo..."
    mkdir -p "$backup_dir"
  fi

  # Obtener la lista de usuarios con directorios en /home
  usuarios=($(ls /home))

  # Comprobar si hay usuarios en /home
  if [ ${#usuarios[@]} -eq 0 ]; then
    echo "No hay usuarios con directorios en /home."
    exit 1
  fi

  # Mostrar la lista de usuarios
  echo "Usuarios con directorios en /home:"
  select usuario in "${usuarios[@]}"; do
    # Comprobar si se ha seleccionado un usuario válido
    if [ -n "$usuario" ]; then
      echo "Has seleccionado a $usuario."
      break
    else
      echo "Selección no válida. Por favor, elige un número de la lista."
    fi
  done

  # Obtener la fecha actual
  fecha=$(date +"%Y-%m-%d_%H-%M-%S")

  # Realizar la copia de seguridad del directorio home del usuario seleccionado
  echo "Realizando copia de seguridad de /home/$usuario en $backup_dir/$usuario"_"$fecha.tar.gz"
  tar -czf "$backup_dir/$usuario"_"$fecha.tar.gz" -C /home "$usuario"

  echo "Copia de seguridad completada: $backup_dir/$usuario"_"$fecha.tar.gz"
}

alumnos(){
  # Pedir el número de alumnos
  read -p "Introduce el número de alumnos de la clase: " num_alumnos

  # Inicializar contadores
  aprobados=0
  suspensos=0
  total_notas=0

  # Pedir la nota de cada alumno
  for (( i=1; i<=$num_alumnos; i++ ))
    do
      # Pedir la nota del alumno
      read -p "Introduce la nota del alumno $i (0-10): " nota
    # Actualizar la suma total de las notas
    total_notas=$(echo "$total_notas + $nota" | bc)

    # Contar los aprobados y suspensos
    if (( $(echo "$nota >= 5" | bc -l) )); then
      ((aprobados++))
    else
      ((suspensos++))
    fi
  done

  # Calcular la nota media
  nota_media=$(echo "$total_notas / $num_alumnos" | bc -l)

  # Mostrar los resultados
  echo "Número de aprobados: $aprobados"
  echo "Número de suspensos: $suspensos"
  echo "Nota media de la clase: $nota_media"
}

quita_blancos() {
  # Iterar sobre todos los ficheros en el directorio actual
  for archivo in *; do
    # Comprobar si es un fichero y si contiene espacios en su nombre
    if [[ -f "$archivo" && "$archivo" =~ \  ]]; then
      # Reemplazar los espacios por subrayados bajos
      nuevo_nombre=$(echo "$archivo" | tr ' ' '_')
      # Renombrar el archivo
      mv "$archivo" "$nuevo_nombre"
      echo "Renombrado: '$archivo' -> '$nuevo_nombre'"
    fi
  done
}

lineas(){
  # Validar que se pasen exactamente tres parámetros
  if [ $# -ne 3 ]; then
    echo "Error: Debes proporcionar exactamente tres parámetros."
    echo "Uso correcto: ./lineas.sh <carácter> <número entre 1 y 60> <número entre 1 y 10>"
    exit 1
  fi

  # Asignar los parámetros a variables
  caracter=$1
  longitud=$2
  lineas=$3

  # Validar que el primer parámetro sea un solo carácter
  if [ ${#caracter} -ne 1 ]; then
    echo "Error: El primer parámetro debe ser un solo carácter."
    exit 1
  fi

  # Validar que el segundo parámetro esté entre 1 y 60
  if [ "$longitud" -lt 1 ] || [ "$longitud" -gt 60 ]; then
    echo "Error: El segundo parámetro debe ser un número entre 1 y 60."
    exit 1
  fi

  # Validar que el tercer parámetro esté entre 1 y 10
  if [ "$lineas" -lt 1 ] || [ "$lineas" -gt 10 ]; then
    echo "Error: El tercer parámetro debe ser un número entre 1 y 10."
    exit 1
  fi

  # Dibujar las líneas
  for (( i=1; i<=$lineas; i++ )); do
    # Imprimir la línea con el carácter repetido según la longitud indicada
    printf "%0.s$caracter" $(seq 1 $longitud)
    echo
  done
}

analizar() {
  # Verificar que se haya proporcionado al menos el directorio y una extensión
  if [ $# -lt 2 ]; then
    echo "Debe proporcionar un directorio y una extension"
    exit 1
  fi

  # El primer parámetro es el directorio a analizar
  directorio=$1
  shift  # Eliminar el primer parámetro para que los siguientes sean las extensiones

  # Comprobar si el directorio existe
  if [ ! -d "$directorio" ]; then
    echo "Error: El directorio '$directorio' no existe."
    exit 1
  fi

  # Inicializar un array para almacenar los conteos de archivos por extensión
  declare -A conteos

  # Recorrer el árbol de directorios con find para cada extensión
  for ext in "$@"; do
    # Inicializar el contador de cada extensión
    conteos[$ext]=0
    # Buscar archivos con la extensión especificada en el directorio y subdirectorios
    archivos=$(find "$directorio" -type f -iname "*.$ext")
    # Contar los archivos encontrados
    for archivo in $archivos; do
      ((conteos[$ext]++))
    done
  done

  # Imprimir el informe
  echo "Informe de archivos en el directorio '$directorio':"
  echo "------------------------------------------"
  for ext in "$@"; do
    echo "Archivos con extensión .$ext: ${conteos[$ext]}"
  done
}

nombre21() {
  #Definición de variables
  LOG_ERROR="bajaserror.log"
  LOG_BAJAS="bajas.log"
  PROYECTO_DIR="/home/proyecto"

# Función para validar el archivo de entrada
validar_parametro() {
      # Comprobar que se pasa un parámetro
      if [ $# -ne 1 ]; then
          echo "ERROR: Se debe proporcionar un archivo como parámetro"
          exit 1
      fi
      # Comprobar que el archivo existe
      if [ ! -f "$1" ]; then
          echo "ERROR: El archivo $1 no existe"
          exit 1
      fi
}

# Función para registrar error
registrar_error() {
    local login=$1
    local nombre=$2
    local apellidos=$3
    local fecha=$(date '+%d/%m/%Y-%H:%M:%S')
    echo "$fecha-$login-$nombre-$apellidos-ERROR:login no existe en el sistema" >> "$LOG_ERROR"
}

# Función para mover archivos del usuario
mover_archivos() {
    local login=$1
    local user_dir="/home/$login"
    local backup_dir="$PROYECTO_DIR/$login"
    local total_archivos=0
    # Crear directorio de backup
    mkdir -p "$backup_dir"
    # Mover archivos del directorio trabajo
    if [ -d "$user_dir/trabajo" ]; then
        # Contar y mover archivos
        total_archivos=$(find "$user_dir/trabajo" -type f | wc -l)
        mv "$user_dir/trabajo"/* "$backup_dir/" 2>/dev/null
        # Registrar en el log
        echo "$(date '+%d/%m/%Y-%H:%M:%S')-$login-$backup_dir" >> "$LOG_BAJAS"
        # Listar archivos movidos
        find "$backup_dir" -type f | awk '{print NR":"$0}' >> "$LOG_BAJAS"
        echo "Total de ficheros movidos: $total_archivos" >> "$LOG_BAJAS"
    fi
    return $total_archivos
}

# Función para procesar un usuario
procesar_usuario() {
    local linea=$1
    local nombre=$(echo "$linea" | cut -d: -f1)
    local apellido1=$(echo "$linea" | cut -d: -f2)
    local apellido2=$(echo "$linea" | cut -d: -f3)
    local login=$(echo "$linea" | cut -d: -f4)
    # Verificar si el usuario existe
    if id "$login" >/dev/null 2>&1; then
        # Mover archivos
        mover_archivos "$login"
        # Eliminar usuario y su directorio home
        userdel -r "$login" 2>/dev/null
        echo "Usuario $login eliminado correctamente"
    else
        registrar_error "$login" "$nombre" "$apellido1 $apellido2"
        echo "Error: Usuario $login no existe"
    fi
}

  # Verificar los parámetros
  validar_parametro "$@"
  archivo_bajas=$1

  # Verificar que el archivo no está vacío
  if [ ! -s "$archivo_bajas" ]; then
      echo "ERROR: El archivo está vacío"
      exit 1
  fi

  # Procesar cada línea del archivo
  while IFS= read -r linea || [ -n "$linea" ]; do
      # Verificar formato de la línea
      if [[ "$linea" =~ ^[^:]+:[^:]+:[^:]+:[^:]+$ ]]; then
          procesar_usuario "$linea"
      else
          echo "ERROR: Línea con formato incorrecto: $linea"
      fi
  done < "$archivo_bajas"

  # Establecer root como propietario de los archivos movidos
  chown -R root:root "$PROYECTO_DIR"/*
  echo "Proceso de bajas completado"
}

nombre22(){

  # Definición de variables
  REPOSITORIOS=("Fotografia" "Dibujo" "Imagenes")
  EXTENSIONES=("jpg" "gif" "png")
  LOG_FILE="descartados.log"

# Función para verificar si una extensión es válida
es_extension_valida() {
    local extension=$1
    for ext in "${EXTENSIONES[@]}"; do
        if [ "$extension" = "$ext" ]; then
            return 0
        fi
    done
    return 1
}

# Función para obtener el formato real del archivo usando file
obtener_formato_real() {
    local archivo=$1
    # Ejecutamos file -i y extraemos solo el tipo de mime
    local tipo=$(file -i "$archivo" | grep -o "image/[a-z]*")
    case $tipo in
        "image/jpeg") echo "jpg";;
        "image/gif") echo "gif";;
        "image/png") echo "png";;
        *) echo "invalid";;
    esac
}

# Función para procesar un archivo
procesar_archivo() {
    local archivo=$1
    local extension="${archivo##*.}"
    local nombre_base="${archivo%.*}"
    local formato_real=$(obtener_formato_real "$archivo")
    # Si el formato no es válido, eliminar y registrar
    if [ "$formato_real" = "invalid" ]; then
        echo "$(whoami):$(groups):$(date +%d.%m.%Y):$archivo" >> "$LOG_FILE"
        rm "$archivo"
        echo "Archivo $archivo eliminado por formato inválido"
        return
    fi
    # Si la extensión no coincide con el formato real, renombrar
    if [ "$extension" != "$formato_real" ]; then
        mv "$archivo" "$nombre_base.$formato_real"
        echo "Archivo $archivo renombrado a $nombre_base.$formato_real"
    fi
}

  # Verificar si se proporcionó un parámetro
  if [ $# -ne 1 ]; then
      echo "Uso: $0 <nombre_alumno>"
      exit 1
  fi

  ALUMNO=$1
  TOTAL_ARCHIVOS=0

  # Procesar cada repositorio
  for repo in "${REPOSITORIOS[@]}"; do
      if [ -d "$repo" ]; then
          echo "Procesando repositorio $repo"
          # Buscar archivos del alumno en el repositorio
          find "$repo" -type f -user "$ALUMNO" | while read archivo; do
              procesar_archivo "$archivo"
              ((TOTAL_ARCHIVOS++))
          done
      fi
  done
  echo "Total de archivos procesados para $ALUMNO: $TOTAL_ARCHIVOS"
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
    echo "Opicón 11: romano"
    echo "Opción 12: automatizar"
    echo "Opción 13: crear"
    echo "Opción 14: crear_2"
    echo "Opción 15: reescribir"
    echo "Opción 16: contusu"
    echo "Opción 17: alumnos"
    echo "Opción 18: quita_blancos"
    echo "Opción 19: lineas"
    echo "Opción 20: analizar"
    echo "Opción 21: nombre21"
    echo "Opción 22: nombre22"
    echo "Opción 0: salir "
    read -p "Elegir opción deseada: " op
    echo ""
    case $op in
      0)
      ;;
      1)
        echo "factorial"
        read -p "De un número positivo: " num
        factorial $num
      ;;
      2)
        echo "bisiesto"
        read -p "Debe de dar el año actual. Ej: 2005 " year
        bisiesto $year
      ;;
      3)
       echo "configurarred"
       read -p "Escriba la IP que desea asignar: " ip
       read -p "Escriba la máscara que desee asignar(En formato CIDR. EJ 24): " mascara
       read -p "Escriba la puerta de enlace: " gw
       read -p "Escriba su DNS: " dns
       configurarred $ip $mascara $gw $dns
      ;;
      4)
       echo "adivina"
       adivina
      ;;
      5)
       echo "edad"
       read -p "Deme su edad: " edad
       edad $edad
      ;;
      6)
       echo "fichero"
       read -p "Deme el fichero que desea busca: " fichero
       fichero $fichero
      ;;
      7)
       echo "buscar"
       read -p "Deme el archivo que desea buscar: " archivo
       buscar $archivo
      ;;
      8)
       echo "contar"
       read -p "Establezca el direcotrio del desea contar su numero de directorios: " directorio
       contar $directorio
      ;;
      9)
       echo "privilegios"
       privilegios
      ;;
     10)
       echo "permisosoctal"
       read -p "Deme la ruta de el objeto: " objeto
       permisosoctal $objeto
      ;;
     11)
       echo "romanos"
       read -p "Deme un numero del 1 al 200: " num
       romano $num
     ;;
    12)
      echo "automatizar"
      automatizar
     ;;
    13)
      echo "crear"
      read -p "Deme el nombre del fichero: " nombre
      read -p "Deme el tamaño deseado: " tamano
      crear $nombre $tamano
     ;;
    14)
      echo "crear_2"
      read -p "Deme el nombre del fichero: " nombre
      read -p "Deme el tamaño deseado: " tamano
      crear_2 $nombre $tamano
     ;;
    15)
      echo "reescribir"
      read -p "Dame una palabra: " palabra
      reescribir "$palabra"
     ;;
    16)
      echo "contusu"
      contusu
     ;;
    17)
      echo "alumnos"
      alumnos
     ;;
    18)
      echo "quita_blancos"
      quita_blancos
     ;;
    19)
      echo "lineas"
      read -p "Pase un caracter: " caract
      read -p "Pase un numero entre 1 y 60: " num
      read -p "Pase un numero entre 1 y 10: " num2
      lineas $caract $num $num2
     ;;
    20)
      echo "analizar"
      read -p "Pase el directorio a analizar: " direct
      read -p "Pase la extension(Ej txt): " ext
      analizar $direct $ext
     ;;
    21)
      echo "nombre21"
      read -p "Deme el nombre de login: " $log
      read -p "Deme su nombre: " $nom
      read -p "Deme su apellido: " $ap
      nombre21 $log $nom $ap
     ;;
    22)
      echo "nombre22"
      read -p "Introduzca el nombre del fichero: " $fichero
      nombre22 $fichero
     ;;
    esac
  done
}
menu
