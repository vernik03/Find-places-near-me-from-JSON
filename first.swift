import Foundation

struct JSONFile : Decodable{
    let candidates : [Candidates]
}

struct Candidates : Decodable {
    let geometry : Geometry  
    let name : String 
}

struct Geometry : Decodable{
    let location : Location
}

struct Location : Decodable{
    let lat : Double
    let lng : Double
}

class CoolPlacesNearMe
{
    private var _coordX: Double;
    private var _coordY: Double;
    private var _radius: Double;
    private var _json : JSONFile;

    init(path: String, coordX: Double, coordY: Double, radius: Double) {
        _coordX = coordX;
        _coordY = coordY;
        _radius = radius;
        let text=try! String(contentsOf: URL(fileURLWithPath: path))
        let data = text.data(using: .utf8)!
        _json = try! JSONDecoder().decode(JSONFile.self, from: data)
    }
    
    func getPlacesNearMe() -> String {
        var places = "";
        for i in 0..._json.candidates.count-1 {
            let d = distance(_x2: _json.candidates[i].geometry.location.lat, _y2: _json.candidates[i].geometry.location.lng);
            if (d < _radius) {
                places += _json.candidates[i].name + " " + String(format: "%f", d) + "km\n";
            }
        }
         return places;
    }

    func distance(_x2: Double, _y2: Double) -> Double {
        return sqrt(pow(_coordX - _x2, 2) + pow(_coordY - _y2, 2));
    }
}

var places = CoolPlacesNearMe(path: "places.json", coordX: 48.471207, coordY: 35.038810, radius: 0.01);
print(places.getPlacesNearMe());