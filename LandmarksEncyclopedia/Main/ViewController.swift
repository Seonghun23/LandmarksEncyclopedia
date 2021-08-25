//
//  ViewController.swift
//  LandmarksEncyclopedia
//
//  Created by Seonghun Kim on 2021/08/24.
//

import UIKit
import TFLiteSwift_Vision

final class ViewController: UIViewController, UIImagePickerControllerDelegate {
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "Waiting import"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let importButton: UIButton = {
        let button = UIButton()
        button.setTitle("Import", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let inferenceQueue: DispatchQueue = DispatchQueue(label: "inferenceQueue", qos: .userInteractive)
    
    private let models: [InputInferable] = [
        AfricaModel(),
        AsiaModel(),
        EuropeModel(),
        NorthAmericaModel(),
        SouthAmericaModel(),
        OceaniaAndAntarcticaModel()
    ]
    
    private var preprocessOptions: PreprocessOptions {
        return PreprocessOptions(cropArea: .squareAspectFill)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImportButton()
        
        setLayout()
    }
    
    private func presentImagePicker() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true)
    }
    
    private func setImportButton() {
        importButton.addAction(
            UIAction(handler: { [weak self] _ in
                self?.presentImagePicker()
            }),
            for: .touchUpInside
        )
    }

    private func setLayout() {
        view.addSubview(imageView)
        view.addSubview(resultLabel)
        view.addSubview(importButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 30
            ),
            imageView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 50
            ),
            imageView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -50
            ),
            imageView.heightAnchor.constraint(
                equalTo: imageView.widthAnchor
            ),
            
            resultLabel.topAnchor.constraint(
                equalTo: imageView.bottomAnchor,
                constant: 30
            ),
            resultLabel.leadingAnchor.constraint(
                equalTo: imageView.leadingAnchor
            ),
            resultLabel.trailingAnchor.constraint(
                equalTo: imageView.trailingAnchor
            ),

            importButton.topAnchor.constraint(
                equalTo: resultLabel.bottomAnchor,
                constant: 30
            ),
            importButton.leadingAnchor.constraint(
                equalTo: imageView.leadingAnchor
            ),
            importButton.trailingAnchor.constraint(
                equalTo: imageView.trailingAnchor
            ),
            importButton.heightAnchor.constraint(
                equalToConstant: 50
            )
        ])
    }
}

extension ViewController: UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let image = info[.originalImage] as? UIImage {
            inferenceQueue.async { [weak self] in
                guard let self = self else { return }
                
                let input: TFLiteVisionInput = .uiImage(
                    uiImage: image,
                    preprocessOptions: self.preprocessOptions
                )
                
                let group = DispatchGroup()
                let queue = DispatchQueue.global(qos: .userInteractive)
                
                var inferences: [(String, Float32)] = []
                
                self.models.forEach { model in
                    queue.async(group: group) {
                        let inference = model.process(input: input)
                        inferences.append(inference)
                    }
                }
                
                group.notify(queue: queue) {
                    let result = inferences.max(by: { $0.1 < $1.1 })
                    self.imageView.image = image
                    self.resultLabel.text = "\(result?.0 ?? "Failure")\n\(result?.1 ?? 0)"
                }
            }
        }
        
        picker.dismiss(animated: true)
    }
}
