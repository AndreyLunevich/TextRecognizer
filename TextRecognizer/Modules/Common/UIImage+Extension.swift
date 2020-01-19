import UIKit

extension UIImage {

    var orientationDegree: CGFloat {
        switch imageOrientation {
        case .right, .rightMirrored:    return 90
        case .left, .leftMirrored:      return -90
        case .up, .upMirrored:          return 180
        case .down, .downMirrored:      return 0
        @unknown default:               fatalError()
        }
    }

    func crop(area: CGRect) -> UIImage {
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(Double.pi)
        }

        let imageOrientation = self.imageOrientation
        let degree = self.orientationDegree
        let cropSize = area.size

        let cgImage = self.cgImage!

        let width = cropSize.width
        let height = self.size.height / self.size.width * cropSize.width

        let bitsPerComponent = cgImage.bitsPerComponent
        let bytesPerRow = cgImage.bytesPerRow
        let colorSpace = cgImage.colorSpace
        let bitmapInfo = cgImage.bitmapInfo

        let context = CGContext(data: nil,
                                width: Int(width),
                                height: Int(height),
                                bitsPerComponent: bitsPerComponent,
                                bytesPerRow: bytesPerRow,
                                space: colorSpace!,
                                bitmapInfo: bitmapInfo.rawValue)

        context!.interpolationQuality = CGInterpolationQuality.none
        context?.rotate(by: degreesToRadians(degree));
        context?.scaleBy(x: -1.0, y: -1.0)

        switch imageOrientation {
        case .right, .rightMirrored:
            context?.draw(cgImage, in: CGRect(x: -height, y: 0, width: height, height: width))

        case .left, .leftMirrored:
            context?.draw(cgImage, in: CGRect(x: 0, y: -width, width: height, height: width))

        case .up, .upMirrored:
            context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        case .down, .downMirrored:
            context?.draw(cgImage, in: CGRect(x: -width, y: -height, width: width, height: height))

        @unknown default:
            fatalError()
        }

        let calculatedFrame = CGRect(x: 0, y: CGFloat((height - cropSize.height)/2.0), width: cropSize.width, height: cropSize.height)
        let scaledCGImage = context?.makeImage()?.cropping(to: calculatedFrame)

        return UIImage(cgImage: scaledCGImage!)
    }
}
