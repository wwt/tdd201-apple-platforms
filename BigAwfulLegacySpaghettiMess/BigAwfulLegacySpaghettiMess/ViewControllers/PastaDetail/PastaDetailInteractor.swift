//
//  PastaDetailInteractor.swift
//  BigAwfulLegacySpaghettiMess
//
//  Created by thompsty on 3/17/21.
//

import Foundation

protocol PastaDetailInteractorInput: class {

}

protocol PastaDetailInteractorOutput: class {
    func getPasta(pastaName: String, _ callback: ((Pasta)->())?)
}

class PastaDetailInteractor: PastaDetailInteractorOutput {
    func getPasta(pastaName: String, _ callback: ((Pasta) -> ())?) {
        NetworkManager.getPasta(pastaName: pastaName, callback)
    }

    var presenter: PastaDetailInteractorInput

    init(_ input: PastaDetailInteractorInput) {
        self.presenter = input
    }
}
