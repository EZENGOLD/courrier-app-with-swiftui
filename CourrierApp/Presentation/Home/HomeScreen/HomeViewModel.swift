import Foundation

class HomeViewModel: ObservableObject {
	var vehicles: [Vehicle] = [.pickup, .van, .lorry, .truck]
	
	var goodTypes: [String] = [
		"Timber / Plywood / Laminate",
		"Electrical / electronics / Home Appliances",
		"Building / Construction",
		"catering / restaurant / Event management",
		"machines / equipments / Spare parts / Metals",
		"Textile / Garmemts / Fashion Accessories",
		"House Shifting",
		"Ceramics / Sanitary / hardware",
		"Paper / Packaging / Printed Material",
		"Chemical / paints",
		"Logisitics Service provide / packers and movers",
		"perishable food items",
		"Furniture / Home Furnishing"
	]
	
	@Published var currentLocation: LocationItem = LocationItem(title: "Your Location", description: "3891, Ranchview, LA, NY")
	
	@Published var dropLocation: LocationItem?
	
	@Published var tripVehicle: Vehicle?
	
	@Published var goodType: String = ""
	
	// sheet controls
	@Published var showPointPicker: Bool = false
	
	@Published var showVehiclePicker: Bool = false
	
	@Published var showGoodTypePicker: Bool = false
	@Published var showGoodsList: Bool = true
	
	@Published var showConfirmDetails: Bool = false
	// end sheet controls
	
	
	// handle search places
	@Published var searchValue: String = ""
	
	var searchUseCase = SearchPlacesUseCase(repo: LocationItemRepositoryImpl(dataSource: LocationItemAPIImpl()))
	
	@Published var predictions: [LocationItem] = []
	// end handle search
	
	
	func handleSearch() async {
		let result = await searchUseCase.execute(self.searchValue)
		
		switch result {
			
		case .success(let response):
			self.predictions = response
			
		case .failure(_):
			self.predictions = []
		}
	}
	
	func pushConfirmDetails() {
		if !goodType.isEmpty && dropLocation != nil && tripVehicle != nil {
			showGoodTypePicker = false
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
				self.showConfirmDetails = true
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				self.resetAll()
			}
		}
	}
	
	func pickLocation(_ location: LocationItem) {
		dropLocation = location
		searchValue = location.title
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			self.predictions = []
		}
	}
	
	func pushLocationPicker(_ delayed: Bool = true) {
		self.showVehiclePicker = false
		self.showGoodTypePicker = false
		if delayed {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				self.showPointPicker = true
			}
		} else {
			self.showPointPicker = true
		}
	}
	
	func pushVehiclePicker() {
		self.showPointPicker = false
		self.showGoodTypePicker = false
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.showVehiclePicker = true
		}
	}
	
	func pushGoodTypePicker() {
		self.showVehiclePicker = false
		self.showPointPicker = false
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.showGoodTypePicker = true
		}
	}
	
	func resetAll() {
		showPointPicker = false
		showVehiclePicker = false
		showGoodTypePicker = false
		showGoodsList = true
		
		dropLocation = nil
		tripVehicle = nil
		goodType = ""
		
		searchValue = ""
		predictions = []
	}
}
