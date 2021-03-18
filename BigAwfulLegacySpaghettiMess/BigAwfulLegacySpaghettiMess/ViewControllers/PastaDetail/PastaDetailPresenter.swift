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
    var view: PastaDetailPresenterInput!

    func getPasta(pastaName: String, _ callback: ((Pasta) -> ())?) {
        DispatchQueue.main.async { [self] in
            interactor.getPasta(pastaName: pastaName, callback)
        }
    }

    init(view: PastaDetailPresenterInput) {
        self.view = view
        self.interactor = PastaDetailInteractor(self)
    }
}
