//
//  ScannerWorker.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 02.04.2025.
//
import AVFoundation
import UIKit

final class ScannerWorker: NSObject, ScannerWorkerLogic {
    //MARK: - Variables
    private let interactor: ScannerBuisnessLogic
    // Сессия для захвата видео
    private let captureSession = AVCaptureSession()
    // Слой для предварительного просмотра (камера в реальном времени)
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    init(interactor: ScannerBuisnessLogic) {
        self.interactor = interactor
    }
    
    //MARK: - Methods
    func setupCaptureSession(in view: UIView) {
        // 1. Настраиваем устройство (камера)
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("Камера недоступна")
            return
        }
        
        // 2. Создаем вход (input)
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                print("Не удалось добавить вход камеры в сессию")
                return
            }
        } catch {
            print("Ошибка при создании входа камеры: \(error.localizedDescription)")
            return
        }
        
        // 3. Создаем выход (output) для метаданных (штрихкоды и т.п.)
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [
                .ean8,
                .ean13,
                .code128,
                .code39,
                .code39Mod43,
                .pdf417,
                .qr
            ]
        } else {
            print("Не удалось добавить выход для метаданных в сессию")
            return
        }
        
        // 4. Настраиваем слой предварительного просмотра
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = view.bounds
        if let previewLayer = previewLayer {
            view.layer.addSublayer(previewLayer)
        }
    }
    
    func startCapture() {
        captureSession.startRunning()
    }
    
    func stopCapture() {
        captureSession.stopRunning()
    }
}

extension ScannerWorker: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        // Обрабатываем распознанные метаданные
        for metadata in metadataObjects {
            guard let readableObject = metadata as? AVMetadataMachineReadableCodeObject,
                  let stringValue = readableObject.stringValue else { continue }
            
            interactor.didCaptureBarcode(stringValue)
            
            
            break
        }
    }
}
