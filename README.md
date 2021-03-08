# PokeDexAppSwift
iOS PokeDex App is a MVVM + Coordinators pattern app, written using Swift 5.3 and with iOS 11 as development target.

This app displays a list of all pokemons with image, name and id.
The app also shows details of a pokemon when the user tap on it.

PokeDexApp uses the public [PokéAPI](https://pokeapi.co/) v2 to get data.
UI is designed without XIBs or Storyboards.
The app support iPhones and iPads with all screen orientations.

## The app
The app loads and shows the first 20 pokemons loaded from APIs or locally, if data are cached. By scrolling down, the app will load other 20 new pokemons with a visible loader.
If the app is not able to load other pokemons, a popup will be shown.

A searchbar is present to help user to find pokemon by name or id: when user types something in this bar, the app searchs for results first locally.
If no results are found locally, the app searchs from the APIs. 
If no results return also from the APIs a warning popup will be shown.

When user taps on a pokemon the app shows a scrollable list of his images, name and id, types, weight and height, stats and abilities.

## Offiline usage
When the app requests some datas from APIs, after his response, it saves datas in cache memory (using URLCache), so the app is able to work even offline with this cached data.
Also data for images are cached locally after first time retrieving.

## Additional features
- Added a search bar to help user to easily find pokemons.
- Added pokemon id in the list, under the name and image, to help user to identify pokemons.
- The image carousel in the details page is useful for the user to see all images available for the selected pokemon.
- The progress bars (for the height, weight and all stats) are useful to get the idea of weaknesses and strenghts.
- Images and colors of types create a good graphical effect with a background gradient in the details page and with shadow in the type's chip.
- Popups and loaders improve the user's experience. 

## External Libs
No external library were used because of skills improvement.

I used only native classes and libraries, such as UIKit, URLCache to store datas, URLComponents, URLRequest, URLSession and URLResponse for API web calls.

## Unit tests
I wrote some unit test to cover all possible lines of code of ViewModels, Coordinators (and Models where necessary).
The UI (Views, ViewControllers) were excluded.

## Sources
All pokemons types used in app are taken from: [here](https://pokeapi.co/api/v2/type)
Official pokemons colors from types are taken from: [here]( https://wiki.pokemoncentral.it/Tipo)
Weight and height max values are taken from: [here](https://pokemondb.net/pokedex/stats/height-weight)
All stats max values are taken from: [here](https://www.serebii.net/pokedex-swsh/stat/sp-attack.shtml)
Images are picked up in Google Images.

## App screenshots

<p>
<img src="./screenshots/list_portrait.png?raw=true" width="150">
<img src="./screenshots/details_portait.png?raw=true" width="150">
</p>
<p>
<img src="./screenshots/list_found.png?raw=true" width="150">
<img src="./screenshots/details_found.png?raw=true" width="150">
</p>
<p>
<img src="./screenshots/list_landscape.png?raw=true" width="200">
<img src="./screenshots/details_landscape.png?raw=true" width="200">
</p>



