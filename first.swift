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
    private var _lat1: Double;
    private var _lon1: Double;
    private var _radius: Double;
    private var _json : JSONFile;

    init(path: String, lat: Double, lon: Double, radius: Double) {
        _lat1 = lat;
        _lon1 = lon;
        _radius = radius;
        let text=try! String(contentsOf: URL(fileURLWithPath: path))
        let data = text.data(using: .utf8)!
        _json = try! JSONDecoder().decode(JSONFile.self, from: data)
    }
    
    func getPlacesNearMe() -> String {
        var places = "";
        for i in 0..._json.candidates.count-1 {
            let d = distance(_lat2: _json.candidates[i].geometry.location.lat, _lon2: _json.candidates[i].geometry.location.lng);
            if (d < _radius) {
                places += _json.candidates[i].name + " " + String(format: "%f", d) + "km\n";
            }
        }
         return places;
    }

    func distance(_lat2: Double, _lon2: Double) -> Double {
        let R = 6371.0; // Radius of the earth in km
        let dLat = deg2rad(deg:_lat2-_lat1);  // deg2rad below
        let dLon = deg2rad(deg:_lon2-_lon1); 
        let a = sin(dLat/2) * sin(dLat/2) + cos(deg2rad(deg:_lat1)) * cos(deg2rad(deg:_lat2)) * sin(dLon/2) * sin(dLon/2);
        let c = 2 * atan2(sqrt(a), sqrt(1-a)); 
        let d = R * c; // Distance in km
        return d;
    }

    func deg2rad(deg: Double) -> Double {
        return deg * (Double.pi/180)
    }
}

var places = CoolPlacesNearMe(path: "places.json", lat: 48.471207, lon: 35.038810, radius: 5);
print(places.getPlacesNearMe());