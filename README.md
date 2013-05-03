Nomeolvides
===========

### ¿Qué es Nomeolvides? ###

Es una aplicación que pretende organizar y trabajar con colecciones de hechos históricos. La idea es ofrecer la posibilidad de, en un futuro, acceder desde múltiples dispositivos y sistemas a los hechos históricos, por fecha, o por algún otro dato relevante. Busca ser una herramienta que facilite el acceso a datos concretos para el profesional, el estudiante o el amante de la historia y la política.

### ¿Ya se puede usar o son sólo palabras bonitas? ###

En este momento el programa permite las operaciones básicas con hechos (guardar, cargar, agregar, modificar, eliminar, ver). Organizar los hechos en listas personalizadas por los criterio del usuario. Además manejar distintas bases de datos, las cuales pueden activarse y desactivarse según se necesite. Los cambios que se realicen se guardan atumáticamente, además puede deshcerse cambios que se hayan hecho por error. El mismo está desarrollado en vala y Gtk+.

### ¿Qué tienen pensado para el futuro? ###

La idea es que se permita agregar diferentes fuentes de datos, locales o en la nube, para que se pueda ir formando un conjunto de datos aportados por la comunidad. La idea es formar una red de servidores descentralizada y confederada, en la que los usuarios puedan compartir sus hechos sin importar en qué servidor estén registrados. También se pretende que se desarrollen aplicaciones para los distintos dispositivos que hoy componen el firmamento tecnológico. Que haya aplicaciones nativas para smartphones, Android, Ubuntu Mobile, Firefox OS. También una aplicación web. La idea es abrir el mayor abanico de posibilidades.

Instalación
============

# Para usuarios #

## Las dependencias ##

* libgee (>= 0.8)
* gtk3  (>= 3.4.1)
* glib (>=2.0)


## En Ubuntu/Debian/Mint (que usen apt-get) ##
 
* Instalar el ppa de Vala

```# add-apt-repository ppa:vala-team/ppa```

* instalar el ppa de la aplicación

```# add-apt-repository ppa:softwareperonista/nomeolvides```

* instalar la aplicación. 

```# apt-get install nomeolvides```


## Instalar en Arch Linux y derivadas (que usen pacman)##

```$ yaourt -S nomeolvides```

# Para desarrolladores #

# Las dependencias #
* debhelper (>= 8.0.0)
* autotools 
* valac (>= 0.20) 
* pkg-config 
* libgee (>= 0.8)
* libgtk-3  (>= 3.4.1)
* libglib (>=2.0)
* git

## En dependencias Ubuntu/Debian/Mint (que usen apt-get) ##

* Instalar el ppa de Vala

```# add-apt-repository ppa:vala-team/ppa```

* Instalas las dependencias 

```# apt-get install git debhelper autotools-dev valac-0.20 pkg-config libgee-0.8-dev libgtk-3-dev libglib2.0-dev```

## Instalar dependencias en Arch Linux y derivadas (que usen pacman) ##

```# pacman -S git vala autogen libltdl libgee gtk3 xdg-utils```

## Compilar ##

```$ git clone https://github.com/softwareperonista/nomeolvides.git```

```$ ./autogen.sh ```

```$ make ```

```$ src/nomeolvides ```
