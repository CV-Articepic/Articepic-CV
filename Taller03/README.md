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
* La función E, es una edge function para determinar la orientación de un vector P, es decir, es el signed area del triangulo formado por v0, v1 y P.
* La función inside revisa que todas las edge function para un vértice P  tienen el mismo signo ( <= 0 o >= 0).
* La función barycentric, retorna los pesos baricentricos para un punto p, calcula los pesos haciendo uso de la función E.
* La función barycentricColor retorna que color que debe tener el pixel asociado a vector P, utilizando los pesos de barycentric para interpolar el color.
Aparte de esto se modificó triangleRaster() para hacer un fill de los pixeles al interior del triángulo, usando las funciones definidas en util.

Para la parte de anti-aliasing se usó la bibliografía aportada por el profesor, donde se describia que para el proceso se debía dividir el pixel que esta afuera del triángulo en subpixeles, determinar el color baricéntrico de  los subpixeles que si se encontraban dentro del triángulo, sacar un promedio del color baricéntrico obtenido y llenar el pixel con ese color, eso fue lo que se hizo en el código, pero se uso una funcion recursiva para dividir esos subpixeles a su vez en otros subpixeles y aumentar el nivel de anti-aliasing.



## Entrega

* Plazo: ~~20/10/19~~ 27/10/19 a las 24h.
