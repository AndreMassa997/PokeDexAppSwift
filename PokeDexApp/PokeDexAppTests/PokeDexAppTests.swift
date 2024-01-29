//
//  PokeDexAppTests.swift
//  PokeDexAppTests
//
//  Created by Andrea Massari on 07/03/21.
//

import XCTest
@testable import PokeDexApp

class PokeDexAppTests: XCTestCase {

    //MARK: MAIN VIEW MODEL TESTS
    func test_getPokemons_shouldReturnData(){
        //Given
        let sut = MainViewModel(with: TestableMainCoordinator(navigationController: UINavigationController()))
        let expetaction = XCTestExpectation(description: "Expected to get pokemons")
       
        
        //When
        sut.getPokemons(){ error in
            guard error != nil else{
                expetaction.fulfill()
                return
            }
            XCTFail()
        }
        
        wait(for: [expetaction], timeout: 5.0)
        
        //Then
        XCTAssertEqual(sut.nextOffset, 20)
        XCTAssertEqual(sut.pokemonCells, [PokemonCellViewModel(pokemonModel: PokeDexAppTests.pokemonModel)])
    }
    
    
    func test_didSelectPokemon_shouldLaunchPokemonDetails(){
        //Given
        let mainCoordinator = TestableMainCoordinator(navigationController: UINavigationController())
        let sut = MainViewModel(with: mainCoordinator)
        let expetaction = XCTestExpectation(description: "Expected to get pokemons")
        
        //When
        sut.getPokemons(){ error in
            guard error != nil else{
                expetaction.fulfill()
                return
            }
            XCTFail()
        }
        
        wait(for: [expetaction], timeout: 5.0)

        sut.didSelectPokemon(pokemon: PokemonCellViewModel(pokemonModel: PokeDexAppTests.pokemonModel))
        
        //Then
        XCTAssertGreaterThan(mainCoordinator.childCoordinators.count, 0)
    }
    
    func test_didSelectPokemon_shouldLaunchPokemonDetailsFromFoundedList(){
        //Given
        let mainCoordinator = TestableMainCoordinator(navigationController: UINavigationController())
        let sut = MainViewModel(with: mainCoordinator)
        let expetaction = XCTestExpectation(description: "Expected to get pokemons")

        //When
        sut.searchPokemon(text: "charizard"){ error in
            guard error != nil else{
                expetaction.fulfill()
                return
            }
            XCTFail()
        }
        
        wait(for: [expetaction], timeout: 5.0)
        
        sut.didSelectPokemon(pokemon: PokemonCellViewModel(pokemonModel: PokeDexAppTests.pokemonModel))

        //Then
        XCTAssertGreaterThan(mainCoordinator.childCoordinators.count, 0)
    }
    
    func test_searchPokemon_shouldReturnPokemonsLocallyFromName(){
        let mainCoordinator = TestableMainCoordinator(navigationController: UINavigationController())
        let sut = MainViewModel(with: mainCoordinator)
        let expetaction = XCTestExpectation(description: "Expected to get pokemons")
        
        //When
        sut.getPokemons(){ error in
            guard error != nil else{
                return
            }
            XCTFail()
        }
        
        sut.searchPokemon(text: "charizard"){ error in
            guard error != nil else{
                expetaction.fulfill()
                return
            }
            XCTFail()
        }
        
        wait(for: [expetaction], timeout: 5.0)
        
        //Then
        XCTAssert(sut.pokemonCells.contains(PokemonCellViewModel(pokemonModel: PokeDexAppTests.pokemonModel)))
    }
    
    func test_searchPokemon_shouldReturnPokemonsLocallyFromId(){
        let mainCoordinator = TestableMainCoordinator(navigationController: UINavigationController())
        let sut = MainViewModel(with: mainCoordinator)
        let expetaction = XCTestExpectation(description: "Expected to get pokemons")
        
        //When
        sut.getPokemons(){ error in
            guard error != nil else{
                return
            }
            XCTFail()
        }
        
        sut.searchPokemon(text: "6"){ error in
            guard error != nil else{
                expetaction.fulfill()
                return
            }
            XCTFail()
        }
        
        wait(for: [expetaction], timeout: 5.0)
        
        //Then
        XCTAssert(sut.pokemonCells.contains(PokemonCellViewModel(pokemonModel: PokeDexAppTests.pokemonModel)))
    }
    
    func test_searchPokemon_shouldReturnPokemonFromServerByText(){
        let mainCoordinator = TestableMainCoordinator(navigationController: UINavigationController())
        let sut = MainViewModel(with: mainCoordinator)
        let expetaction = XCTestExpectation(description: "Expected to find pokemon by his name from server")
        
        //When
        sut.searchPokemon(text: "charizard"){ error in
            guard error != nil else{
                expetaction.fulfill()
                return
            }
            XCTFail()
        }
        
        wait(for: [expetaction], timeout: 5.0)
        
        //Then
        XCTAssert(sut.pokemonCells.contains(PokemonCellViewModel(pokemonModel: PokeDexAppTests.pokemonModel)))
    }
    
    func test_searchPokemon_shouldReturnPokemonFromServerById(){
        let mainCoordinator = TestableMainCoordinator(navigationController: UINavigationController())
        let sut = MainViewModel(with: mainCoordinator)
        let expetaction = XCTestExpectation(description: "Expected to find pokemon by id from server")
        
        //When
        sut.searchPokemon(text: "6"){ error in
            guard error != nil else{
                expetaction.fulfill()
                return
            }
            XCTFail()
        }
        
        wait(for: [expetaction], timeout: 5.0)
        
        //Then
        XCTAssert(sut.pokemonCells.contains(PokemonCellViewModel(pokemonModel: PokeDexAppTests.pokemonModel)))
    }
    
    func test_searchPokemon_shouldNotReturnPokemonFromServer(){
        let mainCoordinator = TestableMainCoordinator(navigationController: UINavigationController())
        let sut = MainViewModel(with: mainCoordinator)
        let expetaction = XCTestExpectation(description: "Expected to find no pokemon from server")
        let text = "test"
        
        //When
        sut.searchPokemon(text: text){ error in
            guard error != nil else{
                expetaction.fulfill()
                return
            }
            expetaction.fulfill()
        }
        
        wait(for: [expetaction], timeout: 5.0)
        
        //Then
        XCTAssertFalse(sut.pokemonCells.contains(where: { cell in
            return cell.name.contains(text) || cell.id == Int(text)
        }))
    }
    
    func test_didFinishSearching_shouldRemoveAllCells(){
        //Given
        let mainCoordinator = TestableMainCoordinator(navigationController: UINavigationController())
        let sut = MainViewModel(with: mainCoordinator)
        let expetaction = XCTestExpectation(description: "Get pokemons")
        
        //When
        sut.getPokemons(onResult: { error in
            guard error != nil else{
                expetaction.fulfill()
                return
            }
            XCTFail()
        })
        
        wait(for: [expetaction], timeout: 5.0)
        
        sut.didFinishSearching()
        
        //Then
        XCTAssertEqual(sut.pokemonCells, [PokemonCellViewModel(pokemonModel: PokeDexAppTests.pokemonModel)])
    }
    

    
    //MARK: POKEMONCELL VIEW MODEL TESTS
    func test_pokemonCellViewModelFromPokemonModel_shouldAssignDataAndGetId(){
        //Given
        let pokemonModel = PokeDexAppTests.pokemonModel
        let sut = PokemonCellViewModel(pokemonModel: pokemonModel)
        
        //When
        let stringId = sut.getPokemonId()
        
        //Then
        XCTAssertEqual(sut.id, pokemonModel.id)
        XCTAssertEqual(sut.type, pokemonModel.types?.first?.type.name)
        XCTAssertEqual(sut.imageURL, pokemonModel.sprites?.other?.officialArtwork?.frontDefault ?? pokemonModel.sprites?.frontDefault)
        XCTAssertEqual(sut.name, pokemonModel.name)
        XCTAssertEqual(stringId, "006")
    }
    
    
    //MARK: DETAILS VIEW MODEL TESTS
    func test_detailViewModelSetupDataSource_shouldAppendDataOnSections(){
        //Given
        let pokemonModel = PokeDexAppTests.pokemonModel
        let sut = DetailsViewModel(with: DetailsCoordinator(navigationController: UINavigationController(), pokemonModel: pokemonModel), pokemonModel: pokemonModel)
        
        //Then
        XCTAssertGreaterThan(sut.sectionViewModels.count, 0)
        XCTAssertEqual(sut.sectionViewModels[0].getSectionName(), "Types")
    }
    
    func test_detailViewModelSimulateBackTappedAndDismiss(){
        //Given
        let pokemonModel = PokeDexAppTests.pokemonModel
        let detailCoordinator = DetailsCoordinator(navigationController:  UINavigationController(), pokemonModel: pokemonModel)
        let sut = DetailsViewModel(with: detailCoordinator, pokemonModel: pokemonModel)


        //When
        sut.onBackTapped()
        sut.viewDidDisappear()

        //Then
        XCTAssert(true)
    }
    
    
    //MARK: DETAILS HEADER VIEW MODEL TESTS
    func test_detailsheaderViewModel_getPokemonIdShouldAssignDataAndReturnStringId(){
        //Given
        let pokemonModel = PokeDexAppTests.pokemonModel
        let sut = DetailsHeaderViewModel(pokemonModel: pokemonModel)
        
        //When
        let urls = [
        pokemonModel.sprites?.other?.officialArtwork?.frontDefault,
            pokemonModel.sprites?.backDefault,
            pokemonModel.sprites?.backFemale,
            pokemonModel.sprites?.backShiny,
            pokemonModel.sprites?.backShinyFemale,
            pokemonModel.sprites?.frontDefault,
            pokemonModel.sprites?.frontFemale,
            pokemonModel.sprites?.frontShiny,
            pokemonModel.sprites?.frontShinyFemale,
        ].compactMap { $0 }
        
        let idString = sut.getPokemonId()

        //Then
        XCTAssertEqual(sut.id, pokemonModel.id)
        XCTAssertEqual(sut.name, pokemonModel.name)
        XCTAssertEqual(sut.carouselViewModel.urls, urls)
        XCTAssertEqual(sut.carouselViewModel.mainColor, pokemonModel.types?.first?.type.name.mainColor ?? .clear)
        XCTAssertEqual(idString, "006")
    }
    
    //MARK: DIMENSIONS CELL VIEW MODEL TESTS
    func test_dimensionsCellViewModel_shouldAssignData(){
        //Given
        let pokemonModel = PokeDexAppTests.pokemonModel
        let sut = DimensionsCellViewModel(height: pokemonModel.height ?? 0, weight: pokemonModel.weight ?? 0, mainColor: .black)
        
        //Then
        XCTAssertEqual(sut.weight, Float(pokemonModel.weight ?? 0)/10)
        XCTAssertEqual(sut.height, Float(pokemonModel.height ?? 0)/10)
        XCTAssertEqual(sut.mainColor, .black)
        XCTAssertEqual(sut.heightProgressValue, sut.height/20)
        XCTAssertEqual(sut.weightProgressValue, sut.weight/1000)
    }
    
    //MARK: STATS CELL VIEW MODEL TESTS
    func test_statCellViewModel_shouldAssignData(){
        //Given
        let pokemonModel = PokeDexAppTests.pokemonModel
        
        pokemonModel.stats?.forEach{ stat in
            let sut = StatCellViewModel(stats: stat, mainColor: .black)

            //Then
            XCTAssertEqual(sut.statName, stat.stat.name.name)
            XCTAssertEqual(sut.statValue, stat.baseStat)
            XCTAssertEqual(sut.progressValue, Float(sut.statValue)/stat.stat.name.maxValue)
            XCTAssertEqual(sut.mainColor, .black)
        }
    }
    
    //MARK: ABILITY CELL VIEW MODEL TESTS
    func test_abilityCellViewModel_shouldAssignData(){
        //Given
        let pokemonModel = PokeDexAppTests.pokemonModel
        
        pokemonModel.abilities?.forEach{ ability in
            let sut = AbilityCellViewModel(ability: ability, mainColor: .black)
            
            //Then
            XCTAssertEqual(sut.abilityName, ability.ability.name)
            XCTAssertEqual(sut.mainColor, .black)
        }
    }
    
    //MARK: POKEMON MODEL TESTS
    func test_pokemonModel_shouldGetCorrectColorsAndImage(){
        //Given
        let normalType: PokemonType = .normal
        let fightingType: PokemonType = .fighting
        let flyingType: PokemonType = .flying
        let posionType: PokemonType = .poison
        let groundType: PokemonType = .ground
        let rockType: PokemonType = .rock
        let bugType: PokemonType = .bug
        let ghostType: PokemonType = .ghost
        let steelType: PokemonType = .steel
        let fireType: PokemonType = .fire
        let waterType: PokemonType = .water
        let grassType: PokemonType = .grass
        let electricType: PokemonType = .electric
        let psychicType: PokemonType = .psychic
        let iceType: PokemonType = .ice
        let dragonType: PokemonType = .dragon
        let darkType: PokemonType = .dark
        let fairyType: PokemonType = .fairy
        let unknownType: PokemonType = .unknown
        let shadowType: PokemonType = .shadow

        //Then
        XCTAssertEqual(normalType.mainColor, #colorLiteral(red: 0.5716369748, green: 0.6002758145, blue: 0.6475561261, alpha: 1))
        XCTAssertEqual(normalType.endColor, #colorLiteral(red: 0.5716369748, green: 0.6002758145, blue: 0.6475561261, alpha: 1))
        XCTAssertEqual(normalType.image, UIImage(named: "normal"))
        
        XCTAssertEqual(fightingType.mainColor, #colorLiteral(red: 0.880083859, green: 0.1892808676, blue: 0.3863664269, alpha: 1))
        XCTAssertEqual(fightingType.endColor, #colorLiteral(red: 0.9739872813, green: 0.1754835248, blue: 0.2562509775, alpha: 1))
        XCTAssertEqual(fightingType.image, UIImage(named: "fighting"))
        
        XCTAssertEqual(flyingType.mainColor, #colorLiteral(red: 0.5495741367, green: 0.6584999561, blue: 0.8765556812, alpha: 1))
        XCTAssertEqual(flyingType.endColor, #colorLiteral(red: 0.6187397838, green: 0.7536559701, blue: 0.9586126208, alpha: 1))
        XCTAssertEqual(flyingType.image, UIImage(named: "flying"))
        
        XCTAssertEqual(posionType.mainColor, #colorLiteral(red: 0.7127818465, green: 0.3641316593, blue: 0.8076178432, alpha: 1))
        XCTAssertEqual(posionType.endColor, #colorLiteral(red: 0.8102468848, green: 0.3396695852, blue: 0.8522182107, alpha: 1))
        XCTAssertEqual(posionType.image, UIImage(named: "poison"))
        
        XCTAssertEqual(groundType.mainColor, #colorLiteral(red: 0.9211483002, green: 0.4423263669, blue: 0.2223921418, alpha: 1))
        XCTAssertEqual(groundType.endColor, #colorLiteral(red: 0.8652047515, green: 0.5614356995, blue: 0.342061609, alpha: 1))
        XCTAssertEqual(groundType.image, UIImage(named: "ground"))
        
        XCTAssertEqual(rockType.mainColor, #colorLiteral(red: 0.7886140943, green: 0.709207356, blue: 0.5137671232, alpha: 1))
        XCTAssertEqual(rockType.endColor, #colorLiteral(red: 0.8462945819, green: 0.7972704768, blue: 0.5281767249, alpha: 1))
        XCTAssertEqual(rockType.image, UIImage(named: "rock"))
        
        XCTAssertEqual(bugType.mainColor, #colorLiteral(red: 0.5278400779, green: 0.7478100657, blue: 0, alpha: 1))
        XCTAssertEqual(bugType.endColor, #colorLiteral(red: 0.6490378976, green: 0.7893058062, blue: 0, alpha: 1))
        XCTAssertEqual(bugType.image, UIImage(named: "bug"))
        
        XCTAssertEqual(ghostType.mainColor, #colorLiteral(red: 0.3072502315, green: 0.413003087, blue: 0.7028397918, alpha: 1))
        XCTAssertEqual(ghostType.endColor, #colorLiteral(red: 0.4711506367, green: 0.4411643147, blue: 0.8536420465, alpha: 1))
        XCTAssertEqual(ghostType.image, UIImage(named: "ghost"))
        
        XCTAssertEqual(steelType.mainColor, #colorLiteral(red: 0.2502724528, green: 0.5344678164, blue: 0.6258850098, alpha: 1))
        XCTAssertEqual(steelType.endColor, #colorLiteral(red: 0.2158685029, green: 0.6516324282, blue: 0.6685814261, alpha: 1))
        XCTAssertEqual(steelType.image, UIImage(named: "steel"))
        
        XCTAssertEqual(fireType.mainColor, #colorLiteral(red: 1, green: 0.5929041505, blue: 0.2348099649, alpha: 1))
        XCTAssertEqual(fireType.endColor, #colorLiteral(red: 1, green: 0.665902853, blue: 0.1286484301, alpha: 1))
        XCTAssertEqual(fireType.image, UIImage(named: "fire"))
        
        XCTAssertEqual(waterType.mainColor, #colorLiteral(red: 0.2218952477, green: 0.6230598092, blue: 0.8972640038, alpha: 1))
        XCTAssertEqual(waterType.endColor, #colorLiteral(red: 0.2920359969, green: 0.732037127, blue: 0.9077424407, alpha: 1))
        XCTAssertEqual(waterType.image, UIImage(named: "water"))
        
        XCTAssertEqual(grassType.mainColor, #colorLiteral(red: 0.1684704125, green: 0.7559096813, blue: 0.2590118647, alpha: 1))
        XCTAssertEqual(grassType.endColor, #colorLiteral(red: 0.07089930028, green: 0.7674418092, blue: 0.4301987886, alpha: 1))
        XCTAssertEqual(grassType.image, UIImage(named: "grass"))
        
        XCTAssertEqual(electricType.mainColor, #colorLiteral(red: 0.9490627646, green: 0.8404652476, blue: 0, alpha: 1))
        XCTAssertEqual(electricType.endColor, #colorLiteral(red: 1, green: 0.8867517114, blue: 0.3580238521, alpha: 1))
        XCTAssertEqual(electricType.image, UIImage(named: "electric"))
        
        XCTAssertEqual(psychicType.mainColor, #colorLiteral(red: 1, green: 0.4060875177, blue: 0.4327207804, alpha: 1))
        XCTAssertEqual(psychicType.endColor, #colorLiteral(red: 0.9490309358, green: 0.4241904616, blue: 0.4450967908, alpha: 1))
        XCTAssertEqual(psychicType.image, UIImage(named: "psychic"))
        
        XCTAssertEqual(iceType.mainColor, #colorLiteral(red: 0.2953563631, green: 0.8154250383, blue: 0.7444574237, alpha: 1))
        XCTAssertEqual(iceType.endColor, #colorLiteral(red: 0.4338750839, green: 0.8733255863, blue: 0.8287960291, alpha: 1))
        XCTAssertEqual(iceType.image, UIImage(named: "ice"))
        
        XCTAssertEqual(dragonType.mainColor, #colorLiteral(red: 0, green: 0.4185396433, blue: 0.8112379909, alpha: 1))
        XCTAssertEqual(dragonType.endColor, #colorLiteral(red: 0, green: 0.501458168, blue: 0.8041072488, alpha: 1))
        XCTAssertEqual(dragonType.image, UIImage(named: "dragon"))
        
        XCTAssertEqual(darkType.mainColor, #colorLiteral(red: 0.355060488, green: 0.3440642953, blue: 0.3920295835, alpha: 1))
        XCTAssertEqual(darkType.endColor, #colorLiteral(red: 0.3428039551, green: 0.3115460575, blue: 0.3858483136, alpha: 1))
        XCTAssertEqual(darkType.image, UIImage(named: "dark"))
        
        XCTAssertEqual(fairyType.mainColor, #colorLiteral(red: 0.9902945161, green: 0.5258321166, blue: 0.9177828431, alpha: 1))
        XCTAssertEqual(fairyType.endColor, #colorLiteral(red: 1, green: 0.6250781417, blue: 0.9216451049, alpha: 1))
        XCTAssertEqual(fairyType.image, UIImage(named: "fairy"))
        
        XCTAssertEqual(shadowType.mainColor, #colorLiteral(red: 0.2507422864, green: 0.2035931051, blue: 0.3424940407, alpha: 1))
        XCTAssertEqual(shadowType.endColor, #colorLiteral(red: 0.3721669614, green: 0.307719171, blue: 0.5072653294, alpha: 1))
        XCTAssertEqual(shadowType.image, UIImage(named: "shadow"))
        
        XCTAssertEqual(unknownType.mainColor, #colorLiteral(red: 0.2782413363, green: 0.4239462614, blue: 0.3825690746, alpha: 1))
        XCTAssertEqual(unknownType.endColor, #colorLiteral(red: 0.4000579417, green: 0.6141328812, blue: 0.5543600917, alpha: 1))
        XCTAssertEqual(unknownType.image, UIImage(named: "unknown"))
    }
    

    private class TestableMainCoordinator: MainCoordinator{
        
        override func getPokemons(offset: Int, onResult: @escaping (MainModel?, [PokemonModel]?, ErrorData?) -> Void){
            onResult(MainModel(count: 1118, next: URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=20&limit=20"), previous: nil, results: []),
                [PokeDexAppTests.pokemonModel], nil)
        }
        
        override func getPokemon(_ nameOrId: String, onResult: @escaping (PokemonModel?, ErrorData?) -> Void){
                onResult(PokeDexAppTests.pokemonModel, nil)
        }
    }

    static var pokemonModel: PokemonModel{
        guard let url = Bundle(for: Self.self).url(forResource: "pokemonModelTestData", withExtension: "json") else {
            fatalError()
        }
        do{
            let data = try Data(contentsOf: url)
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let pokemonModel: PokemonModel = try jsonDecoder.decode(PokemonModel.self, from: data)
            return pokemonModel
        }catch{
            fatalError()
        }
    }
}



