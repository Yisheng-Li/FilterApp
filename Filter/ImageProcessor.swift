import UIKit

public class ImageProcessor{
    var fliterList = ["Brightness","Contrast","Grayscale","Red","Green","Filters_Combination_1","Filters_Combination_2"]
    
    public init() {}
    
    func adjustBrightness(volume:Double, pixel:inout Pixel){
        pixel.red = UInt8 (min (255, Int (volume * Double (pixel.red))))
        pixel.green = UInt8 (min (255, Int (volume * Double (pixel.green))))
        pixel.blue = UInt8 (min (255, Int (volume * Double (pixel.blue))))
    }
    
    func adjustContrast(avgBrightness:Double, volume:Double, pixel:inout Pixel){
        let currentBrightness = (Double(pixel.red) + Double(pixel.green) + Double(pixel.blue)) / 3
        let diff = currentBrightness - avgBrightness
        pixel.red = (diff>0) ? UInt8(min(255,(Double(pixel.red) + volume * diff))) : UInt8(min(255,(Double(pixel.red) - volume * diff)))
        pixel.green = (diff>0) ? UInt8(min(255,(Double(pixel.green) + volume * diff))) : UInt8(min(255,(Double(pixel.green) - volume * diff)))
        pixel.blue = (diff>0) ? UInt8(min(255,(Double(pixel.blue) + volume * diff))) : UInt8(min(255,(Double(pixel.blue) - volume * diff)))
    }
    
    func adjustGrayscale(volume:Double, pixel:inout Pixel){
        let graiedPixel = UInt8(Int(((Double (pixel.red) + Double (pixel.green) + Double (pixel.blue))) / (volume*3)))
        pixel.red = graiedPixel
        pixel.green = graiedPixel
        pixel.blue = graiedPixel
    }
    
    func adjustRed(volume:Double, pixel:inout Pixel){
        pixel.red = UInt8 (min (255, Int (volume * Double (pixel.red))))
    }
    
    func adjustGreen(volume:Double, pixel:inout Pixel){
        pixel.green = UInt8 (min (255, Int (volume * Double (pixel.green))))
    }
    
    func filtersCombination1(avgBrightness:Double,pixel:inout Pixel){
        adjustBrightness(volume:2, pixel:&pixel)
        adjustContrast(avgBrightness:avgBrightness, volume:2, pixel:&pixel)
        adjustRed(volume: 2, pixel: &pixel)
        adjustGreen(volume: 0.5, pixel: &pixel)
    }
    
    
    func filtersCombination2(avgBrightness:Double,pixel:inout Pixel){
        adjustBrightness(volume:0.5, pixel:&pixel)
        adjustContrast(avgBrightness:avgBrightness, volume:2, pixel:&pixel)
        adjustRed(volume: 0.5, pixel: &pixel)
        adjustGreen(volume: 2, pixel: &pixel)
    }
    
    public func applyFilter(image: UIImage, volume: Double, filter:String ) -> UIImage {
        let rgbaImage = RGBAImage(image:image)!
        let count = rgbaImage.height*rgbaImage.width
        var totalBrightness = 0
        
        for y in 0..<rgbaImage.height{
            for x in 0..<rgbaImage.width{
                let index = y * rgbaImage.width + x
                let pixel = rgbaImage.pixels[index]
                totalBrightness += Int(pixel.red) + Int(pixel.green) + Int(pixel.blue)
            }
        }
        
        let avgBrightness = Double(totalBrightness/(3*count))
        
        if fliterList.contains(filter){
            
            for y in 0..<rgbaImage.height{
                for x in 0..<rgbaImage.width{
                    let index = y * rgbaImage.width + x
                    var pixel = rgbaImage.pixels[index]
                    
                    switch filter {
                    case "Brightness":
                        adjustBrightness(volume: volume ,pixel: &pixel)
                    case "Contrast":
                        adjustContrast(avgBrightness: avgBrightness, volume: volume ,pixel: &pixel)
                    case "Grayscale":
                        adjustGrayscale(volume: volume ,pixel: &pixel)
                    case "Red":
                        adjustRed(volume: volume ,pixel: &pixel)
                    case "Green":
                        adjustGreen(volume: volume ,pixel: &pixel)
                    case "Filters_Combination_1":
                        filtersCombination1(avgBrightness: avgBrightness, pixel: &pixel)
                    case "Filters_Combination_2":
                        filtersCombination2(avgBrightness: avgBrightness, pixel: &pixel)
                    default:
                        break
                    }
                    rgbaImage.pixels[index] = pixel    
                }
            }
        }else{
            print("Fliter dose not exist")
        }
        
        return rgbaImage.toUIImage()!
    }
}
