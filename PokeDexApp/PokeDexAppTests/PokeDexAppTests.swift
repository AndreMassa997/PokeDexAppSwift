//
//  PokeDexAppTests.swift
//  PokeDexAppTests
//
//  Created by Andrea Massari on 07/03/21.
//

import XCTest
@testable import PokeDexApp

class PokeDexAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //MARK: MAIN VIEW MODEL TESTS
    func test_getPokemons_shouldReturnData(){
        //Given
        let sut = MainViewModel(with: TestableMainCoordinator(navigationController: UINavigationController()))
        let expetaction = XCTestExpectation(description: "Expected to get pokemons")
       
        
        //When
        sut.getPokemons(onSuccess: {
            expetaction.fulfill()
        }, onError: {
            XCTFail()
        })
        
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
        sut.getPokemons(onSuccess: {
            expetaction.fulfill()
        }, onError: {
            XCTFail()
        })
        
        wait(for: [expetaction], timeout: 5.0)

        sut.didSelectPokemon(pokemon: PokemonCellViewModel(pokemonModel: PokeDexAppTests.pokemonModel))
        
        //Then
        XCTAssertGreaterThan(mainCoordinator.childCoordinators.count, 0)
    }
    
//    func test_didSelectPokemon_shouldLaunchPokemonDetailsFromFoundedList(){
//        //Given
//        let mainCoordinator = TestableMainCoordinator(navigationController: UINavigationController())
//        let sut = MainViewModel(with: mainCoordinator)
//        let expetaction = XCTestExpectation(description: "Expected to get pokemons")
//
//        //When
//
//        sut.didSelectPokemon(pokemon: PokemonCellViewModel(pokemonModel: PokeDexAppTests.pokemonModel))
//
//        //Then
//        XCTAssertGreaterThan(mainCoordinator.childCoordinators.count, 0)
//    }
    
    func test_searchPokemon_shouldReturnPokemonsLocallyFromName(){
        let mainCoordinator = TestableMainCoordinator(navigationController: UINavigationController())
        let sut = MainViewModel(with: mainCoordinator)
        let expetaction = XCTestExpectation(description: "Expected to get pokemons")
        
        //When
        sut.getPokemons(onSuccess: {
            
        }, onError: {
            XCTFail()
        })
        
        sut.searchPokemon(text: "charizard", onSuccess: {
            expetaction.fulfill()
        }, onError: {
            XCTFail()
        })
        
        wait(for: [expetaction], timeout: 5.0)
        
        //Then
        XCTAssert(sut.pokemonCells.contains(PokemonCellViewModel(pokemonModel: PokeDexAppTests.pokemonModel)))
    }
    
    func test_searchPokemon_shouldReturnPokemonsLocallyFromId(){
        let mainCoordinator = TestableMainCoordinator(navigationController: UINavigationController())
        let sut = MainViewModel(with: mainCoordinator)
        let expetaction = XCTestExpectation(description: "Expected to get pokemons")
        
        //When
        sut.getPokemons(onSuccess: {
            
        }, onError: {
            XCTFail()
        })
        
        sut.searchPokemon(text: "6", onSuccess: {
            expetaction.fulfill()
        }, onError: {
            XCTFail()
        })
        
        wait(for: [expetaction], timeout: 5.0)
        
        //Then
        XCTAssert(sut.pokemonCells.contains(PokemonCellViewModel(pokemonModel: PokeDexAppTests.pokemonModel)))
    }
    
    func test_searchPokemon_shouldReturnPokemonFromServerByText(){
        let mainCoordinator = TestableMainCoordinator(navigationController: UINavigationController())
        let sut = MainViewModel(with: mainCoordinator)
        let expetaction = XCTestExpectation(description: "Expected to find pokemon by his name from server")
        
        //When
        sut.searchPokemon(text: "charizard", onSuccess: {
            expetaction.fulfill()
        }, onError: {
            XCTFail()
        })
        
        wait(for: [expetaction], timeout: 5.0)
        
        //Then
        XCTAssert(sut.pokemonCells.contains(PokemonCellViewModel(pokemonModel: PokeDexAppTests.pokemonModel)))
    }
    
    func test_searchPokemon_shouldReturnPokemonFromServerById(){
        let mainCoordinator = TestableMainCoordinator(navigationController: UINavigationController())
        let sut = MainViewModel(with: mainCoordinator)
        let expetaction = XCTestExpectation(description: "Expected to find pokemon by id from server")
        
        //When
        sut.searchPokemon(text: "6", onSuccess: {
            expetaction.fulfill()
        }, onError: {
            XCTFail()
        })
        
        wait(for: [expetaction], timeout: 5.0)
        
        //Then
        XCTAssert(sut.pokemonCells.contains(PokemonCellViewModel(pokemonModel: PokeDexAppTests.pokemonModel)))
    }
    
    func test_searchPokemon_shouldNotReturnPokemonFromServer(){
        let mainCoordinator = TestableMainCoordinator(navigationController: UINavigationController())
        let sut = MainViewModel(with: mainCoordinator)
        let expetaction = XCTestExpectation(description: "Expected to find no pokemon from server")
        
        //When
        sut.searchPokemon(text: "test", onSuccess: {
            XCTFail()
        }, onError: {
            expetaction.fulfill()
        })
        
        wait(for: [expetaction], timeout: 5.0)
        
        //Then
        XCTAssert(true)
    }
    
    func test_didFinishSearching_shouldRemoveAllCells(){
        //Given
        let mainCoordinator = TestableMainCoordinator(navigationController: UINavigationController())
        let sut = MainViewModel(with: mainCoordinator)
        let expetaction = XCTestExpectation(description: "Get pokemons")
        
        //When
        sut.getPokemons(onSuccess: {
            expetaction.fulfill()
        }, onError: {
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
    }
    
//    func test_detailViewModelBackTappedAndDismiss_shouldPopDetailsViewControllerAndRemoveCoordinator(){
//        //Given
//        let pokemonModel = PokeDexAppTests.pokemonModel
//        let navigationController = UINavigationController()
//        let detailCoordinator = DetailsCoordinator(navigationController: navigationController, pokemonModel: pokemonModel)
//        let sut = DetailsViewModel(with: detailCoordinator, pokemonModel: pokemonModel)
//        detailCoordinator.start()
//
//
//        //When
//        sut.onBackTapped()
//        sut.viewDidDisappear()
//
//        //Then
//        XCTAssertNil(detailCoordinator)
//    }
    
    
    //MARK: DETAILS HEADER VIEW MODEL
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
    
    //MARK: DIMENSIONS CELL VIEW MODEL
    func test_dimensionsCellViewModel_shouldAssignData(){
        let pokemonModel = PokeDexAppTests.pokemonModel
        let sut = DimensionsCellViewModel(height: pokemonModel.height ?? 0, weight: pokemonModel.weight ?? 0, mainColor: .black)
        
        XCTAssertEqual(sut.weight, Float(pokemonModel.weight ?? 0)/10)
        XCTAssertEqual(sut.height, Float(pokemonModel.height ?? 0)/10)
        XCTAssertEqual(sut.mainColor, .black)
        XCTAssertEqual(sut.heightProgressValue, sut.height/20)
        XCTAssertEqual(sut.weightProgressValue, sut.weight/1000)
    }
    
    
    
    
    class TestableMainCoordinator: MainCoordinator{
        override func getPokemons(offset: Int, onSuccess: ((MainModel, [PokemonModel]) -> Void)?, onError: (() -> Void)?) {
            onSuccess?(
                MainModel(count: 1118, next: URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=20&limit=20"), previous: nil, results: []),
                [PokeDexAppTests.pokemonModel]
            )
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



