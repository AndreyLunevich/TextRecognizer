import UIKit
import AVFoundation

final class CameraManager: NSObject {

    typealias CompletionHandler = (_ result: Result<Void, CameraError>) -> Void
    typealias CaptureHandler = (_ result: Result<UIImage, CameraError>) -> Void

    enum CameraError: LocalizedError {
        case notSetup
        case setupFailed
        case notAuthorized
        case configurationFailed
        case captureFailed

        var errorDescription: String? {
            switch self {
            case .notSetup:             return "Camera was not setup. Please make setup first."
            case .setupFailed:          return "Camera setup failed."
            case .notAuthorized:        return "AVCam doesn't have permission to use the camera, please change privacy settings."
            case .configurationFailed:  return "Capture session configuration failed."
            case .captureFailed:        return "Image capturing failed."
            }
        }
    }

    private let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()

    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var captureDevice: AVCaptureDevice?

    private var captureHandler: CaptureHandler?

    func setup(completion: @escaping CompletionHandler) {
        checkAuthorization { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                do {
                    self.captureDevice = try self.configureSession(self.session, photoOutput: self.photoOutput)

                    completion(.success(()))
                } catch let error as CameraError {
                    completion(.failure(error))
                } catch {
                    completion(.failure(.setupFailed))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func start(on view: UIView) throws {
        guard captureDevice != nil else { throw CameraError.notSetup }

        let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill

        view.layer.addSublayer(previewLayer)

        self.previewLayer = previewLayer

        session.startRunning()
    }

    func stop() {
        session.stopRunning()
    }

    func captureImage(_ handler: @escaping CaptureHandler) {
        guard let device = captureDevice else {
            handler(.failure(.notSetup))

            return
        }

        self.captureHandler = handler

        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isHighResolutionPhotoEnabled = true
        if device.isFlashAvailable {
            photoSettings.flashMode = .auto
        }

        if let firstAvailablePreviewPhotoPixelFormatTypes = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: firstAvailablePreviewPhotoPixelFormatTypes]
        }

        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }

    private func checkAuthorization(mediaType: AVMediaType = .video, completion: @escaping CompletionHandler) {
        switch AVCaptureDevice.authorizationStatus(for: mediaType) {
        case .authorized:
            completion(.success(()))

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: mediaType) { granted in
                let result: Result<Void, CameraError> = granted
                    ? .success(())
                    : .failure(.notAuthorized)

                completion(result)
            }

        case .restricted, .denied:
            completion(.failure(.notAuthorized))

        @unknown default:
            fatalError()
        }
    }

    private func configureSession(_ session: AVCaptureSession, photoOutput: AVCapturePhotoOutput) throws -> AVCaptureDevice {
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.photo

        do {
            let captureDevice = try self.captureDevice(for: session)

            try configurePhotoOutput(photoOutput, for: session)

            session.commitConfiguration()

            return captureDevice
        } catch {
            session.commitConfiguration()

            throw CameraError.configurationFailed
        }
    }

    private func captureDevice(for session: AVCaptureSession, mediaType: AVMediaType = .video) throws -> AVCaptureDevice {
        var captureDevice: AVCaptureDevice?

        if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: mediaType, position: .back) {
            captureDevice = dualCameraDevice
        } else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: mediaType, position: .back) {
            captureDevice = backCameraDevice
        } else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: mediaType, position: .front) {
            captureDevice = frontCameraDevice
        }

        guard let device = captureDevice else { throw CameraError.configurationFailed }

        let deviceInput = try AVCaptureDeviceInput(device: device)

        if session.canAddInput(deviceInput) {
            session.addInput(deviceInput)

            try device.lockForConfiguration()

            device.focusMode = .continuousAutoFocus

            device.unlockForConfiguration()

            return device
        } else {
            throw CameraError.configurationFailed
        }
    }

    private func configurePhotoOutput(_ photoOutput: AVCapturePhotoOutput, for session: AVCaptureSession) throws {
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)

            photoOutput.isHighResolutionCaptureEnabled = true
            photoOutput.isLivePhotoCaptureEnabled = photoOutput.isLivePhotoCaptureSupported
        } else {
            throw CameraError.configurationFailed
        }
    }
}

extension CameraManager: AVCapturePhotoCaptureDelegate {

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let data = photo.fileDataRepresentation(), let image = UIImage(data: data) {
            captureHandler?(.success(image))
        } else {
            captureHandler?(.failure(.captureFailed))
        }
    }
}
