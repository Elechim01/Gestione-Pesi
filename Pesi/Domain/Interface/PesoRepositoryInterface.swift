
//
//  PesoRepositoryInterface.swift
//  Pesi
//
//  Created by Michele Manniello on 09/04/26.
//

import Foundation

protocol PesoRepositoryInterface {
    func fetchData() throws -> [PesoModel]
    func insertData(model: PesoModel) throws
    func deleteData(model: PesoModel) throws
}
