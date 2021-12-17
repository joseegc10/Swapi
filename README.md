# Swapi

App destinada a la consumición de datos desde la API denominada Swapi. 

Contiene dos apartados:

- Películas: donde podemos observar las películas disponibles en la API (películas de Star Wars). Podemos entrar dentro de cada película para ver su información y los personajes pertenecientes a dicha película.
- Personajes: donde podemos encontrar los personajes del mundo de Star Wars. Se presentarán en tandas de 10 por motivos de rendimiento de Swapi, pudiéndo pedir otras 10 películas en todo momento.

En cuanto a los personajes, se permite la edición de su información. Si editamos la información de un personaje, esta se va a guardar en una base de datos local (Core Data) y se mostrará está información en lugar de la proporcionada por la API.
