//
//  ViewController.swift
//  LandmarksEncyclopedia
//
//  Created by Seonghun Kim on 2021/08/24.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate {
    
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
                
                
            }
        }
        
        picker.dismiss(animated: true)
    }
}
