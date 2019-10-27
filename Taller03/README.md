# Taller raster

## Propósito

Comprender algunos aspectos fundamentales del paradigma de rasterizaci�n.

## Tareas

Emplee coordenadas baricéntricas para:

1. Rasterizar un triángulo.
2. Sombrear su superficie a partir de los colores de sus vértices.
3. Implementar un [algoritmo de anti-aliasing](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-practical-implementation) para sus aristas.

Referencias:

* [The barycentric conspiracy](https://fgiesen.wordpress.com/2013/02/06/the-barycentric-conspirac/)
* [Rasterization stage](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-stage)

Implemente la función ```triangleRaster()``` del sketch adjunto para tal efecto, requiere la librería [nub](https://github.com/visualcomputing/nub/releases) (versión >= 0.2).

## Integrantes

Complete la tabla:

| Integrante | github nick |
|------------|-------------|
| Miguel Ortiz  | miaortizma|
| Nicolas Casas | nmcasasr  |

## Discusión

Describa los resultados obtenidos. En el caso de anti-aliasing describir las técnicas exploradas, citando las referencias.

Para este proyecto se creo un archivo llamado util con todas las funciones necesarias para el funcionamiento del mismo:
* La funcion E, es una edge function para determianar la ortientacion de un vector P, respecto a la linea trazada por un vector V1 y un vector V2.
* La funcion inside se encarga de decir si el vector P esta dentro del triangulo o no, tomando
encuenta los valores de la funcion E(egde function).
* La funcion barycentric, retorna el peso del color que se tiene en un punto dado, es decir, define la transicion entre los colores asociados
a los vertices del triangulo.
* La funcion barycentricColor retorna que color que debe tener el pixel asociado a vector P, usando los pesos retornados por la funcion barycentric y los colores asociados a los vertices del triangulo.



## Entrega

* Plazo: ~~20/10/19~~ 27/10/19 a las 24h.
