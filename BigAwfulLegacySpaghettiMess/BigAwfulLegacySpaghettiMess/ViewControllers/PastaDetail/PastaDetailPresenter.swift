//
//  PastaDetailPresenter.swift
//  BigAwfulLegacySpaghettiMess
//
//  Created by thompsty on 3/17/21.
//

import Foundation

protocol PastaDetailPresenterInput: class {

}

protocol PastaDetailPresenterOutput: class {
    func getPasta(pastaName: String, _ callback: ((Pasta)->())?)
}

class PastaDetailPresenter: PastaDetailPresenterOutput, PastaDetailInteractorInput {
    var interactor: PastaDetailInteractorOutput!

    func getPasta(pastaName: String, _ callback: ((Pasta) -> ())?) {
        interactor.getPasta(pastaName: pastaName, callback)
    }

    init(input: PastaDetailPresenterInput) {
        self.interactor = PastaDetailInteractor(self)
    }
}
